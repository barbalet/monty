# Monty 240-Cycle Playable Demo Plan

## Order-Dice Rules Migration: Monty 200-Cycle Downstream Plan

This plan tracks Monty's downstream migration after DZW and Guderian adopt the order-dice methodology. Monty must consume the shared DZW/Guderian contracts and keep Montgomery-specific content, copy, AI priorities, demo scenarios, progress, and docs separate.

## Dependency Order

1. `guderian/dzw/PLAN.md` owns the rules-engine migration.
2. `guderian/PLAN.md` owns the Guderian scenario/UI/AI adaptation.
3. This Monty plan owns downstream compatibility, demo data, UI, MontyTest, documentation, and release acceptance.

Monty work should not define alternate order rules. If a needed rule is missing, it belongs in DZW first.

## Cycle Range Summary

- **Cycles 1-20:** dependency audit and compatibility expectations.
- **Cycles 21-45:** Monty scenario data migration to order-dice inputs.
- **Cycles 46-75:** Monty app UI conversion to shared order-dice battle surface.
- **Cycles 76-105:** Monty AI/autoplay and MontyTest migration.
- **Cycles 106-130:** three playable demo battles retuned for order-dice play.
- **Cycles 131-155:** persistence, accessibility, visual QA, and harness updates.
- **Cycles 156-180:** documentation/book updates and build matrix.
- **Cycles 181-200:** final downstream acceptance and release handoff.

## Cycles 1-200

