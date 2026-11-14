# Tetris Parts

Tetris Parts holds the CMF Phone 1 controls under Settings > System > Tetris
Parts. It is built from Rodin's Compose components: large collapsing headers,
grouped rounded cards, dynamic Settings colours, animated navigation, live metric
tiles, a battery gauge and a RAM usage bar. CPU, GPU, RAM, battery, temperatures
and the optional adaptive control each have their own page.

## Kernel support

DescartesOS ships the prebuilt `6.1.177-android14-11-Kraken` kernel from
`device/nothing/Tetris-kernel`. That kernel has none of the custom interfaces
Parts can use: the `scaling_locked_limits` cpufreq node, the `boost` command of
`mtk_gpufreq_wrapper.ko` and the charger's `charge_bypass` request. On this
kernel:

- The CPU page shows "Updated kernel required" and labels frequency changes as
  temporary. Android and the Power HAL can still change them.
- Charger-powered mode on the Battery page shows as unavailable.
- The Power HAL's 700 MHz GPU floor during interaction has no effect, because the
  stock module does not implement `boost` in `/proc/gpufreqv2/limit_table`.

Everything else works with the stock kernel: thermal profile control, GPU ranges
through the DEBUG limiter, RAM and battery readings, temperatures and adaptive
control. [KERNEL.md](KERNEL.md) describes the interfaces and how a kernel that
provides them was built upstream.

## Languages and navigation

The app covers the 91 natural locales enabled by this LineageOS product, which is
fewer than Android itself understands. The English base and 85 non-English
resource qualifiers cover those locales, and some regional variants share
resources. `res/xml/locales_config.xml` declares the app languages and leaves out
Android's three test pseudolocales.

Besides Italian there are 82 translated resource sets plus Asturian and Norwegian
Nynorsk. The English strings and some technical wording were reviewed; the
translations have not had a native-speaker review. `tests/check-localizations.py`
checks product coverage, string completeness, formatting placeholders, units,
brands and XML structure, using the product-to-resource mapping in
`tests/localization-expectations.json`. It cannot judge whether a translation is
accurate.

Adaptive control has two tabs. Controls holds the switch, the objective, the
restore action and the current readings. Activity log holds every retained event,
up to the controller's limit of 120. Each tab keeps its own scroll position, and
the selected tab is part of the saved state.

The recovery countdown starts once per continuous episode of unavailable data,
charging, heat or memory pressure. The five-second readings do not restart it.
When it reaches zero the controller waits for the blocking condition to clear and
then collects a fresh baseline, so reaching zero does not by itself authorize a
change. A new episode starts a new interval. The timer is hidden while Adaptive
is off.

Page navigation uses an internal `PartsSubActivity`, the same window navigation
Settings uses for `SubSettings`. Android handles the transition between the Home
and detail windows, including predictive gesture progress, cancellation,
completion and edge direction. Toolbar Back finishes the detail Activity. The
theme uses the framework `Animation.Activity` window style, and the manifest
enables predictive back and RTL. Parts has no NavHost page animation and no
app-wide back callback; the NavHost default scaled the page to 70% in the centre,
which did not match the native Settings gesture.

Notification links open Adaptive with the exact proposal ID and never approve a
change. The Home-to-Adaptive stack stays within the selected task, and restored
Activities do not replay notification requests that were already consumed. A
notification can open a Parts task separate from the one hosted by Settings.
Host tests cover routing, repeated taps, ownership and request restoration.

The English temperature label for the external surface is "Phone casing". Metric
labels wrap so the full description stays visible with longer text or larger
fonts. Internal `TYPE_SKIN` identifiers and raw sensor names are unchanged.

## CPU limits

Both CPU clusters expose their real kernel frequency tables, and the range dialog
applies both bounds together. On a patched kernel, Apply and lock writes
`scaling_locked_limits` to hold the range in the cpufreq policy itself, where
Android's queued QoS requests cannot replace it. Releasing the lock restores the
current QoS aggregate. The lock holds after the app is closed, needs no periodic
userspace writer, and is released by a reboot.

The lock can override software CPU thermal caps even when the separate thermal
switch is off. Hardware, firmware and electrical limits still apply, and no
overclock frequencies are added. With software thermal limits bypassed the phone
can run hotter, draw more power and be damaged.

The core controls keep CPU0 and at least one core per cluster online. Writes are
checked, and a failed write attempts a rollback. "Restore initial CPU values"
releases the locks and restores the ranges and online states the app process
first saw. The thermal profile has its own restore action.

## GPU frequency control

