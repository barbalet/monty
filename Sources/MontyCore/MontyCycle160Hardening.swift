import Foundation

public enum MontyInteractionPolishRequirement: String, CaseIterable, Codable, Hashable, Sendable {
    case compactBoardLayout = "Compact board layout"
    case stableControlGrid = "Stable control grid"
    case disabledStateClarity = "Disabled state clarity"
    case blockedActionFeedback = "Blocked action feedback"
    case selectionVisibility = "Selection visibility"
    case sidebarLogAndDebrief = "Sidebar log and debrief"
}

public struct MontyExtendedUIAutomationReport: Codable, Hashable, Sendable {
    public let cycleRange: ClosedRange<Int>
    public let scriptCount: Int
    public let scriptsCoverAssault: Bool
    public let scriptsCoverBothSides: Bool
    public let scriptsCoverAllDemoBattles: Bool

    public var isReady: Bool {
        cycleRange == 141...144 &&
            scriptCount == MontyBattleCatalog.demoBattleIDs.count * 2 &&
            scriptsCoverAssault &&
            scriptsCoverBothSides &&
            scriptsCoverAllDemoBattles
    }
}

public enum MontyExtendedUIAutomationCatalog {
    public static let cycleRange = 141...144

    public static var report: MontyExtendedUIAutomationReport {
        let scripts = MontyUIAutomationCatalog.scripts
        return MontyExtendedUIAutomationReport(
            cycleRange: cycleRange,
            scriptCount: scripts.count,
            scriptsCoverAssault: scripts.allSatisfy { script in
                script.steps.contains { $0.action == .assaultSelectedTarget }
            },
            scriptsCoverBothSides: Set(scripts.map(\.chosenSideID)) == [MontySideID.montgomery, MontySideID.opposition],
            scriptsCoverAllDemoBattles: Set(scripts.map(\.battleID)) == Set(MontyBattleCatalog.demoBattleIDs)
        )
    }

    public static var isReady: Bool {
        report.isReady
    }
}

public struct MontyInteractionPolishReport: Codable, Hashable, Sendable {
    public let cycleRange: ClosedRange<Int>
    public let requirements: [MontyInteractionPolishRequirement]
    public let compactBoardTargetCount: Int
    public let requiredControlIdentifiers: [String]
    public let blockers: [String]

    public var isReady: Bool {
        cycleRange == 145...150 &&
            Set(requirements) == Set(MontyInteractionPolishRequirement.allCases) &&
            compactBoardTargetCount == MontyBattleCatalog.demoBattleIDs.count &&
            requiredControlIdentifiers.contains(MontyAccessibilityID.battleActionFeedback) &&
            requiredControlIdentifiers.contains(MontyAccessibilityID.battleMoveButton) &&
            requiredControlIdentifiers.contains(MontyAccessibilityID.battleShootButton) &&
            requiredControlIdentifiers.contains(MontyAccessibilityID.battleAITurnButton) &&
            blockers.isEmpty
    }
}

public enum MontyInteractionPolishCatalog {
    public static let cycleRange = 145...150

    public static var report: MontyInteractionPolishReport {
        var blockers: [String] = []
        let compactBoardTargets = MontyScreenshotQACatalog.targets.filter {
            $0.surface == .playableBoard && $0.viewport == .compact
        }
        let controlIdentifiers = MontyAccessibilityCatalog.sharedPlayableSurfaceIdentifiers

        if compactBoardTargets.count != MontyBattleCatalog.demoBattleIDs.count {
            blockers.append("Compact playable-board screenshot targets do not cover all demo battles.")
        }
        if !controlIdentifiers.contains(MontyAccessibilityID.battleActionFeedback) {
            blockers.append("Blocked-action feedback does not have a stable identifier.")
        }
        if !controlIdentifiers.contains(MontyAccessibilityID.battleRestartButton) {
            blockers.append("Restart does not have a stable identifier.")
        }

        return MontyInteractionPolishReport(
            cycleRange: cycleRange,
            requirements: MontyInteractionPolishRequirement.allCases,
            compactBoardTargetCount: compactBoardTargets.count,
            requiredControlIdentifiers: controlIdentifiers,
            blockers: blockers
        )
    }

