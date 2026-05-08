# Cycle 160 UI Polish, Build Matrix, And Save/Load Hardening

Cycles 141-160 extend the cycle-140 visual/accessibility pass into fuller scripted action coverage, user-facing interaction polish, build-matrix verification, and Monty-owned campaign progress persistence.

## Implemented

- `MontyExtendedUIAutomationCatalog` now requires every demo-battle script to cover both selectable sides, all three demo battles, and the assault command path.
- The live Monty battle surface now exposes compact horizontal fallback layout, a stable adaptive command grid, disabled-state hints, tooltips, restart controls, visible action feedback, selection and target highlighting, objectives, log, debrief, and persisted-result identifiers.
- `MontyBuildMatrixCatalog` records the expected verification matrix across root SwiftPM, DZW, Guderian, and both Xcode schemes.
- `MontyCampaignProgressCodec` stores progress inside a versioned Monty envelope with the bundle identifier and storage prefix, then rejects payloads that belong to another app such as Guderian.
- The Monty app now loads and persists selected side, completion records, and debrief progress through Monty-owned `AppStorage` keys.
- `MontyCycle160AcceptanceCatalog.report()` summarizes the cycle-141-through-160 gate.

## Acceptance Surface

The cycle-160 report is ready when:

- The cycle range is 141-160 and cycle-140 acceptance is still ready.
- UI automation scripts cover assault, both sides, and all demo battles.
- Interaction polish covers compact board layout, stable controls, disabled-state clarity, blocked-action feedback, selection visibility, sidebar log, and debrief.
- The build matrix lists root, DZW, Guderian, and Xcode scheme commands.
- Progress round-trips selected side, completion records, and debrief summaries through Monty storage while rejecting non-Monty payloads.

## Verification

- `swift test` passed with 22 XCTest tests.
- `swift build` passed.
- `swift test` passed in `guderian/dzw`.
- `swift build` passed in `guderian/dzw`.
- `swift test` passed in `guderian`.
- `swift build` passed in `guderian`.
- `xcodebuild -project Monty.xcodeproj -scheme Monty -destination 'platform=macOS' build` passed.
- `xcodebuild -project Monty.xcodeproj -scheme MontyTest -destination 'platform=macOS' build` passed.

## Remaining Work For Later Cycles

- Completed in cycles 161-180: relaunch rehearsal now covers all three demo battles from both sides, user-facing docs describe actual playable behavior, `HistoricalPlayableBattleView` is a concrete public SwiftUI surface, and the final acceptance closeout records evidence and known limitations.
