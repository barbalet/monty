# Cycle 210 Critical Playability Interface Repair

Cycles 181-210 are complete as the first half of the post-180 playability repair band.

## What Changed

- Audited the Guderian gameplay boundary around `BattleBoardView`, `GameController+Actions`, `GameController+Queries`, `BattleControlsSection`, and `NativeBoardSession`.
- Added `HistoricalBoardInteractionResolver` so the shared board now follows the Guderian selection intent: tapping an active-side unit selects it, and tapping an opposing unit targets it.
- Wired direct board selection, direct target selection, and clear-selection callbacks through Monty and `MontyTest`.
- Added `MontyDemoBoardSession.clearSelection()` and regression coverage for board-token selection, targeting, and clearing.
- Removed dense always-on terrain and objective names from the shared board layer; terrain names now live in a sidebar summary, objective tokens use compact numeric markers, and unit tokens use abbreviated labels with full help/accessibility text.
- Capped the shared board height in the Guderian-style layout so the command buttons stay reachable in `MontyTest` instead of falling below the visible play surface.
- Added cycle-210 catalog/report coverage so the plan no longer treats the Guderian interface gap as prose-only acceptance.

## Remaining Risks

- `MontyDemoBoardSession` is still a Monty compatibility session. Cycles 211-240 must either replace it with a real native-engine bridge or make the adapter parity explicit enough that it cannot be mistaken for a scripted mock.
- The visual repair is an emergency declutter, not final proof. Cycles 211-240 still need screenshot/pixel checks across all three demo battles and compact layouts.
- Direct token selection is now wired, but movement is still command-button movement toward objectives rather than drag/pick-destination movement.

## Verification

- `swift build` from `/Users/barbalet/github/monty`: passed.
- `swift test` from `/Users/barbalet/github/monty`: 29 tests passed.
- `swift test` from `/Users/barbalet/github/monty/guderian/dzw`: 102 tests passed.
- `swift build` from `/Users/barbalet/github/monty/guderian`: passed.
- Visual smoke: opened `MontyTest` and captured `/private/tmp/montytest-cycle210-final.png`; the post-fix board no longer shows the previous dense terrain/objective text block, and the primary command buttons remain visible.