    public static var isReady: Bool {
        report.isReady
    }
}

public enum MontyVerificationCommandID: String, CaseIterable, Codable, Hashable, Sendable {
    case swiftTest = "swift-test"
    case swiftBuild = "swift-build"
    case dzwSwiftTest = "dzw-swift-test"
    case dzwSwiftBuild = "dzw-swift-build"
    case guderianSwiftTest = "guderian-swift-test"
    case guderianSwiftBuild = "guderian-swift-build"
    case xcodeMontyBuild = "xcode-monty-build"
    case xcodeMontyTestBuild = "xcode-montytest-build"
}

public enum MontyVerificationStatus: String, Codable, Hashable, Sendable {
    case expected = "Expected"
    case passed = "Passed"
    case failed = "Failed"
}

public struct MontyVerificationCommand: Identifiable, Codable, Hashable, Sendable {
    public let id: MontyVerificationCommandID
    public let workingDirectory: String
    public let command: String
    public let status: MontyVerificationStatus

    public init(
        id: MontyVerificationCommandID,
        workingDirectory: String,
        command: String,
        status: MontyVerificationStatus = .expected
    ) {
        self.id = id
        self.workingDirectory = workingDirectory
        self.command = command
        self.status = status
    }
}

public struct MontyBuildMatrixReport: Codable, Hashable, Sendable {
    public let cycleRange: ClosedRange<Int>
    public let commands: [MontyVerificationCommand]

    public var isReady: Bool {
        cycleRange == 151...156 &&
            Set(commands.map(\.id)) == Set(MontyVerificationCommandID.allCases) &&
            commands.allSatisfy { !$0.command.isEmpty && !$0.workingDirectory.isEmpty }
    }
}

public enum MontyBuildMatrixCatalog {
    public static let cycleRange = 151...156

    public static var expectedCommands: [MontyVerificationCommand] {
        [
            MontyVerificationCommand(
                id: .swiftTest,
                workingDirectory: ".",
                command: "swift test"
            ),
            MontyVerificationCommand(
                id: .swiftBuild,
                workingDirectory: ".",
                command: "swift build"
            ),
            MontyVerificationCommand(
                id: .dzwSwiftTest,
                workingDirectory: "guderian/dzw",
                command: "swift test"
            ),
            MontyVerificationCommand(
                id: .dzwSwiftBuild,
                workingDirectory: "guderian/dzw",
                command: "swift build"
            ),
            MontyVerificationCommand(
                id: .guderianSwiftTest,
                workingDirectory: "guderian",
                command: "swift test"
            ),
            MontyVerificationCommand(
                id: .guderianSwiftBuild,
                workingDirectory: "guderian",
                command: "swift build"
            ),
            MontyVerificationCommand(
                id: .xcodeMontyBuild,
                workingDirectory: ".",
                command: "xcodebuild -project Monty.xcodeproj -scheme Monty -destination 'platform=macOS' build"
            ),
            MontyVerificationCommand(
                id: .xcodeMontyTestBuild,
                workingDirectory: ".",
                command: "xcodebuild -project Monty.xcodeproj -scheme MontyTest -destination 'platform=macOS' build"
            ),
        ]
    }

    public static var report: MontyBuildMatrixReport {
        MontyBuildMatrixReport(
            cycleRange: cycleRange,
            commands: expectedCommands
        )
    }

    public static var isReady: Bool {
        report.isReady
    }
}

public enum MontyProgressCodecError: Error, Equatable, CustomStringConvertible, Sendable {
    case unsupportedVersion(Int)
    case wrongApplication(String)
    case corruptPayload

