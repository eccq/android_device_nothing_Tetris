# Device configuration for CMF Phone 1

The CMF Phone 1 ("Tetris") is a mid-range smartphone from CMF by
Nothing, released in July 2024.

## Device specifications

Basic    | Spec Sheet
--------:|:-------------------------
CPU      | Octa-core (4x2.5 GHz Cortex-A78 & 4x2.0 GHz Cortex-A55)
Platform | MediaTek Dimensity 7300 (4 nm)
GPU      | Mali-G615 MC2
Memory   | 6/8 GB, LPDDR4X
Storage  | 128/256 GB, UFS 2.2
Shipped Android Version | 14
Battery  | Li-ion 5000 mAh, non-removable
Display  | 1080 x 2400 pixels, 6.67 inches (~395 ppi density)
Camera   | 50 MP main, 16 MP front

## Device picture

![CMF Phone 1](https://fdn2.gsmarena.com/vv/pics/nothing/nothing-cmf-phone-1-02.jpg "CMF Phone 1")

## DescartesOS

This tree builds DescartesOS 17.0 (based on LineageOS 24 / Android 17) for the
CMF Phone 1. The kernel is the prebuilt `6.1.177-android14-11-Kraken` from
[lufrz](https://github.com/lufrz/android_device_nothing_Tetris-kernel), checked
out at `device/nothing/Tetris-kernel`. [app/parts/KERNEL.md](app/parts/KERNEL.md)
explains which Tetris Parts controls depend on a patched kernel and what the
app does without one.

Build:

```
source build/envsetup.sh
lunch lineage_Tetris cp2a userdebug
m bacon
```

The build writes `out/target/product/Tetris/DescartesOS-17.0-<date>-Tetris-v<version>.zip`
and a matching `Tetris.json` next to it.

## Installing and updating

Builds are on the [releases page](https://github.com/eccq/android_device_nothing_Tetris/releases).
A build is about 2.9 GB, larger than GitHub's 2 GiB limit for a single asset,
so each release holds the zip in two parts with checksums. Reassemble it on a
computer:

```sh
cat DescartesOS-17.0-<date>-Tetris-v<version>.zip.part0 \
    DescartesOS-17.0-<date>-Tetris-v<version>.zip.part1 \
    > DescartesOS-17.0-<date>-Tetris-v<version>.zip
sha256sum -c DescartesOS-17.0-<date>-Tetris-v<version>.zip.sha256sum
```

First installation works like LineageOS: boot a recovery that supports A/B
sideload and run `adb sideload` with the reassembled zip. The build expects the
stock firmware `Tetris_B4.1-260928-1140` from the
[Nothing archive](https://github.com/spike0en/nothing_archive/releases/tag/Tetris_B4.1-260928-1140).

To update a phone already running DescartesOS, copy the reassembled zip to the
phone, open Settings > System > Updater, choose "Install local update" from the
menu and pick the file. The Updater installs it with `update_engine` in the
background and asks for a reboot when it is done. Apps and data are kept. The
Updater's online check does not list Tetris builds, because the DescartesOS OTA
catalog has no entry for this device yet.

## Keeping up with lufrz

This tree is a snapshot of lufrz's `lineage-24.0` device tree with DescartesOS
product configuration on top, without the upstream commit history. To see what
changed upstream since the snapshot:

```sh
git remote add lufrz https://github.com/lufrz/android_device_nothing_Tetris
git fetch lufrz lineage-24.0
git log --oneline b4b53df..lufrz/lineage-24.0
git diff b4b53df lufrz/lineage-24.0 -- . ':!README.md'
```

`b4b53df` is the upstream commit this tree matches as of 2026-11-14. Apply the
upstream diff with `git apply` or cherry-pick the commits, then update that
hash here. The vendor tree follows the same procedure against
lufrz/proprietary_vendor_nothing_Tetris, matched at `6a6e43f`.

## Credits

| Who | What |
|---|---|
| [LineageOS](https://github.com/LineageOS) | Android base, `hardware/mediatek`, `device/mediatek/sepolicy_vndr`, `hardware/lineage/compat` |
| [crDroid Android](https://github.com/crdroidandroid) | Base of the DescartesOS vendor configuration |
| [CMF-Phone-1](https://github.com/CMF-Phone-1) | Original device, vendor and kernel trees for Tetris (`xylobium` / `a17`) |
| [lufrz](https://github.com/lufrz) | LineageOS 24 device tree, vendor and prebuilt kernel; Tetris Parts; power, GPU and audio tuning; UDFPS; EROFS; stock LK |
| [Sreelekshman](https://github.com/sreelekshman) | Original Tetris bring-up and maintenance |
| [Mashopy](https://github.com/Mashopy) | Device bring-up, fingerprint HAL, `libfs_avb` and fastbootd lock-state patches |
| [bengris32](https://github.com/bengris32) | Media, WLAN, audio and scheduler tuning |
| [Abhay Singh Gill](https://github.com/HELLBOY017), [sidharthify](https://github.com/sidharthify) | Fingerprint and UDFPS |
| [swiitch-OFF-Lab](https://github.com/swiitch-OFF-Lab) | `hardware/dolby` and `DolbyUI` |
| [Nothing archive](https://github.com/spike0en/nothing_archive) | Stock firmware archive (`Tetris_B4.1-260928-1140`) |
| [chakra](https://github.com/eccq) | DescartesOS port and maintenance |

### Contributors

Everyone who authored commits in this tree's history:

Aaron Kling, Abhay Singh Gill, Adam Shih, AdarshGrewal, Alexander Koskovich, alextrack2013, Arian, Arthur Hung, Avichal Rakesh, Bart Van Assche, basamaryan, bengris32, Beverly, Bowgo Tsai, Bruno Martins, chandu078, ChrisCatto, Chungkai Mei, cjh1249131356, claxten10, codeworkx, Cosmin Tanislav, Cyber Knight, Danny Lin, electimon, Erfan Abdi, Evgenii Stepanov, Giovanni Ricca, guibing, hiroshi, Jaegeuk Kim, Jake Weinstein, J. Avila, Jeff Chang, Jenhao Chen, Jesse Chan, jiabin, Jis G Jacob, Jooyung Han, JoshuaDoes, Kshitij, Kujou Yuko, Kyle Tso, Lennart Wieboldt, Lokesh Gidra, lufrz, LuK1337, Martin Liu, Mashopy, me-cafebabe, Michael Bestas, Michael Wright, mikoker, Minchan Kim, Nicholas Lim, nift4, Nolen Johnson, Omkar Chandorkar, Pedro Garau Martínez, pjgowtham, Pullakavi Srinivas, Qais Yousef, Rachel Lee, Randall Huang, Ray Chi, rio004, Saalim Quadri, SahilSonar, Sebastiano Barezzi, Seth Moore, sidharthify, sm455, snapboss, sreelekshman, Sriharsha Allenki, Sungtak Lee, swiitchOFF, TheMysticle, Thierry Strudel, Tim Zimmermann, Vaisakh Murali, Victor Hsieh, Vincent Wang, Wei Wang, Woody Lin, Woomymy, Yan Yan, Yong Zhang, Yumi Yukimura.

Thank you all.
