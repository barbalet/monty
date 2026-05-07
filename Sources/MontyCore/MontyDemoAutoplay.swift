public struct MontyDemoAutoplayResult: Codable, Hashable, Sendable {
    public let flow: MontyLaunchFlow
    public let report: HistoricalAutoplayReport<MontyBattleID>
    public let completionRecord: MontyBattleCompletionRecord
    public let progress: MontyCampaignProgress

    public init(
        flow: MontyLaunchFlow,
        report: HistoricalAutoplayReport<MontyBattleID>,
        completionRecord: MontyBattleCompletionRecord,
        progress: MontyCampaignProgress
    ) {
        self.flow = flow
        self.report = report
        self.completionRecord = completionRecord
        self.progress = progress
    }
}

public enum MontyDemoAutoplayRunner {
    public static func runBattle(
        battleID: MontyBattleID,
        chosenSideID: String,
        seed: UInt32? = nil
    ) throws -> MontyDemoAutoplayResult {
        let flow = try MontyLaunchFlowResolver.makeLaunchFlow(
            battleID: battleID,
            chosenSideID: chosenSideID,
            seed: seed
        )
        let session = MontyDemoBoardSession(flow: flow)
        let controller = try HistoricalAutoplayRunController(
            session: session,
            configuration: flow.autoplayConfiguration
        )
        let report = try controller.runToDebrief()
        var progress = MontyCampaignProgress()
        progress.recordSelectedSide(chosenSideID, for: battleID)
        let completionRecord = MontyLaunchFlowResolver.complete(
            flow,
            progress: &progress,
            winningSideID: report.debriefRecord.winningSideID,
            score: report.finalSnapshot.mission.humanScore,
            completedTurn: report.debriefRecord.completedTurn
        )

        return MontyDemoAutoplayResult(
            flow: flow,
            report: report,
            completionRecord: completionRecord,
            progress: progress
        )
    }

    public static func runAllDemoBattlesForBothSides() throws -> [MontyDemoAutoplayResult] {
        var results: [MontyDemoAutoplayResult] = []
        for dataPack in MontyDemoDataPackCatalog.all {
            for side in dataPack.scenario.sideOptions {
                results.append(
                    try runBattle(
                        battleID: dataPack.scenario.id,
                        chosenSideID: side.id
                    )
                )
            }
        }
        return results
    }
}

public final class MontyTestFirstBattleRunController {
    public let battleID: MontyBattleID
    public let chosenSideID: String
    public let flow: MontyLaunchFlow
    public let session: MontyDemoBoardSession
    public let controller: HistoricalAutoplayRunController<MontyDemoBoardSession>
    public private(set) var progress: MontyCampaignProgress
    public private(set) var completionRecord: MontyBattleCompletionRecord?

    public init(
        battleID: MontyBattleID = .alamElHalfa,
        chosenSideID: String = MontySideID.montgomery,
        seed: UInt32? = nil
    ) throws {
        self.battleID = battleID
        self.chosenSideID = chosenSideID
        flow = try MontyLaunchFlowResolver.makeLaunchFlow(
            battleID: battleID,
            chosenSideID: chosenSideID,
            seed: seed
        )
        session = MontyDemoBoardSession(flow: flow)
        controller = try HistoricalAutoplayRunController(
            session: session,
            configuration: flow.autoplayConfiguration
        )
        progress = MontyCampaignProgress()
        progress.recordSelectedSide(chosenSideID, for: battleID)
    }

    public var openingSnapshot: HistoricalBoardSnapshot<MontyBattleID> {
        controller.openingSnapshot
    }

    public var latestSnapshot: HistoricalBoardSnapshot<MontyBattleID> {
        controller.latestSnapshot
    }

    public var runState: HistoricalAutoplayRunState {
        controller.runState
    }

    public var steps: [HistoricalAutoplayStep<MontyBattleID>] {
        controller.steps
    }

    public var phaseAdvances: Int {
        controller.phaseAdvances
    }

    public var lastReport: HistoricalAutoplayReport<MontyBattleID>? {
        controller.lastReport
    }

    public func pause() {
        controller.pause()
    }

    @discardableResult
    public func stepOnce() throws -> HistoricalAutoplayStep<MontyBattleID>? {
        let step = try controller.stepOnce()
        if let report = controller.lastReport {
            _ = finalize(report: report)
        }
        return step
    }

