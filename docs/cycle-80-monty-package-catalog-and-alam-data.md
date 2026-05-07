# Cycle 80 Monty Package, Catalog, And Alam Data

Cycles 61-80 create Monty's first code-bearing package layer on top of the shared DZW historical contracts.

## Root Package Scaffold

New root SwiftPM package:

- `Package.swift`
- `Sources/MontyCore`
- `Sources/MontyApp`
- `Sources/MontyAppHost`
- `Tests/MontyTests`

The package depends on the linked DZW submodule at `guderian/dzw` and imports `DerZweiteWeltkriegHistorical` for shared battle, side-selection, and autoplay contracts.

Products and targets:

- `MontyCore`: catalog, app identity, storage keys, demo data packs.
- `MontyAppUI`: initial SwiftUI campaign browser.
- `MontyApp`: executable app host.
- `MontyTests`: catalog and demo-data acceptance tests.

## Monty App Identity

`MontyAppIdentity` now defines:

- App name: `Monty`
- Bundle identifier: `com.barbalet.monty`
- Storage prefix: `com.barbalet.monty`
- Campaign progress storage key
- Selected side storage key
- Shared battle surface name from `HistoricalPlayableSurfaceCatalog`

The initial SwiftUI shell opens directly into the playable-workflow surface area: a campaign list, battle detail, side-selection buttons, objectives, map preview, and sources.

## 35-Battle Catalog Shell

`MontyBattleCatalog` converts the README chronology into typed scenarios:

- 35 `MontyBattleID` cases.
- Orders 1-35 match the README roster.
- Command phase counts match the README table: 2, 8, 5, 9, 4, and 7.
- Every battle is represented as `HistoricalBattleScenario<MontyBattleID>`.
- Every scenario has two selectable sides: `montgomery` and `opposition`.
- Every scenario has source links, placeholder map elements, deployment zones, objectives, and victory bands.

The demo scope remains:

- `alamElHalfa`
- `secondElAlamein`
- `operationEpsom`

## Alam El Halfa Data Pack

`MontyAlamElHalfaDataPack` starts the first playable demo data slice:

- Status: `dataLocked`
- Six map elements: ridge, minefield belt, anti-tank line, southern approach, air interdiction zone, and lateral track.
- Two deployment zones: Eighth Army prepared boxes and Axis southern approach.
- Four objectives: hold ridge, preserve anti-tank screen, disrupt Axis fuel tempo, and Axis breakthrough onto the ridge.
- Four force groups covering Eighth Army command, anti-tank screen, Axis vanguard, and Axis support columns.
- Shared `HistoricalAutoplayConfiguration` with Montgomery and Axis AI side plans.
- Initial debrief lines for historical defence, Axis pressure, and decisive defence outcomes.

This is not yet a live DZW board session. It is the content and contract layer that cycles 81-95 can use when expanding the remaining demo data packs.

## Acceptance Tests Added

`MontyCatalogTests` verifies:

- The catalog has exactly 35 battles in README order.
- Command phase counts match the researched roster.
- Every scenario uses the shared historical battle contract and has two playable sides.
- The three demo battles remain locked.
- Alam el Halfa is data-locked and cycle-80-ready.
- Either side can be selected as the human side for Alam el Halfa.
- Alam el Halfa exposes shared autoplay contract shape and side AI priorities.
- App identity and storage keys are stable.

## Verification

- `swift test` in the root `monty` package: passed, 6 XCTest tests.
- `swift build` in the root `monty` package: passed.

## Remaining Work For Later Cycles

- Cycles 81-95 should author Second El Alamein and Operation Epsom data packs and add more battle-specific map detail.
- Cycles 96-105 should wire campaign row, briefing, side selector, shared battle screen, debrief, and persistence.
- `MontyTest` remains scheduled for cycles 106-115.
