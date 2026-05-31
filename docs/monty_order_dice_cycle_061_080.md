# Monty Order-Dice Migration Cycles 61-80

Source rule reference: <https://warlordgames.com/downloads/pdf/bolt_action_reference.pdf>

## Cycle 61-65: Sidebar Data

Monty now builds `MontyOrderDiceSidebarDetail` rows for every playable demo unit and both selected-side launch paths. Each row exposes the fields the shared battle sidebar needs for the order-dice ruleset:

- pin count and morale quality
- current order or awaiting-die state
- retained Down/Ambush state
- order-test summary
- target reaction summary
- vehicle damage summary
- morale/debrief-ready summary

The underlying `MontyDemoBoardSession` snapshot now writes a richer `orderDiceSummary` string so the DZW shared UI can show order, quality, pins, retained state, and vehicle damage status from the same snapshot field that Guderian also consumes.

## Cycle 66-70: Human Interaction Preview

`MontyOrderDiceHumanInteractionPreview` records the intended activation loop for each demo battle and selected side:

1. The drawn side is the selected human side at battle open.
2. A direct board tap selects an eligible unit from the drawn side.
3. Legal orders are exposed from the selected unit snapshot.
4. Legal enemy targets are listed for Fire, Advance-fire, and Run/assault decisions.
5. Movement preview distinguishes Advance from Run before execution.
6. After execution the flow waits for the next die.

This keeps Monty aligned with the lower-layer order sequence: draw die, choose unit, choose order, resolve action, then repeat.

## Cycle 71-75: Error Handling

Monty now reports order-specific blockers instead of generic phase rejection text. The tracked blocker taxonomy covers missing selection, wrong drawn side, destroyed units, already-issued orders, order tests, pins, terrain movement blocks, target legality, target reactions, retained orders, turn-end cleanup, and vehicle damage stopping actions.

`MontyDemoBoardSession.issueOrder(_:to:)` now records the concrete blocker in `lastAction`, and `orderEligibilityDetail(for:order:)` exposes the same explanation for tests and UI adapters.

## Cycle 76-80: AI Activation Model

Monty now delegates activation choice to DZW's shared `HistoricalAutoplayOrderAdvisor` through `MontyOrderDiceAIActivationAdvisor`. The decision is one drawn die at a time:

- choose one unit from the drawn side
- choose one legal order
- choose target or movement intent when needed
- mark whether an order test or Ambush/Down reaction is involved
- execute one activation, then wait for the next die

The Monty app's AI control now follows this single-activation model rather than looping every active unit through a full scripted phase. The older autoplay run controller remains as the compatibility harness until the next cycle band migrates runner/debrief pacing around full order-cup turns.

## Verification

`MontyOrderDiceCycle80Catalog.report()` gates this band by requiring:

- cycle 60 readiness
- sidebar rows for every demo unit and selected side
- human interaction previews for every demo battle and selected side
- all blocked-reason categories
- AI activation decisions for every demo battle and selected side

