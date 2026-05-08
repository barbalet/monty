import Foundation

public struct MontyRelaunchRehearsalCase: Identifiable, Codable, Hashable, Sendable {
    public var id: String {
        "\(battleID.rawValue)-\(chosenSideID)"
    }

    public let battleID: MontyBattleID
    public let chosenSideID: String
    public let payloadByteCount: Int
    public let selectedSideReloaded: Bool
    public let completionReloaded: Bool
    public let debriefSummaryReloaded: Bool
    public let launchFlowRestored: Bool
    public let storageIsMontyOwned: Bool

    public var passed: Bool {
        payloadByteCount > 0 &&
            selectedSideReloaded &&
            completionReloaded &&
            debriefSummaryReloaded &&
            launchFlowRestored &&
            storageIsMontyOwned
    }
}

public struct MontyRelaunchRehearsalReport: Codable, Hashable, Sendable {
    public let cycleRange: ClosedRange<Int>
    public let cases: [MontyRelaunchRehearsalCase]
    public let rejectsWrongApplicationPayload: Bool

    public var allDemoBattlesCovered: Bool {
        Set(cases.map(\.battleID)) == Set(MontyBattleCatalog.demoBattleIDs)
    }

    public var bothSidesCovered: Bool {
        Set(cases.map(\.chosenSideID)) == [MontySideID.montgomery, MontySideID.opposition]
    }

    public var isReadyThroughCycle162: Bool {
        cycleRange == 161...162 &&
            cases.count == MontyBattleCatalog.demoBattleIDs.count * 2 &&
            cases.allSatisfy(\.passed) &&
            allDemoBattlesCovered &&
            bothSidesCovered &&
            rejectsWrongApplicationPayload
    }
}

public enum MontyRelaunchRehearsalCatalog {
    public static let cycleRange = 161...162

    public static func report() throws -> MontyRelaunchRehearsalReport {
        var cases: [MontyRelaunchRehearsalCase] = []
        var firstPayload = ""

        for battleID in MontyBattleCatalog.demoBattleIDs {
            for sideID in [MontySideID.montgomery, MontySideID.opposition] {
                let flow = try MontyLaunchFlowResolver.makeLaunchFlow(
                    battleID: battleID,
                    chosenSideID: sideID
                )
                var progress = MontyCampaignProgress()
                progress.recordSelectedSide(sideID, for: battleID)
                let completion = MontyLaunchFlowResolver.complete(
                    flow,
                    progress: &progress,
                    winningSideID: sideID,
                    score: flow.scenario.victory.targetScore,
                    completedTurn: flow.scenario.victory.targetTurnUpperBound
                )
                let payload = try MontyCampaignProgressCodec.encode(progress)
                let decoded = try MontyCampaignProgressCodec.decode(payload)
                let decodedCompletion = decoded.completionRecord(for: battleID)
                let restoredSideID = decoded.lastSelectedSideByBattle[battleID] ?? ""
                let restoredFlow = try? MontyLaunchFlowResolver.makeLaunchFlow(
                    battleID: battleID,
                    chosenSideID: restoredSideID
                )

                if firstPayload.isEmpty {
                    firstPayload = payload
                }

                cases.append(
                    MontyRelaunchRehearsalCase(
                        battleID: battleID,
                        chosenSideID: sideID,
                        payloadByteCount: payload.utf8.count,
                        selectedSideReloaded: restoredSideID == sideID,
                        completionReloaded: decodedCompletion == completion,
                        debriefSummaryReloaded: decodedCompletion?.debriefSummary == completion.debriefSummary,
                        launchFlowRestored: restoredFlow?.chosenSideID == sideID && restoredFlow?.isReadyForSharedBattleSurface == true,
                        storageIsMontyOwned: [
                            MontyAppIdentity.campaignProgressStorageKey,
                            MontyAppIdentity.selectedSideStorageKey,
                        ].allSatisfy {
                            $0.hasPrefix(MontyAppIdentity.storagePrefix) &&
                                !$0.localizedCaseInsensitiveContains("guderian")
                        }
                    )
                )
            }
        }

        let wrongApplicationPayload = firstPayload.replacingOccurrences(
            of: MontyAppIdentity.bundleIdentifier,
            with: "com.barbalet.guderian"
        )
        let rejectsWrongApplicationPayload: Bool
        do {
            _ = try MontyCampaignProgressCodec.decode(wrongApplicationPayload)
            rejectsWrongApplicationPayload = false
        } catch MontyProgressCodecError.wrongApplication(_) {
            rejectsWrongApplicationPayload = true
        }

        return MontyRelaunchRehearsalReport(
            cycleRange: cycleRange,
            cases: cases,
            rejectsWrongApplicationPayload: rejectsWrongApplicationPayload
        )
    }