    @discardableResult
    public func runUntilPauseOrDebrief(maxSteps: Int = Int.max) throws -> MontyDemoAutoplayResult? {
        guard let report = try controller.runUntilPauseOrDebrief(maxSteps: maxSteps) else {
            return nil
        }
        return finalize(report: report)
    }

    @discardableResult
    public func runToDebrief() throws -> MontyDemoAutoplayResult {
        let report = try controller.runToDebrief()
        return finalize(report: report)
    }

    private func finalize(report: HistoricalAutoplayReport<MontyBattleID>) -> MontyDemoAutoplayResult {
        if completionRecord == nil {
            completionRecord = MontyLaunchFlowResolver.complete(
                flow,
                progress: &progress,
                winningSideID: report.debriefRecord.winningSideID,
                score: report.finalSnapshot.mission.humanScore,
                completedTurn: report.debriefRecord.completedTurn
            )
        }

        return MontyDemoAutoplayResult(
            flow: flow,
            report: report,
            completionRecord: completionRecord ?? flow.debriefPreview(),
            progress: progress
        )
    }
}

public struct MontyDemoAcceptanceReport: Codable, Hashable, Sendable {
    public let cycleStart: Int
    public let cycleEnd: Int
    public let demoBattleIDs: [MontyBattleID]
    public let testedSideIDs: [String]
    public let runCount: Int
    public let completedRunCount: Int
    public let bothSidesActedRunCount: Int
    public let montyTestBattleID: MontyBattleID
    public let montyTestCompleted: Bool
    public let requiredAccessibilityIdentifiers: [String]

    public init(
        cycleStart: Int,
        cycleEnd: Int,
        demoBattleIDs: [MontyBattleID],
        testedSideIDs: [String],
        runCount: Int,
        completedRunCount: Int,
        bothSidesActedRunCount: Int,
        montyTestBattleID: MontyBattleID,
        montyTestCompleted: Bool,
        requiredAccessibilityIdentifiers: [String]
    ) {
        self.cycleStart = cycleStart
        self.cycleEnd = cycleEnd
        self.demoBattleIDs = demoBattleIDs
        self.testedSideIDs = testedSideIDs
        self.runCount = runCount
        self.completedRunCount = completedRunCount
        self.bothSidesActedRunCount = bothSidesActedRunCount
        self.montyTestBattleID = montyTestBattleID
        self.montyTestCompleted = montyTestCompleted
        self.requiredAccessibilityIdentifiers = requiredAccessibilityIdentifiers
    }

    public var isReady: Bool {
        cycleStart == 101 &&
            cycleEnd == 120 &&
            demoBattleIDs == MontyBattleCatalog.demoBattleIDs &&
            runCount == demoBattleIDs.count * 2 &&
            completedRunCount == runCount &&
            bothSidesActedRunCount == runCount &&
            montyTestBattleID == .alamElHalfa &&
            montyTestCompleted &&
            requiredAccessibilityIdentifiers.contains("monty-test-first-battle-autoplay") &&
            requiredAccessibilityIdentifiers.contains("monty-test-restart-button") &&
            requiredAccessibilityIdentifiers.contains("monty-test-result-summary")
    }
}

public enum MontyDemoAcceptanceCatalog {
    public static func report() throws -> MontyDemoAcceptanceReport {
        let results = try MontyDemoAutoplayRunner.runAllDemoBattlesForBothSides()
        let montyTestController = try MontyTestFirstBattleRunController()
        let montyTestResult = try montyTestController.runToDebrief()
        let sideIDs = Array(Set(results.map(\.flow.chosenSideID))).sorted()

        return MontyDemoAcceptanceReport(
            cycleStart: 101,
            cycleEnd: 120,
            demoBattleIDs: MontyBattleCatalog.demoBattleIDs,
            testedSideIDs: sideIDs,
            runCount: results.count,
            completedRunCount: results.filter(\.report.completedToDebrief).count,
            bothSidesActedRunCount: results.filter(\.report.bothSidesActed).count,
            montyTestBattleID: montyTestResult.flow.scenario.id,
            montyTestCompleted: montyTestResult.report.completedToDebrief,
            requiredAccessibilityIdentifiers: MontyAlamElHalfaDataPack
                .autoplayConfiguration
                .contract
                .requiredAccessibilityIdentifiers
        )
    }
}
