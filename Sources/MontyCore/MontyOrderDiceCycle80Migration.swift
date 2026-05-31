import Foundation
import DerZweiteWeltkriegHistorical

public struct MontyOrderDiceSidebarDetail: Codable, Hashable, Sendable {
    public let battleID: MontyBattleID
    public let selectedHumanSideID: String
    public let drawnSideID: String
    public let unitID: Int
    public let sideID: String
    public let unitName: String
    public let pinCount: Int
    public let moraleQuality: String
    public let orderState: String
    public let retainedOrder: Bool
    public let orderTestSummary: String
    public let targetReactionSummary: String
    public let vehicleDamageSummary: String
    public let moraleDebriefSummary: String

    public var isReadyForCycle65Sidebar: Bool {
        unitID > 0 &&
            !sideID.isEmpty &&
            !unitName.isEmpty &&
            pinCount >= 0 &&
            !moraleQuality.isEmpty &&
            !orderState.isEmpty &&
            !orderTestSummary.isEmpty &&
            !targetReactionSummary.isEmpty &&
            !vehicleDamageSummary.isEmpty &&
            !moraleDebriefSummary.isEmpty
    }
}

public struct MontyOrderDiceHumanInteractionPreview: Codable, Hashable, Sendable {
    public let battleID: MontyBattleID
    public let selectedHumanSideID: String
    public let drawnSideID: String
    public let selectedUnitID: Int
    public let selectedUnitName: String
    public let directUnitTapIntent: String
    public let legalOrders: [HistoricalBoardOrder]
    public let legalTargetIDs: [Int]
    public let movementPreviewSummary: String
    public let targetReactionSummary: String
    public let executeSummary: String
    public let waitsForNextDieAfterExecution: Bool

    public var isReadyForCycle70Interaction: Bool {
        selectedHumanSideID == drawnSideID &&
            selectedUnitID > 0 &&
            !selectedUnitName.isEmpty &&
            directUnitTapIntent == "selectUnit" &&
            Set(legalOrders) == Set(HistoricalBoardOrder.allCases) &&
            !legalTargetIDs.isEmpty &&
            movementPreviewSummary.contains("Advance") &&
            targetReactionSummary.contains("Target reacts") &&
            executeSummary.contains("drawn die") &&
            waitsForNextDieAfterExecution
    }
}

public enum MontyOrderDiceInteractionBlocker: String, CaseIterable, Codable, Hashable, Sendable {
    case noSelectedUnit = "No selected unit"
    case wrongDrawnSide = "Wrong drawn side"
    case destroyedUnit = "Destroyed unit"
    case alreadyOrdered = "Already ordered"
    case orderTestRequired = "Order test required"
    case pinPressure = "Pin pressure"
    case movementBlockedByTerrain = "Movement blocked by terrain"
    case noLegalTarget = "No legal target"
    case targetReactionPending = "Target reaction pending"
    case retainedOrder = "Retained order"
    case turnEndCleanup = "Turn-end cleanup"
    case vehicleDamageStopsAction = "Vehicle damage stops action"

    public var explanation: String {
        switch self {
        case .noSelectedUnit:
            return "Select one unit from the drawn side before issuing an order."
        case .wrongDrawnSide:
            return "The selected unit belongs to the other side, so it must wait for that side's die."
        case .destroyedUnit:
            return "Destroyed units cannot receive order dice."
        case .alreadyOrdered:
            return "A unit that already has an order cannot receive another order this turn."
        case .orderTestRequired:
            return "Pinned units must pass their order test before executing a non-Down order."
        case .pinPressure:
            return "Pin markers reduce order reliability and shooting effectiveness."
        case .movementBlockedByTerrain:
            return "Terrain can block Run movement or vehicle access, leaving Advance or no move as the legal result."
        case .noLegalTarget:
            return "Fire, Advance-fire, and assault actions need a legal enemy target."
        case .targetReactionPending:
            return "Target reaction is resolved after target declaration and before measuring range or assault movement."
        case .retainedOrder:
            return "Ambush and Down orders can be retained into turn-end handling instead of immediately returning to the cup."
        case .turnEndCleanup:
            return "Order dice return to the cup at turn end, except retained Ambush or Down dice."
        case .vehicleDamageStopsAction:
            return "Vehicle damage can force Down, immobilise the vehicle, or knock it out before another action is possible."
        }
    }
}

