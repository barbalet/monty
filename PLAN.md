# Monty 180-Cycle Playable Demo Plan

## Current Reality Check

`monty` has useful foundations: a 35-battle catalog, three demo battle data packs, side selection, launch-flow records, a deterministic `HistoricalBoardSession`, autoplay, and root tests that pass.

It does not yet have the Guderian-style playable interface in the Monty app. The visible Monty route is still a campaign/detail page with a `Run to Debrief` button. The name `HistoricalPlayableBattleView` exists as a contract string, not as a public SwiftUI battle surface that Monty can instantiate. The current acceptance tests prove model/autoplay contracts, but they do not prove that a human can play a battle through the actual interface.

The reference implementation remains `guderian`: campaign briefing, playable board, unit selection, movement, combat controls, phase flow, AI turn, debrief, and progress persistence. The work below turns that reference into a real shared historical battle interface and wires Monty into it.

## Turnaround Estimate

Recommended turnaround: **180 cycles**.

This implements all three scopes that were discussed:

- **Cycles 1-30:** recover literal playability so the demo is no longer a static/detail-page experience.
- **Cycles 31-90:** implement the proper Guderian-style shared interface instead of a Monty-only patch.
- **Cycles 91-180:** harden, polish, test, and package the demo so it cannot pass acceptance without being genuinely playable.

The 180-cycle estimate is intentionally larger than the minimum fix. It includes the emergency playable surface, the real shared-interface extraction, Guderian parity protection, Monty-specific polish, UI automation, screenshot/manual acceptance, and documentation cleanup.

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

## Acceptance Gates

The 180-cycle demo is accepted only when all of these are true:

- Monty launches a real playable battle board from the campaign flow for each demo battle.
- `HistoricalPlayableBattleView` is a real public SwiftUI surface, not only a contract string.
- The playable surface supports unit selection, movement, shooting, assault, pending-choice resolution, phase advance, AI turn, restart, debrief, and progress persistence.
- Monty can play Alam el Halfa, Second El Alamein, and Operation Epsom from either selectable side.
- `MontyTest` embeds the same shared playable battle surface and autoplays Alam el Halfa to a real debrief.
- Guderian still builds and keeps its playable interface after shared extraction.
- Tests include at least one guard that would fail if Monty regressed to the current detail-page `Run to Debrief` shortcut.
- Visual/UI checks confirm the board is visible, usable, and not overlapped or blank at target desktop window sizes.

## Non-Goals For This Demo

- A fully authored 35-battle Monty campaign.
- Perfect historical simulation for every future Montgomery battle.
- A rewrite of the DZW core combat engine beyond what the shared playable surface needs.
- Rebranding Guderian code by copy-paste without a shared interface.

## Risks

- The largest product risk is accepting autoplay as a substitute for human playability. The new gates must make that impossible.
- The largest engineering risk is extracting too much Guderian-specific behavior into shared code. Shared code must stay content-neutral.
- The largest schedule risk is UI automation on macOS/Xcode. The plan reserves cycles for screenshot and manual demo rehearsal so acceptance is not blocked on one testing method.
- The current `MontyDemoBoardSession` is useful but simplified. If it feels too fake once placed behind the real interface, gameplay tuning must happen inside the 91-120 cycle band.
