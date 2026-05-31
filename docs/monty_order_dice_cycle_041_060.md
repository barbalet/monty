# Monty Order-Dice Migration Cycles 41-60

Rules reference: `https://warlordgames.com/downloads/pdf/bolt_action_reference.pdf`.

This block begins wiring the order-dice migration into Monty's launch, surface, session, and controls. DZW/Guderian still own the rules. Monty stores and exposes enough metadata for the shared order-dice flow to become the default in later cycle bands.

## Cycles 41-45: Launch Flow

`MontyLaunchFlow` now carries `MontyOrderDiceLaunchState`.

The state records:

- staged order-dice ruleset name,
- selected human side,
- launch seed,
- side ownership/controller records,
- order cup dice generated from current force groups,
- compatibility notes that keep `MontyDemoBoardSession` explicitly transitional.

The selected side determines which drawn dice can be human-controlled.

## Cycles 46-50: Shared UI Adoption

Monty and MontyTest now pass `onIssueOrder` into `HistoricalPlayableBattleView`.

The shared surface already presents Fire, Advance, Run, Ambush, Rally, and Down controls. Those controls now call through to Monty's session adapter instead of being inert buttons.

## Cycles 51-55: Board Session Adapter

`MontyDemoBoardSession` now implements explicit order assignment:

- selected active units expose available orders,
- issued orders are stored on the unit snapshot,
- current order summaries are visible to the shared surface,
- Down and Ambush orders expose retained-order flags,
- morale quality is read from the cycle-40 force profile inputs.

This remains a compatibility adapter. It records and routes orders, but DZW/Guderian remain the rules authority.

## Cycles 56-60: Controls

The control contract marks the order buttons as the primary migration path and keeps Move, Shoot, Assault, and Phase as legacy compatibility controls until the native activation loop replaces phase advancement.

Accessibility identifiers now include the six order controls:

- `battle-order-fire-button`
- `battle-order-advance-button`
- `battle-order-run-button`
- `battle-order-ambush-button`
- `battle-order-rally-button`
- `battle-order-down-button`

The next cycle band should move from staged launch metadata to actual order-cup draw and activation lifecycle.