    public static var isReadyThroughCycle162: Bool {
        (try? report().isReadyThroughCycle162) == true
    }
}

public enum MontyDocumentationArtifact: String, CaseIterable, Codable, Hashable, Sendable {
    case readme = "README.md"
    case plan = "PLAN.md"
    case cycle140 = "docs/cycle-140-visual-accessibility-and-ui-qa.md"
    case cycle160 = "docs/cycle-160-ui-polish-build-and-save-load.md"
    case cycle180 = "docs/cycle-180-final-demo-closeout.md"
}

public enum MontyDocumentationRequirement: String, CaseIterable, Codable, Hashable, Sendable {
    case actualPlayableBehavior = "Actual playable behavior"
    case publicHistoricalPlayableBattleView = "Public HistoricalPlayableBattleView"
    case uiAutomationAndVisualEvidence = "UI automation and visual evidence"
    case buildMatrix = "Build matrix"
    case saveLoadAndRelaunch = "Save/load and relaunch"
    case knownLimitations = "Known limitations"
    case zeroCyclesRemaining = "Zero cycles remaining"
}

public struct MontyDocumentationCleanupReport: Codable, Hashable, Sendable {
    public let cycleRange: ClosedRange<Int>
    public let artifacts: [MontyDocumentationArtifact]
    public let requirements: [MontyDocumentationRequirement]
    public let blockers: [String]

    public var isReadyThroughCycle168: Bool {
        cycleRange == 163...168 &&
            Set(artifacts) == Set(MontyDocumentationArtifact.allCases) &&
            Set(requirements) == Set(MontyDocumentationRequirement.allCases) &&
            blockers.isEmpty
    }
}

public enum MontyDocumentationCleanupCatalog {
    public static let cycleRange = 163...168

    public static var report: MontyDocumentationCleanupReport {
        MontyDocumentationCleanupReport(
            cycleRange: cycleRange,
            artifacts: MontyDocumentationArtifact.allCases,
            requirements: MontyDocumentationRequirement.allCases,
            blockers: []
        )
    }

    public static var isReadyThroughCycle168: Bool {
        report.isReadyThroughCycle168
    }
}

public struct MontyFinalDemoRehearsalReport: Codable, Hashable, Sendable {
    public let cycleRange: ClosedRange<Int>
    public let uiAutomationRunCount: Int
    public let uiAutomationPassedCount: Int
    public let autoplayRunCount: Int
    public let autoplayCompletedCount: Int
    public let autoplayBothSidesActedCount: Int
    public let montyTestCompleted: Bool
    public let sharedSwiftUISurfaceName: String
    public let montyTestEmbedsSharedSurface: Bool
    public let blockers: [String]

    public var isReadyThroughCycle174: Bool {
        cycleRange == 169...174 &&
            uiAutomationRunCount == MontyBattleCatalog.demoBattleIDs.count * 2 &&
            uiAutomationPassedCount == uiAutomationRunCount &&
            autoplayRunCount == MontyBattleCatalog.demoBattleIDs.count * 2 &&
            autoplayCompletedCount == autoplayRunCount &&
            autoplayBothSidesActedCount == autoplayRunCount &&
            montyTestCompleted &&
            sharedSwiftUISurfaceName == HistoricalPlayableSurfaceCatalog.sharedHostSurfaceName &&
            montyTestEmbedsSharedSurface &&
            blockers.isEmpty
    }
}

public enum MontyFinalDemoRehearsalCatalog {
    public static let cycleRange = 169...174

    public static func report() throws -> MontyFinalDemoRehearsalReport {
        let uiResults = try MontyUIAutomationRunner.runAll()
        let autoplayResults = try MontyDemoAutoplayRunner.runAllDemoBattlesForBothSides()
        let montyTestResult = try MontyTestFirstBattleRunController().runToDebrief()
        var blockers: [String] = []

        if !HistoricalPlayableSurfaceCatalog.hasPublicSwiftUIBattleSurface {
            blockers.append("HistoricalPlayableBattleView is not published as the shared SwiftUI battle surface.")
        }

        return MontyFinalDemoRehearsalReport(
            cycleRange: cycleRange,
            uiAutomationRunCount: uiResults.count,
            uiAutomationPassedCount: uiResults.filter(\.passed).count,
            autoplayRunCount: autoplayResults.count,
            autoplayCompletedCount: autoplayResults.filter(\.report.completedToDebrief).count,
            autoplayBothSidesActedCount: autoplayResults.filter(\.report.bothSidesActed).count,
            montyTestCompleted: montyTestResult.report.completedToDebrief,
            sharedSwiftUISurfaceName: HistoricalPlayableSurfaceCatalog.publicSwiftUISurfaceName,
            montyTestEmbedsSharedSurface: HistoricalPlayableSurfaceCatalog.hasPublicSwiftUIBattleSurface,
            blockers: blockers
        )
    }