public struct MontyOrderDiceAIActivationDecision: Codable, Hashable, Sendable {
    public let battleID: MontyBattleID
    public let drawnSideID: String
    public let controllerLabel: String
    public let unitID: Int
    public let unitName: String
    public let order: HistoricalBoardOrder
    public let targetID: Int?
    public let targetName: String?
    public let pathTarget: HistoricalBattleCoordinate?
    public let requiresOrderTest: Bool
    public let respondsToAmbushOrDown: Bool
    public let actionIntent: String
    public let reason: String
    public let usesSharedDZWOrderAdvisor: Bool
    public let replacesFullPhaseScript: Bool
    public let waitsForNextDieAfterActivation: Bool

    public var isReadyForCycle80AI: Bool {
        unitID > 0 &&
            !unitName.isEmpty &&
            !controllerLabel.isEmpty &&
            !actionIntent.isEmpty &&
            !reason.isEmpty &&
            usesSharedDZWOrderAdvisor &&
            replacesFullPhaseScript &&
            waitsForNextDieAfterActivation
    }
}

public struct MontyOrderDiceCycle80Report: Codable, Hashable, Sendable {
    public let cycleStart: Int
    public let cycleEnd: Int
    public let cyclesRemaining: Int
    public let documentationPath: String
    public let sidebarDetails: [MontyOrderDiceSidebarDetail]
    public let interactionPreviews: [MontyOrderDiceHumanInteractionPreview]
    public let blockedReasons: [MontyOrderDiceInteractionBlocker]
    public let aiActivationDecisions: [MontyOrderDiceAIActivationDecision]

    public var isReadyThroughCycle80: Bool {
        let battleCount = MontyDemoDataPackCatalog.all.count
        let forceCount = MontyDemoDataPackCatalog.all.map(\.forceGroups.count).reduce(0, +)
        return cycleStart == 61 &&
            cycleEnd == 80 &&
            cyclesRemaining == 120 &&
            documentationPath == MontyOrderDiceCycle80Catalog.documentationPath &&
            MontyOrderDiceCycle60Catalog.isReadyThroughOrderDiceCycle60 &&
            sidebarDetails.count == forceCount * 2 &&
            sidebarDetails.allSatisfy(\.isReadyForCycle65Sidebar) &&
            interactionPreviews.count == battleCount * 2 &&
            interactionPreviews.allSatisfy(\.isReadyForCycle70Interaction) &&
            Set(blockedReasons) == Set(MontyOrderDiceInteractionBlocker.allCases) &&
            aiActivationDecisions.count == battleCount * 2 &&
            aiActivationDecisions.allSatisfy(\.isReadyForCycle80AI)
    }
}

public enum MontyOrderDiceAIActivationAdvisor {
    public static func decision(
        flow: MontyLaunchFlow,
        snapshot: HistoricalBoardSnapshot<MontyBattleID>
    ) -> MontyOrderDiceAIActivationDecision? {
        let sidePlan = flow.autoplayConfiguration.plan(for: snapshot.activeSideID)
        guard let decision = HistoricalAutoplayOrderAdvisor.decision(in: snapshot, sidePlan: sidePlan) else {
            return nil
        }

        return MontyOrderDiceAIActivationDecision(
            battleID: snapshot.battleID,
            drawnSideID: snapshot.activeSideID,
            controllerLabel: sidePlan.controllerLabel,
            unitID: decision.unitID,
            unitName: decision.unitName,
            order: decision.order,
            targetID: decision.targetID,
            targetName: decision.targetName,
            pathTarget: decision.pathTarget,
            requiresOrderTest: decision.requiresOrderTest,
            respondsToAmbushOrDown: decision.respondsToAmbushOrDown,
            actionIntent: actionIntent(for: decision),
            reason: decision.reason,
            usesSharedDZWOrderAdvisor: true,
            replacesFullPhaseScript: true,
            waitsForNextDieAfterActivation: true
        )
    }

