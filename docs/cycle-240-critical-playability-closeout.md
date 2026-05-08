# Cycle 240 Critical Playability Closeout

Cycles 211-240 are complete as the final critical playability repair band.

## What Changed

- Replaced board unit name cards with ID-only tactical tokens to prevent unit text from overlapping into unreadable blocks.
- Added a `Forces` sidebar section so full unit names, roles, side ownership, and selected/targeted state remain visible without being painted over the board.
- Added `HistoricalBoardLayoutResolver` to offset clustered unit tokens in board coordinate space and provide a pure readability audit for snapshots.
- Added `HistoricalPlayableBoardViewportProfile` and strengthened the shared readability profile so accepted boards must keep commands reachable and avoid dense always-on board names.
- Added cycle-240 acceptance data in `MontyCycle240CriticalAcceptanceCatalog`, including readability checks for all three demo battles from both selectable sides.
- Added tests that fail if demo opening boards reintroduce direct board name labels or estimated token collisions.

## Verification

- `swift test` from `/Users/barbalet/github/monty`: 31 tests passed.
- `swift test` from `/Users/barbalet/github/monty/guderian/dzw`: 102 tests passed.
- `swift build` from `/Users/barbalet/github/monty/guderian`: passed.
- Visual smoke: opened `MontyTest` and captured `/private/tmp/montytest-cycle240-final.png`; the board now shows numbered unit tokens, separated force details, reachable command buttons, and no dense board text block.

## Known Limitations

- The demo remains three locked battles: Alam el Halfa, Second El Alamein, and Operation Epsom. The other 32 campaign rows are planned content.
- Monty still uses `MontyDemoBoardSession` as a compatibility session over the shared `HistoricalBoardSession` interface. It now follows the shared Guderian-style surface semantics closely enough for critical UI testing, but a deeper native-engine bridge remains future work.
- Movement is still command-driven toward objectives rather than free drag/drop destination selection.
