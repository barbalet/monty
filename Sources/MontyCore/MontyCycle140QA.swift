import Foundation

public enum MontyAccessibilityID {
    public static let campaignList = "monty-campaign-list"
    public static let battleScreen = "battle-screen"
    public static let battleBoard = "battle-board"
    public static let battleSidebar = "battle-sidebar"
    public static let battleSideSelector = "battle-side-selector"
    public static let battleActionFeedback = "battle-action-feedback"
    public static let battleForces = "battle-forces"
    public static let battleObjectives = "battle-objectives"
    public static let battleTerrainSummary = "battle-terrain-summary"
    public static let battleLog = "battle-log"
    public static let battleNextPhaseButton = "battle-next-phase-button"
    public static let battleAITurnButton = "battle-ai-turn-button"
    public static let battleDebriefPanel = "battle-debrief-panel"
    public static let battlePersistedResult = "battle-persisted-result"
    public static let battleSelectReadyUnitButton = "battle-select-ready-unit-button"
    public static let battleNearestEnemyButton = "battle-nearest-enemy-button"
    public static let battleMoveButton = "battle-move-button"
    public static let battleShootButton = "battle-shoot-button"
    public static let battleAssaultButton = "battle-assault-button"
    public static let battleOrderFireButton = "battle-order-fire-button"
    public static let battleOrderAdvanceButton = "battle-order-advance-button"
    public static let battleOrderRunButton = "battle-order-run-button"
    public static let battleOrderAmbushButton = "battle-order-ambush-button"
    public static let battleOrderRallyButton = "battle-order-rally-button"
    public static let battleOrderDownButton = "battle-order-down-button"
    public static let battleResolvePendingButton = "battle-resolve-pending-button"
    public static let battleRestartButton = "battle-restart-button"
    public static let battleRunToDebriefButton = "battle-run-to-debrief-button"

    public static let montyTestFirstBattleAutoplay = "monty-test-first-battle-autoplay"
    public static let montyTestPrimaryBattleSurface = "monty-test-primary-battle-surface"
    public static let montyTestRunToDebriefButton = "monty-test-run-to-debrief-button"
    public static let montyTestStepButton = "monty-test-step-button"
    public static let montyTestPauseButton = "monty-test-pause-button"
    public static let montyTestRestartButton = "monty-test-restart-button"
    public static let montyTestSpeedPicker = "monty-test-speed-picker"
    public static let montyTestSafetyCap = "monty-test-safety-cap"
    public static let montyTestEventLog = "monty-test-event-log"
    public static let montyTestResultPanel = "monty-test-result-panel"
    public static let montyTestResultSummary = "monty-test-result-summary"

    public static func campaignRow(_ id: MontyBattleID) -> String {
        "monty-campaign-row-\(id.rawValue)"
    }

    public static func battleDetail(_ id: MontyBattleID) -> String {
        "monty-battle-detail-\(id.rawValue)"
    }

    public static func side(_ id: String) -> String {
        "monty-side-\(id)"
    }

    public static func sharedBattleSurface(_ id: MontyBattleID) -> String {
        "monty-shared-battle-surface-\(id.rawValue)"
    }

    public static func sharedBattlePending(_ id: MontyBattleID) -> String {
        "monty-shared-battle-pending-\(id.rawValue)"
    }

    public static func launchUnavailable(_ id: MontyBattleID) -> String {
        "monty-launch-unavailable-\(id.rawValue)"
    }

    public static func launchError(_ id: MontyBattleID) -> String {
        "monty-launch-error-\(id.rawValue)"
    }

    public static func debriefPanel(_ id: MontyBattleID) -> String {
        "monty-debrief-panel-\(id.rawValue)"
    }

    public static func persistedResult(_ id: MontyBattleID) -> String {
        "monty-persisted-result-\(id.rawValue)"
    }

    public static func mapPreview(_ id: MontyBattleID) -> String {
        "monty-map-preview-\(id.rawValue)"
    }

    public static func mapElement(_ id: String) -> String {
        "monty-map-element-\(id)"
    }

