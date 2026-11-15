# Changelog

All notable changes to the DescartesOS device tree for the CMF Phone 1 (Tetris).

## Unreleased

- smaller blur radii to cut lag in the shade, quick settings and lock screen:
  shade 12dp (was 17), axblur 40% system / 35% launcher, launcher depth 12.
- lock styles: fixed "keep home" breaking a live home screen, the on-lock shuffle
  advancing on every app launch, a depth cut-out taken from the wrong picture, a
  stale picture when adopting the current wallpaper, and bitmap leaks in the
  wallpaper and effect code (patch 0005).
- Blur on this GPU: the Settings app bar keeps its plain scrim instead of a
  backdrop blur (it lost its title and buttons), the ColorOS quick settings use
  flat tiles instead of compositor glass regions (the icons vanished and the
  lock screen showed through), and AxBlur surfaces such as the volume panel
  draw their own in-app blur instead of compositor regions (which came out
  square). Device switches in `product.prop`: `ro.descartes.appbar_blur`,
  `ro.descartes.qs_glass`, `ro.descartes.ax_window_blur`.
- Blur: AxBlur starts at 60% system and 50% launcher radius on this device
  instead of 100%, to cut the GPU cost on the Mali-G615. Adjustable in Atelier.
- Settings: the floating search bar on the home page takes taps again, and the
  language pickers show what you type in the search field. Shipped as patches
  under `patches/` because Settings lives in another repository.
- Lock Styles: the custom clock side margin now reaches the lock screen, with
  the top margin, through a SystemUI patch under `patches/`.
- Face unlock enabled (`TARGET_FACE_UNLOCK_SUPPORTED`).
- Tetris Parts: one shared back button for the page scaffold and the terms
  screen.
- README: how to compare this tree with lufrz's upstream tree.
- Split the ImsService blob patches so each smali stub is created by one patch;
  `extract-files.py` failed on the second patch before.
- Moved the prebuilt kernel to lufrz's `lineage-24.0-tetris` branch
  (`6.1.177-android14-11-lufrz`, November 2026 build). It matches the B4.1
  vendor blobs and provides the CPU lock, GPU floor and charger bypass
  interfaces Tetris Parts uses. The September `a17` kernel panicked at boot.
- dm-verity stays disabled in vbmeta, as in the LineageOS tree.
- cpufreq and gpufreq nodes used by Tetris Parts stay world-readable (0664)
  instead of 0660.
- Removed a duplicated `TARGET_SCREEN_DENSITY` in `BoardConfig.mk`.
- Tetris Parts: the temperature, battery and memory pages reuse
  `rememberPartsResumed()`, and the CPU and GPU restore dialogs share
  `PartsConfirmDialog`.
- Rewrote the README and the Parts documents. They now describe the kernel the
  ROM actually ships and how to install or update a build.

## v1.0 (2026-11-13)

- First DescartesOS 17.0 build for Tetris, based on LineageOS 24 / Android 17.
- Device tree, vendor tree and prebuilt kernel from lufrz's lineage-24.0 trees,
  with DescartesOS product configuration.
- Release published as a two-part zip with checksums.
