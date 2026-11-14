# Tetris thermal policy bridge

The app requests `sys.tetrisparts.thermal_disabled=1` or `0`. The vendor helper
uses MTK's existing `/dev/socket/thermal_socket`, sends the fixed command
`apply disable_throttling.conf` and confirms the accepted profile through
`/data/vendor/thermal/.current_tp`, respecting the daemon's file lock.

The app reads these properties, all under `vendor.tetrisparts.`:

| Property suffix | Meaning |
| --- | --- |
| `thermal_state` | `changing`, `disabled`, `enabled`, or `error` when the actual state is unknown |
| `thermal_profile` | The confirmed `.current_tp` basename, or empty if unreadable or unconfirmed |
| `thermal_error` | `none` or the last failure code |
| `thermal_errno` | Associated OS error number, or 0 for a protocol or profile failure |
| `thermal_result_id` | Completion counter; read it before requesting and wait for a different value |

The completion counter is published after the profile, error and state are
written. It resets to zero at boot and advances for successes and failures alike,
including repeated requests for the same mode. A failed disable with a successful
rollback reports `enabled` plus the failure code, and the UI lets the user try
again. An unknown state does not lock the user into a restore-only dialog.

Failure codes: `current_missing`, `current_denied`, `current_busy`,
`current_invalid`, `profile_missing`, `profile_denied`, `profile_unsafe`,
`snapshot_failed`, `socket_missing`, `socket_denied`, `socket_connect_failed`,
`socket_send_failed`, `socket_timeout`, `apply_unconfirmed`, `restore_missing`,
`restore_failed`, `daemon_stopped`. The helper also logs the code, errno and
observed profile to the system log under its executable name.

## Init compatibility

`thermal_core` keeps its stock legacy service name. In current Lineage policy the
generic `init.svc.*` prefix is a private system property, and vendor init rejects
an action that references one when
`ro.actionable_compatible_property.enabled=true`. A syntactically valid RC file
does not reveal this. `init.svc.thermal_core` therefore has an exact exported
property label, readable by vendor init and this helper and writable only by
init. Test both the RC syntax and the effective property-read policy.

The single action runs after boot for each request and every daemon status
change. The helper confirms that the daemon is running, then sends an empty
half-closed socket probe. The daemon's receive-zero path parses no command and
closes the client, which shows it has finished startup and reached its accept
loop before the helper reads `.current_tp`; otherwise the file can still hold a
stale profile from a previous process. Real apply commands also wait for the peer
to close and then check the profile file. A socket write alone is not an
acknowledgment.

## Profile and restore behavior

The stock profile in the current vendor repository has `permanent=No` and
`[LTF-disable-throttling] HW_protection=enabled`, and the helper verifies both
fields before applying it. The profile disables MTK's software throttling,
including CPU table limits, isolation and skin control. MTK's software emergency
shutdown and the LVTS hardware reboot protection stay enabled, and firmware or
other power, voltage and current constraints can still limit frequency. The AIDL
thermal HAL keeps running to report temperatures; its disable property is not
used.

Vendor profiles encode printable characters 32..122 by adding the column modulo
10, wrapping within that 91-character alphabet. The stock `disable_thermal.conf`
disables hardware protection and persists across reboots, so the helper never
applies it. The helper checks custom profiles first, matching the daemon's
`/data/vendor/thermal` precedence, and rejects invalid overrides.

Before disabling, the helper saves the active profile basename atomically in
`/data/vendor/tetrisparts/thermal_previous` with mode 0600. Enabling restores
that profile. The helper runs as UID 0 with all Linux capabilities dropped, so it
can read the daemon's root-owned mode 0600 acknowledgment, and SELinux limits it
to this protocol and its own restore file. The snapshot survives helper and
daemon restarts and is removed at boot. Neither the request nor the selected
disable profile persists. Without a restore point, enabling falls back to
`thermal.conf`.

This uses an existing vendor interface and needs no kernel change. Host tests
cover profile validation and a simulated socket daemon, including readiness
timeouts, locked or missing acknowledgment files, restore failures, rollback and
atomic snapshots. The behavior on a built ROM still has to be checked on a phone.

The socket protocol was inspected in the `thermal_core` binary with Build ID
`e0f91001281758f372b93cd86be034ea`: it parses `%50s %50s`, handles `apply`,
closes its client after queuing the command, and updates `.current_tp` after
parsing the profile. Recheck this when that blob changes.

## Host policy check

`tests/check_property_access.py` queries effective access from the compiled
binary policy with libsepol, including attributes and constraints. It resolves
property contexts (exact match, then longest prefix), checks every RC property
trigger's `vendor_init` read permission, checks the request and diagnostic
permissions, and reproduces the old denial by resolving `init.svc.thermal_core`
without its exact context. It reads an offline policy file and does not touch the
host kernel's policy.

Pass `--policy`, `--rc` and repeated `--property-contexts` inputs (platform,
current device system_ext and vendor contexts). If the distribution's libsepol is
older than Android's policy capabilities, pass `--libsepol` with the matching
Android host library; the Android host `libsepol.a` can be linked into a
temporary shared library for this, with no ROM rebuild.