| Cycles | Focus | Technical Output |
| --- | --- | --- |
| 1-5 | Dependency audit | Identify every Monty type that imports DZW historical snapshots, Guderian shared UI, `MontyDemoBoardSession`, launch flow, side selection, autoplay, and old phase/action names. |
| 6-10 | Contract comparison | Compare Monty's existing demo session and shared battle view calls with the new Guderian order-dice consumer APIs. List required adapter changes before editing gameplay. |
| 11-15 | Compatibility gates | Add tests that fail if Monty's default playable path still assumes side-wide movement/shooting/assault phases once DZW/Guderian expose order dice. |
| 16-20 | Migration shim decision | Decide which Monty-only demo-session pieces can be deleted, which become thin adapters, and which must move down into Guderian/DZW shared contracts. |
| 21-25 | Side and order ownership | Map Montgomery and opposition side IDs onto DZW order-dice side ownership, drawn dice, human/AI control, and selected-side persistence. |
| 26-30 | Unit quality data | Assign morale quality, officer modifiers, weapon classes, vehicle classes, and pin behavior to Alam el Halfa, Second El Alamein, and Operation Epsom data packs. |
| 31-35 | Terrain data | Reclassify Monty demo terrain into open, rough, obstacle, building, road, soft cover, hard cover, and impassable/wreck interactions used by DZW movement and shooting. |
| 36-40 | Objective/scoring pacing | Convert phase-count scoring assumptions to turn/activation-aware objective scoring, debrief thresholds, and safety caps. |
| 41-45 | Launch flow | Update `MontyLaunchFlow` and related records to store ruleset, selected side, order-dice launch seed, order cup state where needed, and compatibility metadata. |
| 46-50 | Shared UI adoption | Replace phase command assumptions in Monty's use of `HistoricalPlayableBattleView` with order picker, drawn die, eligible units, order-test result, and activation log controls. |
| 51-55 | Board session adapter | Replace or retire `MontyDemoBoardSession` as a rules authority. It may only remain as a thin compatibility adapter over DZW/Guderian order-dice session semantics. |
| 56-60 | Controls | Replace old Move/Shoot/Assault/Next Phase affordance expectations with Fire, Advance, Run, Ambush, Rally, Down, execute-order, and end-turn cleanup controls. |
| 61-65 | Sidebar | Add pin count, quality, order state, retained order, order-test details, target reaction, vehicle damage, and morale/debrief status to Monty's sidebar data. |
| 66-70 | Human interaction | Make direct board selection feed order-dice commands: choose drawn side's unit, choose order, preview legal movement/targets, execute, then wait for the next die. |
| 71-75 | Error handling | Replace phase-based disabled-state messages with order eligibility, order-test failure, pin, movement, terrain, target, reaction, retained-order, and turn-end explanations. |
| 76-80 | Monty AI model | Convert Montgomery and opposition AI plans to choose units/orders/actions when their side's die is drawn instead of running a full scripted side phase. |
| 81-85 | Autoplay runner | Update `MontyDemoAutoplayRunner` so each step is an activation with order choice, order test, action execution, and turn-end cleanup. |
| 86-90 | MontyTest | Convert `MontyTest` to show order cup, drawn side, current activation, order choices, activation log, safety cap, and run-to-debrief outcome. |
| 91-95 | Replay signatures | Add deterministic replay signatures for the three demo battles under the new order-dice rules and both selected sides. |
| 96-100 | AI fallback behavior | Add Rally/Down/Ambush choices, pin-aware target selection, and activation skipping/failure handling for both Monty playable sides. |
| 101-105 | Debrief records | Ensure debrief records capture winning side, selected side, turn count, activation count, score, and relevant order-dice blockers. |
| 106-110 | Alam el Halfa tuning | Retune movement distances, ridge defense, Axis armour pressure, mine/terrain effects, pins, Down/Ambush/Rally decisions, and debrief thresholds. |
| 111-115 | Second El Alamein tuning | Retune minefield lanes, infantry/armour mix, objective pressure, pins from artillery/HE, Advance/Run pacing, and debrief thresholds. |
| 116-120 | Operation Epsom tuning | Retune Odon crossings, bridgehead expansion, Hill 112 pressure, German counterattack behavior, vehicle damage, and close-quarters outcomes. |
| 121-125 | Cross-demo balance | Normalize activation counts, safety caps, AI pressure, scoring ranges, order variety, and failure/debrief pacing across all three demos. |
| 126-130 | Both-side acceptance | Prove each demo can be played as Montgomery or the opposing force through at least one full order-dice turn and through autoplay debrief. |
| 131-135 | Persistence migration | Version Monty's campaign progress and selected-side storage for order-dice battle records. Preserve old completion data where possible. |
| 136-140 | Accessibility identifiers | Stabilize identifiers for order cup, die draw, order picker, unit order, pin count, order test, Rally, Down, Ambush, Fire, Advance, Run, and debrief. |
| 141-145 | Screenshot QA | Add screenshot targets for campaign, side selection, order-dice battle, activation log, debrief, compact layout, and MontyTest. |
| 146-150 | UI automation | Update UI automation scripts so they choose a side, draw/observe a die, choose an eligible unit, assign an order, resolve action, run AI activation, and reach debrief. |
| 151-155 | Readability audit | Ensure order-dice UI additions do not reintroduce board label collisions, hidden controls, or unreadable compact layouts. |
| 156-160 | README and book docs | Update Monty README/book docs to explain order dice, selected side, order choices, pins, morale, AI activations, and demo limitations. |
| 161-165 | PLAN/docs alignment | Update Monty cycle docs and acceptance catalogs so stale phase-flow terms no longer describe the default game. |
| 166-170 | Build matrix | Run root `swift test`, root `swift build`, Guderian build/test, DZW build/test, and any maintained Xcode scheme checks. |
| 171-175 | Visual rehearsal | Perform manual rehearsal for all three demo battles from both sides with screenshots or notes covering order cup, activation flow, and debrief. |
| 176-180 | Downstream bug pass | Fix Monty-only integration bugs found after DZW/Guderian migration: labels, persistence, accessibility, AI pacing, and launch-flow mismatches. |
| 181-185 | Release report | Produce a Monty order-dice acceptance report with commands run, covered battles, covered sides, visual evidence, known limitations, and dependency versions. |
| 186-190 | Deprecated API cleanup | Remove or clearly quarantine phase-flow APIs, old automation actions, and old documentation claims from Monty's default paths. |
| 191-195 | Cross-layer verification | Verify Monty consumes Guderian/DZW shared contracts without copy-pasting rules, and that Guderian still builds after any consumer API adjustments. |
| 196-200 | Final closeout | Mark the downstream order-dice migration complete only when DZW, Guderian, and Monty plans have matching acceptance notes and Monty has zero remaining blockers. |

