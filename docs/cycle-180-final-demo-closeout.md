# Cycle 180 Final Demo Closeout

Cycles 161-180 finish the release-hardening block for the Monty playable demo. This pass closes the contract-only surface gap, rehearses save/load relaunch behavior across the demo battles, updates public documentation, and records final acceptance evidence.

## Implemented

- `HistoricalPlayableBattleView` is now a real public SwiftUI surface in `DerZweiteWeltkriegHistorical`, built over `HistoricalBoardSnapshot` and the shared battle accessibility identifiers.
- The Monty app and `MontyTest` both instantiate `HistoricalPlayableBattleView` for the live battle board, command controls, sidebar, objectives, log, action feedback, debrief, and persisted-result state.
- `MontyRelaunchRehearsalCatalog` verifies all three demo battles from both sides can save, reload selected side, reload completion records, reload debrief summaries, restore launch flow, and reject Guderian-owned payloads.
- `MontyDocumentationCleanupCatalog` tracks README, PLAN, cycle-140, cycle-160, and cycle-180 documentation coverage.
- `MontyFinalDemoRehearsalCatalog` reruns scripted UI action flows, deterministic autoplay for all demo battle/side pairs, and MontyTest autoplay to debrief.
- `MontyCycle180AcceptanceCatalog.report()` combines the cycle-160 hardening gates, relaunch rehearsal, docs, final demo rehearsal, build matrix, visual checks, and public shared-surface guard.

## Acceptance Surface

The cycle-180 report is ready when:

- Cycles remaining is zero.
- All three demo battles launch playable boards.
- `HistoricalPlayableBattleView` is a public SwiftUI battle surface, not only a contract string.
- The command set covers selection, targeting, movement, shooting, assault, pending-choice resolution, phase advance, AI phase, restart, and debrief.
- Demo battles can be rehearsed from both selectable sides.
- MontyTest autoplays Alam el Halfa through the same shared surface path.
- Guderian regression coverage remains in the build matrix.
- Visual/accessibility/UI automation guards prevent returning to a static detail-page-only flow.
- Save/load relaunch rehearsal passes without touching Guderian storage.

## Verification

- `swift test` passed with 27 XCTest tests.
- `swift build` passed.
- `swift test` passed in `guderian/dzw`.
- `swift build` passed in `guderian/dzw`.
- `swift test` passed in `guderian`.
- `swift build` passed in `guderian`.
- `xcodebuild -project Monty.xcodeproj -scheme Monty -destination 'platform=macOS' build` passed.
- `xcodebuild -project Monty.xcodeproj -scheme MontyTest -destination 'platform=macOS' build` passed.

## Known Limitations

- The playable demo authors Alam el Halfa, Second El Alamein, and Operation Epsom only.
- The remaining 32 campaign rows stay planned content for the future full campaign.
- Historical tuning is demo-grade and narrower than the eventual 35-battle Montgomery campaign.
