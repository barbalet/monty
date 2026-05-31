import Foundation
import DerZweiteWeltkriegHistorical

public struct MontyOrderDiceSideOwnership: Codable, Hashable, Sendable {
    public let battleID: MontyBattleID
    public let sideID: String
    public let selectedHumanSideID: String
    public let controller: HistoricalController
    public let enginePlayerSlot: HistoricalEnginePlayerSlot
    public let orderDiceCount: Int
    public let canHumanControlDrawnDie: Bool
    public let launchSeed: UInt32

    public init(
        battleID: MontyBattleID,
        sideID: String,
        selectedHumanSideID: String,
        controller: HistoricalController,
        enginePlayerSlot: HistoricalEnginePlayerSlot,
        orderDiceCount: Int,
        canHumanControlDrawnDie: Bool,
        launchSeed: UInt32
    ) {
        self.battleID = battleID
        self.sideID = sideID
        self.selectedHumanSideID = selectedHumanSideID
        self.controller = controller
        self.enginePlayerSlot = enginePlayerSlot
        self.orderDiceCount = orderDiceCount
        self.canHumanControlDrawnDie = canHumanControlDrawnDie
        self.launchSeed = launchSeed
    }
}

public enum MontyOrderDiceMoraleQuality: String, CaseIterable, Codable, Hashable, Sendable {
    case inexperienced = "Inexperienced"
    case regular = "Regular"
    case veteran = "Veteran"
}

public enum MontyOrderDiceWeaponClass: String, CaseIterable, Codable, Hashable, Sendable {
    case smallArms = "Small arms"
    case supportWeapon = "Support weapon"
    case antiTank = "Anti-tank"
    case artillery = "Artillery"
    case armourWeapon = "Armour weapon"
    case engineers = "Engineers"
    case closeAssault = "Close assault"
}

public enum MontyOrderDiceVehicleClass: String, CaseIterable, Codable, Hashable, Sendable {
    case none = "None"
    case transport = "Transport"
    case artillery = "Artillery"
    case tank = "Tank"
}

public enum MontyOrderDicePinBehavior: String, CaseIterable, Codable, Hashable, Sendable {
    case standard = "Standard"
    case stubborn = "Stubborn"
    case rallyPriority = "Rally priority"
    case counterattackRisk = "Counterattack risk"
}

public struct MontyOrderDiceForceProfile: Codable, Hashable, Sendable {
    public let battleID: MontyBattleID
    public let forceGroupID: String
    public let sideID: String
    public let quality: MontyOrderDiceMoraleQuality
    public let officerModifier: Int
    public let weaponClasses: [MontyOrderDiceWeaponClass]
    public let vehicleClass: MontyOrderDiceVehicleClass
    public let pinBehavior: MontyOrderDicePinBehavior
    public let recommendedOrders: [HistoricalBoardOrder]

    public init(
        battleID: MontyBattleID,
        forceGroupID: String,
        sideID: String,
        quality: MontyOrderDiceMoraleQuality,
        officerModifier: Int,
        weaponClasses: [MontyOrderDiceWeaponClass],
        vehicleClass: MontyOrderDiceVehicleClass,
        pinBehavior: MontyOrderDicePinBehavior,
        recommendedOrders: [HistoricalBoardOrder]
    ) {
        self.battleID = battleID
        self.forceGroupID = forceGroupID
        self.sideID = sideID
        self.quality = quality
        self.officerModifier = officerModifier
        self.weaponClasses = weaponClasses
        self.vehicleClass = vehicleClass
        self.pinBehavior = pinBehavior
        self.recommendedOrders = recommendedOrders
    }
}

public enum MontyOrderDiceTerrainClass: String, CaseIterable, Codable, Hashable, Sendable {
    case open = "Open"
    case rough = "Rough"
    case obstacle = "Obstacle"
    case building = "Building"
    case road = "Road"
    case softCover = "Soft cover"
    case hardCover = "Hard cover"
    case impassable = "Impassable"
    case minefield = "Minefield"
}

public struct MontyOrderDiceTerrainProfile: Codable, Hashable, Sendable {
    public let battleID: MontyBattleID
    public let elementID: String
    public let elementKind: HistoricalMapElementKind
    public let classes: [MontyOrderDiceTerrainClass]
    public let allowsRoadBonus: Bool
    public let blocksRun: Bool
    public let blocksLineOfSight: Bool
    public let coverClass: MontyOrderDiceTerrainClass?