## Monty Acceptance Gates

- Monty's default battle path uses the shared order-dice battle surface.
- Monty can play Alam el Halfa, Second El Alamein, and Operation Epsom from either side.
- MontyTest autoplays through activation-by-activation order-dice flow.
- Monty docs and book material no longer describe the old fixed phase loop as the default.
- No Monty code becomes an alternate rules authority for order dice, pins, morale, movement, shooting, vehicles, or close quarters.

## Order-Dice Migration Cycle Progress

- **Cycles 1-20 complete:** Added the Monty order-dice dependency audit, DZW/Guderian contract comparison, compatibility diagnostics, and shim decisions in `MontyOrderDiceCycle20Catalog`. Documentation lives in `docs/monty_order_dice_cycle_001_020.md`, and tests now prove that Monty's current default demo path is still phase-driven, that `MontyDemoBoardSession` does not yet implement explicit order assignment, and that those blockers are tracked before cycles 21-45 add side/order ownership and order-dice launch data. DZW remains the rules authority; no Monty-only order rules were introduced.
- **Cycles 21-40 complete:** Added Monty's order-dice side ownership, force quality, weapon/vehicle/pin input, terrain classification, and activation-aware scoring/pacing catalogs in `MontyOrderDiceCycle40Catalog`. Documentation lives in `docs/monty_order_dice_cycle_021_040.md`; launch flow has not yet been changed to store the new ruleset/order-cup state because that is the next cycle band, cycles 41-45.

## Current Reality Check

`monty` now has a 35-battle catalog, three playable demo battle data packs, side selection, launch-flow records, a deterministic `HistoricalBoardSession`, a concrete shared `HistoricalPlayableBattleView`, autoplay, visual/accessibility/UI-automation gates, compact interaction polish, Monty-owned progress persistence, relaunch rehearsal, and a passing root/DZW/Guderian/Xcode build matrix.

Cycles 161-180 closed the old contract-only gap in a narrow technical sense: `HistoricalPlayableBattleView` is now a public SwiftUI surface in the historical DZW layer over `HistoricalBoardSnapshot`, and both Monty and `MontyTest` instantiate it. A critical visual smoke pass after Cycle 180 showed that this is still not sufficient for a playable game. The board has unreadable overlapping labels, the command flow is still closer to a Monty demo-session wrapper than to the real Guderian gameplay interface, and acceptance can still be too forgiving about visual and interaction quality.

The reference implementation remains `guderian`: campaign briefing, playable board, unit selection, movement, combat controls, phase flow, AI turn, debrief, and progress persistence. The next 60 cycles are a critical playability repair extension that replaces the remaining demo-wrapper behavior with a real Guderian-backed interface path and makes board readability a hard acceptance gate.

## Turnaround Estimate

Recommended turnaround: **240 cycles**.

The first 180 cycles implemented the broad demo shell and public shared surface. The additional 60 cycles fix the basic elements that are still not critically testable:

- **Cycles 1-30:** recover literal playability so the demo is no longer a static/detail-page experience.
- **Cycles 31-90:** implement the proper Guderian-style shared interface instead of a Monty-only patch.
- **Cycles 91-180:** harden, polish, test, and package the demo so it cannot pass acceptance without being genuinely playable.
- **Cycles 181-240:** repair critical playability failures: unreadable board presentation, insufficient Guderian gameplay-interface usage, weak human interaction affordances, and visual acceptance gaps.

The 240-cycle estimate includes the original emergency playable surface, the public shared-interface extraction, Guderian parity protection, Monty-specific polish, UI automation, screenshot/manual acceptance, documentation cleanup, and now a dedicated repair band for the problems found by critical visual review.

## Demo Goal

The accepted Monty demo ships a native macOS app with the same practical playability level as `guderian`:

- A Monty-branded 35-battle campaign list with three playable demo battles.
- Historical briefing and side selection before launch.
- A real DZW/Guderian-style battle interface with a board, units, terrain, objectives, phase controls, action feedback, AI turn controls, log, debrief, and persisted progress.
- Play from either side for Alam el Halfa, Second El Alamein, and Operation Epsom.
- A `MontyTest` app that launches directly into Alam el Halfa and can autoplay to a real debrief through the same playable surface.
- Regression tests and UI/screenshot checks that fail if the app falls back to contract-only playability.

