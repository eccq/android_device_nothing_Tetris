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
cd frameworks/base && git apply ../../device/nothing/Tetris/patches/0007-*.patch && cd -
cd frameworks/base && git apply ../../device/nothing/Tetris/patches/0008-*.patch && cd -
cd frameworks/base && git apply ../../device/nothing/Tetris/patches/0009-*.patch && cd -
cd frameworks/base && git apply ../../device/nothing/Tetris/patches/0010-*.patch && cd -
cd frameworks/base && git apply ../../device/nothing/Tetris/patches/0011-*.patch && cd -
cd frameworks/base && git apply ../../device/nothing/Tetris/patches/0012-*.patch && cd -
cd packages/apps/Atelier && git apply ../../../device/nothing/Tetris/patches/0013-*.patch && cd -
cd frameworks/base && git apply ../../device/nothing/Tetris/patches/0014-*.patch && cd -
cd packages/apps/Launcher3 && git apply ../../../device/nothing/Tetris/patches/0015-*.patch && cd -
cd packages/apps/Atelier && git apply ../../../device/nothing/Tetris/patches/0016-*.patch && cd -
cd packages/apps/DescartesLaboratory && git apply ../../../device/nothing/Tetris/patches/0017-*.patch && cd -
cd packages/apps/SettingsIntelligence && git apply ../../../device/nothing/Tetris/patches/0018-*.patch && cd -
cd packages/apps/Launcher3 && git apply ../../../device/nothing/Tetris/patches/0019-*.patch && cd -
cd packages/apps/Launcher3 && git apply ../../../device/nothing/Tetris/patches/0020-*.patch && cd -
cd frameworks/base && git apply ../../device/nothing/Tetris/patches/0021-*.patch && cd -
cd frameworks/base && git apply ../../device/nothing/Tetris/patches/0022-*.patch && cd -
cd packages/apps/LockStyles && git apply ../../../device/nothing/Tetris/patches/0023-*.patch && cd -
cd packages/apps/Atelier && git apply ../../../device/nothing/Tetris/patches/0024-*.patch && cd -
cd frameworks/base && git apply ../../device/nothing/Tetris/patches/0025-*.patch && cd -
cd frameworks/base && git apply ../../device/nothing/Tetris/patches/0026-*.patch && cd -
cd frameworks/base && git apply ../../device/nothing/Tetris/patches/0027-*.patch && cd -
cd packages/apps/Atelier && git apply ../../../device/nothing/Tetris/patches/0028-*.patch && cd -
cd frameworks/base && git apply ../../device/nothing/Tetris/patches/0029-*.patch && cd -
cd packages/apps/Launcher3 && git apply ../../../device/nothing/Tetris/patches/0030-*.patch && cd -
cd frameworks/base && git apply ../../device/nothing/Tetris/patches/0031-*.patch && cd -
cd packages/apps/LockStyles && git apply ../../../device/nothing/Tetris/patches/0032-*.patch && cd -
cd packages/apps/Settings && git apply ../../../device/nothing/Tetris/patches/0033-*.patch && cd -
cd packages/apps/Atelier && git apply ../../../device/nothing/Tetris/patches/0034-*.patch && cd -
cd frameworks/base && git apply ../../device/nothing/Tetris/patches/0035-*.patch && cd -
cd frameworks/base && git apply ../../device/nothing/Tetris/patches/0036-*.patch && cd -
cd frameworks/base && git apply ../../device/nothing/Tetris/patches/0037-*.patch && cd -
cd frameworks/base && git apply ../../device/nothing/Tetris/patches/0038-*.patch && cd -
cd frameworks/base && git apply ../../device/nothing/Tetris/patches/0039-*.patch && cd -
cd packages/apps/Launcher3 && git apply ../../../device/nothing/Tetris/patches/0040-*.patch && cd -
cd packages/apps/GameSpace && git apply ../../../device/nothing/Tetris/patches/0041-*.patch && cd -
cd packages/apps/DescartesLaboratory && git apply ../../../device/nothing/Tetris/patches/0042-*.patch && cd -
cd frameworks/base && git apply ../../device/nothing/Tetris/patches/0043-*.patch && cd -
cd frameworks/base && git apply ../../device/nothing/Tetris/patches/0044-*.patch && cd -
cd frameworks/base && git apply ../../device/nothing/Tetris/patches/0045-*.patch && cd -
cd packages/apps/Settings && git apply ../../../device/nothing/Tetris/patches/0046-*.patch && cd -
cd frameworks/base && git apply ../../device/nothing/Tetris/patches/0047-*.patch && cd -
cd vendor/gms && git apply ../../device/nothing/Tetris/patches/0048-*.patch && cd -
cd frameworks/av && git apply ../../device/nothing/Tetris/patches/0049-*.patch && cd -
cd vendor/lineage && git apply ../../device/nothing/Tetris/patches/0050-*.patch && cd -
cd frameworks/base && git apply ../../device/nothing/Tetris/patches/0051-*.patch && cd -
cd frameworks/base && git apply ../../device/nothing/Tetris/patches/0052-*.patch && cd -
cd frameworks/base && git apply ../../device/nothing/Tetris/patches/0053-*.patch && cd -
```

| Patch | What it fixes |
| --- | --- |
| `0001-Settings-Homepage-search-bar-and-language-search.patch` | The floating search bar on the Settings home page took no taps: the click handler was attached to the hidden two-pane copy that shares its ids. In the language pickers the collapsed toolbar title was drawn over the search field, so typed text never showed. The home page app bar honours `ro.descartes.appbar_blur` like the other pages. |
| `0002-frameworks-base-Clock-margins-glass-tiles-and-app-bar-blur.patch` | SystemUI never read the custom clock side margin that Lock Styles saves; it now applies it, with the top margin, to the clock frame. Two device switches: `ro.descartes.qs_glass=false` keeps the ColorOS quick settings on flat tiles instead of compositor blur regions, and `ro.descartes.appbar_blur=false` keeps the Settings app bar on its plain scrim instead of a backdrop blur. Tetris sets both, because its compositor draws those regions without the tile icons and the app bar without its title. The status bar root no longer clips to its corner inset, so a negative start padding moves the clock into the rounded corner instead of cutting it off. The clock gradient from Lock Styles works: SystemUI reads the gradient colours, centre and size and paints one radial gradient across the whole clock. The doze transition of custom clocks goes straight from where it is to the target scale and alpha on a hardware layer, with the emphasized curves, instead of fading to nothing and popping back. The display service has three more screen off animations: slide down, zoom in and fold. With `ro.descartes.ax_window_blur=false` the volume dialog, its ringer drawer and the power menu skip their compositor blur regions, which this GPU draws without corner radius, and use their plain rounded backgrounds. With `ro.descartes.qs_glass=false` the scrim keeps its colour behind the ColorOS and HyperOS panels: it used to turn transparent for a glass that is never drawn, which left the lock screen showing through the tiles of a half-open shade. |
| `0003-AxBlur-Device-default-blur-radius.patch` | AxBlur reads its default radius percentages from `ro.descartes.blur.system_pct` and `ro.descartes.blur.launcher_pct`, so a device tree can start lighter than the 100% upstream default. Tetris sets 40 and 35 in `product.prop`; the user's own setting still overrides them. `ro.descartes.ax_window_blur=false` makes AxBlur draw its own in-app blur instead of compositor regions, which Tetris needs because those regions come out square. |
| `0004-Launcher3-Lighter-default-blur-depth.patch` | Default launcher blur depth 12 instead of 30, so the app drawer and recents animate without stutter on this GPU. Adjustable in the launcher settings. |
| `0005-LockStyles-Wallpaper-and-memory-fixes.patch` | lock styles: "keep home" no longer turns an engine-drawn home screen black or into the new lock picture, the "on lock" shuffle stops skipping a photo every time an app opens, no depth cut-out taken from the home photo when the lock screen is live, re-adopting the current wallpaper can't show a stale cached picture, and the full-screen bitmaps used for wallpapers and effects get recycled instead of piling up in memory. |
| `0006-Atelier-More-screen-off-animations.patch` | Atelier > User interface > Screen off animation lists the new slide down, zoom in and fold animations next to default, CRT and scale. Needs the 0002 framework part. |
| `0007-SystemUI-Wi-Fi-standard-icon-without-end-margin.patch` | Status bar > Icons > Wi-Fi standard moved the icon left and left a gap before the battery: the standard icon shares a frame with the signal icon and its 4sp end margin widened it. Without the margin it sits where the plain signal icon does. |
| `0008-frameworks-base-OmniJawsClient-air-quality-fields.patch` | OmniJaws from crDroid shows an air quality card since 6ecc2cb and reads aqi, aqiScale, pm25, pm10 and AQI_SCALE_IN from OmniJawsClient. The DescartesOS framework did not have them yet and the build failed in DetailCards.kt. Same change as OmniJawsClient.java in crDroid frameworks_base 17.0. |
| `0009-SystemUI-Back-dispatcher-for-the-lock-screen-media-card.patch` | SystemUI crashed every few seconds on the lock screen while music played: the media card's SceneTransitionLayout asks for a back dispatcher and the keyguard root view has none (IllegalStateException: No NavigationEventDispatcherOwner was provided). The card's compose view now gets one when attached, the way the communal hub does. |
| `0010-SystemUI-Space-under-the-drawn-lock-screen-clock.patch` | The lock screen put the media card and the notifications under the measured bottom of the custom clock, so the date of clocks with negative margins or a size above 100% sat on top of them. The clock view now pads its bottom to where its content is drawn, and the media card keeps the same 16dp gap as the notifications. Needs 0002 and 0009. |
| `0011-SystemUI-Center-the-lock-screen-island-card-over-the-player.patch` | An island card opened on the lock screen, such as a download or the Buds panel, started under the small clock and the media card, added later, drew over its lower part. The expanded card now spans from the status bar to the fingerprint icon, so it sits mid screen and a tap anywhere around it closes it, and the media card is hidden while it is open. |
| `0012-services-Add-iris-desaturate-and-shutter-screen-off-animations.patch` | Adds the Iris, Desaturate and Shutter screen off animations from Lunaris. ElectronBeam now draws with the Lunaris GLES2 shaders, and slide, zoom and fold from 0002 are drawn with them too. Needs 0002. |
| `0013-Atelier-List-the-new-screen-off-animations.patch` | Lists Iris, Desaturate and Shutter in the screen off animation setting, as values 6, 7 and 8. Needs 0006 and 0012. |
| `0014-services-Mirror-the-Luminous-switch-to-a-property.patch` | The window manager copies the Laboratory switch `penguin_luminous_all_apps` to `persist.sys.penguin.luminous` (1 system apps, 2 all apps), which apps read to move view animations to the RenderThread. Before, nothing set the property and the switch did nothing. Needs the device sepolicy for `penguin_luminous_prop`. |
| `0015-Launcher3-Apply-the-GPU-blur-tier-once.patch` | The app drawer blur took the mid-range GPU tier twice, through the max radius and again on the COS cap, and ended near zero under the scrim. The tier is now applied once. Needs 0004. |
| `0016-Atelier-Index-every-page-and-drop-the-misc-glass-switches.patch` | Settings search finds the options of every Atelier page: the 15 sub-pages without a search provider now have one. Miscellaneous loses the Liquid glass, refraction and AX glass switches, which now live in Descartes Laboratory, and the glass tab bars start off. Needs 0006 and 0013. |
| `0017-DescartesLaboratory-Drop-dead-options-and-add-AX-glass.patch` | Removes Laboratory switches that nothing reads any more (now bar, lock icon on top, floating depth wallpaper, One UI panel, back to app, frequent apps and five COS parts). The QS panel style is saved in Settings.System, where SystemUI reads it, and the volume style says when the COS volume panel overrides it. Liquid glass gets the AX glass switch moved from Atelier. |
| `0018-SettingsIntelligence-Search-on-the-existing-index.patch` | Settings search no longer waits for the background refresh of non-indexable keys before it answers: when the index was built for this build and locale it is queried right away, and the results reload when the refresh ends. A full rebuild after an update or a language change still waits. |
| `0019-Launcher3-Fade-into-the-splash-on-app-launch.patch` | Opening an app from its icon cut from the icon colour to the splash screen in one frame, white to dark blue for Weather. The COS launch skipped the fade when the app had a splash, and the handoff from the tap preview seeked past it. The splash now fades in over 120 ms from the handoff and the preview stays under it until it is covered. Needs 0004. |
| `0020-Launcher3-Add-recents-styles-from-Lunaris.patch` | Recents layout styles from Lunaris 16.2 (Default, Scale effect, Kami, iOS, OxygenOS), chosen in Home settings > Recents. Default keeps the stock overview. Leaves out the unrelated parts of that series. Needs 0004, 0015 and 0019. |
| `0021-SystemUI-Keep-the-live-lock-wallpaper-under-depth.patch` | With a live lock screen wallpaper, as LockStyles sets, the depth wallpaper drew the home or default image behind the subject and covered it on the lock screen and the PIN. It now draws no background then, and turns spatial off without one. |
| `0022-fonts-Add-a-system-emoji-style.patch` | Emoji style read at boot from persist.sys.emoji_style: android, ios or samsung. The ios and samsung fonts come from vendor/themes/emoji, added by device.mk. Based on Lunaris. |
| `0023-LockStyles-Apply-the-photo-filter-with-effects.patch` | The photo filters had no effect with an unlock effect on, in the preview and on the lock screen. The depth settings page keeps only the fade tuning; the rest is set per lock screen in Customise. |
| `0024-Atelier-Add-the-emoji-style-option.patch` | Emoji style option in Atelier > User interface, applied after a reboot. Needs 0022. |
| `0025-SystemUI-Start-Pulse-from-the-current-lock-screen-state.patch` | Pulse never started on the lock screen with music playing: its start condition was built from events that come from several threads and can arrive out of order, so a stale screen off or media flag kept it stopped. It now reads the current screen, keyguard and media state, and dumps its state in dumpsys. |
| `0026-SystemUI-End-the-lock-screen-clock-at-its-glyphs.patch` | The lock screen clock now ends where its glyphs end, so the media card and notifications sit a fixed 16dp below what is drawn, for every clock style. Font line spacing left up to 110dp of empty space under large digits, and rotated or shifted parts (Block clock) were not counted. Text is measured line by line with shadow and outline; images and views with a background count in full. Replaces the overflow padding of 0010. |
| `0027-services-Read-volume-steps-from-settings.patch` | AudioService takes the media, call, ring, notification and alarm volume steps from the volume_steps_* system settings (5 to 60) at boot. |
| `0028-Atelier-Add-volume-steps.patch` | Atelier > Sound > Volume steps: one slider per stream, with a reboot prompt. Reset restores the stock 15/15/7/7/7. |
| `0029-SystemUI-Fade-the-lock-screen-media-blur-with-the-keyguard.patch` | The iOS-style lock screen media card blur follows the alpha of its parent views, so it no longer stays on the home screen after unlocking. |
| `0030-Launcher3-Make-the-cos-recents-and-fluid-clock-parts-work.patch` | COS Recents also springs the task launch from recents (it only changed the swipe settle before). The Fluid Clock widget is placed again whenever it is missing instead of only once, and a full home screen is logged. |
| `0031-SystemUI-Find-motion-art-for-uploaded-tracks.patch` | Motion art lookup drops a file extension from the title (SoundCloud and local uploads) and logs when a track has no Apple Music match or no motion artwork. |
| `0032-LockStyles-Adopt-the-wallpaper-set-outside-the-app.patch` | LockStyles adopted the built-in default wallpaper whenever the lock screen shared the home wallpaper, then put it back on every apply, clock changes included. It now falls back to the home wallpaper, adopts again when the wallpaper was changed outside the app, and opens on the current lock screen. |
| `0033-Settings-Register-the-search-index-refresh.patch` | Registers Atelier's search index refresh receiver for BOOT_COMPLETED (see 0034). |
| `0034-Atelier-Refresh-the-search-index-on-a-new-build.patch` | Settings search found nothing in Atelier: the search app only rebuilds its index when the fingerprint or the providers' version codes change, and the spoofed fingerprint and Settings' version code never do. On the first boot of each build the index of the search app is cleared, so every page and sub-page is indexed again on the next search. |
| `0035-SystemUI-Centre-the-COS-volume-panel-on-the-landscape-cutout.patch` | In landscape the COS volume panel sat too low. Its column (ringer, slider, expand button and app sliders) is now centred on the side punch hole, or on the screen without one, and kept inside the window. |
| `0036-SystemUI-Keep-the-Modular-QS-header-in-the-status-bar.patch` | With the Modular (Axion) QS style, the header's clock and status icons overlapped the date and the edit, settings and menu buttons, on the lock screen too. The portrait header already sizes itself around the cutout and was padded by the cutout again. |
| `0037-SystemUI-Show-the-ColorOS-QS-modules-after-a-fast-open.patch` | Opening the ColorOS QS quickly left it empty (only the edit and settings buttons): a dip of the fraction while the fling settled hid the modules for good. A fully open panel now always shows them. |
| `0038-SystemUI-Keep-the-depth-subject-off-the-lock-screen-media-card.patch` | The depth wallpaper subject no longer covers the lock screen media card; it still sits over the clock. |
| `0039-SystemUI-Keep-the-stock-carrier-row-in-the-landscape-ColorOS-header.patch` | In landscape the ColorOS QS header is one row: the carrier name keeps its stock place instead of sticking to the date. |
| `0040-Launcher3-Send-freeform-to-the-Descartes-freeform-app.patch` | Freeform from recents sent its request to com.libremobileos.freeform, which no longer exists, and only went home. It now goes to com.descartes.freeform. |
| `0041-GameSpace-Send-freeform-to-the-Descartes-freeform-app.patch` | Same freeform fix for the game panel. |
| `0042-DescartesLaboratory-Say-what-the-fluid-clock-needs.patch` | The Fluid Clock summary says it needs the lock screen clock widget on the first home page, where the clock lands. |
| `0043-SystemUI-Fly-the-fluid-clock-only-after-a-fingerprint-unlock.patch` | The COS fluid clock flies to the home screen widget only when a fingerprint unlocked the device. |
| `0044-services-Add-sleep-mode.patch` | Sleep mode from Lunaris: turns off Wi-Fi, Bluetooth, mobile data and sensors by hand or on a schedule, and restores them even after a reboot. |
| `0045-SystemUI-Add-the-idle-manager-and-the-sleep-mode-tile.patch` | Idle manager from Lunaris, limited to user apps and never the keyboard, phone, messages or next alarm app, plus the sleep mode tile. |
| `0046-Settings-Add-the-sleep-mode-and-idle-manager-pages.patch` | Sleep mode and Idle manager pages under Battery. |
| `0047-SystemUI-Skip-the-water-unlock-effect-with-the-fluid-clock.patch` | The water unlock effects do not play when the COS fluid clock is on. |
| `0048-gms-Drop-Google-apps-nobody-opens.patch` | Drops Feedback, Telemetry, Carrier Metrics, Partner Setup, the kids and glasses stubs and print recommendations. |
| `0049-cameraserver-Cap-the-torch-level.patch` | Caps the torch strength levels at ro.descartes.torch_max_level, for flash drivers that wrap around above it. Unset, nothing changes. |
| `0050-changelog-Use-the-device-changelog.patch` | The build ships the device's Changelog.txt when there is one, instead of ten days of commits from every repository. |
| `0051-SystemUI-Keep-the-depth-layers-off-the-media-card-and-Pulse.patch` | The depth subject is clipped off the media card for real, and the depth background no longer covers Pulse. |
| `0052-SystemUI-Add-the-PenguinOS-island-look.patch` | The stock Dynamic island can wear the PenguinOS pill: size, outline, text colour and side crescents. |
| `0053-services-Give-the-DeX-PC-client-a-desktop.patch` | Displays made from the shell, as the PC client does, are DeX desktops whatever the mirror switch says. |