    public init(
        battleID: MontyBattleID,
        elementID: String,
        elementKind: HistoricalMapElementKind,
        classes: [MontyOrderDiceTerrainClass],
        allowsRoadBonus: Bool,
        blocksRun: Bool,
        blocksLineOfSight: Bool,
        coverClass: MontyOrderDiceTerrainClass?
    ) {
        self.battleID = battleID
        self.elementID = elementID
        self.elementKind = elementKind
        self.classes = classes
        self.allowsRoadBonus = allowsRoadBonus
        self.blocksRun = blocksRun
        self.blocksLineOfSight = blocksLineOfSight
        self.coverClass = coverClass
    }
}

public struct MontyOrderDicePacingProfile: Codable, Hashable, Sendable {
    public let battleID: MontyBattleID
    public let targetScore: Int
    public let targetTurnUpperBound: Int
    public let orderDicePerTurn: Int
    public let targetActivationBudget: Int
    public let activationSafetyCap: Int
    public let objectiveVictoryPointsBySide: [String: Int]
    public let debriefRequiresActivationCount: Bool
    public let phaseCountScoringDeprecated: Bool

    public init(
        battleID: MontyBattleID,
        targetScore: Int,
        targetTurnUpperBound: Int,
        orderDicePerTurn: Int,
        targetActivationBudget: Int,
        activationSafetyCap: Int,
        objectiveVictoryPointsBySide: [String: Int],
        debriefRequiresActivationCount: Bool,
        phaseCountScoringDeprecated: Bool
    ) {
        self.battleID = battleID
        self.targetScore = targetScore
        self.targetTurnUpperBound = targetTurnUpperBound
        self.orderDicePerTurn = orderDicePerTurn
        self.targetActivationBudget = targetActivationBudget
        self.activationSafetyCap = activationSafetyCap
        self.objectiveVictoryPointsBySide = objectiveVictoryPointsBySide
        self.debriefRequiresActivationCount = debriefRequiresActivationCount
        self.phaseCountScoringDeprecated = phaseCountScoringDeprecated
    }
}

public struct MontyOrderDiceCycle40Report: Codable, Hashable, Sendable {
    public let cycleStart: Int
    public let cycleEnd: Int
    public let cyclesRemaining: Int
    public let documentationPath: String
    public let sideOwnershipCases: [MontyOrderDiceSideOwnership]
    public let forceProfiles: [MontyOrderDiceForceProfile]
    public let terrainProfiles: [MontyOrderDiceTerrainProfile]
    public let pacingProfiles: [MontyOrderDicePacingProfile]

    public var isReadyThroughCycle40: Bool {
        let battleCount = MontyDemoDataPackCatalog.all.count
        let forceCount = MontyDemoDataPackCatalog.all.map(\.forceGroups.count).reduce(0, +)
        let terrainCount = MontyDemoDataPackCatalog.all.map(\.scenario.map.elements.count).reduce(0, +)

        return cycleStart == 21 &&
            cycleEnd == 40 &&
            cyclesRemaining == 160 &&
            documentationPath == MontyOrderDiceCycle40Catalog.documentationPath &&
            MontyOrderDiceCycle20Catalog.isReadyThroughOrderDiceCycle20 &&
            sideOwnershipCases.count == battleCount * 4 &&
            sideOwnershipCases.allSatisfy { $0.orderDiceCount > 0 } &&
            forceProfiles.count == forceCount &&
            forceProfiles.allSatisfy { !$0.weaponClasses.isEmpty && !$0.recommendedOrders.isEmpty } &&
            terrainProfiles.count == terrainCount &&
            terrainProfiles.allSatisfy { !$0.classes.isEmpty } &&
            pacingProfiles.count == battleCount &&
            pacingProfiles.allSatisfy {
                $0.orderDicePerTurn > 0 &&
                    $0.targetActivationBudget == $0.orderDicePerTurn * $0.targetTurnUpperBound &&
                    $0.activationSafetyCap >= $0.targetActivationBudget &&
                    $0.debriefRequiresActivationCount &&
                    $0.phaseCountScoringDeprecated
            }
    }
}

public enum MontyOrderDiceCycle40Catalog {
    public static let cycleRange = 21...40
    public static let documentationPath = "docs/monty_order_dice_cycle_021_040.md"

