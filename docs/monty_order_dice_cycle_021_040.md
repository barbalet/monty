# Monty Order-Dice Migration Cycles 21-40

Rules reference: `https://warlordgames.com/downloads/pdf/bolt_action_reference.pdf`.

This block prepares Monty's three locked demo battles for the shared order-dice loop without moving rules into Monty. DZW/Guderian still own the order list, tests, order assignment semantics, movement, combat, pins, morale, and retained-order behavior. Monty adds scenario input data that those shared contracts can consume in later cycles.

## Cycles 21-25: Side and Order Ownership

`MontyOrderDiceSideOwnership` maps each demo battle from each selected human side into:

- side ID,
- human or AI controller,
- engine player slot,
- launch seed,
- order dice count from alive force groups,
- whether a drawn die for that side can be controlled by the human.

The selected side remains the authority for human control. If Montgomery is selected, Montgomery's drawn dice are human-controlled. If the opposition is selected, opposition dice are human-controlled.

## Cycles 26-30: Unit Quality Data

`MontyOrderDiceForceProfile` now derives scenario input rows for every force group in Alam el Halfa, Second El Alamein, and Operation Epsom:

- morale quality,
- officer modifier,
- weapon class hints,
- vehicle class hints,
- pin behavior,
- recommended order set.

These are data inputs, not a new rules engine. The values are intentionally inspectable so cycles 41-75 can expose them through launch flow, sidebars, and order controls.

## Cycles 31-35: Terrain Data

`MontyOrderDiceTerrainProfile` classifies each demo map element into DZW-facing categories:

- open,
- rough,
- obstacle,
- building,
- road,
- soft cover,
- hard cover,
- impassable,
- minefield.

Road and bridge elements expose road-bonus eligibility. Minefields, rivers, and forests expose run blockers where appropriate. Ridge, town, and forest categories expose line-of-sight and cover flags.

## Cycles 36-40: Objective and Scoring Pacing

`MontyOrderDicePacingProfile` converts each demo battle from phase-count acceptance toward activation-aware pacing:

- order dice per turn,
- target activation budget,
- activation safety cap,
- objective victory points by side,
- debrief requiring activation count,
- phase-count scoring marked deprecated.

This does not yet make the default Monty session order-dice playable. It creates the structured data that cycles 41-45 need when launch flow starts carrying ruleset, order ownership, and activation metadata.