    public static func battleUnitToken(_ id: Int) -> String {
        "battle-unit-token-\(id)"
    }

    public static func battleObjectiveToken(_ id: Int) -> String {
        "battle-objective-token-\(id)"
    }

    public static func battleZone(_ id: Int) -> String {
        "battle-zone-\(id)"
    }
}

public enum MontyAccessibilityCatalog {
    public static let sharedPlayableSurfaceIdentifiers = [
        MontyAccessibilityID.battleScreen,
        MontyAccessibilityID.battleBoard,
        MontyAccessibilityID.battleSidebar,
        MontyAccessibilityID.battleSideSelector,
        MontyAccessibilityID.battleActionFeedback,
        MontyAccessibilityID.battleForces,
        MontyAccessibilityID.battleObjectives,
        MontyAccessibilityID.battleTerrainSummary,
        MontyAccessibilityID.battleLog,
        MontyAccessibilityID.battleNextPhaseButton,
        MontyAccessibilityID.battleAITurnButton,
        MontyAccessibilityID.battleDebriefPanel,
        MontyAccessibilityID.battlePersistedResult,
        MontyAccessibilityID.battleSelectReadyUnitButton,
        MontyAccessibilityID.battleNearestEnemyButton,
        MontyAccessibilityID.battleMoveButton,
        MontyAccessibilityID.battleShootButton,
        MontyAccessibilityID.battleAssaultButton,
        MontyAccessibilityID.battleOrderFireButton,
        MontyAccessibilityID.battleOrderAdvanceButton,
        MontyAccessibilityID.battleOrderRunButton,
        MontyAccessibilityID.battleOrderAmbushButton,
        MontyAccessibilityID.battleOrderRallyButton,
        MontyAccessibilityID.battleOrderDownButton,
        MontyAccessibilityID.battleResolvePendingButton,
        MontyAccessibilityID.battleRestartButton,
        MontyAccessibilityID.battleRunToDebriefButton,
    ]

    public static let montyTestIdentifiers = [
        MontyAccessibilityID.montyTestFirstBattleAutoplay,
        MontyAccessibilityID.montyTestPrimaryBattleSurface,
        MontyAccessibilityID.montyTestRunToDebriefButton,
        MontyAccessibilityID.montyTestStepButton,
        MontyAccessibilityID.montyTestPauseButton,
        MontyAccessibilityID.montyTestRestartButton,
        MontyAccessibilityID.montyTestSpeedPicker,
        MontyAccessibilityID.montyTestSafetyCap,
        MontyAccessibilityID.montyTestEventLog,
        MontyAccessibilityID.montyTestResultPanel,
        MontyAccessibilityID.montyTestResultSummary,
    ]

    public static func launchFlowIdentifiers(
        battleID: MontyBattleID,
        chosenSideID: String
    ) -> [String] {
        [
            MontyAccessibilityID.campaignRow(battleID),
            MontyAccessibilityID.battleDetail(battleID),
            MontyAccessibilityID.side(chosenSideID),
            MontyAccessibilityID.sharedBattleSurface(battleID),
            MontyAccessibilityID.debriefPanel(battleID),
            MontyAccessibilityID.persistedResult(battleID),
        ] + sharedPlayableSurfaceIdentifiers
    }

    public static var cycle132RequiredIdentifiers: [String] {
        var identifiers = [
            MontyAccessibilityID.campaignList,
            MontyAccessibilityID.battleScreen,
            MontyAccessibilityID.battleBoard,
            MontyAccessibilityID.battleSidebar,
            MontyAccessibilityID.battleSideSelector,
        ]
        identifiers.append(contentsOf: sharedPlayableSurfaceIdentifiers)
        identifiers.append(contentsOf: montyTestIdentifiers)
        return Array(Set(identifiers)).sorted()
    }
}

public enum MontyScreenshotViewport: String, CaseIterable, Codable, Hashable, Sendable {
    case desktop = "Desktop"
    case compact = "Compact"
    case testApp = "MontyTest"
}