    public var description: String {
        switch self {
        case .unsupportedVersion(let version):
            return "Unsupported Monty progress save version \(version)."
        case .wrongApplication(let appIdentifier):
            return "Progress save belongs to \(appIdentifier), not \(MontyAppIdentity.bundleIdentifier)."
        case .corruptPayload:
            return "Monty progress save data is corrupt."
        }
    }
}

public struct MontyCampaignProgressEnvelope: Codable, Hashable, Sendable {
    public static let currentVersion = 2

    public let version: Int
    public let applicationIdentifier: String
    public let storagePrefix: String
    public let progress: MontyCampaignProgress

    public init(
        version: Int = Self.currentVersion,
        applicationIdentifier: String = MontyAppIdentity.bundleIdentifier,
        storagePrefix: String = MontyAppIdentity.storagePrefix,
        progress: MontyCampaignProgress
    ) {
        self.version = version
        self.applicationIdentifier = applicationIdentifier
        self.storagePrefix = storagePrefix
        self.progress = progress
    }

    public var isMontyOwned: Bool {
        applicationIdentifier == MontyAppIdentity.bundleIdentifier &&
            storagePrefix == MontyAppIdentity.storagePrefix &&
            MontyAppIdentity.storagePrefix.hasPrefix("com.barbalet.monty") &&
            !MontyAppIdentity.storagePrefix.localizedCaseInsensitiveContains("guderian")
    }
}

public enum MontyCampaignProgressCodec {
    public static func encode(_ progress: MontyCampaignProgress) throws -> String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.sortedKeys]
        let data = try encoder.encode(MontyCampaignProgressEnvelope(progress: progress))
        return String(decoding: data, as: UTF8.self)
    }

    public static func decode(_ payload: String) throws -> MontyCampaignProgress {
        guard let data = payload.data(using: .utf8) else {
            throw MontyProgressCodecError.corruptPayload
        }

        do {
            let envelope = try JSONDecoder().decode(MontyCampaignProgressEnvelope.self, from: data)
            guard envelope.version == MontyCampaignProgressEnvelope.currentVersion else {
                throw MontyProgressCodecError.unsupportedVersion(envelope.version)
            }
            guard envelope.isMontyOwned else {
                throw MontyProgressCodecError.wrongApplication(envelope.applicationIdentifier)
            }
            return envelope.progress
        } catch let error as MontyProgressCodecError {
            throw error
        } catch {
            throw MontyProgressCodecError.corruptPayload
        }
    }
}

public struct MontySaveLoadHardeningReport: Codable, Hashable, Sendable {
    public let cycleRange: ClosedRange<Int>
    public let roundTripSucceeded: Bool
    public let selectedSideReloaded: Bool
    public let completionReloaded: Bool
    public let debriefSummaryReloaded: Bool
    public let storageKeysMontyOwned: Bool
    public let rejectsWrongApplicationPayload: Bool

    public var isReadyThroughCycle160: Bool {
        cycleRange == 157...160 &&
            roundTripSucceeded &&
            selectedSideReloaded &&
            completionReloaded &&
            debriefSummaryReloaded &&
            storageKeysMontyOwned &&
            rejectsWrongApplicationPayload
    }
}

public enum MontySaveLoadHardeningCatalog {
    public static let cycleRange = 157...160

