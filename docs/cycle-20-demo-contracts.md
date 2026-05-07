# Cycle 20 Demo Contracts

This note captures the decisions completed for cycles 1-20 of `PLAN.md`: repository/dependency baseline, demo scope, shared scenario contracts, and side-selection architecture. It is intentionally implementation-facing so the later Swift package work can move quickly without re-deciding the product shape.

## Baseline Findings

- Root project: `/Users/barbalet/github/monty`
- Reference game: `guderian` submodule at `bb9b672406db4a22ddc6f5739b24085418097fce`
- Engine submodule: `guderian/dzw` at `0d2c4647360c641d4bb7269d278ca5c53c84ab66`
- `guderian/dzw` had to be initialized before baseline checks.
- DZW package products found:
  - `DerZweiteWeltkriegCore`
  - `DerZweiteWeltkriegAppUI`
  - `DerZweiteWeltkriegGuderian`
  - `DerZweiteWeltkriegApp`
  - `DerZweiteWeltkriegTest`
- Guderian package products found:
  - `GuderianCore`
  - `GuderianAppUI`
  - `GuderianApp`
- Verification:
  - `swift test` in `guderian/dzw`: passed, 89 XCTest tests.
  - `swift test` in `guderian`: passed outside the sandbox after an app code-signing sandbox failure, 132 XCTest tests plus 16 Swift Testing tests.

Important code boundaries:

- The reusable DZW app UI already exists in `guderian/dzw/Sources/DerZweiteWeltkriegApp`.
- Guderian content and scenario adapters live in `guderian/dzw/Sources/DerZweiteWeltkriegGuderian`.
- The Guderian app-level DZW-style campaign battle screen still lives in `guderian/Sources/GuderianApp/DZWPlayableBattleView.swift`.
- The C engine currently exposes a Guderian-named board hook: `game_apply_guderian_scenario_board`.
- The C engine target currently defines `HEINZ_GUDERIAN_GAME` globally in `guderian/dzw/Package.swift`.

The later extraction should therefore generalize names and contracts, not copy the Monty app from `guderian/Sources/GuderianApp`.

## Demo Scope Lock

The first Monty demo will contain three playable battles:

| Order | Battle | Why It Is In Demo | Primary Mechanics To Prove |
| --- | --- | --- | --- |
| 1 | Battle of Alam el Halfa | Best tutorial battle: Montgomery's first major Eighth Army defensive command and a clear prepared-position problem. | Ridge defense, minefields, anti-tank lanes, air/artillery pressure, Axis fuel/time limits. |
| 2 | Second Battle of El Alamein | Signature Montgomery battle and expected public demo centerpiece. | Minefield clearance, infantry assault lanes, armoured exploitation corridors, Axis reserve shifts. |
| 3 | Operation Epsom | Focused Normandy battle that proves the north-west Europe module without taking on Market Garden's full airborne-corridor complexity first. | River crossing, bridgehead widening, Hill 112 pressure, German panzer counterattack. |

The remaining 32 README battles should appear in the Monty catalog as planned/non-playable rows during the demo.

## Shared Target Recommendation

Add a content-neutral DZW target before Monty app work begins:

```swift
.target(
    name: "DerZweiteWeltkriegHistorical",
    dependencies: [
        "DerZweiteWeltkriegCore",
        "DerZweiteWeltkriegAppUI",
    ],
    path: "Sources/DerZweiteWeltkriegHistorical"
)
```

This target should own reusable historical-campaign contracts and battle runtime adapters. `DerZweiteWeltkriegGuderian` and the future `MontyCore` should depend on it.

If adding a new target is too disruptive, the fallback is to place the contracts in `DerZweiteWeltkriegAppUI`, but that makes content modules depend on app UI. The new target is cleaner.

## Generic Historical Contracts

The shared layer should be generic over battle IDs so Guderian and Monty can keep their own enums while sharing runtime code.

```swift
public protocol HistoricalBattleID: RawRepresentable, Codable, Hashable, Sendable
where RawValue == String {}

public enum HistoricalSideRole: String, Codable, Hashable, Sendable {
    case protagonist
    case opponent
}

public struct HistoricalSideOption: Identifiable, Codable, Hashable, Sendable {
    public let id: String
    public let role: HistoricalSideRole
    public let title: String
    public let historicalForce: String
    public let commander: String?
    public let armyListName: String
    public let playerBriefing: String
    public let aiBriefing: String
}

public struct HistoricalBattleScenario<ID: HistoricalBattleID>: Identifiable, Codable, Hashable, Sendable {
    public let id: ID
    public let order: Int
    public let title: String
    public let dateLabel: String
    public let theater: String
    public let status: HistoricalBattleStatus
    public let historicalResult: String
    public let designIntent: String
    public let sourceLinks: [HistoricalSourceLink]
    public let sideOptions: [HistoricalSideOption]
    public let map: HistoricalBattleMap
    public let objectives: [HistoricalObjective]
    public let victory: HistoricalVictoryProfile
}
```

