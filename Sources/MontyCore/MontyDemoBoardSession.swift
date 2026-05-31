import Foundation

public final class MontyDemoBoardSession: HistoricalBoardSession {
    public typealias BattleID = MontyBattleID

    private struct UnitState: Hashable {
        let id: Int
        let forceGroupID: String
        let sideID: String
        let name: String
        let role: String
        let kind: String
        var position: HistoricalBattleCoordinate
        var facingDegrees: Double
        var destroyed: Bool
    }

    public let battleID: MontyBattleID
    public let launch: HistoricalBattleLaunch<MontyBattleID>
    public let dataPack: MontyDemoBattleDataPack

    private let sideOrder: [String]
    private var activeSideID: String
    private var phase: HistoricalBoardPhase = .movement
    private var turnNumber = 1
    private var winningSideID: String?
    private var selectedUnitID: Int?
    private var selectedTargetID: Int?
    private var pendingChoices = 0
    private var unitStates: [Int: UnitState]
    private var assignedOrders: [Int: HistoricalBoardOrder] = [:]
    private var lastAction = HistoricalBoardActionMessage(
        status: .idle,
        title: "Ready",
        detail: "Monty demo board session is ready."
    )
    private var log: [String] = []

    public init(flow: MontyLaunchFlow) {
        battleID = flow.scenario.id
        launch = flow.launch
        dataPack = flow.dataPack

        let opponentSideID = flow.launch.aiSideID ?? MontySideID.opposition
        sideOrder = [flow.launch.chosenHumanSideID, opponentSideID]
        activeSideID = flow.launch.chosenHumanSideID

        var nextID = 1
        var sideSlotCounts: [String: Int] = [:]
        var states: [Int: UnitState] = [:]
        for forceGroup in flow.dataPack.forceGroups {
            let slot = sideSlotCounts[forceGroup.sideID, default: 0]
            sideSlotCounts[forceGroup.sideID] = slot + 1
            let state = UnitState(
                id: nextID,
                forceGroupID: forceGroup.id,
                sideID: forceGroup.sideID,
                name: forceGroup.name,
                role: forceGroup.role,
                kind: Self.unitKind(for: forceGroup),
                position: Self.deploymentPosition(
                    for: forceGroup,
                    slot: slot,
                    map: flow.scenario.map
                ),
                facingDegrees: forceGroup.sideID == MontySideID.montgomery ? 135 : 315,
                destroyed: false
            )
            states[nextID] = state
            nextID += 1
        }
        unitStates = states
        recordAction(
            status: .idle,
            title: "Ready",
            detail: "\(flow.scenario.title) opened for \(flow.selectedSide?.title ?? flow.chosenSideID)."
        )
    }

    public convenience init(
        battleID: MontyBattleID,
        chosenSideID: String,
        seed: UInt32? = nil
    ) throws {
        let flow = try MontyLaunchFlowResolver.makeLaunchFlow(
            battleID: battleID,
            chosenSideID: chosenSideID,
            seed: seed
        )
        self.init(flow: flow)
    }

    public func snapshot() -> HistoricalBoardSnapshot<MontyBattleID> {
        HistoricalBoardSnapshot(
            battleID: battleID,
            turnNumber: turnNumber,
            activeSideID: activeSideID,
            phase: phase,
            mission: HistoricalBoardMissionSnapshot(
                name: dataPack.scenario.title,
                targetScore: dataPack.scenario.victory.targetScore,
                humanScore: score(for: launch.chosenHumanSideID),
                aiScore: score(for: opposingSideID),
                winningSideID: winningSideID
            ),
            units: unitSnapshots(),
            zones: zoneSnapshots(),
            objectives: objectiveSnapshots(),
            lastAction: lastAction,
            log: log
        )
    }

    public func selectUnit(_ id: Int) {
        guard unitStates[id] != nil else {
            recordAction(status: .blocked, title: "Select unit", detail: "No unit exists with id \(id).")
            return
        }

        selectedUnitID = id
        if selectedTargetID == id {
            selectedTargetID = nil
        }
        recordAction(status: .succeeded, title: "Select unit", detail: "\(unitStates[id]?.name ?? "Unit") selected.")
    }