    public static func sideOwnershipCases() throws -> [MontyOrderDiceSideOwnership] {
        try MontyDemoDataPackCatalog.all.flatMap { pack in
            try [MontySideID.montgomery, MontySideID.opposition].flatMap { chosenSideID in
                let launch = try HistoricalBattleLaunchResolver.makeLaunch(
                    scenario: pack.scenario,
                    chosenHumanSideID: chosenSideID,
                    seed: pack.autoplayConfiguration.seed
                )
                return launch.sideBindings.map { binding in
                    MontyOrderDiceSideOwnership(
                        battleID: pack.scenario.id,
                        sideID: binding.sideID,
                        selectedHumanSideID: chosenSideID,
                        controller: binding.controller,
                        enginePlayerSlot: binding.enginePlayerSlot,
                        orderDiceCount: pack.forceGroups.filter { $0.sideID == binding.sideID }.count,
                        canHumanControlDrawnDie: binding.sideID == chosenSideID,
                        launchSeed: launch.seed
                    )
                }
            }
        }
    }

    public static func forceProfiles() -> [MontyOrderDiceForceProfile] {
        MontyDemoDataPackCatalog.all.flatMap { pack in
            pack.forceGroups.map { profile(for: $0, battleID: pack.scenario.id) }
        }
    }

    public static func terrainProfiles() -> [MontyOrderDiceTerrainProfile] {
        MontyDemoDataPackCatalog.all.flatMap { pack in
            pack.scenario.map.elements.map { profile(for: $0, battleID: pack.scenario.id) }
        }
    }

    public static func pacingProfiles() -> [MontyOrderDicePacingProfile] {
        MontyDemoDataPackCatalog.all.map { pack in
            let dicePerTurn = pack.forceGroups.count
            let targetActivationBudget = dicePerTurn * pack.scenario.victory.targetTurnUpperBound
            let objectivePoints = Dictionary(
                grouping: pack.scenario.objectives,
                by: { $0.sideID ?? "uncontrolled" }
            ).mapValues { objectives in
                objectives.map(\.victoryPoints).reduce(0, +)
            }

            return MontyOrderDicePacingProfile(
                battleID: pack.scenario.id,
                targetScore: pack.scenario.victory.targetScore,
                targetTurnUpperBound: pack.scenario.victory.targetTurnUpperBound,
                orderDicePerTurn: dicePerTurn,
                targetActivationBudget: targetActivationBudget,
                activationSafetyCap: max(24, targetActivationBudget + dicePerTurn * 2),
                objectiveVictoryPointsBySide: objectivePoints,
                debriefRequiresActivationCount: true,
                phaseCountScoringDeprecated: true
            )
        }
    }

    public static func report() throws -> MontyOrderDiceCycle40Report {
        MontyOrderDiceCycle40Report(
            cycleStart: cycleRange.lowerBound,
            cycleEnd: cycleRange.upperBound,
            cyclesRemaining: 160,
            documentationPath: documentationPath,
            sideOwnershipCases: try sideOwnershipCases(),
            forceProfiles: forceProfiles(),
            terrainProfiles: terrainProfiles(),
            pacingProfiles: pacingProfiles()
        )
    }

    public static var isReadyThroughOrderDiceCycle40: Bool {
        (try? report().isReadyThroughCycle40) == true
    }
}

private extension MontyOrderDiceCycle40Catalog {
    static func profile(
        for forceGroup: MontyBattleForceGroup,
        battleID: MontyBattleID
    ) -> MontyOrderDiceForceProfile {
        let text = "\(forceGroup.name) \(forceGroup.role) \(forceGroup.note)".lowercased()
        let vehicleClass: MontyOrderDiceVehicleClass
        if text.contains("anti-tank") || text.contains("gun") {
            vehicleClass = .artillery
        } else if text.contains("armour") || text.contains("armor") || text.contains("panzer") || text.contains("tank") {
            vehicleClass = .tank
        } else if text.contains("support column") || text.contains("reserve") {
            vehicleClass = .transport
        } else {
            vehicleClass = .none
        }

        let quality: MontyOrderDiceMoraleQuality
        if text.contains("ss") || text.contains("command") || text.contains("anti-tank") || text.contains("armour") || text.contains("panzer") {
            quality = .veteran
        } else {
            quality = .regular
        }

        let officerModifier: Int
        if text.contains("command") {
            officerModifier = 2
        } else if quality == .veteran || text.contains("engineer") {
            officerModifier = 1
        } else {
            officerModifier = 0
        }

        var weapons: Set<MontyOrderDiceWeaponClass> = [.smallArms]
        if text.contains("engineer") || text.contains("minefield") {
            weapons.insert(.engineers)
            weapons.insert(.supportWeapon)
        }
        if text.contains("anti-tank") || text.contains("gun") {
            weapons.insert(.antiTank)
            weapons.insert(.supportWeapon)
        }
        if text.contains("artillery") || text.contains("air") {
            weapons.insert(.artillery)
        }
        if vehicleClass == .tank {
            weapons.insert(.armourWeapon)
            weapons.insert(.antiTank)
        }
        if text.contains("assault") || text.contains("counterattack") || text.contains("spearhead") {
            weapons.insert(.closeAssault)
        }

        let pinBehavior: MontyOrderDicePinBehavior
        if text.contains("counterattack") || text.contains("probe") || text.contains("breakthrough") {
            pinBehavior = .counterattackRisk
        } else if text.contains("engineer") || text.contains("minefield clearance") {
            pinBehavior = .rallyPriority
        } else if text.contains("defence") || text.contains("screen") || text.contains("boxes") || text.contains("ridge") {
            pinBehavior = .stubborn
        } else {
            pinBehavior = .standard
        }

        return MontyOrderDiceForceProfile(
            battleID: battleID,
            forceGroupID: forceGroup.id,
            sideID: forceGroup.sideID,
            quality: quality,
            officerModifier: officerModifier,
            weaponClasses: weapons.sorted { $0.rawValue < $1.rawValue },
            vehicleClass: vehicleClass,
            pinBehavior: pinBehavior,
            recommendedOrders: recommendedOrders(
                text: text,
                vehicleClass: vehicleClass,
                pinBehavior: pinBehavior
            )
        )
    }

