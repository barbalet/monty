import Foundation
import DerZweiteWeltkriegHistorical

public enum MontyOrderDiceMigrationDependencyArea: String, CaseIterable, Codable, Hashable, Sendable {
    case dzwOrderDiceContracts = "DZW order-dice contracts"
    case guderianSharedBattleSurface = "Guderian shared battle surface"
    case montyDemoBoardSession = "Monty demo board session"
    case montyLaunchFlow = "Monty launch flow"
    case montySideSelection = "Monty side selection"
    case montyAutoplay = "Monty autoplay"
    case montyTest = "MontyTest"
    case montyAccessibilityAutomation = "Monty accessibility and UI automation"
    case montyPersistence = "Monty persistence"
    case montyDocumentation = "Monty documentation"

    public var sourcePath: String {
        switch self {
        case .dzwOrderDiceContracts:
            return "guderian/dzw/Sources/DerZweiteWeltkriegHistorical/HistoricalBoardSession.swift"
        case .guderianSharedBattleSurface:
            return "guderian/dzw/Sources/DerZweiteWeltkriegHistorical/HistoricalPlayableBattleView.swift"
        case .montyDemoBoardSession:
            return "Sources/MontyCore/MontyDemoBoardSession.swift"
        case .montyLaunchFlow:
            return "Sources/MontyCore/MontyLaunchFlow.swift"
        case .montySideSelection:
            return "Sources/MontyApp/MontyCampaignView.swift"
        case .montyAutoplay:
            return "Sources/MontyCore/MontyDemoAutoplay.swift"
        case .montyTest:
            return "Sources/MontyTest/MontyTestApp.swift"
        case .montyAccessibilityAutomation:
            return "Sources/MontyCore/MontyCycle140QA.swift"
        case .montyPersistence:
            return "Sources/MontyCore/MontyCycle160Hardening.swift"
        case .montyDocumentation:
            return "PLAN.md"
        }
    }

    public var currentState: String {
        switch self {
        case .dzwOrderDiceContracts:
            return "HistoricalBoardOrder exposes Fire, Advance, Run, Ambush, Rally, and Down for consumers."
        case .guderianSharedBattleSurface:
            return "HistoricalPlayableBattleView can display order buttons, board tokens, forces, objectives, and action feedback."
        case .montyDemoBoardSession:
            return "MontyDemoBoardSession is still a phase-driven compatibility session for move, shoot, assault, and phase advance."
        case .montyLaunchFlow:
            return "Launch flow records battle, selected side, AI side, seed, shared surface identifiers, and persistence hooks."
        case .montySideSelection:
            return "The campaign flow lets the player choose Montgomery or the opposition before opening the board."
        case .montyAutoplay:
            return "Autoplay is still measured by phase advances through HistoricalAutoplayRunController."
        case .montyTest:
            return "MontyTest embeds the shared battle surface but still presents run-to-debrief and phase-advance progress."
        case .montyAccessibilityAutomation:
            return "Automation identifiers still include move, shoot, assault, next phase, AI phase, and run-to-debrief controls."
        case .montyPersistence:
            return "Progress stores selected side and debrief records, but not order cup, drawn die, assigned order, or activation count."
        case .montyDocumentation:
            return "The root plan contains the order-dice migration rows; older demo closeout notes still describe phase-flow playability."
        }
    }

    public var orderDiceRequirement: String {
        switch self {
        case .dzwOrderDiceContracts:
            return "Consume DZW/Guderian order values and snapshots without copying rules into Monty."
        case .guderianSharedBattleSurface:
            return "Bind visible controls to drawn die, eligible units, order picker, order-test results, and activation log."
        case .montyDemoBoardSession:
            return "Keep only as a thin adapter or replace with a native shared session that issues explicit orders."
        case .montyLaunchFlow:
            return "Add ruleset, order-dice seed, selected side ownership, and activation metadata."
        case .montySideSelection:
            return "Use selected side to determine which drawn dice can be human-controlled."
        case .montyAutoplay:
            return "Make one autoplay step equal one order-dice activation, including order test and action resolution."
        case .montyTest:
            return "Show order cup, drawn side, current activation, order choices, activation log, and debrief outcome."
        case .montyAccessibilityAutomation:
            return "Replace phase-control assumptions with Fire, Advance, Run, Ambush, Rally, Down, order test, and activation controls."
        case .montyPersistence:
            return "Version progress for order-dice battle records without corrupting existing selected-side completions."
        case .montyDocumentation:
            return "Describe phase-flow controls as legacy compatibility until the Monty order-dice default path is complete."
        }
    }

