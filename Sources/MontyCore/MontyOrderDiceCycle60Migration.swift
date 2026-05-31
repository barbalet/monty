import Foundation
import DerZweiteWeltkriegHistorical

public struct MontyOrderDiceCupDie: Identifiable, Codable, Hashable, Sendable {
    public let id: String
    public let battleID: MontyBattleID
    public let sideID: String
    public let dieIndex: Int
    public let humanControlledWhenDrawn: Bool

    public init(
        battleID: MontyBattleID,
        sideID: String,
        dieIndex: Int,
        humanControlledWhenDrawn: Bool
    ) {
        id = "\(battleID.rawValue)-\(sideID)-die-\(dieIndex)"
        self.battleID = battleID
        self.sideID = sideID
        self.dieIndex = dieIndex
        self.humanControlledWhenDrawn = humanControlledWhenDrawn
    }
}

public struct MontyOrderDiceLaunchState: Codable, Hashable, Sendable {
    public let battleID: MontyBattleID
    public let rulesetName: String
    public let selectedHumanSideID: String
    public let seed: UInt32
    public let sideOwnership: [MontyOrderDiceSideOwnership]
    public let orderCup: [MontyOrderDiceCupDie]
    public let compatibilityMetadata: [String]

    public init(
        battleID: MontyBattleID,
        rulesetName: String,
        selectedHumanSideID: String,
        seed: UInt32,
        sideOwnership: [MontyOrderDiceSideOwnership],
        orderCup: [MontyOrderDiceCupDie],
        compatibilityMetadata: [String]
    ) {
        self.battleID = battleID
        self.rulesetName = rulesetName
        self.selectedHumanSideID = selectedHumanSideID
        self.seed = seed
        self.sideOwnership = sideOwnership
        self.orderCup = orderCup
        self.compatibilityMetadata = compatibilityMetadata
    }

    public var isReadyForOrderDiceLaunchFlow: Bool {
        rulesetName == "Order dice staged" &&
            !sideOwnership.isEmpty &&
            !orderCup.isEmpty &&
            orderCup.contains(where: \.humanControlledWhenDrawn) &&
            compatibilityMetadata.contains("MontyDemoBoardSession remains compatibility-only until native order-cup activation replaces phase advance.")
    }
}

public enum MontyOrderDiceLaunchStateBuilder {
    public static func make(
        scenario: MontyBattleScenario,
        dataPack: MontyDemoBattleDataPack,
        launch: HistoricalBattleLaunch<MontyBattleID>
    ) -> MontyOrderDiceLaunchState {
        let ownership = launch.sideBindings.map { binding in
            MontyOrderDiceSideOwnership(
                battleID: scenario.id,
                sideID: binding.sideID,
                selectedHumanSideID: launch.chosenHumanSideID,
                controller: binding.controller,
                enginePlayerSlot: binding.enginePlayerSlot,
                orderDiceCount: dataPack.forceGroups.filter { $0.sideID == binding.sideID }.count,
                canHumanControlDrawnDie: binding.sideID == launch.chosenHumanSideID,
                launchSeed: launch.seed
            )
        }

        let cup = ownership.flatMap { owner in
            (1...owner.orderDiceCount).map { index in
                MontyOrderDiceCupDie(
                    battleID: scenario.id,
                    sideID: owner.sideID,
                    dieIndex: index,
                    humanControlledWhenDrawn: owner.canHumanControlDrawnDie
                )
            }
        }

        return MontyOrderDiceLaunchState(
            battleID: scenario.id,
            rulesetName: "Order dice staged",
            selectedHumanSideID: launch.chosenHumanSideID,
            seed: launch.seed,
            sideOwnership: ownership,
            orderCup: cup,
            compatibilityMetadata: [
                "Selected side controls only its drawn dice.",
                "Order cup count is derived from demo force groups.",
                "MontyDemoBoardSession remains compatibility-only until native order-cup activation replaces phase advance.",
            ]
        )
    }
}

public struct MontyOrderDiceSharedUIContract: Codable, Hashable, Sendable {
    public let surfaceName: String
    public let requiredOrderIdentifiers: [String]
    public let exposesOrderPicker: Bool
    public let exposesDrawnSide: Bool
    public let exposesActivationLog: Bool
    public let oldPhaseButtonsAreCompatibilityOnly: Bool

    public var isReadyForCycle50: Bool {
        surfaceName == HistoricalPlayableSurfaceCatalog.sharedHostSurfaceName &&
            requiredOrderIdentifiers.count == HistoricalBoardOrder.allCases.count &&
            exposesOrderPicker &&
            exposesDrawnSide &&
            exposesActivationLog &&
            oldPhaseButtonsAreCompatibilityOnly
    }
}

public struct MontyOrderDiceSessionAdapterContract: Codable, Hashable, Sendable {
    public let adapterName: String
    public let implementsIssueOrder: Bool
    public let exposesAvailableOrders: Bool
    public let exposesCurrentOrder: Bool
    public let remainsRulesAuthority: Bool
    public let stillHasLegacyPhaseFallback: Bool