public enum MontyScreenshotSurface: String, Codable, Hashable, Sendable {
    case campaign = "Campaign"
    case briefing = "Briefing"
    case sideSelection = "Side selection"
    case playableBoard = "Playable board"
    case debrief = "Debrief"
    case montyTest = "MontyTest"
}

public struct MontyScreenshotQATarget: Identifiable, Codable, Hashable, Sendable {
    public let id: String
    public let surface: MontyScreenshotSurface
    public let viewport: MontyScreenshotViewport
    public let battleID: MontyBattleID?
    public let width: Int
    public let height: Int
    public let requiredAccessibilityIdentifiers: [String]

    public init(
        surface: MontyScreenshotSurface,
        viewport: MontyScreenshotViewport,
        battleID: MontyBattleID?,
        width: Int,
        height: Int,
        requiredAccessibilityIdentifiers: [String]
    ) {
        self.surface = surface
        self.viewport = viewport
        self.battleID = battleID
        self.width = width
        self.height = height
        self.requiredAccessibilityIdentifiers = requiredAccessibilityIdentifiers
        id = [
            surface.rawValue.lowercased().replacingOccurrences(of: " ", with: "-"),
            viewport.rawValue.lowercased(),
            battleID?.rawValue ?? "global",
        ].joined(separator: "-")
    }

    public var hasStableViewport: Bool {
        width >= 760 && height >= 520
    }
}

public enum MontyScreenshotQACatalog {
    public static let cycleRange = 133...138

    public static var targets: [MontyScreenshotQATarget] {
        var result = [
            MontyScreenshotQATarget(
                surface: .campaign,
                viewport: .desktop,
                battleID: nil,
                width: 1280,
                height: 820,
                requiredAccessibilityIdentifiers: [
                    MontyAccessibilityID.campaignList,
                    MontyAccessibilityID.campaignRow(.alamElHalfa),
                ]
            ),
            MontyScreenshotQATarget(
                surface: .montyTest,
                viewport: .testApp,
                battleID: .alamElHalfa,
                width: 1180,
                height: 760,
                requiredAccessibilityIdentifiers: MontyAccessibilityCatalog.montyTestIdentifiers
            ),
        ]

        for battleID in MontyBattleCatalog.demoBattleIDs {
            result.append(
                MontyScreenshotQATarget(
                    surface: .briefing,
                    viewport: .desktop,
                    battleID: battleID,
                    width: 1180,
                    height: 760,
                    requiredAccessibilityIdentifiers: [
                        MontyAccessibilityID.battleDetail(battleID),
                        MontyAccessibilityID.mapPreview(battleID),
                    ]
                )
            )
            result.append(
                MontyScreenshotQATarget(
                    surface: .sideSelection,
                    viewport: .desktop,
                    battleID: battleID,
                    width: 1180,
                    height: 760,
                    requiredAccessibilityIdentifiers: [
                        MontyAccessibilityID.battleSideSelector,
                        MontyAccessibilityID.side(MontySideID.montgomery),
                        MontyAccessibilityID.side(MontySideID.opposition),
                    ]
                )
            )
            result.append(
                MontyScreenshotQATarget(
                    surface: .playableBoard,
                    viewport: .desktop,
                    battleID: battleID,
                    width: 1360,
                    height: 860,
                    requiredAccessibilityIdentifiers: [
                        MontyAccessibilityID.sharedBattleSurface(battleID),
                        MontyAccessibilityID.battleScreen,
                        MontyAccessibilityID.battleBoard,
                        MontyAccessibilityID.battleSidebar,
                    ]
                )
            )
            result.append(
                MontyScreenshotQATarget(
                    surface: .playableBoard,
                    viewport: .compact,
                    battleID: battleID,
                    width: 900,
                    height: 620,
                    requiredAccessibilityIdentifiers: [
                        MontyAccessibilityID.battleBoard,
                        MontyAccessibilityID.battleActionFeedback,
                        MontyAccessibilityID.battleNextPhaseButton,
                    ]
                )
            )
            result.append(
                MontyScreenshotQATarget(
                    surface: .debrief,
                    viewport: .desktop,
                    battleID: battleID,
                    width: 1180,
                    height: 760,
                    requiredAccessibilityIdentifiers: [
                        MontyAccessibilityID.debriefPanel(battleID),
                        MontyAccessibilityID.persistedResult(battleID),
                        MontyAccessibilityID.battleDebriefPanel,
                        MontyAccessibilityID.battlePersistedResult,
                    ]
                )
            )
        }

        return result
    }

