# Native Activity navigation host tests

`./run-tests.sh` compiles the production `PartsActivity.kt` with small Android,
Compose and screen test doubles and exercises its lifecycle methods, route
validation, toolbar callbacks, notification forwarding, saved-state restoration,
owner checks and rapid-tap handling. The tests run that file directly, not a copy
of the navigation code.

The doubles record Activity launches and screen inputs. They do not simulate
WindowManager, task selection, the back gesture, composition or Compose's
saveable-state registry. Saving the unconsumed review input is covered here; the
popup's own saved state belongs to `AdaptiveScreen`.

Still to check on a phone:

- Enter each page from Home, use toolbar Back, and repeat with three-button Back.
- Drag predictive Back from both edges, cancel halfway, then drag again and commit.
- Repeat in RTL and with light and dark themes; check the window background and
  corners.
- Rotate Home, a scrolled page and Adaptive with an open review dialog. Confirm
  Adaptive's selected tab and both lists keep their positions.
- Tap monitoring and proposal notifications with the app closed and while Home,
  GPU or Adaptive is open. Confirm the exact proposal is reviewed and Back
  reaches Home.
- Recreate the process while reviewing: expired or nonexistent proposal IDs must
  stay unavailable, and opening a notification must never approve a change.

Notifications can select a separate Parts task when Parts was opened inside
Settings. `CLEAR_TOP | SINGLE_TOP` deduplicates within the selected task; these
tests do not cover global task deduplication or the animation itself.