## Scope Boundaries

Move only content-neutral interface/runtime code into shared DZW or historical targets. Keep Montgomery and Guderian campaign content separate.

Shared code should include:

- `HistoricalPlayableBattleView`, not just the string name.
- Generic board rendering, viewport, terrain, objective, and unit token views.
- Generic battle view model over `HistoricalBoardSession`.
- Generic controls for select, move, rotate, shoot, assault, resolve pending choice, next phase, AI turn, restart, and run to debrief.
- Generic debrief, event log, action feedback, and persistence hooks.
- UI accessibility identifiers used by both Guderian and Monty.

Game-specific code should include:

- Monty/Guderian catalogs, battle IDs, side labels, historical copy, AI priority names, palette choices, app identity, and storage keys.
- Any scenario-specific balance or historical data pack content.

## Cycle Range Summary

- **Cycles 1-30:** playable recovery and false-positive test prevention.
- **Cycles 31-60:** shared historical battle UI architecture and board model.
- **Cycles 61-90:** Guderian-style interaction parity and Monty integration.
- **Cycles 91-120:** three-battle gameplay completeness and MontyTest parity.
- **Cycles 121-150:** UI polish, accessibility, visual QA, and automation.
- **Cycles 151-180:** release hardening, docs, packaging, and final acceptance.
- **Cycles 181-210:** Guderian gameplay-interface replacement and real interaction audit.
- **Cycles 211-240:** board readability, visual proof, and critical-playability acceptance.

## Status Through Cycle 180

Cycles 1-180 are complete in this checkout. See `docs/cycle-140-visual-accessibility-and-ui-qa.md` for the visual/accessibility pass, `docs/cycle-160-ui-polish-build-and-save-load.md` for the extended UI automation and save/load hardening pass, and `docs/cycle-180-final-demo-closeout.md` for relaunch rehearsal, documentation cleanup, final demo rehearsal, and acceptance closeout.

The post-180 critical review invalidates the previous readiness claim. Monty has a visible shared battle surface, but it is not yet a critically playable game.

## Status Through Cycle 210

Cycles 181-210 are complete in this checkout. See `docs/cycle-210-critical-playability-interface-repair.md` for the Guderian boundary audit, shared interaction resolver, direct board selection/targeting callbacks, emergency label declutter, and regression commands.

Technical changes landed in this band:

- `HistoricalBoardInteractionResolver` now centralizes the Guderian-style board tap intent: active-side unit taps select units; opposing unit taps target enemies.
- `HistoricalPlayableBattleView` now exposes direct unit selection, direct target selection, and clear-selection callbacks while preserving command buttons for select, target, move, shoot, assault, resolve, phase, AI phase, restart, and debrief.
- Monty and `MontyTest` pass those callbacks into the shared surface instead of relying only on command-button scripting.
- `MontyDemoBoardSession` now supports clear selection and is documented as a compatibility session, not final proof that the real native engine bridge is complete.
- The shared board no longer draws dense terrain/objective name blocks directly over the map; terrain detail moved to the sidebar, objective tokens are compact, unit labels are abbreviated with full help/accessibility text, and board height is capped so command buttons remain reachable in `MontyTest`.
- New cycle-210 tests guard direct board selection, target selection, clearing, Guderian boundary accounting, and readable-label profile metadata.

Verification completed for cycle 210:

- `swift build` from the Monty root.
- `swift test` from the Monty root: 29 tests passed.
- `swift test` from `guderian/dzw`: 102 tests passed.
- `swift build` from `guderian`.
- `MontyTest` visual smoke captured `/private/tmp/montytest-cycle210-final.png`; the old dense board-label block is gone and command buttons remain visible.

## Status Through Cycle 240

Cycles 211-240 are complete in this checkout. See `docs/cycle-240-critical-playability-closeout.md` for the final readability, viewport, visual smoke, and critical acceptance notes.

Technical changes landed in this band:

- The shared board now uses ID-only tactical tokens instead of full unit-name cards, so unit names cannot overlap into an unintelligible text block.
- Full unit names, roles, side ownership, and selected/targeted state moved into a dedicated `Forces` sidebar section.
- `HistoricalBoardLayoutResolver` offsets clustered unit tokens in board coordinate space and exposes `HistoricalBoardReadabilityAudit` for regression checks.
- The shared readability profile now requires no direct terrain, objective, or unit name labels on the board; details must be disclosed through sidebar/help surfaces.
- The shared viewport profile records the accepted aspect ratio and max board heights that keep command buttons visible.
- New cycle-240 tests audit all three demo battle opening boards from both selectable sides and require zero direct board name labels and zero estimated unit-token collisions.
- `MontyCycle240CriticalAcceptanceCatalog.report()` records zero cycles remaining, demo-battle readability coverage, autoplay-to-debrief coverage, verification commands, visual smoke artifact path, and known limitations.

Verification completed for cycle 240:

- `swift test` from the Monty root: 31 tests passed.
- `swift test` from `guderian/dzw`: 102 tests passed.
- `swift build` from `guderian`.
- `MontyTest` visual smoke captured `/private/tmp/montytest-cycle240-final.png`; the board now uses numbered unit tokens, separated force details, reachable command buttons, and no dense board text block.

Cycles remaining: **0**.

## Cycles 1-180

| Cycles | Focus | Output |
| --- | --- | --- |
| 1-5 | Reality reset | Replace the old 120-cycle completion claim with explicit current-state notes; identify every contract-only acceptance check that can pass without a playable UI. |
| 6-10 | Failing playability gates | Add tests or diagnostics that require an actual Monty battle surface route, board identifiers, action controls, and debrief panel rather than just `HistoricalPlayableSurfaceCatalog` strings. |
| 11-15 | Emergency board shell | Add a temporary Monty playable battle view backed by `MontyDemoBoardSession`, with board, units, zones, objectives, selected unit/target state, and action feedback. |
| 16-20 | Emergency controls | Wire select, move, shoot, assault, resolve pending choice, next phase, restart, and run-to-debrief into the temporary playable surface. |
| 21-25 | App launch path | Replace the detail-page `Run to Debrief` flow with campaign row -> briefing -> side selector -> playable board -> debrief for all three demo battles. |
| 26-30 | Minimum playability acceptance | Prove all three battles can be manually advanced from either side; preserve current autoplay tests; document remaining gaps before the shared extraction starts. |
| 31-35 | Shared target design | Decide whether the real shared SwiftUI surface lives in `DerZweiteWeltkriegHistorical`, a new DZW UI target, or a local transitional target; update package dependencies accordingly. |
| 36-40 | Generic battle view model | Build a content-neutral view model over `HistoricalBoardSession` snapshots, selected units, legal actions, completion, AI steps, and persistence callbacks. |
| 41-45 | Shared board rendering | Extract or recreate Guderian-style battlefield viewport, grid, terrain, objectives, and unit tokens using `HistoricalBoardSnapshot` types. |
| 46-50 | Shared command panels | Build reusable controls, inspector, objectives, forces, log, and action-feedback panels with public SwiftUI entry points. |
| 51-55 | Shared debrief flow | Add generic debrief display, completion callback, persisted-result identifier, and restart/return-to-campaign behavior. |
| 56-60 | Shared API stabilization | Publish `HistoricalPlayableBattleView` as a real type; make tests fail if Monty cannot instantiate it. |
| 61-65 | Guderian parity mapping | Map the important Guderian interface affordances onto the shared view: board viewport, toolbar, sidebar/panel behavior, phase flow, AI turn, action feedback, and debrief. |
| 66-70 | Monty integration | Replace the emergency Monty board with the real shared `HistoricalPlayableBattleView`. Keep Monty-only content in adapters. |
| 71-75 | Bidirectional human play | Verify both Montgomery and opposing-force player selections produce correct active side labels, AI labels, scores, and control handoff. |
| 76-80 | AI turn controls | Add visible and testable AI step/run controls for the opposing side, with safety caps and logs that match Guderian expectations. |
| 81-85 | Guderian regression pass | Build and test Guderian after shared-interface changes; fix parity regressions before adding more Monty polish. |
| 86-90 | Shared-interface acceptance | Require both Guderian and Monty to use the shared surface with no Monty-only clone of the final board UI. |
| 91-96 | Alam el Halfa gameplay pass | Tune map layout, unit placement, objective control, AI priorities, scoring, debrief text, and blocked-action messaging for the first demo battle. |
| 97-102 | Second El Alamein gameplay pass | Tune minefields, corridors, infantry assault flow, armoured breakthrough objectives, Axis reserves, scoring, and debrief. |
| 103-108 | Operation Epsom gameplay pass | Tune Odon crossings, bridgehead expansion, Hill 112 pressure, German counterattack behavior, scoring, and debrief. |
| 109-114 | Cross-battle consistency | Normalize labels, phase counts, turn bounds, objective scoring, and visual scale across the three demo battles. |
| 115-120 | MontyTest parity | Make `MontyTest` embed the same shared battle surface, not a separate diagnostics board, while preserving run, pause, step, speed, restart, log, safety cap, and result summary. |
| 121-126 | Visual design pass | Apply Monty palette and typography while retaining the Guderian interface structure; remove static preview-only UI from the playable path. |
| 127-132 | Accessibility pass | Stabilize identifiers for campaign, side selector, board, unit tokens, controls, objectives, log, AI turn, debrief, persisted result, and MontyTest controls. |
| 133-138 | Screenshot QA | Add or run repeatable screenshot checks for campaign, briefing, side selection, board at desktop size, board at smaller window size, debrief, and MontyTest. |
| 139-144 | UI automation | Add UI tests or scripted checks that select a side, choose a unit, move, shoot, advance phase, run AI turn, and reach debrief. |
| 145-150 | Interaction polish | Fix text overlap, cramped panels, board scaling, selection visibility, disabled states, blocked-action clarity, and control discoverability. |
| 151-156 | Build matrix | Run root `swift test`, root `swift build`, DZW tests/builds, Guderian tests/builds, and Xcode scheme builds where available. |
| 157-162 | Save/load hardening | Verify selected side, completion records, debrief summaries, and campaign progress persist and reload without corrupting Guderian storage. |
| 163-168 | Documentation cleanup | Update `README.md`, `PLAN.md`, and cycle docs so they describe actual playable behavior, not intended contracts. |
| 169-174 | Final demo rehearsal | Perform a human-facing demo pass through all three battles from both sides, plus MontyTest autoplay, recording blockers and fixing them. |
| 175-180 | Acceptance closeout | Produce a final readiness report with commands run, UI evidence, known limitations, and explicit confirmation that the old contract-only acceptance gap is closed. |

