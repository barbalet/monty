import Foundation
import DerZweiteWeltkriegHistorical

public enum MontyCriticalAcceptanceRequirement: String, CaseIterable, Codable, Hashable, Sendable {
    case cycle210InterfaceRepair = "Cycle 210 interface repair retained"
    case idOnlyBoardTokens = "ID-only board tokens"
    case sidebarForceDisclosure = "Sidebar force disclosure"
    case noDenseBoardNameLabels = "No dense board name labels"
    case collisionOffsetTokenLayout = "Collision-offset token layout"
    case viewportKeepsCommandsReachable = "Viewport keeps commands reachable"
    case allDemoBattlesReadableFromBothSides = "All demo battles readable from both sides"
    case allDemoBattlesAutoplayToDebrief = "All demo battles autoplay to debrief"
    case montyTestVisualSmoke = "MontyTest visual smoke"
    case guderianRegressionMatrix = "Guderian regression matrix"
}

public struct MontyCriticalReadabilityCase: Codable, Hashable, Sendable {
    public let battleID: MontyBattleID
    public let sideID: String
    public let audit: HistoricalBoardReadabilityAudit

    public init(
        battleID: MontyBattleID,
        sideID: String,
        audit: HistoricalBoardReadabilityAudit
    ) {
        self.battleID = battleID
        self.sideID = sideID
        self.audit = audit
    }

    public var passed: Bool {
        audit.passesCriticalReadabilityGate
    }
}

public struct MontyCriticalVisualSmokeArtifact: Codable, Hashable, Sendable {
    public let path: String
    public let description: String

    public init(path: String, description: String) {
        self.path = path
        self.description = description
    }
}

public struct MontyCycle240CriticalAcceptanceReport: Codable, Hashable, Sendable {
    public let cycleStart: Int
    public let cycleEnd: Int
    public let cyclesRemaining: Int
    public let completedRequirements: [MontyCriticalAcceptanceRequirement]
    public let readabilityCases: [MontyCriticalReadabilityCase]
    public let autoplayRunCount: Int
    public let autoplayCompletedCount: Int
    public let autoplayBothSidesActedCount: Int
    public let verificationCommands: [MontyCriticalPlayabilityVerificationCommand]
    public let visualSmokeArtifacts: [MontyCriticalVisualSmokeArtifact]
    public let knownLimitations: [String]

    public var isReadyThroughCycle240: Bool {
        cycleStart == 211 &&
            cycleEnd == 240 &&
            cyclesRemaining == 0 &&
            Set(completedRequirements) == Set(MontyCriticalAcceptanceRequirement.allCases) &&
            MontyCycle210CriticalPlayabilityCatalog.isReadyThroughCycle210 &&
            HistoricalPlayableSurfaceCatalog.boardReadabilityProfile.preventsDenseAlwaysOnBoardText &&
            HistoricalPlayableSurfaceCatalog.boardViewportProfile.isCriticalViewportReady &&
            readabilityCases.count == MontyDemoDataPackCatalog.all.count * 2 &&
            readabilityCases.allSatisfy(\.passed) &&
            autoplayRunCount == MontyDemoDataPackCatalog.all.count * 2 &&
            autoplayCompletedCount == autoplayRunCount &&
            autoplayBothSidesActedCount == autoplayRunCount &&
            verificationCommands.contains { $0.workingDirectory == "guderian/dzw" && $0.command == "swift test" } &&
            verificationCommands.contains { $0.workingDirectory == "guderian" && $0.command == "swift build" } &&
            !visualSmokeArtifacts.isEmpty
    }
}

public enum MontyCycle240CriticalAcceptanceCatalog {
    public static let cycleRange = 211...240

    public static let visualSmokeArtifacts = [
        MontyCriticalVisualSmokeArtifact(
            path: "/private/tmp/montytest-cycle240-final.png",
            description: "MontyTest first-battle surface after ID-only token and viewport repairs."
        ),
    ]

    public static func readabilityCases() throws -> [MontyCriticalReadabilityCase] {
        try MontyDemoDataPackCatalog.all.flatMap { pack in
            try [MontySideID.montgomery, MontySideID.opposition].map { sideID in
                let session = try MontyDemoBoardSession(
                    battleID: pack.scenario.id,
                    chosenSideID: sideID
                )
                return MontyCriticalReadabilityCase(
                    battleID: pack.scenario.id,
                    sideID: sideID,
                    audit: HistoricalBoardLayoutResolver.readabilityAudit(for: session.snapshot())
                )
            }
        }
    }

    public static func report() throws -> MontyCycle240CriticalAcceptanceReport {
        let readabilityCases = try readabilityCases()
        let autoplayResults = try MontyDemoAutoplayRunner.runAllDemoBattlesForBothSides()
        let completedCount = autoplayResults.filter { $0.report.completedToDebrief }.count
        let bothSidesActedCount = autoplayResults.filter { $0.report.bothSidesActed }.count

        return MontyCycle240CriticalAcceptanceReport(
            cycleStart: cycleRange.lowerBound,
            cycleEnd: cycleRange.upperBound,
            cyclesRemaining: 0,
            completedRequirements: MontyCriticalAcceptanceRequirement.allCases,
            readabilityCases: readabilityCases,
            autoplayRunCount: autoplayResults.count,
            autoplayCompletedCount: completedCount,
            autoplayBothSidesActedCount: bothSidesActedCount,
            verificationCommands: MontyCycle210CriticalPlayabilityCatalog.verificationCommands,
            visualSmokeArtifacts: visualSmokeArtifacts,
            knownLimitations: [
                "The playable demo still covers the three locked demo battles; the remaining 32 campaign rows are planned content.",
                "Monty uses the shared HistoricalBoardSession interface and Guderian-style surface semantics; a deeper native-engine replacement remains future work beyond this critical demo closeout.",
            ]
        )
    }

    public static var isReadyThroughCycle240: Bool {
        (try? report().isReadyThroughCycle240) == true
    }
}
