public enum MontyLaunchFlowStage: String, CaseIterable, Codable, Hashable, Sendable {
    case campaignRow = "Campaign row"
    case briefing = "Briefing"
    case sideSelection = "Side selection"
    case sharedBattleSurface = "Shared battle surface"
    case debrief = "Debrief"
    case persistence = "Persistence"
}

public enum MontyLaunchFlowError: Error, Equatable, CustomStringConvertible {
    case unknownBattle(MontyBattleID)
    case missingDemoDataPack(MontyBattleID)
    case sideSelection(String)

    public var description: String {
        switch self {
        case .unknownBattle(let id):
            return "Unknown Monty battle: \(id.rawValue)."
        case .missingDemoDataPack(let id):
            return "Monty battle \(id.rawValue) does not have a demo data pack."
        case .sideSelection(let message):
            return message
        }
    }
}

public struct MontyBattleCompletionRecord: Identifiable, Codable, Hashable, Sendable {
    public var id: String {
        "\(battleID.rawValue)-\(chosenSideID)-turn-\(completedTurn)"
    }

    public let battleID: MontyBattleID
    public let chosenSideID: String
    public let winningSideID: String?
    public let score: Int
    public let completedTurn: Int
    public let victoryBandLabel: String
    public let debriefSummary: String

    public init(
        battleID: MontyBattleID,
        chosenSideID: String,
        winningSideID: String?,
        score: Int,
        completedTurn: Int,
        victoryBandLabel: String,
        debriefSummary: String
    ) {
        self.battleID = battleID
        self.chosenSideID = chosenSideID
        self.winningSideID = winningSideID
        self.score = score
        self.completedTurn = completedTurn
        self.victoryBandLabel = victoryBandLabel
        self.debriefSummary = debriefSummary
    }
}

public struct MontyCampaignProgress: Codable, Hashable, Sendable {
    public private(set) var completions: [MontyBattleID: MontyBattleCompletionRecord]
    public private(set) var lastSelectedSideByBattle: [MontyBattleID: String]

    public init(
        completions: [MontyBattleID: MontyBattleCompletionRecord] = [:],
        lastSelectedSideByBattle: [MontyBattleID: String] = [:]
    ) {
        self.completions = completions
        self.lastSelectedSideByBattle = lastSelectedSideByBattle
    }

    public var completedBattleIDs: Set<MontyBattleID> {
        Set(completions.keys)
    }

    public func completionRecord(for id: MontyBattleID) -> MontyBattleCompletionRecord? {
        completions[id]
    }

    public mutating func recordSelectedSide(_ sideID: String, for battleID: MontyBattleID) {
        lastSelectedSideByBattle[battleID] = sideID
    }

    public mutating func recordCompletion(_ record: MontyBattleCompletionRecord) {
        completions[record.battleID] = record
        recordSelectedSide(record.chosenSideID, for: record.battleID)
    }
}

public struct MontyLaunchFlow: Codable, Hashable, Sendable {
    public let scenario: MontyBattleScenario
    public let dataPack: MontyDemoBattleDataPack
    public let chosenSideID: String
    public let launch: HistoricalBattleLaunch<MontyBattleID>
    public let autoplayConfiguration: HistoricalAutoplayConfiguration<MontyBattleID>
    public let orderDiceLaunchState: MontyOrderDiceLaunchState
    public let stages: [MontyLaunchFlowStage]
    public let requiredAccessibilityIdentifiers: [String]

    public init(
        scenario: MontyBattleScenario,
        dataPack: MontyDemoBattleDataPack,
        chosenSideID: String,
        launch: HistoricalBattleLaunch<MontyBattleID>,
        autoplayConfiguration: HistoricalAutoplayConfiguration<MontyBattleID>,
        orderDiceLaunchState: MontyOrderDiceLaunchState? = nil,
        stages: [MontyLaunchFlowStage] = MontyLaunchFlowStage.allCases,
        requiredAccessibilityIdentifiers: [String]
    ) {
        self.scenario = scenario
        self.dataPack = dataPack
        self.chosenSideID = chosenSideID
        self.launch = launch
        self.autoplayConfiguration = autoplayConfiguration
        self.orderDiceLaunchState = orderDiceLaunchState ?? MontyOrderDiceLaunchStateBuilder.make(
            scenario: scenario,
            dataPack: dataPack,
            launch: launch
        )
        self.stages = stages
        self.requiredAccessibilityIdentifiers = requiredAccessibilityIdentifiers
    }

