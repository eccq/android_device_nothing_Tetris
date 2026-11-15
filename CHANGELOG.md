# Changelog

All notable changes to the DescartesOS device tree for the CMF Phone 1 (Tetris).

## Unreleased

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