    public func selectTarget(_ id: Int) {
        guard unitStates[id] != nil else {
            recordAction(status: .blocked, title: "Select target", detail: "No target exists with id \(id).")
            return
        }

        selectedTargetID = id
        recordAction(status: .succeeded, title: "Select target", detail: "\(unitStates[id]?.name ?? "Target") targeted.")
    }

    public func clearSelection() {
        selectedUnitID = nil
        selectedTargetID = nil
        recordAction(status: .idle, title: "Selection cleared", detail: "No unit or target selected.")
    }

    public func selectFirstActiveUnit() {
        guard let unit = unitStates.values
            .filter({ $0.sideID == activeSideID && !$0.destroyed })
            .sorted(by: { $0.id < $1.id })
            .first else {
            recordAction(status: .blocked, title: "Select unit", detail: "No active unit is available.")
            return
        }

        selectUnit(unit.id)
    }

    public func selectNearestEnemyToSelectedUnit() {
        guard let selected = selectedUnit else {
            recordAction(status: .blocked, title: "Select target", detail: "Select a unit before targeting.")
            return
        }

        guard let target = unitStates.values
            .filter({ $0.sideID != selected.sideID && !$0.destroyed })
            .min(by: { distance($0.position, selected.position) < distance($1.position, selected.position) }) else {
            recordAction(status: .blocked, title: "Select target", detail: "No enemy target is available.")
            return
        }

        selectTarget(target.id)
    }

    public func moveSelectedUnitTowardNearestObjective(maxDistance: Double) -> Bool {
        guard let selected = selectedUnit else {
            recordAction(status: .blocked, title: "Move", detail: "Select a unit before moving.")
            return false
        }

        guard let destination = nearestObjectiveCoordinate(to: selected.position) else {
            recordAction(status: .blocked, title: "Move", detail: "No objective location is available.")
            return false
        }

        return moveSelectedUnit(toward: destination, maxDistance: maxDistance)
    }

    public func moveSelectedUnitTowardPriorityObjective(
        named priorityNames: [String],
        maxDistance: Double
    ) -> Bool {
        guard let destination = priorityCoordinate(named: priorityNames) else {
            return false
        }

        return moveSelectedUnit(toward: destination, maxDistance: maxDistance)
    }

    public func moveUnit(_ id: Int, to point: HistoricalBattleCoordinate) -> Bool {
        guard var unit = unitStates[id], unitCanMove(unit) else {
            recordAction(status: .blocked, title: "Move", detail: "Unit \(id) cannot move right now.")
            return false
        }

        unit.position = clamped(point)
        unitStates[id] = unit
        selectedUnitID = id
        recordAction(status: .succeeded, title: "Move", detail: "\(unit.name) moved.")
        return true
    }

    public func rotateUnit(_ id: Int, to facingDegrees: Double) -> Bool {
        guard var unit = unitStates[id], unit.sideID == activeSideID, !unit.destroyed else {
            recordAction(status: .blocked, title: "Rotate", detail: "Unit \(id) cannot rotate right now.")
            return false
        }

        unit.facingDegrees = facingDegrees.truncatingRemainder(dividingBy: 360)
        unitStates[id] = unit
        selectedUnitID = id
        recordAction(status: .succeeded, title: "Rotate", detail: "\(unit.name) changed facing.")
        return true
    }

    public func toggleCover(for id: Int, enabled: Bool) -> Bool {
        guard let unit = unitStates[id], unit.sideID == activeSideID, !unit.destroyed else {
            recordAction(status: .blocked, title: "Cover", detail: "Unit \(id) cannot change cover right now.")
            return false
        }

        recordAction(
            status: .succeeded,
            title: "Cover",
            detail: "\(unit.name) \(enabled ? "entered" : "left") cover."
        )
        return true
    }

    public func toggleHullDown(for id: Int, enabled: Bool) -> Bool {
        guard let unit = unitStates[id], unit.sideID == activeSideID, !unit.destroyed else {
            recordAction(status: .blocked, title: "Hull down", detail: "Unit \(id) cannot change hull-down status right now.")
            return false
        }

        recordAction(
            status: .succeeded,
            title: "Hull down",
            detail: "\(unit.name) \(enabled ? "took" : "left") a hull-down position."
        )
        return true
    }

