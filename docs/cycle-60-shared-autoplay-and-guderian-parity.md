# Cycle 60 Shared Autoplay And Guderian Parity

Cycles 41-60 move the next reusable demo surface into the linked DZW stack and prove the parent Guderian package can see it without breaking its current app/test behavior.

## Implemented In `guderian/dzw`

`DerZweiteWeltkriegHistorical` now owns a content-neutral autoplay harness:

- `HistoricalAutoplayRunState`
- `HistoricalAutoplaySpeed`
- `HistoricalAutoplaySidePlan`
- `HistoricalAutoplayConfiguration`
- `HistoricalAutoplayStep`
- `HistoricalAutoplayDebriefRecord`
- `HistoricalAutoplayReport`
- `HistoricalAutoplayRunController`

The controller drives any `HistoricalBoardSession` through movement, shooting, assault, pending-choice draining, phase advance, phase guard handling, both-side activity checks, and final debrief report creation. This gives `MontyTest` the reusable first-battle runner shape before the Monty package exists.

`HistoricalAutoplayContract` now also records `retiredEmbeddedSurfaceNames`, so adapters can name legacy surfaces such as `DZWPlayableBattleView` while advertising the future shared host, `HistoricalPlayableBattleView`.

## Guderian Adapter Proof

`DerZweiteWeltkriegGuderian` now depends on `DerZweiteWeltkriegHistorical` and supplies a thin adapter:

- `GuderianBattleID` conforms to `HistoricalBattleID`.
- `GuderianHistoricalScenarioAdapter` converts existing `GuderianScenario` records into `HistoricalBattleScenario<GuderianBattleID>`.
- `GuderianHistoricalAutoplayCatalog` exposes the first-battle shared autoplay contract and configuration for Tuchola Forest.
- `GuderianHistoricalAutoplayRewriteReport` is the cycle 46-55 readiness gate.

This is an adapter-layer rewrite, not yet a SwiftUI host rewrite. The current Guderian UI still renders `DZWPlayableBattleView`; the shared contract now marks that as retired and exposes the reusable host name that Monty should target.

## Parent Guderian Integration

`GuderianCore` now directly depends on and re-exports `DerZweiteWeltkriegHistorical`.

`GuderianTestFirstBattleAutoplayContract` exposes:

- `sharedHistoricalAutoplayContract`
- `sharedHistoricalScenario()`

The parent test suite now checks that the existing Guderian first-battle test harness can be described through the shared historical scenario and autoplay contracts while preserving the legacy `DZWPlayableBattleView` runtime.

## Acceptance Tests Added

In `guderian/dzw`:

- Historical autoplay can step a generic board session through legal actions.
- Historical autoplay can complete to debrief with both sides acting.
- Guderian scenarios adapt to the shared historical scenario contract.
- Guderian first-battle autoplay exposes the shared historical harness contract.

In `guderian`:

- Guderian exposes first-battle autoplay through shared historical contracts from the parent package boundary.

## Verification

- `swift test` in `guderian/dzw`: passed, 101 XCTest tests.
- `swift build` in `guderian/dzw`: passed.
- `swift test` in `guderian`: passed, 132 XCTest tests plus 17 Swift Testing tests.
- `swift build` in `guderian`: passed.
- `xcodebuild -project Guderian.xcodeproj -scheme Guderian -configuration Debug -destination 'platform=macOS' build`: passed.
- `xcodebuild -project Guderian.xcodeproj -scheme GuderianTest -configuration Debug -destination 'platform=macOS' build`: passed after rerunning sequentially. The first parallel attempt failed with Xcode's build database lock.

## Remaining Work For Later Cycles

- Move or wrap the concrete SwiftUI playable battle host so `HistoricalPlayableBattleView` becomes an actual reusable UI surface rather than a contract name.
- Give Guderian runtime adapters a real `HistoricalBoardSession` bridge instead of keeping the current `NativeBoardSession` path private to Guderian.
- Start cycles 61-75 by adding the root Monty Swift package, app shell, and 35-battle catalog scaffold against the shared contracts.