    public var containsLegacyPhaseAssumption: Bool {
        switch self {
        case .dzwOrderDiceContracts, .guderianSharedBattleSurface, .montyLaunchFlow, .montySideSelection:
            return false
        case .montyDemoBoardSession, .montyAutoplay, .montyTest, .montyAccessibilityAutomation, .montyPersistence, .montyDocumentation:
            return true
        }
    }
}

public struct MontyOrderDiceDependencyAuditItem: Codable, Hashable, Sendable {
    public let area: MontyOrderDiceMigrationDependencyArea
    public let sourcePath: String
    public let currentState: String
    public let orderDiceRequirement: String
    public let containsLegacyPhaseAssumption: Bool

    public init(area: MontyOrderDiceMigrationDependencyArea) {
        self.area = area
        sourcePath = area.sourcePath
        currentState = area.currentState
        orderDiceRequirement = area.orderDiceRequirement
        containsLegacyPhaseAssumption = area.containsLegacyPhaseAssumption
    }
}

public enum MontyOrderDiceContractGap: String, CaseIterable, Codable, Hashable, Sendable {
    case phaseDrivenBoardSession = "Phase-driven board session"
    case missingOrderCupState = "Missing order cup state"
    case orderAssignmentNotImplemented = "Order assignment not implemented"
    case phaseGatedMovement = "Phase-gated movement"
    case phaseGatedShooting = "Phase-gated shooting"
    case phaseGatedAssault = "Phase-gated assault"
    case phaseAdvanceAutoplay = "Phase-advance autoplay"
    case phaseNamedAccessibility = "Phase-named accessibility"
    case persistenceMissingActivationState = "Persistence missing activation state"
    case runToDebriefShortcut = "Run-to-debrief shortcut"

    public var currentMontyContract: String {
        switch self {
        case .phaseDrivenBoardSession:
            return "HistoricalBoardSnapshot.phase and advancePhase() are still the Monty battle clock."
        case .missingOrderCupState:
            return "Snapshots do not expose cup contents, current die owner, spent dice, or retained dice."
        case .orderAssignmentNotImplemented:
            return "MontyDemoBoardSession inherits the default issueOrder implementation, which returns false."
        case .phaseGatedMovement:
            return "moveUnit succeeds only during the Movement phase."
        case .phaseGatedShooting:
            return "shootUnit succeeds only during the Shooting phase."
        case .phaseGatedAssault:
            return "assaultUnit succeeds only during the Assault phase."
        case .phaseAdvanceAutoplay:
            return "Autoplay reports phaseAdvances and advances side-wide phases."
        case .phaseNamedAccessibility:
            return "Required identifiers still include battle-next-phase-button and phase-flow automation steps."
        case .persistenceMissingActivationState:
            return "Completion records do not store order dice, selected order, retained orders, or activation count."
        case .runToDebriefShortcut:
            return "The app and MontyTest still expose run-to-debrief helpers for fast demo completion."
        }
    }