    static func recommendedOrders(
        text: String,
        vehicleClass: MontyOrderDiceVehicleClass,
        pinBehavior: MontyOrderDicePinBehavior
    ) -> [HistoricalBoardOrder] {
        var orders: [HistoricalBoardOrder] = [.advance]
        if text.contains("defence") || text.contains("screen") || text.contains("ridge") || text.contains("boxes") {
            orders.append(.fire)
            orders.append(.ambush)
            orders.append(.down)
        }
        if text.contains("counterattack") || text.contains("probe") || text.contains("breakthrough") || vehicleClass == .tank {
            orders.append(.run)
            orders.append(.fire)
        }
        if pinBehavior == .rallyPriority {
            orders.append(.rally)
        }

        var uniqueOrders: [HistoricalBoardOrder] = []
        for order in orders where !uniqueOrders.contains(order) {
            uniqueOrders.append(order)
        }
        return uniqueOrders
    }

    static func profile(
        for element: HistoricalMapElement,
        battleID: MontyBattleID
    ) -> MontyOrderDiceTerrainProfile {
        let classes: [MontyOrderDiceTerrainClass]
        let allowsRoadBonus: Bool
        let blocksRun: Bool
        let blocksLineOfSight: Bool
        let coverClass: MontyOrderDiceTerrainClass?

        switch element.kind {
        case .road:
            classes = [.road, .open]
            allowsRoadBonus = true
            blocksRun = false
            blocksLineOfSight = false
            coverClass = nil
        case .bridge:
            classes = [.road, .obstacle]
            allowsRoadBonus = true
            blocksRun = false
            blocksLineOfSight = false
            coverClass = nil
        case .river:
            classes = [.obstacle, .impassable]
            allowsRoadBonus = false
            blocksRun = true
            blocksLineOfSight = false
            coverClass = nil
        case .ridge:
            classes = [.rough, .hardCover]
            allowsRoadBonus = false
            blocksRun = false
            blocksLineOfSight = true
            coverClass = .hardCover
        case .town:
            classes = [.building, .hardCover]
            allowsRoadBonus = false
            blocksRun = false
            blocksLineOfSight = true
            coverClass = .hardCover
        case .forest:
            classes = [.rough, .softCover]
            allowsRoadBonus = false
            blocksRun = true
            blocksLineOfSight = true
            coverClass = .softCover
        case .minefield:
            classes = [.obstacle, .minefield]
            allowsRoadBonus = false
            blocksRun = true
            blocksLineOfSight = false
            coverClass = nil
        case .objective, .phaseLine, .deployment, .other:
            classes = [.open]
            allowsRoadBonus = false
            blocksRun = false
            blocksLineOfSight = false
            coverClass = nil
        }

        return MontyOrderDiceTerrainProfile(
            battleID: battleID,
            elementID: element.id,
            elementKind: element.kind,
            classes: classes,
            allowsRoadBonus: allowsRoadBonus,
            blocksRun: blocksRun,
            blocksLineOfSight: blocksLineOfSight,
            coverClass: coverClass
        )
    }
}