    public func shootUnit(_ attackerID: Int, targetID: Int) -> Bool {
        guard let attacker = unitStates[attackerID], unitCanShoot(attacker) else {
            recordAction(status: .blocked, title: "Shoot", detail: "Attacker \(attackerID) cannot shoot right now.")
            return false
        }
        guard let target = unitStates[targetID], target.sideID != attacker.sideID, !target.destroyed else {
            recordAction(status: .blocked, title: "Shoot", detail: "Target \(targetID) is not a legal enemy target.")
            return false
        }

        selectedUnitID = attackerID
        selectedTargetID = targetID
        pendingChoices += 1
        recordAction(status: .succeeded, title: "Shoot", detail: "\(attacker.name) fired on \(target.name).")
        return true
    }

    public func assaultUnit(_ attackerID: Int, targetID: Int, advance: Bool) -> Bool {
        guard var attacker = unitStates[attackerID], unitCanAssault(attacker) else {
            recordAction(status: .blocked, title: "Assault", detail: "Attacker \(attackerID) cannot assault right now.")
            return false
        }
        guard let target = unitStates[targetID], target.sideID != attacker.sideID, !target.destroyed else {
            recordAction(status: .blocked, title: "Assault", detail: "Target \(targetID) is not a legal enemy target.")
            return false
        }

        selectedUnitID = attackerID
        selectedTargetID = targetID
        if advance {
            attacker.position = clamped(pointBetween(attacker.position, target.position, fraction: 0.6))
            unitStates[attackerID] = attacker
        }
        pendingChoices += 1
        recordAction(status: .succeeded, title: "Assault", detail: "\(attacker.name) assaulted \(target.name).")
        return true
    }

    public func shootSelectedTarget() -> Bool {
        guard let selectedUnitID, let selectedTargetID else {
            recordAction(status: .blocked, title: "Shoot", detail: "Select both an attacker and a target before shooting.")
            return false
        }
        return shootUnit(selectedUnitID, targetID: selectedTargetID)
    }

    public func issueOrder(_ order: HistoricalBoardOrder, to unitID: Int) -> Bool {
        guard let unit = unitStates[unitID], availableOrders(for: unit).contains(order) else {
            recordAction(status: .blocked, title: "Order", detail: "Unit \(unitID) cannot receive \(order.rawValue) right now.")
            return false
        }

        selectedUnitID = unitID
        assignedOrders[unitID] = order
        recordAction(status: .succeeded, title: "Order", detail: "\(unit.name) received \(order.rawValue).")
        return true
    }

    public func issueOrderToSelectedUnit(_ order: HistoricalBoardOrder) -> Bool {
        guard let selectedUnitID else {
            recordAction(status: .blocked, title: "Order", detail: "Select a unit before issuing \(order.rawValue).")
            return false
        }
        return issueOrder(order, to: selectedUnitID)
    }

    public func resolveFirstPendingChoice() -> Bool {
        guard pendingChoices > 0 else {
            return false
        }

        pendingChoices -= 1
        recordAction(status: .succeeded, title: "Resolve", detail: "Resolved the pending combat choice.")
        return true
    }

    public func advancePhase() {
        switch phase {
        case .movement:
            phase = .shooting
        case .shooting:
            phase = .assault
        case .assault:
            advanceSideAfterAssault()
        }

        selectedUnitID = nil
        selectedTargetID = nil
        recordAction(status: .succeeded, title: "Advance phase", detail: "Turn \(turnNumber), \(activeSideID), \(phase.rawValue).")
    }

    private var selectedUnit: UnitState? {
        guard let selectedUnitID else {
            return nil
        }
        return unitStates[selectedUnitID]
    }

    private var opposingSideID: String {
        launch.aiSideID ?? sideOrder.first { $0 != launch.chosenHumanSideID } ?? MontySideID.opposition
    }

    private func currentOrder(for unit: UnitState) -> HistoricalBoardOrder? {
        assignedOrders[unit.id]
    }

    private func availableOrders(for unit: UnitState) -> [HistoricalBoardOrder] {
        guard unit.sideID == activeSideID, !unit.destroyed, assignedOrders[unit.id] == nil else {
            return []
        }
        return HistoricalBoardOrder.allCases
    }