    public var requiredOrderDiceContract: String {
        switch self {
        case .phaseDrivenBoardSession:
            return "A drawn die chooses a side, then one eligible unit receives an explicit order."
        case .missingOrderCupState:
            return "Snapshots expose order cup, current die, spent dice, retained dice, and turn-end cleanup state."
        case .orderAssignmentNotImplemented:
            return "Monty callers issue Fire, Advance, Run, Ambush, Rally, or Down through the shared session."
        case .phaseGatedMovement:
            return "Advance and Run orders own movement legality, distance, and terrain rejection reasons."
        case .phaseGatedShooting:
            return "Fire and Advance orders own normal shooting and target reaction timing."
        case .phaseGatedAssault:
            return "Run owns assault movement, target reaction, close-quarters resolution, and regroup."
        case .phaseAdvanceAutoplay:
            return "One autoplay step resolves one activation, including order tests, action execution, and retained orders."
        case .phaseNamedAccessibility:
            return "Identifiers cover order cup, drawn die, order picker, order test, pin count, and activation log."
        case .persistenceMissingActivationState:
            return "Progress and save records carry selected side plus order-dice turn and activation details."
        case .runToDebriefShortcut:
            return "Run-to-debrief remains a test helper; the default path stays activation-by-activation."
        }
    }

    public var blocksDefaultOrderDiceReadiness: Bool {
        true
    }
}

public struct MontyOrderDiceContractComparison: Codable, Hashable, Sendable {
    public let gap: MontyOrderDiceContractGap
    public let currentMontyContract: String
    public let requiredOrderDiceContract: String
    public let blocksDefaultOrderDiceReadiness: Bool

    public init(gap: MontyOrderDiceContractGap) {
        self.gap = gap
        currentMontyContract = gap.currentMontyContract
        requiredOrderDiceContract = gap.requiredOrderDiceContract
        blocksDefaultOrderDiceReadiness = gap.blocksDefaultOrderDiceReadiness
    }
}

public enum MontyOrderDiceCompatibilityGate: String, CaseIterable, Codable, Hashable, Sendable {
    case dzwOrdersAvailable = "DZW orders available"
    case sharedSurfaceAvailable = "Shared surface available"
    case defaultSessionAuditedAsPhaseDriven = "Default session audited as phase-driven"
    case issueOrderAuditedAsNoOp = "Order assignment audited as no-op"
    case automationAuditedAsPhaseDriven = "Automation audited as phase-driven"
    case shimDecisionRecorded = "Shim decision recorded"
}

public struct MontyOrderDiceCompatibilityGateResult: Codable, Hashable, Sendable {
    public let gate: MontyOrderDiceCompatibilityGate
    public let passed: Bool
    public let detail: String
    public let blocksDefaultOrderDiceReadiness: Bool

    public init(
        gate: MontyOrderDiceCompatibilityGate,
        passed: Bool,
        detail: String,
        blocksDefaultOrderDiceReadiness: Bool
    ) {
        self.gate = gate
        self.passed = passed
        self.detail = detail
        self.blocksDefaultOrderDiceReadiness = blocksDefaultOrderDiceReadiness
    }
}

public enum MontyOrderDiceShimComponent: String, CaseIterable, Codable, Hashable, Sendable {
    case montyDemoBoardSession = "MontyDemoBoardSession"
    case historicalPlayableBattleView = "HistoricalPlayableBattleView"
    case historicalAutoplayRunController = "HistoricalAutoplayRunController"
    case montyLaunchFlow = "MontyLaunchFlow"
    case montyUIAutomationRunner = "MontyUIAutomationRunner"
    case montyRunToDebriefControls = "Monty run-to-debrief controls"
}

public enum MontyOrderDiceShimDisposition: String, Codable, Hashable, Sendable {
    case keepAsThinCompatibilityAdapter = "Keep as thin compatibility adapter"
    case consumeSharedDZWContract = "Consume shared DZW/Guderian contract"
    case extendWithOrderDiceMetadata = "Extend with order-dice metadata"
    case quarantineAsLegacyHelper = "Quarantine as legacy helper"
    case replaceDuringOrderDiceUIConversion = "Replace during order-dice UI conversion"
}

public struct MontyOrderDiceShimDecision: Codable, Hashable, Sendable {
    public let component: MontyOrderDiceShimComponent
    public let disposition: MontyOrderDiceShimDisposition
    public let rulesAuthorityRemainsDownstream: Bool
    public let notes: String

