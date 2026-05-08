# Cycle 140 Visual, Accessibility, And UI QA

Cycles 121-140 harden the Monty demo surface after the cycle-120 autoplay acceptance pass. The goal of this block is to make the visible app path commandable enough for visual QA and scripted UI action checks, while preserving the existing shared historical harness and MontyTest autoplay behavior.

## Implemented

- The Monty app launch path now creates a live `MontyDemoBoardSession` after side selection instead of showing only a `Run to Debrief` shortcut.
- The battle detail route now exposes a commandable board with terrain zones, objectives, unit tokens, selected/targeted state, action feedback, controls, AI phase execution, event log, debrief, restart, and persisted-result identifiers.
- Core accessibility IDs now live in `MontyAccessibilityID` and `MontyAccessibilityCatalog`, covering campaign rows, side selection, battle board, sidebar, objectives, log, command buttons, AI phase, debrief, persisted result, and MontyTest controls.
- `MontyScreenshotQACatalog` records repeatable screenshot targets for campaign, briefing, side selection, desktop board, compact board, debrief, and MontyTest.
- `MontyUIAutomationCatalog` and `MontyUIAutomationRunner` execute six scripted flows: three demo battles times two selectable sides. Each script selects a side, selects and targets units, moves, shoots, resolves a pending choice, advances phase flow, runs an AI phase, reaches debrief, and records persistence.
- `MontyCycle140AcceptanceCatalog.report()` summarizes the cycle-140 visual/accessibility/screenshot/automation gate.

## Acceptance Surface

The cycle-140 report is ready when:

- The cycle range is 121-140.
- Demo data packs retain enough map, objective, and force detail for the visual pass.
- The shared playable-surface accessibility IDs and MontyTest IDs are centralized and covered.
- Screenshot targets cover all required demo states at stable desktop and compact dimensions.
- All six UI automation scripts reach debrief with both sides acting and persisted results.

## Verification

- `swift test` passed with 17 XCTest tests.
- `swift build` passed.
- `xcodebuild -project Monty.xcodeproj -scheme Monty -destination 'platform=macOS' build` passed.
- `xcodebuild -project Monty.xcodeproj -scheme MontyTest -destination 'platform=macOS' build` passed.

## Remaining Work For Later Cycles

- Completed in later cycles: cycles 141-160 broadened UI automation, interaction polish, build-matrix coverage, and save/load hardening.
- Completed in later cycles: cycles 161-180 added the concrete `HistoricalPlayableBattleView`, relaunch rehearsal, final demo rehearsal, release documentation cleanup, and explicit closeout of the old contract-only acceptance gap.