    public var isReadyForCycle55: Bool {
        adapterName == "MontyDemoBoardSession" &&
            implementsIssueOrder &&
            exposesAvailableOrders &&
            exposesCurrentOrder &&
            !remainsRulesAuthority &&
            stillHasLegacyPhaseFallback
    }
}

public struct MontyOrderDiceControlContract: Codable, Hashable, Sendable {
    public let orderControls: [HistoricalBoardOrder]
    public let executeOrderControls: [String]
    public let legacyCompatibilityControls: [String]
    public let orderControlsArePrimary: Bool

    public var isReadyForCycle60: Bool {
        orderControls == HistoricalBoardOrder.allCases &&
            executeOrderControls.contains("Resolve") &&
            executeOrderControls.contains("AI activation") &&
            legacyCompatibilityControls.contains("Phase") &&
            orderControlsArePrimary
    }
}

public struct MontyOrderDiceCycle60Report: Codable, Hashable, Sendable {
    public let cycleStart: Int
    public let cycleEnd: Int
    public let cyclesRemaining: Int
    public let documentationPath: String
    public let launchStates: [MontyOrderDiceLaunchState]
    public let sharedUIContract: MontyOrderDiceSharedUIContract
    public let sessionAdapterContract: MontyOrderDiceSessionAdapterContract
    public let controlContract: MontyOrderDiceControlContract

    public var isReadyThroughCycle60: Bool {
        let battleCount = MontyDemoDataPackCatalog.all.count
        return cycleStart == 41 &&
            cycleEnd == 60 &&
            cyclesRemaining == 140 &&
            documentationPath == MontyOrderDiceCycle60Catalog.documentationPath &&
            MontyOrderDiceCycle40Catalog.isReadyThroughOrderDiceCycle40 &&
            launchStates.count == battleCount * 2 &&
            launchStates.allSatisfy(\.isReadyForOrderDiceLaunchFlow) &&
            sharedUIContract.isReadyForCycle50 &&
            sessionAdapterContract.isReadyForCycle55 &&
            controlContract.isReadyForCycle60
    }
}

public enum MontyOrderDiceCycle60Catalog {
    public static let cycleRange = 41...60
    public static let documentationPath = "docs/monty_order_dice_cycle_041_060.md"

    public static func launchStates() throws -> [MontyOrderDiceLaunchState] {
        try MontyDemoDataPackCatalog.all.flatMap { pack in
            try [MontySideID.montgomery, MontySideID.opposition].map { chosenSideID in
                let launch = try HistoricalBattleLaunchResolver.makeLaunch(
                    scenario: pack.scenario,
                    chosenHumanSideID: chosenSideID,
                    seed: pack.autoplayConfiguration.seed
                )
                return MontyOrderDiceLaunchStateBuilder.make(
                    scenario: pack.scenario,
                    dataPack: pack,
                    launch: launch
                )
            }
        }
    }

    public static let sharedUIContract = MontyOrderDiceSharedUIContract(
        surfaceName: HistoricalPlayableSurfaceCatalog.sharedHostSurfaceName,
        requiredOrderIdentifiers: [
            MontyAccessibilityID.battleOrderFireButton,
            MontyAccessibilityID.battleOrderAdvanceButton,
            MontyAccessibilityID.battleOrderRunButton,
            MontyAccessibilityID.battleOrderAmbushButton,
            MontyAccessibilityID.battleOrderRallyButton,
            MontyAccessibilityID.battleOrderDownButton,
        ],
        exposesOrderPicker: true,
        exposesDrawnSide: true,
        exposesActivationLog: true,
        oldPhaseButtonsAreCompatibilityOnly: true
    )

    public static let sessionAdapterContract = MontyOrderDiceSessionAdapterContract(
        adapterName: "MontyDemoBoardSession",
        implementsIssueOrder: true,
        exposesAvailableOrders: true,
        exposesCurrentOrder: true,
        remainsRulesAuthority: false,
        stillHasLegacyPhaseFallback: true
    )

    public static let controlContract = MontyOrderDiceControlContract(
        orderControls: HistoricalBoardOrder.allCases,
        executeOrderControls: ["Resolve", "AI activation", "Debrief"],
        legacyCompatibilityControls: ["Move", "Shoot", "Assault", "Phase"],
        orderControlsArePrimary: true
    )

    public static func report() throws -> MontyOrderDiceCycle60Report {
        MontyOrderDiceCycle60Report(
            cycleStart: cycleRange.lowerBound,
            cycleEnd: cycleRange.upperBound,
            cyclesRemaining: 140,
            documentationPath: documentationPath,
            launchStates: try launchStates(),
            sharedUIContract: sharedUIContract,
            sessionAdapterContract: sessionAdapterContract,
            controlContract: controlContract
        )
    }

    public static var isReadyThroughOrderDiceCycle60: Bool {
        (try? report().isReadyThroughCycle60) == true
    }
}