    public init(
        component: MontyOrderDiceShimComponent,
        disposition: MontyOrderDiceShimDisposition,
        rulesAuthorityRemainsDownstream: Bool,
        notes: String
    ) {
        self.component = component
        self.disposition = disposition
        self.rulesAuthorityRemainsDownstream = rulesAuthorityRemainsDownstream
        self.notes = notes
    }
}

public struct MontyOrderDiceCycle20Report: Codable, Hashable, Sendable {
    public let cycleStart: Int
    public let cycleEnd: Int
    public let cyclesRemaining: Int
    public let rulesReferenceURL: String
    public let documentationPath: String
    public let auditedDependencies: [MontyOrderDiceDependencyAuditItem]
    public let contractComparisons: [MontyOrderDiceContractComparison]
    public let compatibilityGates: [MontyOrderDiceCompatibilityGateResult]
    public let shimDecisions: [MontyOrderDiceShimDecision]
    public let defaultReadinessBlockers: [String]

    public var isDefaultOrderDiceReady: Bool {
        defaultReadinessBlockers.isEmpty
    }

    public var isReadyThroughCycle20: Bool {
        cycleStart == 1 &&
            cycleEnd == 20 &&
            cyclesRemaining == 180 &&
            !isDefaultOrderDiceReady &&
            rulesReferenceURL.contains("bolt_action_reference.pdf") &&
            documentationPath == MontyOrderDiceCycle20Catalog.documentationPath &&
            Set(auditedDependencies.map(\.area)) == Set(MontyOrderDiceMigrationDependencyArea.allCases) &&
            Set(contractComparisons.map(\.gap)) == Set(MontyOrderDiceContractGap.allCases) &&
            compatibilityGates.allSatisfy(\.passed) &&
            compatibilityGates.contains { $0.blocksDefaultOrderDiceReadiness } &&
            shimDecisions.contains {
                $0.component == .montyDemoBoardSession &&
                    $0.disposition == .keepAsThinCompatibilityAdapter &&
                    !$0.rulesAuthorityRemainsDownstream
            } &&
            shimDecisions.allSatisfy { !$0.rulesAuthorityRemainsDownstream }
    }
}

public enum MontyOrderDiceCycle20Catalog {
    public static let cycleRange = 1...20
    public static let rulesReferenceURL = "https://warlordgames.com/downloads/pdf/bolt_action_reference.pdf"
    public static let documentationPath = "docs/monty_order_dice_cycle_001_020.md"

    public static var dependencyAudit: [MontyOrderDiceDependencyAuditItem] {
        MontyOrderDiceMigrationDependencyArea.allCases.map(MontyOrderDiceDependencyAuditItem.init(area:))
    }

    public static var contractComparisons: [MontyOrderDiceContractComparison] {
        MontyOrderDiceContractGap.allCases.map(MontyOrderDiceContractComparison.init(gap:))
    }

    public static var shimDecisions: [MontyOrderDiceShimDecision] {
        [
            MontyOrderDiceShimDecision(
                component: .montyDemoBoardSession,
                disposition: .keepAsThinCompatibilityAdapter,
                rulesAuthorityRemainsDownstream: false,
                notes: "Keep only as the current demo adapter until cycles 21-75 replace phase gates with shared order assignment."
            ),
            MontyOrderDiceShimDecision(
                component: .historicalPlayableBattleView,
                disposition: .consumeSharedDZWContract,
                rulesAuthorityRemainsDownstream: false,
                notes: "Use the shared DZW/Guderian surface for order controls instead of creating a Monty-only rules view."
            ),
            MontyOrderDiceShimDecision(
                component: .historicalAutoplayRunController,
                disposition: .replaceDuringOrderDiceUIConversion,
                rulesAuthorityRemainsDownstream: false,
                notes: "Replace phase-advance stepping with activation stepping once Monty has order-dice session state."
            ),
            MontyOrderDiceShimDecision(
                component: .montyLaunchFlow,
                disposition: .extendWithOrderDiceMetadata,
                rulesAuthorityRemainsDownstream: false,
                notes: "Add ruleset, selected-side die ownership, order seed, and activation metadata in cycles 21-45."
            ),
            MontyOrderDiceShimDecision(
                component: .montyUIAutomationRunner,
                disposition: .replaceDuringOrderDiceUIConversion,
                rulesAuthorityRemainsDownstream: false,
                notes: "Re-script automation around order choice, order test, action execution, AI activation, and debrief."
            ),
            MontyOrderDiceShimDecision(
                component: .montyRunToDebriefControls,
                disposition: .quarantineAsLegacyHelper,
                rulesAuthorityRemainsDownstream: false,
                notes: "Keep fast completion only for test harnesses; it cannot be the proof of default order-dice playability."
            ),
        ]
    }

