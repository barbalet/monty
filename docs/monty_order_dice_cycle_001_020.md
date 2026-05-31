# Monty Order-Dice Migration Cycles 1-20

Rules reference: `https://warlordgames.com/downloads/pdf/bolt_action_reference.pdf`.

This document closes the first Monty order-dice migration block. DZW remains the rules authority and Guderian remains the shared gameplay/interface reference. Monty's job in these cycles is to audit the current phase-driven demo, compare it with the shared order-dice contracts, and record which compatibility pieces can survive only as temporary adapters.

## Cycles 1-5: Dependency Audit

The Monty layer currently touches these order-dice migration surfaces:

- DZW/Guderian historical contracts expose `HistoricalBoardOrder` with Fire, Advance, Run, Ambush, Rally, and Down.
- `HistoricalPlayableBattleView` is the shared UI surface Monty already embeds.
- `MontyDemoBoardSession` still drives movement, shooting, assault, and side handoff through fixed phases.
- `MontyLaunchFlow` records the selected side and seed, but not the ruleset, current die, order cup, or activation metadata.
- Monty side selection already allows Montgomery or the opposition to be human controlled; later cycles must bind that selected side to drawn-die ownership.
- Monty autoplay, MontyTest, accessibility IDs, and UI automation still describe progress through phase advances.
- Monty progress records selected side and debriefs, but not activation count, assigned orders, retained orders, or order-cup state.

## Cycles 6-10: Contract Comparison

The shared target loop is order-first: build an order-dice cup, draw a side, choose one eligible unit, assign an order, resolve tests/reactions, execute the action, then continue until the turn is cleaned up.

Monty's current demo loop does not yet match that contract:

- `HistoricalBoardSnapshot.phase` and `advancePhase()` are still the battle clock.
- `moveUnit` is legal only in Movement, instead of being owned by Advance or Run.
- `shootUnit` is legal only in Shooting, instead of being owned by Fire or Advance.
- `assaultUnit` is legal only in Assault, instead of being owned by Run.
- `issueOrder` is not implemented by `MontyDemoBoardSession`.
- Autoplay counts phase advances rather than activations.
- Accessibility and UI automation still key off phase controls.
- Persistence does not store order-dice state.

## Cycles 11-15: Compatibility Gates

`MontyOrderDiceCycle20Catalog.report()` is the executable gate for this block. It intentionally reports cycle-20 readiness while also reporting that the default Monty battle path is not order-dice ready yet.

The report must keep these blockers visible until later cycles remove them:

- The default session is phase-driven.
- Explicit order assignment is a no-op in Monty's session.
- Autoplay and MontyTest still measure phase advances.
- Run-to-debrief remains a convenience helper, not proof of activation-by-activation play.

## Cycles 16-20: Shim Decision

The migration decision is:

- Keep `MontyDemoBoardSession` only as a thin compatibility adapter while cycles 21-75 add order ownership, order data, and UI controls.
- Consume `HistoricalPlayableBattleView` from DZW/Guderian rather than creating a Monty-only battle surface.
- Replace phase-advance autoplay with activation stepping once Monty has order-dice session state.
- Extend `MontyLaunchFlow` with ruleset, selected-side die ownership, order seed, and activation metadata in the next block.
- Re-script UI automation around Fire, Advance, Run, Ambush, Rally, Down, order tests, and activation logs.
- Quarantine run-to-debrief as a test helper only.

No new order rules are added in Monty in this cycle band.