The GPU page reads the MediaTek GPUFREQ v2 interface in `/proc/gpufreqv2`.
`gpu_working_opp_table` lists the supported frequencies, and `gpufreq_status`
gives the active or idle clock and the effective PPM limits. Like the CPU dialog,
the range dialog offers a minimum and a maximum taken from that table, and both
can be equal. It never edits GPU voltages.

Ranges go through the existing `limit_table` interface. Only the DEBUG limiter
(ID 1) changes, with `set 1 <maximum OPP index> <minimum OPP index>`, and
frequency scaling continues inside the interval. An old fixed-frequency selection
is released once the new range is acknowledged. Automatic restoration releases
both this limiter and the old fixed selector without disabling other controllers,
and it stays available when the frequency table cannot be read.

The page shows requested and effective bounds separately. The manager checks the
DEBUG row, the full limiter table against the driver's priority rules, the
reported PPM bounds and, while the GPU is active, the current OPP. A failed
transaction attempts rollback only while the observed settings are still owned by
Parts, because the proc interface has no atomic compare-and-swap against other
writers. Other limiters can narrow the result or win a conflicting range by
driver priority. A powered-down GPU shows as idle instead of reporting its last
clock as active.

The Power HAL asks for earlier GPU upshifts through GED's loading-based DVFS
margin. The upshift thresholds are 43% GPU load during app launch (1500 ms), 47%
during expensive rendering and 52% during interaction. The rendering margin lasts
as long as its hint. The interaction margin follows the display-idle handler,
with a bounded timeout as fallback. When the hints end, the idle threshold
returns to 70%. Each interaction hint also starts a 120 ms margin request with a
30% upshift threshold, on its own hint so its timeout is independent of the 500
to 1500 ms interaction fallback. New interaction hints renew the short request;
once it expires, the strongest remaining margin applies.

The Power HAL also requests a 700 MHz minimum during interaction, app launch and
expensive rendering, with the same hint lifetimes as the margin. The patched
`mtk_gpufreq_wrapper.ko` implements this as the `boost <kHz>` command in
`/proc/gpufreqv2/limit_table`: it maps 700000 kHz to the lowest working OPP at or
above that value, combines the request with existing APIBOOST requests, restores
the latest non-UI request on release, and lets a manual DEBUG range suspend the
floor. Overlapping hints share one floor and the final release writes `boost 0`.
Frequency ceilings and limiter arbitration stay in place. The module and the
powerhint configuration have to ship together; the stock module ignores the
command.

The manual GPU controls use the existing GPUEB firmware interface, and their
settings are not reapplied at boot. The dialog scrolls the explanation and the
controls together for long translations and large fonts. The proc node has its
own SELinux label. App code limits writes to the DEBUG row; SELinux limits file
access but cannot restrict individual rows.

## Thermal profile control

The vendor init action reads `init.svc.thermal_core`. The generic `init.svc.*`
properties are private, and when `ro.actionable_compatible_property.enabled=true`
vendor init rejects actions that reference them, so the helper would never see a
request. The tree gives `init.svc.thermal_core` its own exported label, readable
by the vendor components that need it. Other private init properties stay
private.

The backend confirms the daemon is ready, applies MediaTek's
`disable_throttling.conf`, waits for the profile to take effect and publishes a
fresh completion counter. The UI shows the active profile and the specific
failure reason, allows another disable attempt and offers restoration. An unknown
or error state does not force a restore-only dialog. This works independently of
CPU locking and does not need a patched kernel.

The thermal override resets at reboot and restores the previously active profile
when switched off. The throttling-disable profile keeps emergency shutdown and
hardware protection. [thermal/README.md](thermal/README.md) has the protocol
details.

## RAM and battery

The RAM page shows physical memory, swap and read-only zRAM statistics, and can
terminate selected or all eligible cached third-party apps. Foreground, service,
persistent, system and shared-UID processes are excluded, as are the app's own.
Eligibility is checked again before each request, and the report separates
requests from observed terminations. Android can restart the apps.

The Battery page shows level, charging state, health, temperature, voltage,
current and charge counter. Unsupported measurements show as unavailable instead
of zero. Polling stops whenever a page is not resumed.

The Battery page also has an experimental Charger-powered mode switch, which
needs the patched charger modules from the `nt_supply` driver. It uses only the
charger's dedicated `charge_bypass` request and the versioned
`charge_bypass_status`, and never writes the shared charging-enable or power-path
controls. The request and the hardware state are shown separately. Active means
the kernel verified that battery charging and the charge pumps are off while the
charger power path stays on. The battery remains connected and can supplement
charger power under load. A paused or failed request is never shown as active,
and an existing request can be switched off even when telemetry or the charger
connection is unavailable.