## Cycles 181-240: Critical Playability Repair

| Cycles | Focus | Technical Output |
| --- | --- | --- |
| 181-185 | Critical playability audit | Document every gap between Monty and the real Guderian play loop: board viewport, direct unit selection, legal action calculation, command toolbar, turn/phase authority, combat resolution, AI handoff, debrief, and persistence. Convert the audit into failing acceptance checks rather than prose-only notes. |
| 186-190 | Guderian interface boundary | Identify the actual Guderian gameplay interface types, view models, and engine/session calls that should be shared or adapted. Decide which APIs move to DZW historical/shared code and which remain Guderian-specific. Remove acceptance language that allows a Monty-only imitation to pass. |
| 191-195 | Replace demo-session dependency | Replace or wrap `MontyDemoBoardSession` so the Monty board uses the same gameplay command semantics as Guderian: selected unit identity, legal move targets, legal fire targets, assault eligibility, pending choice resolution, phase advance, AI phase, and game-over/debrief state. Keep temporary adapters only behind a clearly named compatibility layer. |
| 196-200 | Real board interaction model | Add direct board interactions instead of command-only scripting: click/tap unit selection, target selection from enemy tokens, clear selected/target state, hover/help details where available, and visible disabled-state reasons tied to engine legality. |
| 201-205 | Command and phase parity | Rebuild the Monty command panel to match Guderian interaction expectations: current side, phase, selected unit, legal actions, pending choices, AI turn/run controls, restart, debrief, and event log. Add tests that fail if actions mutate only a mock preview snapshot. |
| 206-210 | Guderian regression protection | Build and test Guderian after the shared-interface changes. Add a smoke route proving Guderian still opens its playable board and can perform select, move, combat, phase advance, AI handoff, and debrief using the shared or adapted code. |
| 211-215 | Label collision system | Remove always-on dense map text from the board. Implement a label strategy with collision avoidance, priority tiers, truncation rules, selected/hovered detail disclosure, and optional label layers. No board state may render a large unreadable block of overlapping text. |
| 216-220 | Token and terrain readability | Rework unit tokens, objective markers, terrain bands, and zone labels for legibility at desktop and compact sizes. Stabilize token dimensions, z-order, contrast, selection outlines, target outlines, and minimum touch/click areas. |
| 221-225 | Board viewport and scaling | Add a real board viewport model: aspect ratio constraints, pan/zoom or fit modes if needed, scroll behavior, compact layout breakpoints, and screenshot checks for all three demo battles. The board must never rely on text overlap to communicate essential state. |
| 226-230 | Three-battle critical tuning | Re-check Alam el Halfa, Second El Alamein, and Operation Epsom with the repaired interface. Tune initial placements, objective density, terrain label priority, AI priorities, scoring triggers, and debrief state so each battle is understandable and playable from both sides. |
| 231-235 | Visual and functional acceptance automation | Add or update automated checks that inspect board token count, visible command availability, side/phase labels, debrief state, and screenshot/pixel evidence for nonblank readable board regions. Include regression checks for the exact text-overlap failure observed after Cycle 180. |
| 236-240 | Critical demo rehearsal and closeout | Perform a manual critical-test rehearsal through all three demo battles from both sides plus MontyTest. Record before/after screenshots, commands run, known limitations, and explicit evidence that Monty is using the real Guderian gameplay interface rather than a standalone scripted demo wrapper. |