    public static var isReady: Bool {
        let surfaces = Set(targets.map(\.surface))
        return cycleRange == 133...138 &&
            targets.allSatisfy(\.hasStableViewport) &&
            surfaces.isSuperset(of: [.campaign, .briefing, .sideSelection, .playableBoard, .debrief, .montyTest]) &&
            MontyBattleCatalog.demoBattleIDs.allSatisfy { battleID in
                targets.contains { $0.battleID == battleID && $0.surface == .playableBoard && $0.viewport == .desktop } &&
                    targets.contains { $0.battleID == battleID && $0.surface == .playableBoard && $0.viewport == .compact } &&
                    targets.contains { $0.battleID == battleID && $0.surface == .debrief }
            }
    }
}

public enum MontyUIAutomationAction: String, Codable, Hashable, Sendable {
    case openCampaignRow = "Open campaign row"
    case chooseSide = "Choose side"
    case selectFirstActiveUnit = "Select first active unit"
    case selectNearestEnemy = "Select nearest enemy"
    case moveSelectedUnit = "Move selected unit"
    case nextPhase = "Next phase"
    case shootSelectedTarget = "Shoot selected target"
    case assaultSelectedTarget = "Assault selected target"
    case resolvePendingChoice = "Resolve pending choice"
    case aiTurn = "AI turn"
    case runToDebrief = "Run to debrief"
    case assertDebriefPersistence = "Assert debrief persistence"
}

public struct MontyUIAutomationStep: Identifiable, Codable, Hashable, Sendable {
    public let id: String
    public let action: MontyUIAutomationAction
    public let accessibilityIdentifier: String

    public init(
        id: String,
        action: MontyUIAutomationAction,
        accessibilityIdentifier: String
    ) {
        self.id = id
        self.action = action
        self.accessibilityIdentifier = accessibilityIdentifier
    }
}

public struct MontyUIAutomationScript: Identifiable, Codable, Hashable, Sendable {
    public let id: String
    public let cycleRange: ClosedRange<Int>
    public let battleID: MontyBattleID
    public let chosenSideID: String
    public let steps: [MontyUIAutomationStep]

    public init(
        battleID: MontyBattleID,
        chosenSideID: String,
        steps: [MontyUIAutomationStep]
    ) {
        self.battleID = battleID
        self.chosenSideID = chosenSideID
        self.steps = steps
        cycleRange = 139...140
        id = "\(battleID.rawValue)-\(chosenSideID)-ui-automation"
    }

    public var coversHumanActionFlow: Bool {
        let actions = Set(steps.map(\.action))
        return actions.isSuperset(of: [
            .selectFirstActiveUnit,
            .selectNearestEnemy,
            .moveSelectedUnit,
            .shootSelectedTarget,
            .assaultSelectedTarget,
            .resolvePendingChoice,
            .nextPhase,
            .aiTurn,
            .runToDebrief,
            .assertDebriefPersistence,
        ])
    }
}

public enum MontyUIAutomationCatalog {
    public static let cycleRange = 139...140

    public static var scripts: [MontyUIAutomationScript] {
        MontyBattleCatalog.demoBattleIDs.flatMap { battleID in
            [MontySideID.montgomery, MontySideID.opposition].map { sideID in
                script(battleID: battleID, chosenSideID: sideID)
            }
        }
    }

    public static var isReady: Bool {
        scripts.count == MontyBattleCatalog.demoBattleIDs.count * 2 &&
            scripts.allSatisfy { $0.cycleRange == cycleRange && $0.coversHumanActionFlow }
    }