Monty side roles:

- `protagonist`: Montgomery-side command.
- `opponent`: the army opposing Montgomery.

Guderian adapter roles:

- `protagonist`: anti-Guderian/player historical force.
- `opponent`: Guderian's force.

This lets the shared UI say "Choose side" without knowing whether the game is Monty or Guderian.

## Side Selection Contract

A battle launch must bind the chosen side to engine players explicitly:

```swift
public struct HistoricalBattleLaunch<ID: HistoricalBattleID>: Codable, Hashable, Sendable {
    public let battleID: ID
    public let chosenHumanSideID: String
    public let seed: UInt32
}

public struct HistoricalEngineSideBinding: Codable, Hashable, Sendable {
    public let sideID: String
    public let enginePlayer: Int
    public let controller: HistoricalController
}

public enum HistoricalController: String, Codable, Hashable, Sendable {
    case human
    case ai
}
```

Rules:

- The human-selected side should usually be `DZW_PLAYER_ONE` so existing unit-selection affordances remain simple.
- The non-selected side becomes `DZW_PLAYER_TWO` and is controlled by the scenario AI.
- If a scenario requires historical first-move ownership, the launch binding can override active-player sequencing after board creation.
- Save data must include the chosen side ID; completion records must not assume one fixed player role.
- Debrief text should be resolved from battle ID plus chosen side, because victory meaning changes when the player is Montgomery-side versus opposing-side.

## Shared Board Session Contract

The current Guderian app has a private `DZWPlayableBoardSession` protocol. That shape should move into the shared layer and become public:

```swift
public protocol HistoricalBoardSession: AnyObject {
    associatedtype BattleID: HistoricalBattleID

    var battleID: BattleID { get }
    var launch: HistoricalBattleLaunch<BattleID> { get }

    func snapshot() -> HistoricalBoardSnapshot
    func selectUnit(_ id: Int)
    func selectTarget(_ id: Int)
    func selectFirstActiveUnit()
    func selectNearestEnemyToSelectedUnit()
    func moveSelectedUnitTowardNearestObjective(maxDistance: Double) -> Bool
    func moveSelectedUnitTowardPriorityObjective(named priorityNames: [String], maxDistance: Double) -> Bool
    func moveUnit(_ id: Int, to point: HistoricalBattleCoordinate) -> Bool
    func rotateUnit(_ id: Int, to facingDegrees: Double) -> Bool
    func toggleCover(for id: Int, enabled: Bool) -> Bool
    func toggleHullDown(for id: Int, enabled: Bool) -> Bool
    func shootUnit(_ attackerID: Int, targetID: Int) -> Bool
    func assaultUnit(_ attackerID: Int, targetID: Int, advance: Bool) -> Bool
    func shootSelectedTarget() -> Bool
    func resolveFirstPendingChoice() -> Bool
    func advancePhase()
}
```

Initial implementation can typealias or adapter-wrap the existing Guderian `NativeBoardSession` and Monty sessions rather than rewriting the C bridge immediately.

## C Engine Hook Generalization

The existing hook:

```c
bool game_apply_guderian_scenario_board(...);
```

should become a generic hook:

```c
bool game_apply_historical_scenario_board(
    game_t *game,
    const char *mission_name,
    int target_score,
    const historical_scenario_zone_t *zones,
    int zone_count,
    const historical_scenario_objective_t *objectives,
    int objective_count
);
```

Migration path:

1. Add generic C structs and function names while keeping the Guderian names as compatibility wrappers.
2. Update `DerZweiteWeltkriegGuderian` to call the generic hook.
3. Remove the need for game-specific C macro names before Monty depends on the same hook.

## Cycle 20 Acceptance Checklist

- [x] Nested `dzw` submodule initialized.
- [x] DZW and Guderian package targets inspected.
- [x] DZW and Guderian SwiftPM baselines verified.
- [x] First three Monty demo battles selected.
- [x] Shared target recommendation recorded.
- [x] Generic historical scenario contract outlined.
- [x] Side-selection engine binding rules outlined.
- [x] Shared board-session protocol shape outlined.
- [x] C hook generalization path recorded.