    private func unitCanMove(_ unit: UnitState) -> Bool {
        guard unit.sideID == activeSideID, !unit.destroyed else {
            return false
        }
        if phase == .movement {
            return true
        }
        return currentOrder(for: unit).map { $0 == .advance || $0 == .run } ?? false
    }

    private func unitCanShoot(_ unit: UnitState) -> Bool {
        guard unit.sideID == activeSideID, !unit.destroyed else {
            return false
        }
        if phase == .shooting {
            return true
        }
        return currentOrder(for: unit).map { $0 == .fire || $0 == .advance } ?? false
    }

    private func unitCanAssault(_ unit: UnitState) -> Bool {
        guard unit.sideID == activeSideID, !unit.destroyed else {
            return false
        }
        if phase == .assault {
            return true
        }
        return currentOrder(for: unit) == .run
    }

    private func score(for sideID: String) -> Int {
        let targetScore = dataPack.scenario.victory.targetScore
        guard let winningSideID else {
            return sideID == launch.chosenHumanSideID
                ? min(targetScore - 1, max(1, turnNumber + 2))
                : max(0, turnNumber)
        }

        if winningSideID == sideID {
            return targetScore
        }
        return max(0, targetScore / 2)
    }

    private func unitSnapshots() -> [HistoricalBoardUnitSnapshot] {
        unitStates.values
            .sorted { $0.id < $1.id }
            .map { unit in
                let profile = forceProfile(for: unit)
                let order = currentOrder(for: unit)
                return HistoricalBoardUnitSnapshot(
                    id: unit.id,
                    sideID: unit.sideID,
                    name: unit.name,
                    kind: unit.kind,
                    role: unit.role,
                    position: unit.position,
                    facingDegrees: unit.facingDegrees,
                    destroyed: unit.destroyed,
                    canMoveNow: unitCanMove(unit),
                    canShootNow: unitCanShoot(unit),
                    canAssaultNow: unitCanAssault(unit),
                    selected: unit.id == selectedUnitID,
                    targeted: unit.id == selectedTargetID,
                    currentOrder: order,
                    availableOrders: availableOrders(for: unit),
                    orderDiceSummary: order.map { "\($0.rawValue) assigned from staged order-dice controls." } ?? "Ready for order die.",
                    pinCount: 0,
                    moraleQuality: profile?.quality.rawValue ?? "Regular",
                    retainedOrder: order == .ambush || order == .down,
                    downOrderActive: order == .down,
                    ambushOrderActive: order == .ambush
                )
            }
    }

    private func forceProfile(for unit: UnitState) -> MontyOrderDiceForceProfile? {
        MontyOrderDiceCycle40Catalog.forceProfiles().first {
            $0.battleID == battleID && $0.forceGroupID == unit.forceGroupID
        }
    }

    private func zoneSnapshots() -> [HistoricalBoardZoneSnapshot] {
        dataPack.scenario.map.elements.enumerated().map { index, element in
            let origin = element.points.first ?? HistoricalBattleCoordinate(x: 0, y: 0)
            let end = element.points.last ?? origin
            return HistoricalBoardZoneSnapshot(
                id: index + 1,
                name: element.name,
                kind: element.kind,
                origin: origin,
                width: max(4, abs(end.x - origin.x)),
                height: max(3, abs(end.y - origin.y)),
                blocksLineOfSight: element.kind == .ridge || element.kind == .forest || element.kind == .town
            )
        }
    }

    private func objectiveSnapshots() -> [HistoricalBoardObjectiveSnapshot] {
        dataPack.scenario.objectives.enumerated().map { index, objective in
            HistoricalBoardObjectiveSnapshot(
                id: index + 1,
                name: objective.name,
                location: objective.location ?? HistoricalBattleCoordinate(x: 50, y: 28),
                radius: max(4, objective.radius),
                controllingSideID: objective.sideID
            )
        }
    }

    private func moveSelectedUnit(toward destination: HistoricalBattleCoordinate, maxDistance: Double) -> Bool {
        guard let selected = selectedUnit else {
            recordAction(status: .blocked, title: "Move", detail: "Select a unit before moving.")
            return false
        }

        let nextPoint = pointToward(selected.position, destination, maxDistance: maxDistance)
        return moveUnit(selected.id, to: nextPoint)
    }