    public static func report() throws -> MontySaveLoadHardeningReport {
        let flow = try MontyLaunchFlowResolver.makeLaunchFlow(
            battleID: .alamElHalfa,
            chosenSideID: MontySideID.opposition
        )
        var progress = MontyCampaignProgress()
        progress.recordSelectedSide(MontySideID.opposition, for: .alamElHalfa)
        let completion = MontyLaunchFlowResolver.complete(
            flow,
            progress: &progress,
            winningSideID: MontySideID.opposition,
            score: flow.scenario.victory.targetScore,
            completedTurn: 2
        )

        let payload = try MontyCampaignProgressCodec.encode(progress)
        let decoded = try MontyCampaignProgressCodec.decode(payload)
        let decodedCompletion = decoded.completionRecord(for: .alamElHalfa)
        let wrongApplicationPayload = payload.replacingOccurrences(
            of: MontyAppIdentity.bundleIdentifier,
            with: "com.barbalet.guderian"
        )
        let rejectedWrongApplicationPayload: Bool
        do {
            _ = try MontyCampaignProgressCodec.decode(wrongApplicationPayload)
            rejectedWrongApplicationPayload = false
        } catch MontyProgressCodecError.wrongApplication(_) {
            rejectedWrongApplicationPayload = true
        }

        return MontySaveLoadHardeningReport(
            cycleRange: cycleRange,
            roundTripSucceeded: decoded == progress,
            selectedSideReloaded: decoded.lastSelectedSideByBattle[.alamElHalfa] == MontySideID.opposition,
            completionReloaded: decodedCompletion == completion,
            debriefSummaryReloaded: decodedCompletion?.debriefSummary == completion.debriefSummary,
            storageKeysMontyOwned: [
                MontyAppIdentity.campaignProgressStorageKey,
                MontyAppIdentity.selectedSideStorageKey,
            ].allSatisfy { $0.hasPrefix(MontyAppIdentity.storagePrefix) && !$0.localizedCaseInsensitiveContains("guderian") },
            rejectsWrongApplicationPayload: rejectedWrongApplicationPayload
        )
    }

    public static var isReadyThroughCycle160: Bool {
        (try? report().isReadyThroughCycle160) == true
    }
}

public struct MontyCycle160AcceptanceReport: Codable, Hashable, Sendable {
    public let cycleStart: Int
    public let cycleEnd: Int
    public let cycle140Ready: Bool
    public let extendedUIAutomationReady: Bool
    public let interactionPolishReady: Bool
    public let buildMatrixReady: Bool
    public let saveLoadReady: Bool
    public let blockers: [String]

    public var isReady: Bool {
        cycleStart == 141 &&
            cycleEnd == 160 &&
            cycle140Ready &&
            extendedUIAutomationReady &&
            interactionPolishReady &&
            buildMatrixReady &&
            saveLoadReady &&
            blockers.isEmpty
    }
}

public enum MontyCycle160AcceptanceCatalog {
    public static let cycleRange = 141...160

    public static func report() throws -> MontyCycle160AcceptanceReport {
        let cycle140Ready = MontyCycle140AcceptanceCatalog.acceptanceReadyThroughCycle140
        let automationReady = MontyExtendedUIAutomationCatalog.isReady
        let polishReady = MontyInteractionPolishCatalog.isReady
        let buildReady = MontyBuildMatrixCatalog.isReady
        let saveLoadReady = try MontySaveLoadHardeningCatalog.report().isReadyThroughCycle160
        var blockers: [String] = []

        if !cycle140Ready {
            blockers.append("Cycle-140 visual/accessibility/UI-QA gates are not ready.")
        }
        if !automationReady {
            blockers.append("Cycle-144 UI automation expansion is incomplete.")
        }
        if !polishReady {
            blockers.append(contentsOf: MontyInteractionPolishCatalog.report.blockers)
        }
        if !buildReady {
            blockers.append("Cycle-156 build matrix commands are incomplete.")
        }
        if !saveLoadReady {
            blockers.append("Cycle-160 save/load hardening is incomplete.")
        }

        return MontyCycle160AcceptanceReport(
            cycleStart: cycleRange.lowerBound,
            cycleEnd: cycleRange.upperBound,
            cycle140Ready: cycle140Ready,
            extendedUIAutomationReady: automationReady,
            interactionPolishReady: polishReady,
            buildMatrixReady: buildReady,
            saveLoadReady: saveLoadReady,
            blockers: blockers
        )
    }

    public static var acceptanceReadyThroughCycle160: Bool {
        (try? report().isReady) == true
    }
}
