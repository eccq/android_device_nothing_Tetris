# Patches for repositories outside this tree

These patches fix DescartesOS apps that live in other repositories. Apply them
after `repo sync`, from the root of the source tree:

```sh
cd packages/apps/Settings && git apply ../../../device/nothing/Tetris/patches/0001-*.patch && cd -
cd frameworks/base && git apply ../../device/nothing/Tetris/patches/0002-*.patch && cd -
cd vendor/addons && git apply ../../device/nothing/Tetris/patches/0003-*.patch && cd -
cd packages/apps/Launcher3 && git apply ../../../device/nothing/Tetris/patches/0004-*.patch && cd -
```

| Patch | What it fixes |
| --- | --- |
| `0001-Settings-Homepage-search-bar-and-language-search.patch` | The floating search bar on the Settings home page took no taps: the click handler was attached to the hidden two-pane copy that shares its ids. In the language pickers the collapsed toolbar title was drawn over the search field, so typed text never showed. |
| `0002-SystemUI-Custom-clock-side-margin.patch` | SystemUI never read the custom clock side margin that Lock Styles saves; it now applies it, together with the top margin, to the clock frame. |
| `0003-AxBlur-Device-default-blur-radius.patch` | AxBlur reads its default radius percentages from `ro.descartes.blur.system_pct` and `ro.descartes.blur.launcher_pct`, so a device tree can start lighter than the 100% upstream default. Tetris sets 60 and 50 in `product.prop`; the user's own setting still overrides them. |
| `0004-Launcher3-Lighter-default-blur-depth.patch` | Default launcher blur depth 18 instead of 30, so the app drawer and recents animate without stutter on this GPU. Adjustable in the launcher settings. |
