# Cycle 40 Shared Historical Layer

Cycles 21-40 create the first code-bearing shared layer for Monty/Guderian reuse.

## Implemented In `guderian/dzw`

New product and target:

- Product: `DerZweiteWeltkriegHistorical`
- Target path: `Sources/DerZweiteWeltkriegHistorical`
- Current dependency: `DerZweiteWeltkriegCore`

The target is intentionally Core-only in this cycle. The original cycle-20 sketch listed `DerZweiteWeltkriegAppUI` as a dependency, but the current DZW app UI imports `DerZweiteWeltkriegGuderian`, and `DerZweiteWeltkriegGuderian` will later need to depend on the historical layer. Making the new target depend on AppUI now would create the wrong dependency direction. The UI extraction should invert that dependency in a later pass.

## Shared Contracts Added

`HistoricalBattleContracts.swift`:

- `HistoricalBattleID`
- `HistoricalBattleStatus`
- `HistoricalSideRole`
- `HistoricalSideOption`
- `HistoricalBattleScenario`
- `HistoricalBattleMap`
- `HistoricalMapElement`
- `HistoricalDeploymentZone`
- `HistoricalObjective`
- `HistoricalVictoryProfile`
- `HistoricalVictoryBand`
- `HistoricalSourceLink`

`HistoricalBattleLaunch.swift`:

- `HistoricalController`
- `HistoricalEnginePlayerSlot`
- `HistoricalEngineSideBinding`
- `HistoricalBattleLaunch`
- `HistoricalSideSelectionError`
- `HistoricalBattleLaunchResolver`

`HistoricalBoardSession.swift`:

- `HistoricalBoardSession`
- `HistoricalBoardSnapshot`
- `HistoricalBoardMissionSnapshot`
- `HistoricalBoardUnitSnapshot`
- `HistoricalBoardZoneSnapshot`
- `HistoricalBoardObjectiveSnapshot`
- `HistoricalBoardActionMessage`
- `HistoricalBoardPhase`
- `HistoricalBoardActionStatus`

`HistoricalPlayableSurface.swift`:

- `HistoricalPlayableSurfaceStage`
- `HistoricalPlayableSurfaceContract`
- `HistoricalPlayableSurfaceCatalog`
- `HistoricalAutoplayContract`

`HistoricalScenarioBoardHook.swift`:

- `HistoricalScenarioBoardHookMigration`
- `HistoricalScenarioBoardHookCatalog`

## Acceptance Tests Added

New test file:

- `guderian/dzw/Tests/DerZweiteWeltkriegTests/HistoricalCampaignContractsTests.swift`

Test coverage:

- Historical scenarios require exactly two selectable sides.
- Either side can be chosen as the human side.
- Human side defaults to `DZW_PLAYER_ONE`; AI side defaults to `DZW_PLAYER_TWO`.
- Unknown side IDs are rejected.
- The shared playable surface contract covers side selection, board, combat, AI turn, debrief, and persistence.
- The future `MontyTest` shape is represented by a reusable autoplay contract.
- A generic board-session implementation can snapshot, select, move, shoot, advance phase, and log actions through the shared protocol.
- The Guderian-named C hook has a documented migration path to `game_apply_historical_scenario_board`.

## Verification

- `swift test` in `guderian/dzw`: passed, 97 XCTest tests.
- `swift test` in `guderian`: passed outside the sandbox, 132 XCTest tests plus 16 Swift Testing tests.

## Remaining Work For Later Cycles

- Cycles 41-45 should generalize the first-battle autoplay runner more deeply.
- Cycles 46-60 should rewrite Guderian adapters to import and use `DerZweiteWeltkriegHistorical`.
- A later UI extraction should move or wrap the concrete SwiftUI battle host so `HistoricalPlayableBattleView` becomes the real reusable view, not only the contract name.
- The C hook still needs an implementation migration from `game_apply_guderian_scenario_board` to a generic historical-scenario wrapper.