After fast-charge shutdown, the patched driver refreshes the allowed input
current so the phone is not left at the 100 mA limit of the PD stop sequence. It
keeps the source, USB/PD, thermal and known AICL limits without restarting
battery charging. If the input budget cannot be verified or is below the hardware
minimum, the request stays pending and input is suspended until the policy can
verify a usable limit. The battery is not isolated electrically, and no exact
charge level is guaranteed.

The kernel clears the request on unplug and starts with it off after a reboot.
Parts stores no preference and runs no service or periodic writer for this
feature. A consent reset releases only this request; the charger policy decides
whether ordinary charging resumes. `tests/battery/run-tests.sh` checks parsing,
acknowledgement, failed writes, consent races, release and external or kernel
updates. The feature needs matching charger modules, the Parts APK and its init
and SELinux configuration together; installing the APK alone adds nothing, and
mixing old and new charger modules breaks their versioned interfaces. The 12
strings for this feature are translated only into Italian so far, and the
localization checker reports those gaps along with the existing ones.

## Temperatures and adaptive control

The Temperatures page combines the Android thermal service, the readable kernel
thermal zones and the battery temperature. It keeps sensor names and unavailable
values, separates thermal status from a guessed threshold, and shows recent
readings. Tetris's HAL reports one shared SoC maximum under several hardware
labels, so those values are not independent measurements.

