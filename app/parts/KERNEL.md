# Tetris kernel and the Parts kernel interfaces

## What DescartesOS ships

The ROM uses the prebuilt kernel from `device/nothing/Tetris-kernel`
(lufrz/android_device_nothing_Tetris-kernel, branch `a17`, commit `cfd6501`).
`BoardConfigKernel.mk` sets `TARGET_FORCE_PREBUILT_KERNEL := true`, so the
`Image`, DTB, DTBO and module directories in that tree are packaged as they are.
The image identifies itself as `6.1.177-android14-11-Kraken`.

That kernel does not provide the custom interfaces described below. Parts
detects this at runtime: the CPU page shows "Updated kernel required" and labels
frequency changes as temporary, Charger-powered mode shows as unavailable, and
the Power HAL's `boost` request to `/proc/gpufreqv2/limit_table` is ignored by
the stock `mtk_gpufreq_wrapper.ko`.

The sections below describe the `scaling_locked_limits` interface Parts expects
and the build that produced a kernel with it upstream. The kernel patches and the
wrapper scripts named here are not part of this repository, and they are not in
lufrz's public kernel repositories either. Treat this as a record of how that
kernel was made, not as something this tree can rebuild on its own.

## The `scaling_locked_limits` interface

Each cpufreq policy exposes `scaling_locked_limits`:

- Read: `0 min max` for unlocked current limits, `1 min max` for a locked range.
- Write `1 min max` to validate, apply and own both bounds atomically, in kHz.
- Write `0` to release ownership and apply the current ordinary QoS requests.

The kernel serializes the whole transaction with the policy write semaphore,
requires frequencies from the available OPP table, and rolls back a failed
application. The Power HAL and other frequency-QoS clients can keep submitting
requests, but they cannot replace locked policy bounds. The lock survives app
exit and policy CPU hotplug until it is released, the driver is removed, or the
phone reboots. Parts' Restore button also releases it.

This overrides CPU cooling caps implemented through frequency QoS, whatever the
separate thermal profile setting says. It does not overclock, modify the OPP
table, disable emergency shutdown, or remove hardware or firmware constraints. A
fixed software range does not guarantee an exact physical clock in every
condition, and CPU idle keeps working.

The node has its own SELinux label, `vendor_tetris_cpu_lock`, and only Parts can
write it; the Power HAL rules for ordinary frequency controls do not grant
ownership changes. The patch uses a private allocation wrapper and does not
change the exported `struct cpufreq_policy` layout or add exported symbols, so it
avoids a KMI layout change. That alone does not make an arbitrary rebuilt kernel
compatible with the shipped modules.

## How the upstream kernel was built

### Sources

| Checkout | Base commit |
| --- | --- |
| `kernel/nothing/tetris` | `f810d726b10b9ae24a627c5bf317a534c2d9a1c6` |
| `kernel/nothing/tetris-device-modules` | `a70397a9db3c062ff2087f24881076670b4d22eb` |
| `kernel/nothing/tetris-modules` | `48e57b184f1b092c9be69f74d6d5bf6e7f80d0cc` |
| `device/nothing/Tetris-kernel` (prebuilt base) | `cfd650165cc3dd743e12da86b4dd78bb870bd991` |
| Nothing build infrastructure (`NothingOSS/android_kernel_build_nothing_mt6878`) | `9331088f57045ca5f136f30f767a2f7db3438f78` |

The first two are lufrz/android_kernel_6.1_nothing_mt6878 and
lufrz/android_kernel_device_modules_6.1_nothing_mt6878 on `lineage-24.0`. The
kernel's `build.config.constants` selects Android 14 / Linux 6.1 and
`clang-r596125`, which this ROM checkout already contains. `gki_defconfig` has
`CONFIG_CPU_FREQ=y`, so the CPU lock patch needs no extra Kconfig option.

### Workspace layout

The build ran in a separate workspace with the official Nothing build
infrastructure, using shared clones of the three kernel repositories with the
integration patches applied. The ROM's own `build` directory was not touched.

| Kernel workspace path | Source |
| --- | --- |
| `kernel-6.1` | `kernel/nothing/tetris` with the local patches |
| `kernel_device_modules-6.1` | `kernel/nothing/tetris-device-modules` |
| `vendor/mediatek/kernel_modules` | `kernel/nothing/tetris-modules` |

The MediaTek configuration came from `mgk_64_k61_defconfig` with
`Tetris.config` and `bliss.config`, built with `clang-r596125`, thin LTO and the
Android NDK r23c sysroot (`23.2.8568313`). The entry point was the legacy
Nothing/MediaTek path, `build/build.sh` with a generated `BUILD_CONFIG`, which
in turn runs `kernel_device_modules-6.1/scripts/legacy_build.sh`. The
device-modules repository also has a Kleaf `build.sh`; that was not used. The
build was limited to 12 CPUs.