    public static func compatibilityGates() -> [MontyOrderDiceCompatibilityGateResult] {
        let orderSet = Set(HistoricalBoardOrder.allCases)
        let expectedOrders: Set<HistoricalBoardOrder> = [.fire, .advance, .run, .ambush, .rally, .down]

        return [
            MontyOrderDiceCompatibilityGateResult(
                gate: .dzwOrdersAvailable,
                passed: orderSet == expectedOrders,
                detail: "DZW/Guderian historical contracts expose the six order values Monty must consume.",
                blocksDefaultOrderDiceReadiness: false
            ),
            MontyOrderDiceCompatibilityGateResult(
                gate: .sharedSurfaceAvailable,
                passed: HistoricalPlayableSurfaceCatalog.hasPublicSwiftUIBattleSurface,
                detail: "The shared HistoricalPlayableBattleView is available as the UI target.",
                blocksDefaultOrderDiceReadiness: false
            ),
            MontyOrderDiceCompatibilityGateResult(
                gate: .defaultSessionAuditedAsPhaseDriven,
                passed: true,
                detail: "MontyDemoBoardSession still uses HistoricalBoardPhase and advancePhase as its battle clock.",
                blocksDefaultOrderDiceReadiness: true
            ),
            MontyOrderDiceCompatibilityGateResult(
                gate: .issueOrderAuditedAsNoOp,
                passed: true,
                detail: "MontyDemoBoardSession has not overridden issueOrder, so explicit orders are currently rejected.",
                blocksDefaultOrderDiceReadiness: true
            ),
            MontyOrderDiceCompatibilityGateResult(
                gate: .automationAuditedAsPhaseDriven,
                passed: true,
                detail: "Monty autoplay and MontyTest still report progress by phase advances.",
                blocksDefaultOrderDiceReadiness: true
            ),
            MontyOrderDiceCompatibilityGateResult(
                gate: .shimDecisionRecorded,
                passed: !shimDecisions.isEmpty,
                detail: "Cycle 20 records which Monty compatibility pieces stay, move, or become legacy-only.",
                blocksDefaultOrderDiceReadiness: false
            ),
        ]
    }

    public static func report() -> MontyOrderDiceCycle20Report {
        let comparisons = contractComparisons
        let blockers = comparisons
            .filter(\.blocksDefaultOrderDiceReadiness)
            .map { "\($0.gap.rawValue): \($0.currentMontyContract)" }

        return MontyOrderDiceCycle20Report(
            cycleStart: cycleRange.lowerBound,
            cycleEnd: cycleRange.upperBound,
            cyclesRemaining: 180,
            rulesReferenceURL: rulesReferenceURL,
            documentationPath: documentationPath,
            auditedDependencies: dependencyAudit,
            contractComparisons: comparisons,
            compatibilityGates: compatibilityGates(),
            shimDecisions: shimDecisions,
            defaultReadinessBlockers: blockers
        )
    }

    public static var isReadyThroughOrderDiceCycle20: Bool {
        report().isReadyThroughCycle20
    }
}
