import Foundation
import DerZweiteWeltkriegHistorical

public enum MontyCriticalPlayabilityRequirement: String, CaseIterable, Codable, Hashable, Sendable {
    case guderianInterfaceBoundaryAudit = "Guderian interface boundary audit"
    case sharedInteractionResolver = "Shared direct board interaction resolver"
    case directUnitSelection = "Direct unit selection from board tokens"
    case directTargetSelection = "Direct target selection from opposing tokens"
    case clearSelectionHook = "Clear selection hook"
    case commandPhaseParity = "Command and phase parity"
    case readableBoardEmergencyDeclutter = "Readable board emergency declutter"
    case montyTestSharedSurfaceCallbacks = "MontyTest shared surface callbacks"
    case guderianRegressionProtection = "Guderian regression protection"
}

public enum MontyGuderianGameplayBoundary: String, CaseIterable, Codable, Hashable, Sendable {
    case appBoardView = "Guderian BattleBoardView"
    case appGameControllerActions = "Guderian GameController actions"
    case appGameControllerQueries = "Guderian GameController queries"
    case appControlsSection = "Guderian battle controls section"
    case nativeBoardSession = "Guderian NativeBoardSession"
    case sharedHistoricalSurface = "HistoricalPlayableBattleView"
    case montyCompatibilitySession = "MontyDemoBoardSession compatibility layer"

    public var sourcePath: String {
        switch self {
        case .appBoardView:
            return "guderian/dzw/Sources/DerZweiteWeltkriegApp/Board/BattleBoardView.swift"
        case .appGameControllerActions:
            return "guderian/dzw/Sources/DerZweiteWeltkriegApp/ViewModel/GameController+Actions.swift"
        case .appGameControllerQueries:
            return "guderian/dzw/Sources/DerZweiteWeltkriegApp/ViewModel/GameController+Queries.swift"
        case .appControlsSection:
            return "guderian/dzw/Sources/DerZweiteWeltkriegApp/Sidebar/BattleControlsSection.swift"
        case .nativeBoardSession:
            return "guderian/dzw/Sources/DerZweiteWeltkriegGuderian/NativeBoardSession.swift"
        case .sharedHistoricalSurface:
            return "guderian/dzw/Sources/DerZweiteWeltkriegHistorical/HistoricalPlayableBattleView.swift"
        case .montyCompatibilitySession:
            return "Sources/MontyCore/MontyDemoBoardSession.swift"
        }
    }
}

public struct MontyCriticalPlayabilityVerificationCommand: Codable, Hashable, Sendable {
    public let workingDirectory: String
    public let command: String
    public let purpose: String

    public init(workingDirectory: String, command: String, purpose: String) {
        self.workingDirectory = workingDirectory
        self.command = command
        self.purpose = purpose
    }
}

public struct MontyCycle210CriticalPlayabilityReport: Codable, Hashable, Sendable {
    public let cycleStart: Int
    public let cycleEnd: Int
    public let cyclesRemaining: Int
    public let completedRequirements: [MontyCriticalPlayabilityRequirement]
    public let guderianBoundaryFiles: [MontyGuderianGameplayBoundary]
    public let verificationCommands: [MontyCriticalPlayabilityVerificationCommand]
    public let deferredRisks: [String]

    public var isReadyThroughCycle210: Bool {
        cycleStart == 181 &&
            cycleEnd == 210 &&
            cyclesRemaining == 30 &&
            Set(completedRequirements) == Set(MontyCriticalPlayabilityRequirement.allCases) &&
            Set(guderianBoundaryFiles) == Set(MontyGuderianGameplayBoundary.allCases) &&
            HistoricalPlayableSurfaceCatalog.boardInteractionProfile.supportsGuderianStyleBoardCommands &&
            HistoricalPlayableSurfaceCatalog.boardReadabilityProfile.preventsDenseAlwaysOnBoardText &&
            verificationCommands.contains { $0.workingDirectory == "guderian/dzw" && $0.command == "swift test" }
    }
}

public enum MontyCycle210CriticalPlayabilityCatalog {
    public static let cycleRange = 181...210

    public static let verificationCommands = [
        MontyCriticalPlayabilityVerificationCommand(
            workingDirectory: ".",
            command: "swift build",
            purpose: "Compile Monty app, MontyTest, and the shared historical surface after direct board-interaction changes."
        ),
        MontyCriticalPlayabilityVerificationCommand(
            workingDirectory: ".",
            command: "swift test",
            purpose: "Validate Monty launch flow, board session semantics, cycle-210 report, and previous acceptance gates."
        ),
        MontyCriticalPlayabilityVerificationCommand(
            workingDirectory: "guderian/dzw",
            command: "swift test",
            purpose: "Protect the DZW/Guderian historical, native board, and shared surface contracts."
        ),
        MontyCriticalPlayabilityVerificationCommand(
            workingDirectory: "guderian",
            command: "swift build",
            purpose: "Protect the top-level Guderian build against shared historical surface regressions."
        ),
    ]

    public static func report() -> MontyCycle210CriticalPlayabilityReport {
        MontyCycle210CriticalPlayabilityReport(
            cycleStart: cycleRange.lowerBound,
            cycleEnd: cycleRange.upperBound,
            cyclesRemaining: 30,
            completedRequirements: MontyCriticalPlayabilityRequirement.allCases,
            guderianBoundaryFiles: MontyGuderianGameplayBoundary.allCases,
            verificationCommands: verificationCommands,
            deferredRisks: [
                "MontyDemoBoardSession is still the Monty compatibility session. Cycles 211-240 must either replace it with a real native-engine bridge or make the adapter parity impossible to confuse with a scripted mock.",
                "The board now removes dense always-on labels, but cycles 211-240 still need screenshot-level collision proof across all three demo battles and compact layouts.",
            ]
        )
    }

    public static var isReadyThroughCycle210: Bool {
        report().isReadyThroughCycle210
    }
}