    private static func script(
        battleID: MontyBattleID,
        chosenSideID: String
    ) -> MontyUIAutomationScript {
        let pairs: [(MontyUIAutomationAction, String)] = [
            (.openCampaignRow, MontyAccessibilityID.campaignRow(battleID)),
            (.chooseSide, MontyAccessibilityID.side(chosenSideID)),
            (.selectFirstActiveUnit, MontyAccessibilityID.battleSelectReadyUnitButton),
            (.selectNearestEnemy, MontyAccessibilityID.battleNearestEnemyButton),
            (.moveSelectedUnit, MontyAccessibilityID.battleMoveButton),
            (.nextPhase, MontyAccessibilityID.battleNextPhaseButton),
            (.selectFirstActiveUnit, MontyAccessibilityID.battleSelectReadyUnitButton),
            (.selectNearestEnemy, MontyAccessibilityID.battleNearestEnemyButton),
            (.shootSelectedTarget, MontyAccessibilityID.battleShootButton),
            (.resolvePendingChoice, MontyAccessibilityID.battleResolvePendingButton),
            (.nextPhase, MontyAccessibilityID.battleNextPhaseButton),
            (.selectFirstActiveUnit, MontyAccessibilityID.battleSelectReadyUnitButton),
            (.selectNearestEnemy, MontyAccessibilityID.battleNearestEnemyButton),
            (.assaultSelectedTarget, MontyAccessibilityID.battleAssaultButton),
            (.resolvePendingChoice, MontyAccessibilityID.battleResolvePendingButton),
            (.aiTurn, MontyAccessibilityID.battleAITurnButton),
            (.runToDebrief, MontyAccessibilityID.battleRunToDebriefButton),
            (.assertDebriefPersistence, MontyAccessibilityID.battlePersistedResult),
        ]
        let steps = pairs.enumerated().map { index, pair in
            MontyUIAutomationStep(
                id: "\(battleID.rawValue)-\(chosenSideID)-step-\(index + 1)",
                action: pair.0,
                accessibilityIdentifier: pair.1
            )
        }
        return MontyUIAutomationScript(
            battleID: battleID,
            chosenSideID: chosenSideID,
            steps: steps
        )
    }
}

public enum MontyUIAutomationError: Error, CustomStringConvertible, Hashable, Sendable {
    case actionFailed(String)
    case missingDebrief(String)

    public var description: String {
        switch self {
        case .actionFailed(let message):
            return message
        case .missingDebrief(let message):
            return message
        }
    }
}

public struct MontyUIAutomationRunResult: Codable, Hashable, Sendable {
    public let script: MontyUIAutomationScript
    public let observedAccessibilityIdentifiers: [String]
    public let completedToDebrief: Bool
    public let bothSidesActed: Bool
    public let persistedResult: Bool
    public let finalResultSummary: String

    public var passed: Bool {
        completedToDebrief &&
            bothSidesActed &&
            persistedResult &&
            script.steps.allSatisfy { observedAccessibilityIdentifiers.contains($0.accessibilityIdentifier) }
    }
}

