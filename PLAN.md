# Monty Demo Development Plan

## Current Ship Status

`monty` currently has the historical 35-battle README roster but no Swift package, app target, scenario catalog, playable scenario data, or test app of its own.

The included `guderian` submodule is the reference implementation for the desired interface: a SwiftUI campaign list, historical briefing flow, DZW-style playable battle board, progress/debrief persistence, and a `GuderianTest` first-battle autoplay app. The nested `guderian/dzw` submodule is present but not initialized in this checkout, so implementation should begin by syncing that dependency before build work.

Cycle 20 update: cycles 1-20 are complete. The nested `guderian/dzw` submodule is initialized, the DZW and Guderian package baselines were verified, the three demo battles are locked to Alam el Halfa, Second El Alamein, and Operation Epsom, and `docs/cycle-20-demo-contracts.md` records the shared historical-scenario contracts, side-selection engine binding, shared board-session shape, and generic C hook migration path. DZW `swift test` passed with 89 XCTest tests. Guderian `swift test` initially hit a sandboxed app-signing failure, then passed outside the sandbox with 132 XCTest tests plus 16 Swift Testing tests.

Recommended demo estimate: 120 cycles.

That estimate assumes we do the useful reuse work instead of cloning Guderian UI code into Monty. A direct copy-and-rebrand demo might fit into roughly 80-90 cycles, but it would leave `guderian`, `monty`, and future games with duplicate battle screens, duplicate autoplay logic, and duplicate campaign plumbing. The recommended 120-cycle plan includes 35 cycles for extracting reusable code into `derZweiteWeltkrieg` and rewriting `guderian` to prove the shared interface still works.

## Demo Goal

The first accepted demo should ship a native macOS Monty app using the same playable interface as `guderian`:

- A Monty-branded campaign list populated from the README chronology.
- Historical briefing screens for the demo battles.
- A side selector before launch: play Montgomery's command or the opposing army.
- The real DZW-style board surface with selectable units, movement, combat, objectives, phase controls, action feedback, AI turns, debrief, and progress persistence.
- A `MontyTest` app similar to `GuderianTest`, launching directly into the first demo battle and autoplaying to a real debrief.

Recommended first demo battles:

- [Battle of Alam el Halfa](https://en.wikipedia.org/wiki/Battle_of_Alam_el_Halfa) as the tutorial/defensive battle.
- [Second Battle of El Alamein](https://en.wikipedia.org/wiki/Second_Battle_of_El_Alamein) as the signature breakthrough battle.
- [Operation Epsom](https://en.wikipedia.org/wiki/Operation_Epsom) as the Normandy bridgehead/counterattack battle.

Operation Epsom is a better demo third battle than Market Garden because it proves the north-west Europe rules and German counterattack pressure without making the first demo depend on the full airborne corridor problem.

## Reuse And Refactor Recommendation

Move only content-agnostic code from `guderian` down into `derZweiteWeltkrieg`. Keep all Guderian-specific and Montgomery-specific history, catalogs, copy, battle IDs, AI priorities, source links, and app branding outside the shared engine.

Code that is worth moving or generalizing:

- The DZW-style playable SwiftUI battle surface currently embodied by `DZWPlayableBattleView`.
- The board/session protocol used by the view model: snapshot, select, move, rotate, shoot, assault, pending choice, phase advance, restart, AI turn, and completion hooks.
- Generic battlefield map rendering and viewport components.
- Generic campaign row, briefing, completion, save/load, debrief, and accessibility contracts.
- Generic first-battle autoplay controller shape currently proven by `GuderianTestFirstBattleRunController`.
- C engine hooks that are currently guarded for Guderian scenario boards, renamed or wrapped as a generic historical-scenario board API.

Code that should stay game-specific:

- `GuderianCampaignCatalog`, `UnifiedGuderianBattleCatalog`, late-career Guderian context, and Guderian AI naming.
- The future Monty battle catalog, side-selection policy, Montgomery/opposing force text, and Monty AI priorities.
- App identity: app names, icons, colors where they are historically or brand specific, storage keys, and tutorial copy.

The desired end state is:

- `dzw` owns reusable engine, board, scenario-session, campaign-UI, and autoplay contracts.
- `guderian` becomes a thin game module that supplies Guderian content adapters to those contracts.
- `monty` becomes a thin game module that supplies Montgomery content adapters to those contracts.

## Cycle Range Summary

- Cycles 1-10: repository bootstrap and dependency lock.
- Cycles 11-25: shared architecture and side-selection contract.
- Cycles 26-45: move reusable playable battle UI/runtime into `dzw`.
- Cycles 46-60: rewrite `guderian` onto the shared interface and prove parity.
- Cycles 61-75: create the Monty package, app targets, and 35-battle catalog shell.
- Cycles 76-95: author the three demo battle data packs.
- Cycles 96-105: implement playable side selection and opposing AI for both directions.
- Cycles 106-115: create `MontyTest` first-battle autoplay.
- Cycles 116-120: acceptance hardening, documentation, and demo readiness.

## Cycles 1-120: Playable Demo

| Cycles | Focus | Output |
| --- | --- | --- |
| 1-5 | Repository and submodule bootstrap | Initialize/sync `guderian/dzw`, confirm SwiftPM and Xcode build baselines, record exact reusable targets and source files. |
| 6-10 | Demo scope lock | Freeze the three demo battles, side-select policy, minimum acceptance gates, app naming, storage-key prefix, and README-to-catalog ID mapping. |
| 11-15 | Shared scenario contracts | Define content-neutral battle ID, side option, force role, source link, map, objective, victory band, debrief, progress, and save contracts. |
| 16-20 | Side-selection architecture | Add a generic "player side vs AI side" model so a battle can run either Montgomery-side human vs opposing AI or opposing human vs Montgomery-side AI. |
| 21-25 | Refactor design review | Identify which Guderian types become adapters, which view models become generic, and which C symbols need generic historical-scenario names. |
| 26-35 | Shared playable battle surface | Move/generalize `DZWPlayableBattleView`, battlefield viewport, map rendering, board action feedback, debrief panel, and accessibility identifiers into `dzw` shared UI/runtime targets. |
| 36-40 | Shared board/session runtime | Move/generalize the board-session protocol, completion resolver bridge, AI turn hook points, restart flow, and deterministic seed handling. |
| 41-45 | Shared autoplay harness | Move/generalize first-battle autoplay run state, speed modes, step logs, phase guard, final-result summary, and real debrief persistence. |
| 46-55 | Guderian adapter rewrite | Rewrite `guderian` to supply Guderian scenarios, Guderian side labels, Guderian AI plans, and Guderian persistence through the shared `dzw` contracts. |
| 56-60 | Guderian parity gate | Run `swift test`, `swift build`, and the Xcode `Guderian` / `GuderianTest` build schemes; fix regressions before starting Monty app work. |
| 61-65 | Monty package scaffold | Add root `Package.swift`, `Sources/MontyCore`, `Sources/MontyApp`, `Sources/MontyAppHost`, `Tests/MontyTests`, and shared `dzw` dependency wiring. |
| 66-70 | Monty app identity | Add Monty app shell, campaign view entry point, storage keys, initial palette, Xcode project/schemes if the repo follows the Guderian Xcode pattern. |
| 71-75 | 35-battle catalog shell | Convert README chronology into typed battle IDs, chronology rows, side options, source links, command notes, and placeholder readiness states. |
| 76-82 | Alam el Halfa data pack | Author first demo map, forces, deployment zones, ridge/minefield/anti-tank objectives, AI priorities for both sides, scoring, and debrief. |
| 83-89 | Second El Alamein data pack | Author minefield corridors, infantry assault lanes, armoured exploitation zones, Axis reserve/counterattack logic, scoring, and debrief. |
| 90-95 | Operation Epsom data pack | Author Odon crossings, Hill 112 objectives, British bridgehead expansion, German counterattack priorities, scoring, and debrief. |
| 96-100 | Playable launch flow | Wire campaign row -> briefing -> side selector -> shared DZW battle screen -> debrief -> progress persistence for all three demo battles. |
| 101-105 | Bidirectional AI pass | Ensure both sides can be AI-controlled, both sides can be player-controlled through side selection, and autoplay uses legal board actions in either direction. |
| 106-110 | MontyTest app | Add `MontyTest` single-window app that embeds the shared battle surface for Alam el Halfa with run, pause, step, speed, log, safety-cap, and result controls. |
| 111-115 | MontyTest acceptance | Make `MontyTest` autoplay to a real debrief, prove both sides acted, persist the result, and add regression tests for the first-battle autoplay contract. |
| 116-120 | Demo acceptance | Final pass for documentation, screenshots if needed, build/test commands, README/PLAN updates, and a zero-blocker demo readiness report. |

## MontyTest Requirements

`MontyTest` should be planned as a first-class app, not a throwaway diagnostics panel.

Acceptance requirements:

- Launch directly into Alam el Halfa.
- Embed the same shared DZW playable battle view used by the real Monty app.
- Show controls for run to debrief, step once, pause/resume, restart, speed, phase safety cap, event log, and final result summary.
- Autoplay legal board actions for the current player side and then hand the turn to the opposing AI.
- Support deterministic seed replay.
- Record a real debrief and Monty progress completion.
- Expose stable accessibility identifiers equivalent to the GuderianTest contract, renamed for Monty.

## Acceptance Gates

The 120-cycle demo is accepted when:

- `guderian` still builds and tests after the shared-code extraction.
- The shared DZW battle surface is used by both Guderian and Monty, with no cloned Monty-only copy of the playable board UI.
- Monty has 35 catalog rows from the README chronology, with the three demo battles marked playable and the others marked planned.
- Each playable demo battle can be launched from the campaign list, played from either side, run through AI turns, and completed to debrief.
- `MontyTest` launches Alam el Halfa directly and autoplays to a debrief through the real shared battle surface.
- SwiftPM tests cover catalog integrity, side selection, demo scenario loading, shared battle-surface routing, debrief persistence, and MontyTest autoplay.
- Xcode schemes exist and build for `Monty`, `MontyTest`, and the rewritten `Guderian` / `GuderianTest` apps if Xcode project support is kept.

## Risks And Notes

- The largest new gameplay risk is bidirectional play. `guderian` assumes a fixed player role in many places; Monty needs side selection and AI naming to be data-driven.
- The largest engineering risk is moving too much into `dzw`. Shared code should be generic contracts and UI/runtime plumbing only, not campaign-specific history.
- The nested `dzw` submodule is not initialized in the current checkout, so early cycle work must verify the actual engine target names and current C hook shape before editing.
- If upstreaming to `derZweiteWeltkrieg` is deferred, the same extraction can temporarily live as a local shared package target, but that should be treated as a fallback because it weakens reuse for future games.
- A full 35-battle Monty campaign should be planned separately after the demo. With the shared layer in place, a full campaign expansion is likely another 150-220 cycles depending on how detailed each battle board becomes.