    private static func actionIntent(for decision: HistoricalAutoplayOrderDecision) -> String {
        switch decision.order {
        case .fire:
            return "Fire one selected unit at \(decision.targetName ?? "its legal target"), then wait for the next die."
        case .advance:
            return "Advance one selected unit toward its objective and resolve any legal fire, then wait for the next die."
        case .run:
            return "Run or assault with one selected unit, then wait for the next die."
        case .ambush:
            return "Place one selected unit on Ambush and hold opportunity fire for a later trigger."
        case .rally:
            return "Resolve one selected unit's Rally order test and pin removal, then wait for the next die."
        case .down:
            return "Place one selected unit Down as its reaction or defensive order, then wait for the next die."
        }
    }
}

public enum MontyOrderDiceCycle80Catalog {
    public static let cycleRange = 61...80
    public static let documentationPath = "docs/monty_order_dice_cycle_061_080.md"

    public static func sidebarDetails() throws -> [MontyOrderDiceSidebarDetail] {
        try selectedSideFlows().flatMap { flow in
            let snapshot = MontyDemoBoardSession(flow: flow).snapshot()
            return snapshot.units.map { unit in
                sidebarDetail(for: unit, snapshot: snapshot, flow: flow)
            }
        }
    }

    public static func interactionPreviews() throws -> [MontyOrderDiceHumanInteractionPreview] {
        try selectedSideFlows().compactMap { flow in
            let session = MontyDemoBoardSession(flow: flow)
            session.selectFirstActiveUnit()
            session.selectNearestEnemyToSelectedUnit()
            let snapshot = session.snapshot()
            guard let selected = snapshot.units.first(where: \.selected) else {
                return nil
            }
            let legalTargets = snapshot.units
                .filter { $0.sideID != selected.sideID && !$0.destroyed }
                .map(\.id)
                .sorted()
            let target = snapshot.units.first(where: \.targeted)

            return MontyOrderDiceHumanInteractionPreview(
                battleID: snapshot.battleID,
                selectedHumanSideID: flow.chosenSideID,
                drawnSideID: snapshot.activeSideID,
                selectedUnitID: selected.id,
                selectedUnitName: selected.name,
                directUnitTapIntent: intentLabel(
                    HistoricalBoardInteractionResolver.unitTapIntent(for: selected, in: snapshot)
                ),
                legalOrders: selected.availableOrders,
                legalTargetIDs: legalTargets,
                movementPreviewSummary: movementPreview(for: selected, snapshot: snapshot),
                targetReactionSummary: targetReactionSummary(for: target),
                executeSummary: "Issue one order to \(selected.name) from the drawn die, execute that activation, then wait for the next die.",
                waitsForNextDieAfterExecution: true
            )
        }
    }

    public static var blockedReasons: [MontyOrderDiceInteractionBlocker] {
        MontyOrderDiceInteractionBlocker.allCases
    }

    public static func aiActivationDecisions() throws -> [MontyOrderDiceAIActivationDecision] {
        try selectedSideFlows().compactMap { flow in
            let session = MontyDemoBoardSession(flow: flow)
            return MontyOrderDiceAIActivationAdvisor.decision(
                flow: flow,
                snapshot: session.snapshot()
            )
        }
    }

    public static func report() throws -> MontyOrderDiceCycle80Report {
        MontyOrderDiceCycle80Report(
            cycleStart: cycleRange.lowerBound,
            cycleEnd: cycleRange.upperBound,
            cyclesRemaining: 120,
            documentationPath: documentationPath,
            sidebarDetails: try sidebarDetails(),
            interactionPreviews: try interactionPreviews(),
            blockedReasons: blockedReasons,
            aiActivationDecisions: try aiActivationDecisions()
        )
    }

    public static var isReadyThroughOrderDiceCycle80: Bool {
        (try? report().isReadyThroughCycle80) == true
    }
}