    private func nearestObjectiveCoordinate(to point: HistoricalBattleCoordinate) -> HistoricalBattleCoordinate? {
        dataPack.scenario.objectives
            .compactMap(\.location)
            .min { distance($0, point) < distance($1, point) }
    }

    private func priorityCoordinate(named priorityNames: [String]) -> HistoricalBattleCoordinate? {
        for priorityName in priorityNames {
            if let objective = dataPack.scenario.objectives.first(where: { matches($0.name, priorityName) }),
               let location = objective.location {
                return location
            }

            if let element = dataPack.scenario.map.elements.first(where: { matches($0.name, priorityName) }),
               let location = element.points.first {
                return location
            }
        }
        return nil
    }

    private func advanceSideAfterAssault() {
        phase = .movement
        assignedOrders.removeAll()
        if activeSideID == sideOrder.last {
            activeSideID = sideOrder[0]
            turnNumber += 1
            if turnNumber >= 2 {
                winningSideID = launch.chosenHumanSideID
            }
        } else {
            activeSideID = sideOrder.last ?? sideOrder[0]
        }
    }

    private func recordAction(status: HistoricalBoardActionStatus, title: String, detail: String) {
        lastAction = HistoricalBoardActionMessage(status: status, title: title, detail: detail)
        log.append("\(title): \(detail)")
        if log.count > 20 {
            log.removeFirst(log.count - 20)
        }
    }

    private func pointToward(
        _ origin: HistoricalBattleCoordinate,
        _ destination: HistoricalBattleCoordinate,
        maxDistance: Double
    ) -> HistoricalBattleCoordinate {
        let totalDistance = distance(origin, destination)
        guard totalDistance > 0 else {
            return origin
        }

        let fraction = min(1, max(0, maxDistance) / totalDistance)
        return pointBetween(origin, destination, fraction: fraction)
    }

    private func pointBetween(
        _ origin: HistoricalBattleCoordinate,
        _ destination: HistoricalBattleCoordinate,
        fraction: Double
    ) -> HistoricalBattleCoordinate {
        HistoricalBattleCoordinate(
            x: origin.x + (destination.x - origin.x) * fraction,
            y: origin.y + (destination.y - origin.y) * fraction
        )
    }

    private func distance(_ lhs: HistoricalBattleCoordinate, _ rhs: HistoricalBattleCoordinate) -> Double {
        let dx = lhs.x - rhs.x
        let dy = lhs.y - rhs.y
        return sqrt(dx * dx + dy * dy)
    }

    private func clamped(_ point: HistoricalBattleCoordinate) -> HistoricalBattleCoordinate {
        HistoricalBattleCoordinate(
            x: min(max(0, point.x), dataPack.scenario.map.width),
            y: min(max(0, point.y), dataPack.scenario.map.height)
        )
    }

    private func matches(_ candidate: String, _ priority: String) -> Bool {
        let lhs = candidate.lowercased()
        let rhs = priority.lowercased()
        return lhs == rhs || lhs.contains(rhs) || rhs.contains(lhs)
    }

    private static func deploymentPosition(
        for forceGroup: MontyBattleForceGroup,
        slot: Int,
        map: HistoricalBattleMap
    ) -> HistoricalBattleCoordinate {
        let zone = map.deploymentZones.first { $0.sideID == forceGroup.sideID }
        let origin = zone?.origin ?? HistoricalBattleCoordinate(x: 10, y: 10)
        let width = zone?.width ?? 16
        let height = zone?.height ?? 12
        return HistoricalBattleCoordinate(
            x: origin.x + min(width - 2, 4 + Double(slot * 8)),
            y: origin.y + min(height - 2, 4 + Double(slot * 5))
        )
    }

    private static func unitKind(for forceGroup: MontyBattleForceGroup) -> String {
        let text = "\(forceGroup.name) \(forceGroup.role)".lowercased()
        if text.contains("panzer") || text.contains("armour") || text.contains("armor") || text.contains("tank") {
            return "Armour"
        }
        if text.contains("gun") || text.contains("artillery") {
            return "Gun"
        }
        if text.contains("command") {
            return "Command"
        }
        return "Infantry"
    }
}