public enum MontyUIAutomationRunner {
    public static func run(_ script: MontyUIAutomationScript) throws -> MontyUIAutomationRunResult {
        let flow = try MontyLaunchFlowResolver.makeLaunchFlow(
            battleID: script.battleID,
            chosenSideID: script.chosenSideID
        )
        let session = MontyDemoBoardSession(flow: flow)
        var progress = MontyCampaignProgress()
        var observedIdentifiers: [String] = []
        var actedSideIDs: Set<String> = []
        var report: HistoricalAutoplayReport<MontyBattleID>?
        var persistedRecord: MontyBattleCompletionRecord?

        for step in script.steps {
            observedIdentifiers.append(step.accessibilityIdentifier)
            switch step.action {
            case .openCampaignRow:
                break
            case .chooseSide:
                progress.recordSelectedSide(script.chosenSideID, for: script.battleID)
            case .selectFirstActiveUnit:
                session.selectFirstActiveUnit()
            case .selectNearestEnemy:
                session.selectNearestEnemyToSelectedUnit()
            case .moveSelectedUnit:
                actedSideIDs.insert(session.snapshot().activeSideID)
                guard session.moveSelectedUnitTowardNearestObjective(maxDistance: 5) else {
                    throw MontyUIAutomationError.actionFailed("\(script.id) could not move a selected unit.")
                }
            case .nextPhase:
                session.advancePhase()
            case .shootSelectedTarget:
                actedSideIDs.insert(session.snapshot().activeSideID)
                guard session.shootSelectedTarget() else {
                    throw MontyUIAutomationError.actionFailed("\(script.id) could not shoot the selected target.")
                }
            case .assaultSelectedTarget:
                actedSideIDs.insert(session.snapshot().activeSideID)
                let snapshot = session.snapshot()
                guard let attacker = snapshot.units.first(where: { $0.selected }),
                      let target = snapshot.units.first(where: { $0.targeted }),
                      session.assaultUnit(attacker.id, targetID: target.id, advance: true) else {
                    throw MontyUIAutomationError.actionFailed("\(script.id) could not assault the selected target.")
                }
            case .resolvePendingChoice:
                guard session.resolveFirstPendingChoice() else {
                    throw MontyUIAutomationError.actionFailed("\(script.id) had no pending choice to resolve.")
                }
            case .aiTurn:
                actedSideIDs.insert(session.snapshot().activeSideID)
                runOneAutomatedPhase(on: session, flow: flow)
            case .runToDebrief:
                let controller = try HistoricalAutoplayRunController(
                    session: session,
                    configuration: continuationConfiguration(from: flow.autoplayConfiguration)
                )
                report = try controller.runToDebrief()
            case .assertDebriefPersistence:
                guard let report else {
                    throw MontyUIAutomationError.missingDebrief("\(script.id) reached persistence assertion without a debrief.")
                }
                persistedRecord = MontyLaunchFlowResolver.complete(
                    flow,
                    progress: &progress,
                    winningSideID: report.debriefRecord.winningSideID,
                    score: report.finalSnapshot.mission.humanScore,
                    completedTurn: report.debriefRecord.completedTurn
                )
            }
        }

        guard let report else {
            throw MontyUIAutomationError.missingDebrief("\(script.id) did not run to debrief.")
        }

        return MontyUIAutomationRunResult(
            script: script,
            observedAccessibilityIdentifiers: observedIdentifiers,
            completedToDebrief: report.completedToDebrief,
            bothSidesActed: actedSideIDs
                .union(report.debriefRecord.automatedSideIDs)
                .isSuperset(of: Set(flow.launch.sideBindings.map(\.sideID))),
            persistedResult: persistedRecord != nil && progress.completionRecord(for: script.battleID) == persistedRecord,
            finalResultSummary: report.finalResultSummary
        )
    }

    public static func runAll() throws -> [MontyUIAutomationRunResult] {
        try MontyUIAutomationCatalog.scripts.map(run)
    }

    private static func runOneAutomatedPhase(
        on session: MontyDemoBoardSession,
        flow: MontyLaunchFlow
    ) {
        let snapshot = session.snapshot()
        let plan = flow.autoplayConfiguration.plan(for: snapshot.activeSideID)
        let activeUnits = snapshot.units
            .filter { $0.sideID == snapshot.activeSideID && !$0.destroyed }
            .sorted { $0.id < $1.id }

        for unit in activeUnits {
            session.selectUnit(unit.id)
            session.selectNearestEnemyToSelectedUnit()
            switch snapshot.phase {
            case .movement:
                _ = session.moveSelectedUnitTowardPriorityObjective(
                    named: plan.movementPriorityNames,
                    maxDistance: plan.movementDistance
                ) || session.moveSelectedUnitTowardNearestObjective(maxDistance: plan.movementDistance)
            case .shooting:
                _ = session.shootSelectedTarget()
                _ = session.resolveFirstPendingChoice()
            case .assault:
                if let target = session.snapshot().units.first(where: { $0.targeted && !$0.destroyed }) {
                    _ = session.assaultUnit(unit.id, targetID: target.id, advance: true)
                    _ = session.resolveFirstPendingChoice()
                }
            }
        }

        session.advancePhase()
    }