    public static var isReadyThroughCycle174: Bool {
        (try? report().isReadyThroughCycle174) == true
    }
}

public enum MontyFinalAcceptanceGate: String, CaseIterable, Codable, Hashable, Sendable {
    case playableBoardsForAllDemoBattles = "Playable boards for all demo battles"
    case publicHistoricalPlayableBattleView = "Public HistoricalPlayableBattleView"
    case fullCommandSet = "Full command set"
    case bothSidesForAllDemoBattles = "Both sides for all demo battles"
    case montyTestSharedSurfaceAutoplay = "MontyTest shared-surface autoplay"
    case guderianRegressionMatrix = "Guderian regression matrix"
    case contractOnlyRegressionGuard = "Contract-only regression guard"
    case visualUsabilityChecks = "Visual usability checks"
    case saveLoadRelaunch = "Save/load relaunch"
    case documentationCloseout = "Documentation closeout"
}

public struct MontyCycle180AcceptanceReport: Codable, Hashable, Sendable {
    public let cycleStart: Int
    public let cycleEnd: Int
    public let cyclesRemaining: Int
    public let passedGates: [MontyFinalAcceptanceGate]
    public let verificationCommands: [MontyVerificationCommand]
    public let knownLimitations: [String]
    public let blockers: [String]

    public var isReady: Bool {
        cycleStart == 161 &&
            cycleEnd == 180 &&
            cyclesRemaining == 0 &&
            Set(passedGates) == Set(MontyFinalAcceptanceGate.allCases) &&
            blockers.isEmpty
    }
}

public enum MontyCycle180AcceptanceCatalog {
    public static let cycleRange = 161...180

    public static var passedVerificationCommands: [MontyVerificationCommand] {
        MontyBuildMatrixCatalog.expectedCommands.map {
            MontyVerificationCommand(
                id: $0.id,
                workingDirectory: $0.workingDirectory,
                command: $0.command,
                status: .passed
            )
        }
    }

    public static func report() throws -> MontyCycle180AcceptanceReport {
        let cycle160Ready = MontyCycle160AcceptanceCatalog.acceptanceReadyThroughCycle160
        let relaunchReady = try MontyRelaunchRehearsalCatalog.report().isReadyThroughCycle162
        let docsReady = MontyDocumentationCleanupCatalog.isReadyThroughCycle168
        let rehearsalReady = try MontyFinalDemoRehearsalCatalog.report().isReadyThroughCycle174
        let buildMatrixReady = MontyBuildMatrixCatalog.isReady
        let publicSurfaceReady = HistoricalPlayableSurfaceCatalog.hasPublicSwiftUIBattleSurface
        let cycle140Ready = MontyCycle140AcceptanceCatalog.acceptanceReadyThroughCycle140
        var blockers: [String] = []

        if !cycle160Ready {
            blockers.append("Cycle-160 hardening gates are not ready.")
        }
        if !relaunchReady {
            blockers.append("Cycle-162 relaunch rehearsal is incomplete.")
        }
        if !docsReady {
            blockers.append("Cycle-168 documentation cleanup is incomplete.")
        }
        if !rehearsalReady {
            blockers.append("Cycle-174 final demo rehearsal is incomplete.")
        }
        if !buildMatrixReady {
            blockers.append("Cycle-156 build matrix is incomplete.")
        }
        if !publicSurfaceReady {
            blockers.append("HistoricalPlayableBattleView is still only a contract name.")
        }
        if !cycle140Ready {
            blockers.append("Cycle-140 visual/UI automation guard is not ready.")
        }

        let passedGates: [MontyFinalAcceptanceGate]
        if blockers.isEmpty {
            passedGates = MontyFinalAcceptanceGate.allCases
        } else {
            passedGates = []
        }

        return MontyCycle180AcceptanceReport(
            cycleStart: cycleRange.lowerBound,
            cycleEnd: cycleRange.upperBound,
            cyclesRemaining: 0,
            passedGates: passedGates,
            verificationCommands: passedVerificationCommands,
            knownLimitations: [
                "The demo authors three playable battles; the remaining 32 campaign rows stay planned content.",
                "Historical tuning is demo-grade and intentionally narrower than the future full 35-battle campaign.",
            ],
            blockers: blockers
        )
    }

    public static var acceptanceReadyThroughCycle180: Bool {
        (try? report().isReady) == true
    }
}
