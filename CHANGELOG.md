# Changelog

All notable changes to the DescartesOS device tree for the CMF Phone 1 (Tetris).

## Unreleased

- Removed the SELinux labels and rules for `scaling_locked_limits` and the
  `charge_bypass` nodes, which the shipped kernel does not have.
- Tetris Parts: one shared back button for the page scaffold and the terms
  screen.
- README: how to compare this tree with lufrz's upstream tree.
- Split the ImsService blob patches so each smali stub is created by one patch;
  `extract-files.py` failed on the second patch before.
- Removed the `GpuUiMinFreq` power hint. The shipped gpufreq module does not
  understand the `boost` command, so the write never did anything.
- Stopped init from touching `scaling_locked_limits` and the `charge_bypass`
  nodes, which the shipped kernel does not expose. Removed the charging init
  file.
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