    private static func continuationConfiguration(
        from configuration: HistoricalAutoplayConfiguration<MontyBattleID>
    ) -> HistoricalAutoplayConfiguration<MontyBattleID> {
        let contract = configuration.contract
        return HistoricalAutoplayConfiguration(
            battleID: configuration.battleID,
            battleTitle: configuration.battleTitle,
            seed: configuration.seed,
            contract: HistoricalAutoplayContract(
                primarySurfaceName: contract.primarySurfaceName,
                embeddedBattleSurfaceName: contract.embeddedBattleSurfaceName,
                retiredEmbeddedSurfaceNames: contract.retiredEmbeddedSurfaceNames,
                requiredAccessibilityIdentifiers: contract.requiredAccessibilityIdentifiers,
                speedModes: contract.speedModes,
                supportsDeterministicSeed: contract.supportsDeterministicSeed,
                requiresBothSidesActed: false,
                requiresRealDebriefPersistence: contract.requiresRealDebriefPersistence
            ),
            targetTurnUpperBound: configuration.targetTurnUpperBound,
            maxPhaseAdvances: configuration.maxPhaseAdvances,
            sidePlans: configuration.sidePlans,
            persistsDebriefResult: configuration.persistsDebriefResult
        )
    }
}

public struct MontyCycle140AcceptanceReport: Codable, Hashable, Sendable {
    public let cycleStart: Int
    public let cycleEnd: Int
    public let visualAuditPassed: Bool
    public let accessibilityIdentifierCount: Int
    public let screenshotTargetCount: Int
    public let automationScriptCount: Int
    public let automationPassedCount: Int
    public let blockers: [String]

    public var isReady: Bool {
        cycleStart == 121 &&
            cycleEnd == 140 &&
            visualAuditPassed &&
            accessibilityIdentifierCount >= 28 &&
            screenshotTargetCount >= 17 &&
            automationScriptCount == MontyBattleCatalog.demoBattleIDs.count * 2 &&
            automationPassedCount == automationScriptCount &&
            blockers.isEmpty
    }
}

public enum MontyCycle140AcceptanceCatalog {
    public static let cycleRange = 121...140

    public static func report() throws -> MontyCycle140AcceptanceReport {
        var blockers: [String] = []
        let automationResults = try MontyUIAutomationRunner.runAll()
        let visualAuditPassed = MontyDemoDataPackCatalog.all.allSatisfy { dataPack in
            dataPack.scenario.map.elements.count >= 6 &&
                dataPack.scenario.objectives.count >= 4 &&
                dataPack.forceGroups.count >= 4
        }

        if !visualAuditPassed {
            blockers.append("One or more demo battle data packs are missing enough map, objective, or force detail for cycle-126 visual QA.")
        }
        if !MontyScreenshotQACatalog.isReady {
            blockers.append("Cycle-138 screenshot QA targets are incomplete.")
        }
        if !MontyUIAutomationCatalog.isReady {
            blockers.append("Cycle-140 UI automation scripts are incomplete.")
        }
        if automationResults.contains(where: { !$0.passed }) {
            blockers.append("One or more cycle-140 UI automation scripts failed to reach debrief and persistence.")
        }

        return MontyCycle140AcceptanceReport(
            cycleStart: cycleRange.lowerBound,
            cycleEnd: cycleRange.upperBound,
            visualAuditPassed: visualAuditPassed,
            accessibilityIdentifierCount: MontyAccessibilityCatalog.cycle132RequiredIdentifiers.count,
            screenshotTargetCount: MontyScreenshotQACatalog.targets.count,
            automationScriptCount: automationResults.count,
            automationPassedCount: automationResults.filter(\.passed).count,
            blockers: blockers
        )
    }

    public static var acceptanceReadyThroughCycle140: Bool {
        (try? report().isReady) == true
    }
}
