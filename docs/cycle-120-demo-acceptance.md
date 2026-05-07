# Cycle 120 Demo Acceptance

Cycles 101-120 turn the three data-locked Monty demo battles into runnable demo sessions through the shared `DerZweiteWeltkriegHistorical` harness.

## Implemented

- `MontyDemoBoardSession` conforms to `HistoricalBoardSession` for every demo data pack.
- The session exposes deterministic unit, zone, objective, mission, action, and event-log snapshots.
- Legal board actions now exist for movement, shooting, assault, pending-choice resolution, phase advance, cover, hull-down, facing, and target selection.
- `MontyDemoAutoplayRunner` runs Alam el Halfa, Second El Alamein, and Operation Epsom from either selectable side.
- Each autoplay run uses the shared DZW `HistoricalAutoplayRunController`, requires both sides to act, reaches debrief, and records Monty campaign progress.
- The campaign app's demo debrief button now runs the autoplay harness instead of creating a preview-only completion.
- `MontyTest` builds as a standalone executable and opens directly into Alam el Halfa.
- `MontyTest` includes run, step, pause, restart, speed, safety-cap, event-log, battle-surface, result-panel, and result-summary controls with stable accessibility identifiers.

## Acceptance Surface

The cycle-120 report is provided by `MontyDemoAcceptanceCatalog.report()` and is considered ready when:

- The cycle range is 101-120.
- The demo battle IDs match `MontyBattleCatalog.demoBattleIDs`.
- There are six autoplay runs: three battles times two selectable sides.
- Every run reaches debrief without blockers.
- Every run records both sides acting.
- The `MontyTestFirstBattleRunController` completes Alam el Halfa to debrief.
- The MontyTest accessibility contract includes the first-battle surface, restart control, and result summary.

## Verification

- `swift test` passed with 13 XCTest tests.
- `swift build` passed for the root package, including `MontyApp` and `MontyTest`.

The remaining larger reuse task is to replace the lightweight MontyTest board rendering with the fully shared DZW/Guderian playable SwiftUI battle surface once that UI extraction is scheduled for a later hardening pass.