    public var selectedSide: HistoricalSideOption? {
        resolvedSideSelection.selectedSide
    }

    public var opposingSide: HistoricalSideOption? {
        resolvedSideSelection.opposingSide
    }

    public var resolvedSideSelection: HistoricalBattleSideSelection<MontyBattleID> {
        scenario.resolvedSideSelection(for: launch)
    }

    public var sharedBattleSurfaceName: String {
        HistoricalPlayableSurfaceCatalog.sharedHostSurfaceName
    }

    public var isReadyForSharedBattleSurface: Bool {
            dataPack.isDemoReady &&
            stages == MontyLaunchFlowStage.allCases &&
            launch.humanSideID == chosenSideID &&
            autoplayConfiguration.battleID == scenario.id &&
            orderDiceLaunchState.isReadyForOrderDiceLaunchFlow &&
            autoplayConfiguration.contract.embeddedBattleSurfaceName == sharedBattleSurfaceName
    }

    public func debriefPreview(
        winningSideID: String? = nil,
        score: Int? = nil,
        completedTurn: Int? = nil
    ) -> MontyBattleCompletionRecord {
        let finalScore = score ?? scenario.victory.targetScore
        let band = scenario.victory.bands.first { $0.scoreRange.contains(finalScore) } ?? scenario.victory.bands.last
        let preferredLine = dataPack.debriefLines.first { $0.sideID == (winningSideID ?? chosenSideID) } ??
            dataPack.debriefLines.first { $0.sideID == chosenSideID } ??
            dataPack.debriefLines[0]

        return MontyBattleCompletionRecord(
            battleID: scenario.id,
            chosenSideID: chosenSideID,
            winningSideID: winningSideID ?? chosenSideID,
            score: finalScore,
            completedTurn: completedTurn ?? scenario.victory.targetTurnUpperBound,
            victoryBandLabel: band?.label ?? "Debrief",
            debriefSummary: preferredLine.summary
        )
    }
}

public enum MontyLaunchFlowResolver {
    public static func makeLaunchFlow(
        battleID: MontyBattleID,
        chosenSideID: String,
        seed: UInt32? = nil
    ) throws -> MontyLaunchFlow {
        guard let scenario = MontyBattleCatalog.scenario(id: battleID) else {
            throw MontyLaunchFlowError.unknownBattle(battleID)
        }
        guard let dataPack = MontyDemoDataPackCatalog.dataPack(for: battleID) else {
            throw MontyLaunchFlowError.missingDemoDataPack(battleID)
        }

        do {
            let launch = try HistoricalBattleLaunchResolver.makeLaunch(
                scenario: scenario,
                chosenHumanSideID: chosenSideID,
                seed: seed ?? dataPack.autoplayConfiguration.seed
            )
            return MontyLaunchFlow(
                scenario: scenario,
                dataPack: dataPack,
                chosenSideID: chosenSideID,
                launch: launch,
                autoplayConfiguration: dataPack.autoplayConfiguration,
                requiredAccessibilityIdentifiers: MontyAccessibilityCatalog.launchFlowIdentifiers(
                    battleID: battleID,
                    chosenSideID: chosenSideID
                )
            )
        } catch let error as HistoricalSideSelectionError {
            throw MontyLaunchFlowError.sideSelection(error.description)
        }
    }

    public static func complete(
        _ flow: MontyLaunchFlow,
        progress: inout MontyCampaignProgress,
        winningSideID: String? = nil,
        score: Int? = nil,
        completedTurn: Int? = nil
    ) -> MontyBattleCompletionRecord {
        let record = flow.debriefPreview(
            winningSideID: winningSideID,
            score: score,
            completedTurn: completedTurn
        )
        progress.recordCompletion(record)
        return record
    }
}