private extension MontyOrderDiceCycle80Catalog {
    static func selectedSideFlows() throws -> [MontyLaunchFlow] {
        try MontyDemoDataPackCatalog.all.flatMap { pack in
            try [MontySideID.montgomery, MontySideID.opposition].map { chosenSideID in
                try MontyLaunchFlowResolver.makeLaunchFlow(
                    battleID: pack.scenario.id,
                    chosenSideID: chosenSideID,
                    seed: pack.autoplayConfiguration.seed
                )
            }
        }
    }

    static func sidebarDetail(
        for unit: HistoricalBoardUnitSnapshot,
        snapshot: HistoricalBoardSnapshot<MontyBattleID>,
        flow: MontyLaunchFlow
    ) -> MontyOrderDiceSidebarDetail {
        let orderState = unit.currentOrder?.rawValue ?? "Awaiting drawn die"
        return MontyOrderDiceSidebarDetail(
            battleID: snapshot.battleID,
            selectedHumanSideID: flow.chosenSideID,
            drawnSideID: snapshot.activeSideID,
            unitID: unit.id,
            sideID: unit.sideID,
            unitName: unit.name,
            pinCount: unit.pinCount,
            moraleQuality: unit.moraleQuality,
            orderState: orderState,
            retainedOrder: unit.retainedOrder,
            orderTestSummary: orderTestSummary(for: unit),
            targetReactionSummary: targetReactionSummary(for: unit),
            vehicleDamageSummary: vehicleDamageSummary(for: unit),
            moraleDebriefSummary: moraleDebriefSummary(for: unit, flow: flow)
        )
    }

    static func orderTestSummary(for unit: HistoricalBoardUnitSnapshot) -> String {
        if unit.pinCount > 0 {
            return "\(unit.name) must pass an order test before non-Down orders."
        }
        return "\(unit.name) has no pin markers, so no order test is required."
    }

    static func targetReactionSummary(for unit: HistoricalBoardUnitSnapshot?) -> String {
        guard let unit else {
            return "Target reacts after declaration; no target is currently selected."
        }
        if unit.downOrderActive {
            return "Target reacts from Down, applying its defensive state."
        }
        if unit.ambushOrderActive {
            return "Target reacts from Ambush, holding opportunity fire."
        }
        return "Target reacts after declaration before range and damage are resolved."
    }

    static func vehicleDamageSummary(for unit: HistoricalBoardUnitSnapshot) -> String {
        guard unit.kind == "Armour" || unit.kind == "Vehicle" else {
            return "Vehicle damage does not apply to this unit."
        }
        if unit.destroyed {
            return "Vehicle damage result: knocked out."
        }
        if unit.downOrderActive {
            return "Vehicle damage state: halted Down until cleanup."
        }
        return "Vehicle damage state: no stun, immobilisation, fire, or knockout marker."
    }

    static func moraleDebriefSummary(
        for unit: HistoricalBoardUnitSnapshot,
        flow: MontyLaunchFlow
    ) -> String {
        let sideTitle = flow.scenario.sideOptions.first { $0.id == unit.sideID }?.title ?? unit.sideID
        return "\(sideTitle): \(unit.moraleQuality) morale, \(unit.pinCount) pins, \(unit.orderDiceSummary)."
    }

    static func movementPreview(
        for unit: HistoricalBoardUnitSnapshot,
        snapshot: HistoricalBoardSnapshot<MontyBattleID>
    ) -> String {
        let objective = snapshot.objectives
            .sorted { distance(unit.position, $0.location) < distance(unit.position, $1.location) }
            .first?
            .name ?? "nearest objective"
        return "Advance previews one normal move toward \(objective); Run previews double movement and no firing."
    }

    static func intentLabel(_ intent: HistoricalBoardSelectionIntent) -> String {
        switch intent {
        case .selectUnit:
            return "selectUnit"
        case .selectTarget:
            return "selectTarget"
        case .clearSelection:
            return "clearSelection"
        case .ignored:
            return "ignored"
        }
    }

    static func distance(_ lhs: HistoricalBattleCoordinate, _ rhs: HistoricalBattleCoordinate) -> Double {
        let dx = lhs.x - rhs.x
        let dy = lhs.y - rhs.y
        return sqrt(dx * dx + dy * dy)
    }
}