The generic external module list needed three changes, none of which alters
driver configuration or weakens modpost checks:

- Exclude `fpsgo_cus`: Tetris disables `MTK_FPSGO_V3` and ships neither
  `fpsgo.ko` nor `game.ko`.
- Build `conninfra_mt6653` right after `conninfra`, before its GPS and Bluetooth
  consumers, and keep `connfem` before the Bluetooth consumers.
- Replace the generic `wlan/adaptor_mt6653` group with
  `wlan/adaptor_mt6653/build/connac3x_6989_6653`, before both MT6653 Wi-Fi core
  variants. The subgroup produces the needed symbols without the malformed parent
  wrapper and without duplicating the generic adapters.

### Branding and timestamp

Two small patches set the kernel name and build time:

- `arch/arm64/configs/gki_defconfig` in the kernel: `CONFIG_LOCALVERSION="-lufrz"`.
- `scripts/gen_build_config.py` in the device modules: the generated
  configuration uses the current Unix epoch when `SOURCE_DATE_EPOCH` is unset or
  empty and defaults `GKI_SOURCE_DATE_EPOCH` to the same value. An explicit
  nonempty value, including `0`, is kept.

The workspace writes `-android14-11` to `localversion` and an empty
`.scmversion`, which keeps the Android KMI generation and avoids an appended Git
suffix. The resulting release string was `6.1.177-android14-11-lufrz`. The GKI
infrastructure overrides the build identity variables, so the image reports
`build-user@build-host`.

### Result

The build finished on 2026-09-28 at 20:11:23 UTC. The imported `Image.lz4` has
SHA-256 `8eb0c4edd2be23768f2d8b4264d197baa7015eb7735d3013615ca682bbcd36d5` and
embeds `Mon Sep 28 19:40:05 UTC 2026` (epoch `1790624405`). The distribution had
495 files: 481 `.ko` paths for 467 distinct modules plus 14 identical copies,
all rebuilt, with regenerated dependency metadata in the normal and recovery
loading order. The rebuilt MT6878 DTB was byte-identical to the previous one, so
the DTB and DTBO stayed unchanged. Host checks found no missing symbols, CRC
mismatches, provider conflicts or vermagic mismatches across the 467 modules.
None of this was tested on a phone.

## Importing a rebuilt kernel into this tree

Keep the current artifacts before replacing them. The ROM uses these
destinations:

| Rebuilt artifact | Destination |
| --- | --- |
| ARM64 `Image.lz4`, legacy LZ4 format | `device/nothing/Tetris-kernel/Image` |
| system kernel modules and module metadata | `device/nothing/Tetris-kernel/system_dlkm/` |
| device/vendor modules and module metadata | `device/nothing/Tetris-kernel/vendor_dlkm/` |
| early boot modules and module metadata | `device/nothing/Tetris-kernel/vendor_boot/` |
| matching DTB image(s), if changed | `device/nothing/Tetris-kernel/dtbs/` |
| matching DTBO image, if changed | `device/nothing/Tetris-kernel/dtbo.img` |

Replace modules together with their `modules.load`, `modules.dep`,
`modules.alias`, `modules.softdep`, signing and version metadata; swapping only
the `.ko` files leaves stale dependency data behind. Check the rebuilt kernel
against every module that will ship, including any prebuilt module you keep.

The prebuilt `Image` is LZ4 compressed in the legacy format (`file` reports
LZ4 v0.1-v0.9), produced by `lz4 -l`. Import the matching `Image.lz4` under the
name `Image` and keep that format; the uncompressed `Image` has the same name but
is not what the boot image expects.

```sh
matched_kernel_image=/absolute/path/to/matched/distribution/Image.lz4
install -m 0644 "$matched_kernel_image" device/nothing/Tetris-kernel/Image
```

Then run the normal ROM build; it packages the imported image and modules into
boot, vendor_boot and the DLKM partitions. `TARGET_FORCE_PREBUILT_KERNEL` stays
set. Pointing `TARGET_KERNEL_SOURCE` elsewhere while that flag is set would still
package the old image.

## Verification

Host checks in this tree:

```sh
device/nothing/Tetris/app/parts/tests/run-cpu-tests.sh
python3 device/nothing/Tetris/app/parts/tests/check-kernel-cpu-lock.py
```

The second compiles the kernel parser, store and policy functions added by the
patch in a host harness and exercises competing QoS, unlock, malformed input,
driver failure and rollback. It does not build the kernel or certify the KMI.

On a phone running a kernel with the interface, both
`/sys/devices/system/cpu/cpufreq/policy0/scaling_locked_limits` and
`policy4/scaling_locked_limits` must exist. Apply a range in Parts: readback must
show `1 min max`, and `scaling_min_freq` and `scaling_max_freq` must stay at that
pair through normal Android boosts and mode changes. Unlock and confirm that
Android's requests take effect again. Reboot and confirm both locks are off.