Adaptive control is an original local feedback feature. The public
[MaxManager feature description](https://github.com/nader295/Max-Manger) was the
reference; no MaxManager code, graphics, data or private components are included.

It is off until enabled and shows a foreground notification while it runs.
Performance, balanced and battery objectives guide proposals for one supported
CPU-ceiling step on one unlocked cluster, or one GPU-ceiling step, based on
measured load, temperature, battery, memory and classified app-frame
observations. Every change needs explicit approval. A notification opens a review
dialog with the proposed before and after limit, the objective, the reason and
the original readings. Apply starts a measured trial; Reject leaves the limits
alone. The same review is on the Controls tab when proposal notifications are
disabled.

Readings refresh about every 5 seconds, and the Activity log adds at most one
periodic status card every 60 seconds. Proposal decisions also have a 60-second
minimum interval, while actions and state changes are logged as they happen.
There is at most one pending proposal, and it expires after 120 seconds. Its ID
works once, and approval checks the conditions and ownership again. Changing the
objective, stopping, or an incompatible manual or external change cancels it.
Rejected targets back off for ten minutes. A service restart clears proposals,
and a notification cannot recreate or approve an old one.

Opening Parts to review a proposal keeps the original workload's baseline. The
trial waits for that workload to come back before comparing measurements, so the
drop in load caused by opening Parts never counts as a benefit. It compares
observation windows of about thirty seconds while discharging and abandons a
trial it cannot measure once the deadline passes. The journal records measured
differences in current, temperature and frame jank, rejected proposals, trial
results and restorations. It makes no claim of a proven battery-life gain and does
not infer a workload from long-term usage habits.

Manual CPU and GPU writes take priority, including manual requests that change
nothing. Locked CPU clusters and manually selected GPU ranges or fixed
frequencies are only observed. A shared GPU coordinator serializes manual and
adaptive transactions, validates the raw controls and the OPP table before
writing, and tracks ownership. GPU trials change only the maximum, by one
advertised step. A failed trial restores the previous raw settings, and Stop
releases a retained adaptive ceiling back to the automatic `-1/-1` mode. If a new
write cannot be verified, no change is reported as successful, and the GPU page's
automatic-mode action stays available for manual recovery.

The controller does not change the thermal profile or terminate apps. A trial
can restore its earlier limit automatically when its evaluation fails, but it
never applies another optimization without approval. No network or model API is
used, and the controller never starts itself at boot. A normal Stop restores the
values it still owns; a killed or crashed process cannot guarantee that CPU and
GPU limits are cleaned up, and a new process does not take over an existing GPU
range.

### GPU load and frame smoothness

GPU utilization comes from the driver's read-only
`/sys/kernel/ged/hal/gpu_utilization` counter. It is unavailable when the GPU is
inactive or the driver data cannot be read, and CPU utilization is never used in
its place. The SELinux policy allows only this file and traversal of its parent.
This telemetry needs no kernel change.

The foreground app's classified frame history comes from SurfaceFlinger's
`--frametimeline -all` Binder dump. Parts enables no tracing session, resets no
statistics and launches no shell process. The app's system UID and its compositor
Binder permissions already allow the read, so no `android.permission.DUMP` grant
or SurfaceFlinger policy rule is added. The read has a one-second budget and a
2 MiB cap. PIDs, layer names and package identities are used only while selecting
and comparing samples, and are not stored in the journal.

The compositor keeps a finite history, normally 64 display frames, so
five-second polls only sample recent rendering, and the UI labels the coverage
as partial. It shows observed frame counts, the late or dropped percentage, the
dropped count, the target rendering FPS, the display refresh rate and, when
available, the 95th percentile of measured present-to-present intervals. Target
FPS is what the app aims for, which can differ from what it achieves: a 30 FPS
game on a 120 Hz display is not laggy just because the two rates differ. One
rendering surface is selected; frames from a SurfaceView and the app UI around it
are never added together. Duplicate, expired, unclassified, stale or ambiguous
data never counts as smooth frames. Network latency, input latency and rendering
paths the compositor does not report are outside what this feature measures.

An increase needs sustained high load on the proposed CPU or GPU and missed frame
deadlines attributed to the app; jank in the compositor alone does not justify
raising app frequencies. The trial is kept only if comparable frame samples
improve within the temperature and discharge-current budgets. A reduction needs
low load and stable frames, and is kept only with a measured drop in current and
no frame regression. Missing or incomparable frames keep the controller observing
or roll back the current trial. CPU and GPU share one proposal or trial at a time.

## Integration and validation

The platform-signed system_ext app has its own SELinux domain. CPU sysfs
permissions cover only the nodes it uses, and only the vendor helper talks to the
thermal daemon. Product dependencies install the permission XML, the init files
and the helper. The Settings entry is limited to system callers and the primary
user. The Dolby integration ships DolbyAtmos from `packages/apps/DolbyUI`.

Volume-key dispatch needs the `media_session_service` lookup used by
`PhoneWindow` and `MediaSessionManager`, and the app has that permission, scoped
to the lookup. Without it both volume keys can reach a null-service crash.
`tests/check-volume-key-access.py` checks the compiled policy: the lookup is
denied in the baseline and allowed by the new rule, which grants no service
registration rights. The app also has the scoped `notification_service` lookup
for its foreground and proposal notifications; `tests/check-notification-access.py`
checks that rule the same way. If notifications are blocked, the review is still
reachable inside the app.

Host checks under `tests/` cover Compose compilation against Android, AndroidX
and SettingsLib; resource compilation and locale checks; CPU transaction and lock
tests; GPU OPP parsing, acknowledgement, idle state, coordinator and rollback
tests (`tests/run-gpu-tests.sh`); frame parsing, deduplication and cadence tests;
adaptive CPU and GPU decision, approval and ownership tests; temperature
conversion and source tests; kernel logic checks; simulated thermal daemon tests;
SELinux neverallow checks for the current device; and init and property access
checks. `tests/check-gpu-access.py` checks the compiled labels and the narrow GPU
permissions, and `tests/check-frame-gpu-access.py` checks the read-only GPU
counter, the untouched GED siblings and the compositor Binder and socket
permissions.

These checks run on the build host. The following still has to be confirmed on
a phone:

- Thermal disable, restore and retry, and the diagnostic code when it fails.
- With a patched kernel: lock a supported range, leave the app, trigger the
  normal Android performance modes and confirm the bounds stay locked; then
  release the lock and reboot.
- Back-gesture completion and cancellation from both edges, tab scroll positions
  after switching, RTL and translated layouts, light and dark themes, both volume
  keys on every page, RAM app termination and the battery measurements.
- GPU control: a supported range while active, requested versus effective
  limits, equal bounds, migration from an old fixed selection, idle display,
  automatic restoration and behavior after reboot.
- Adaptive control: five-second readings and one periodic log card per minute;
  open a proposal from its notification, reject one and approve another, return
  to the original workload for measurement, and try expired or duplicate taps.
  Also check the in-app review with the notification channel disabled.
- Frame telemetry: compare smooth and visibly stuttering workloads in a game, and
  confirm the target FPS and refresh rate, unavailable data and surface or app
  changes.
- CPU and GPU proposals separately, measured results after returning from review,
  manual overrides during trials, and Stop returning GPU control to automatic.

## Credits

Tetris Parts was written by [lufrz](https://github.com/lufrz). It builds on the
LineageOS settings framework and follows the Rodin Compose UI used across the
DescartesOS Settings pages.
