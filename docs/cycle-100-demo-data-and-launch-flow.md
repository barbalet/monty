# Cycle 100 Demo Data And Launch Flow

Cycles 81-100 complete the three demo battle data packs and add Monty's first launch-flow layer.

## Demo Data Packs

The demo scope is now backed by `MontyDemoBattleDataPack` records for all three initial battles:

- `MontyAlamElHalfaDataPack`
- `MontySecondElAlameinDataPack`
- `MontyOperationEpsomDataPack`

`MontyDemoDataPackCatalog` exposes the full demo pack list, lookup by battle ID, and the cycle-100 readiness gate.

Each data pack now has:

- A data-locked `HistoricalBattleScenario<MontyBattleID>`
- Two selectable sides: `montgomery` and `opposition`
- At least six map elements
- Two deployment zones
- Four objectives split across Montgomery-side and opposing-side aims
- Force groups for both sides
- Shared `HistoricalAutoplayConfiguration`
- Battle-specific movement priorities for both sides
- Debrief lines for likely outcomes

## New Battle Content

Second El Alamein now includes:

- Devil's gardens minefield belt
- Northern assault corridor
- Southern fixing corridor
- Tel el Eisa ridge
- Axis reserve route
- Armour exploitation zone
- Objectives for minefield clearance, armoured route opening, reserve pinning, and Axis breach sealing

Operation Epsom now includes:

- River Odon
- Odon crossing
- Hill 112 approaches
- Scottish start line
- German shoulder positions
- II SS counterattack route
- Objectives for crossing the Odon, widening the bridgehead, pressuring Hill 112, and containing the salient

## Launch Flow

`MontyLaunchFlow` adds the core route from campaign/briefing selection into the shared battle-surface contract:

- Campaign row
- Briefing
- Side selection
- Shared battle surface
- Debrief
- Persistence

`MontyLaunchFlowResolver` creates a `HistoricalBattleLaunch<MontyBattleID>` for either selectable side, attaches the demo data pack, records the shared battle surface name, and provides stable accessibility identifiers for launch, debrief, and persistence.

`MontyCampaignProgress` and `MontyBattleCompletionRecord` provide the first persistence shape for selected side and debrief completion records.

## App Shell Update

`MontyCampaignView` now uses the launch-flow resolver for demo battles:

- Demo side buttons prepare a launch flow.
- The detail view exposes the shared battle surface contract name.
- A preview debrief can be resolved and stored in local progress state.
- Non-demo rows remain catalog-only until future data packs exist.

This is still not a live DZW board session. It proves the app path and state model that cycles 101-115 can connect to live board/autoplay behavior.

## Verification

- `swift test` in the root `monty` package: passed, 9 XCTest tests.
- `swift build` in the root `monty` package: passed.

## Remaining Work For Later Cycles

- Cycles 101-105 should replace the preview battle/debrief step with legal board-session actions and bidirectional AI behavior.
- Cycles 106-115 should add the `MontyTest` app and make Alam el Halfa autoplay to a real debrief.
- Cycles 116-120 should run final acceptance hardening and produce the demo readiness report.
