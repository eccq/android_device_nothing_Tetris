# Patches for repositories outside this tree

These patches fix DescartesOS apps that live in other repositories. Apply them
after `repo sync`, from the root of the source tree:

```sh
cd packages/apps/Settings && git apply ../../../device/nothing/Tetris/patches/0001-*.patch && cd -
cd frameworks/base && git apply ../../device/nothing/Tetris/patches/0002-*.patch && cd -
cd vendor/addons && git apply ../../device/nothing/Tetris/patches/0003-*.patch && cd -
cd packages/apps/Launcher3 && git apply ../../../device/nothing/Tetris/patches/0004-*.patch && cd -
cd packages/apps/LockStyles && git apply ../../../device/nothing/Tetris/patches/0005-*.patch && cd -
cd packages/apps/Atelier && git apply ../../../device/nothing/Tetris/patches/0006-*.patch && cd -
```

| Patch | What it fixes |
| --- | --- |
| `0001-Settings-Homepage-search-bar-and-language-search.patch` | The floating search bar on the Settings home page took no taps: the click handler was attached to the hidden two-pane copy that shares its ids. In the language pickers the collapsed toolbar title was drawn over the search field, so typed text never showed. The home page app bar honours `ro.descartes.appbar_blur` like the other pages. |
| `0002-frameworks-base-Clock-margins-glass-tiles-and-app-bar-blur.patch` | SystemUI never read the custom clock side margin that Lock Styles saves; it now applies it, with the top margin, to the clock frame. Two device switches: `ro.descartes.qs_glass=false` keeps the ColorOS quick settings on flat tiles instead of compositor blur regions, and `ro.descartes.appbar_blur=false` keeps the Settings app bar on its plain scrim instead of a backdrop blur. Tetris sets both, because its compositor draws those regions without the tile icons and the app bar without its title. The status bar root no longer clips to its corner inset, so a negative start padding moves the clock into the rounded corner instead of cutting it off. The clock gradient from Lock Styles works: SystemUI reads the gradient colours, centre and size and paints one radial gradient across the whole clock. The doze transition of custom clocks goes straight from where it is to the target scale and alpha on a hardware layer, with the emphasized curves, instead of fading to nothing and popping back. The display service has three more screen off animations: slide down, zoom in and fold. With `ro.descartes.ax_window_blur=false` the volume dialog, its ringer drawer and the power menu skip their compositor blur regions, which this GPU draws without corner radius, and use their plain rounded backgrounds. With `ro.descartes.qs_glass=false` the scrim keeps its colour behind the ColorOS and HyperOS panels: it used to turn transparent for a glass that is never drawn, which left the lock screen showing through the tiles of a half-open shade. |
| `0003-AxBlur-Device-default-blur-radius.patch` | AxBlur reads its default radius percentages from `ro.descartes.blur.system_pct` and `ro.descartes.blur.launcher_pct`, so a device tree can start lighter than the 100% upstream default. Tetris sets 40 and 35 in `product.prop`; the user's own setting still overrides them. `ro.descartes.ax_window_blur=false` makes AxBlur draw its own in-app blur instead of compositor regions, which Tetris needs because those regions come out square. |
| `0004-Launcher3-Lighter-default-blur-depth.patch` | Default launcher blur depth 12 instead of 30, so the app drawer and recents animate without stutter on this GPU. Adjustable in the launcher settings. |
| `0005-LockStyles-Wallpaper-and-memory-fixes.patch` | lock styles: "keep home" no longer turns an engine-drawn home screen black or into the new lock picture, the "on lock" shuffle stops skipping a photo every time an app opens, no depth cut-out taken from the home photo when the lock screen is live, re-adopting the current wallpaper can't show a stale cached picture, and the full-screen bitmaps used for wallpapers and effects get recycled instead of piling up in memory. |
| `0006-Atelier-More-screen-off-animations.patch` | Atelier > User interface > Screen off animation lists the new slide down, zoom in and fold animations next to default, CRT and scale. Needs the 0002 framework part. |