## Acceptance Gates

The 240-cycle demo is accepted only when all of these are true:

- Monty launches a real playable battle board from the campaign flow for each demo battle.
- `HistoricalPlayableBattleView` is a real public SwiftUI surface, not only a contract string.
- The playable surface uses the real Guderian gameplay interface or a thin shared adapter over the same engine semantics; a Monty-only scripted demo-session wrapper is not sufficient.
- The playable surface supports direct unit selection, direct target selection, movement, shooting, assault, pending-choice resolution, phase advance, AI turn, restart, debrief, and progress persistence.
- The board is readable at accepted desktop and compact sizes. Terrain labels, unit labels, objective markers, and status text must not overlap into unintelligible blocks.
- Essential game state must be visible without relying on overlapping board text; selected units, targets, legal actions, phase, active side, objectives, and debrief state must have clear, separate affordances.
- Monty can play Alam el Halfa, Second El Alamein, and Operation Epsom from either selectable side.
- `MontyTest` embeds the same shared playable battle surface and autoplays Alam el Halfa to a real debrief.
- Guderian still builds and keeps its playable interface after shared extraction.
- Tests include at least one guard that would fail if Monty regressed to the current detail-page `Run to Debrief` shortcut.
- Visual/UI checks confirm the board is visible, usable, nonblank, and readable at target desktop and compact window sizes.

## Non-Goals For This Demo

- A fully authored 35-battle Monty campaign.
- Perfect historical simulation for every future Montgomery battle.
- A rewrite of the DZW core combat engine beyond what the shared playable surface needs.
- Rebranding Guderian code by copy-paste without a shared interface.

## Risks

- The largest product risk is accepting autoplay as a substitute for human playability. The new gates must make that impossible.
- The largest engineering risk is extracting too much Guderian-specific behavior into shared code. Shared code must stay content-neutral.
- The largest schedule risk is UI automation on macOS/Xcode. The plan reserves cycles for screenshot and manual demo rehearsal so acceptance is not blocked on one testing method.
- The current `MontyDemoBoardSession` is useful but simplified. If it remains the primary interaction path, the game can still feel fake even with a visible board. Cycles 181-240 must either replace it with the real Guderian gameplay interface path or confine it behind a thin compatibility adapter with strict parity tests.
