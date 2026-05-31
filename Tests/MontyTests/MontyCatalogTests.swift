@testable import MontyCore
import SwiftUI
import XCTest

final class MontyCatalogTests: XCTestCase {
    func testCatalogMatchesThirtyFiveBattleReadmeRoster() {
        let scenarios = MontyBattleCatalog.all

        XCTAssertEqual(scenarios.count, 35)
        XCTAssertEqual(scenarios.map(\.order), Array(1...35))
        XCTAssertEqual(scenarios.map(\.id), MontyBattleID.allCases)
        XCTAssertEqual(scenarios.first?.id, .battleOfFrance)
        XCTAssertEqual(scenarios.last?.id, .hamburg)
        XCTAssertEqual(MontyBattleCatalog.phaseCounts.values.reduce(0, +), 35)
        XCTAssertEqual(MontyBattleCatalog.phaseCounts[.befFrance], 2)
        XCTAssertEqual(MontyBattleCatalog.phaseCounts[.northAfricaTunisia], 8)
        XCTAssertEqual(MontyBattleCatalog.phaseCounts[.sicilyItaly], 5)
        XCTAssertEqual(MontyBattleCatalog.phaseCounts[.normandyFrance], 9)
        XCTAssertEqual(MontyBattleCatalog.phaseCounts[.channelLowCountries], 4)
        XCTAssertEqual(MontyBattleCatalog.phaseCounts[.ardennesRhinelandGermany], 7)
    }

    func testEveryCatalogScenarioUsesSharedHistoricalBattleContract() {
        for scenario in MontyBattleCatalog.all {
            XCTAssertTrue(scenario.hasTwoPlayableSides, scenario.title)
            XCTAssertEqual(scenario.sideOptions.map(\.id), [MontySideID.montgomery, MontySideID.opposition], scenario.title)
            XCTAssertEqual(scenario.sideOptions.first?.role, .protagonist, scenario.title)
            XCTAssertEqual(scenario.sideOptions.last?.role, .opponent, scenario.title)
            XCTAssertFalse(scenario.sourceLinks.isEmpty, scenario.title)
            XCTAssertFalse(scenario.sourceLinks.contains { !$0.url.hasPrefix("https://en.wikipedia.org/wiki/") }, scenario.title)
            XCTAssertGreaterThanOrEqual(scenario.map.elements.count, 2, scenario.title)
            XCTAssertEqual(scenario.map.deploymentZones.count, 2, scenario.title)
            XCTAssertGreaterThanOrEqual(scenario.objectives.count, 2, scenario.title)
            XCTAssertFalse(scenario.victory.bands.isEmpty, scenario.title)
        }
    }

    func testDemoBattleScopeIsLockedAndAllDemoDataPacksAreReadyThroughCycle100() throws {
        XCTAssertEqual(
            MontyBattleCatalog.demoBattleIDs,
            [.alamElHalfa, .secondElAlamein, .operationEpsom]
        )

        let alam = try XCTUnwrap(MontyBattleCatalog.scenario(id: .alamElHalfa))
        let secondAlamein = try XCTUnwrap(MontyBattleCatalog.scenario(id: .secondElAlamein))
        let epsom = try XCTUnwrap(MontyBattleCatalog.scenario(id: .operationEpsom))

        XCTAssertEqual(alam.status, .dataLocked)
        XCTAssertEqual(secondAlamein.status, .dataLocked)
        XCTAssertEqual(epsom.status, .dataLocked)
        XCTAssertTrue(MontyAlamElHalfaDataPack.dataPack.isCycle80Ready)
        XCTAssertTrue(MontySecondElAlameinDataPack.dataPack.isDemoReady)
        XCTAssertTrue(MontyOperationEpsomDataPack.dataPack.isDemoReady)
        XCTAssertTrue(MontyDemoDataPackCatalog.cycle100Ready)
        XCTAssertEqual(alam.map.elements.count, 6)
        XCTAssertEqual(alam.objectives.count, 4)
        XCTAssertEqual(Set(alam.objectives.compactMap(\.sideID)), [MontySideID.montgomery, MontySideID.opposition])
        XCTAssertEqual(secondAlamein.map.elements.count, 6)
        XCTAssertEqual(epsom.map.elements.count, 6)
    }

    func testAlamElHalfaSideSelectionAllowsEitherSideToBeHumanControlled() throws {
        let scenario = try XCTUnwrap(MontyBattleCatalog.scenario(id: .alamElHalfa))
        let montgomeryLaunch = try HistoricalBattleLaunchResolver.makeLaunch(
            scenario: scenario,
            chosenHumanSideID: MontySideID.montgomery,
            seed: MontyAlamElHalfaDataPack.defaultSeed
        )
        let axisLaunch = try HistoricalBattleLaunchResolver.makeLaunch(
            scenario: scenario,
            chosenHumanSideID: MontySideID.opposition,
            seed: MontyAlamElHalfaDataPack.defaultSeed
        )

        XCTAssertEqual(montgomeryLaunch.humanBinding?.sideID, MontySideID.montgomery)
        XCTAssertEqual(montgomeryLaunch.aiBinding?.sideID, MontySideID.opposition)
        XCTAssertEqual(axisLaunch.humanBinding?.sideID, MontySideID.opposition)
        XCTAssertEqual(axisLaunch.aiBinding?.sideID, MontySideID.montgomery)
    }

    @MainActor
    func testMontyBattleSelectionCanUseSharedSidePickerDropdown() throws {
        let scenario = try XCTUnwrap(MontyBattleCatalog.scenario(id: .alamElHalfa))
        let picker = HistoricalBattleSidePicker(
            scenario: scenario,
            selectedSideID: .constant(MontySideID.montgomery),
            accessibilityIdentifier: MontyAccessibilityID.battleSideSelector,
            optionAccessibilityIDPrefix: "monty-side"
        )

        XCTAssertEqual(HistoricalBattleSidePickerDefaults.accessibilityIdentifier, MontyAccessibilityID.battleSideSelector)
        XCTAssertEqual(scenario.sideOptions.map(\.id), [MontySideID.montgomery, MontySideID.opposition])
        XCTAssertEqual(MontyAccessibilityID.side(MontySideID.montgomery), "monty-side-\(MontySideID.montgomery)")
        XCTAssertTrue(String(describing: type(of: picker)).contains("HistoricalBattleSidePicker"))
    }

    func testAlamElHalfaAutoplayContractAndAIPlansUseSharedHistoricalHarnessShape() {
        let config = MontyAlamElHalfaDataPack.autoplayConfiguration

        XCTAssertEqual(config.battleID, .alamElHalfa)
        XCTAssertEqual(config.seed, MontyAlamElHalfaDataPack.defaultSeed)
        XCTAssertEqual(config.contract.embeddedBattleSurfaceName, HistoricalPlayableSurfaceCatalog.sharedHostSurfaceName)
        XCTAssertTrue(config.contract.isFirstBattleAutoplayContract)
        XCTAssertEqual(config.sidePlans.map(\.sideID), [MontySideID.montgomery, MontySideID.opposition])
        XCTAssertTrue(config.sidePlans[0].movementPriorityNames.contains("Hold Alam el Halfa ridge"))
        XCTAssertTrue(config.sidePlans[1].movementPriorityNames.contains("Break onto the ridge"))
        XCTAssertGreaterThanOrEqual(config.maxPhaseAdvances, 24)
    }

    func testAllDemoDataPacksExposeBattleSpecificAutoplayPriorities() throws {
        let packs = MontyDemoDataPackCatalog.all

        XCTAssertEqual(packs.map(\.scenario.id), MontyBattleCatalog.demoBattleIDs)

        for pack in packs {
            XCTAssertTrue(pack.isDemoReady, pack.scenario.title)
            XCTAssertEqual(pack.autoplayConfiguration.battleID, pack.scenario.id)
            XCTAssertEqual(pack.autoplayConfiguration.contract.embeddedBattleSurfaceName, HistoricalPlayableSurfaceCatalog.sharedHostSurfaceName)
            XCTAssertEqual(Set(pack.autoplayConfiguration.sidePlans.map(\.sideID)), [MontySideID.montgomery, MontySideID.opposition], pack.scenario.title)
            XCTAssertFalse(pack.autoplayConfiguration.sidePlans.flatMap(\.movementPriorityNames).isEmpty, pack.scenario.title)
            XCTAssertEqual(Set(pack.forceGroups.map(\.sideID)), [MontySideID.montgomery, MontySideID.opposition], pack.scenario.title)
            XCTAssertGreaterThanOrEqual(pack.debriefLines.count, 3, pack.scenario.title)
        }

        let secondAlamein = try XCTUnwrap(MontyDemoDataPackCatalog.dataPack(for: .secondElAlamein))
        let epsom = try XCTUnwrap(MontyDemoDataPackCatalog.dataPack(for: .operationEpsom))

        XCTAssertTrue(secondAlamein.scenario.map.elements.contains { $0.kind == .minefield && $0.name.contains("Devil") })
        XCTAssertTrue(secondAlamein.scenario.objectives.contains { $0.name == "Open the armoured route" })
        XCTAssertTrue(epsom.scenario.map.elements.contains { $0.kind == .river && $0.name.contains("Odon") })
        XCTAssertTrue(epsom.scenario.objectives.contains { $0.name == "Pressure Hill 112" })
    }

    func testLaunchFlowRoutesEveryDemoBattleFromSideSelectionToDebriefPersistence() throws {
        for battleID in MontyBattleCatalog.demoBattleIDs {
            for sideID in [MontySideID.montgomery, MontySideID.opposition] {
                var progress = MontyCampaignProgress()
                let flow = try MontyLaunchFlowResolver.makeLaunchFlow(
                    battleID: battleID,
                    chosenSideID: sideID
                )
                let record = MontyLaunchFlowResolver.complete(
                    flow,
                    progress: &progress,
                    winningSideID: sideID
                )

                XCTAssertEqual(flow.scenario.id, battleID)
                XCTAssertEqual(flow.chosenSideID, sideID)
                XCTAssertEqual(flow.launch.humanBinding?.sideID, sideID)
                XCTAssertEqual(flow.stages, MontyLaunchFlowStage.allCases)
                XCTAssertTrue(flow.isReadyForSharedBattleSurface, flow.scenario.title)
                XCTAssertTrue(flow.requiredAccessibilityIdentifiers.contains("monty-shared-battle-surface-\(battleID.rawValue)"))
                XCTAssertEqual(record.battleID, battleID)
                XCTAssertEqual(record.chosenSideID, sideID)
                XCTAssertEqual(progress.completionRecord(for: battleID), record)
                XCTAssertEqual(progress.lastSelectedSideByBattle[battleID], sideID)
            }
        }
    }

    func testDemoBoardSessionExposesLegalActionsForEveryDemoBattleAndSide() throws {
        for battleID in MontyBattleCatalog.demoBattleIDs {
            for sideID in [MontySideID.montgomery, MontySideID.opposition] {
                let session = try MontyDemoBoardSession(
                    battleID: battleID,
                    chosenSideID: sideID
                )
                let opening = session.snapshot()

                XCTAssertEqual(opening.battleID, battleID)
                XCTAssertEqual(opening.activeSideID, sideID)
                XCTAssertEqual(opening.phase, .movement)
                XCTAssertGreaterThanOrEqual(opening.units.count, 4, opening.mission.name)
                XCTAssertGreaterThanOrEqual(opening.zones.count, 6, opening.mission.name)
                XCTAssertGreaterThanOrEqual(opening.objectives.count, 4, opening.mission.name)
                XCTAssertTrue(opening.units.contains { $0.sideID == sideID && $0.canMoveNow }, opening.mission.name)

                session.selectFirstActiveUnit()
                session.selectNearestEnemyToSelectedUnit()
                XCTAssertTrue(session.moveSelectedUnitTowardNearestObjective(maxDistance: 3), opening.mission.name)
                session.advancePhase()
                XCTAssertEqual(session.snapshot().phase, .shooting)
                session.selectFirstActiveUnit()
                session.selectNearestEnemyToSelectedUnit()
                XCTAssertTrue(session.shootSelectedTarget(), opening.mission.name)
                XCTAssertTrue(session.resolveFirstPendingChoice(), opening.mission.name)
            }
        }
    }

    func testHistoricalAutoplayRunsEveryDemoBattleFromEitherSideToDebrief() throws {
        let results = try MontyDemoAutoplayRunner.runAllDemoBattlesForBothSides()

        XCTAssertEqual(results.count, MontyBattleCatalog.demoBattleIDs.count * 2)
        XCTAssertEqual(Set(results.map(\.flow.scenario.id)), Set(MontyBattleCatalog.demoBattleIDs))
        XCTAssertEqual(Set(results.map(\.flow.chosenSideID)), [MontySideID.montgomery, MontySideID.opposition])

        for result in results {
            XCTAssertTrue(result.report.completedToDebrief, result.report.finalResultSummary)
            XCTAssertTrue(result.report.bothSidesActed, result.report.finalResultSummary)
            XCTAssertEqual(result.report.surfaceName, result.flow.autoplayConfiguration.contract.primarySurfaceName)
            XCTAssertEqual(result.report.embeddedBattleSurfaceName, HistoricalPlayableSurfaceCatalog.sharedHostSurfaceName)
            XCTAssertEqual(result.completionRecord.battleID, result.flow.scenario.id)
            XCTAssertEqual(result.completionRecord.chosenSideID, result.flow.chosenSideID)
            XCTAssertEqual(result.progress.completionRecord(for: result.flow.scenario.id), result.completionRecord)
            XCTAssertEqual(result.progress.lastSelectedSideByBattle[result.flow.scenario.id], result.flow.chosenSideID)
        }
    }

    func testMontyTestFirstBattleControllerAutoplaysAlamElHalfaToDebrief() throws {
        let controller = try MontyTestFirstBattleRunController()

        XCTAssertEqual(controller.flow.scenario.id, .alamElHalfa)
        XCTAssertEqual(controller.openingSnapshot.activeSideID, MontySideID.montgomery)
        XCTAssertEqual(controller.runState, .ready)

        let firstStep = try XCTUnwrap(controller.stepOnce())
        XCTAssertEqual(firstStep.battleID, .alamElHalfa)
        XCTAssertEqual(controller.runState, .paused)
        XCTAssertGreaterThan(controller.steps.count, 0)

        let result = try controller.runToDebrief()
        XCTAssertEqual(controller.runState, .completed)
        XCTAssertTrue(result.report.completedToDebrief)
        XCTAssertTrue(result.report.bothSidesActed)
        XCTAssertEqual(result.completionRecord.battleID, .alamElHalfa)
        XCTAssertEqual(controller.progress.completionRecord(for: .alamElHalfa), result.completionRecord)
    }

    func testCycle120DemoAcceptanceReportIsReady() throws {
        let report = try MontyDemoAcceptanceCatalog.report()

        XCTAssertTrue(report.isReady)
        XCTAssertEqual(report.cycleStart, 101)
        XCTAssertEqual(report.cycleEnd, 120)
        XCTAssertEqual(report.runCount, 6)
        XCTAssertEqual(report.completedRunCount, report.runCount)
        XCTAssertEqual(report.bothSidesActedRunCount, report.runCount)
        XCTAssertEqual(report.testedSideIDs, [MontySideID.montgomery, MontySideID.opposition])
    }

    func testLaunchFlowRejectsNonDemoBattlesUntilTheyHaveDataPacks() {
        XCTAssertThrowsError(
            try MontyLaunchFlowResolver.makeLaunchFlow(
                battleID: .battleOfFrance,
                chosenSideID: MontySideID.montgomery
            )
        ) { error in
            XCTAssertEqual(error as? MontyLaunchFlowError, .missingDemoDataPack(.battleOfFrance))
        }
    }

    func testMontyAppIdentityUsesStableStorageKeysAndSharedSurfaceName() {
        XCTAssertEqual(MontyAppIdentity.appName, "Monty")
        XCTAssertEqual(MontyAppIdentity.bundleIdentifier, "com.barbalet.monty")
        XCTAssertTrue(MontyAppIdentity.campaignProgressStorageKey.hasPrefix("com.barbalet.monty"))
        XCTAssertTrue(MontyAppIdentity.selectedSideStorageKey.hasPrefix("com.barbalet.monty"))
        XCTAssertEqual(MontyAppIdentity.sharedBattleSurfaceName, HistoricalPlayableSurfaceCatalog.sharedHostSurfaceName)
    }

    func testCycle132AccessibilityCatalogCoversPlayableBoardControlsAndMontyTest() {
        let identifiers = MontyAccessibilityCatalog.cycle132RequiredIdentifiers

        XCTAssertTrue(identifiers.contains(MontyAccessibilityID.campaignList))
        XCTAssertTrue(identifiers.contains(MontyAccessibilityID.battleScreen))
        XCTAssertTrue(identifiers.contains(MontyAccessibilityID.battleBoard))
        XCTAssertTrue(identifiers.contains(MontyAccessibilityID.battleSidebar))
        XCTAssertTrue(identifiers.contains(MontyAccessibilityID.battleActionFeedback))
        XCTAssertTrue(identifiers.contains(MontyAccessibilityID.battleObjectives))
        XCTAssertTrue(identifiers.contains(MontyAccessibilityID.battleLog))
        XCTAssertTrue(identifiers.contains(MontyAccessibilityID.battleNextPhaseButton))
        XCTAssertTrue(identifiers.contains(MontyAccessibilityID.battleAITurnButton))
        XCTAssertTrue(identifiers.contains(MontyAccessibilityID.battleDebriefPanel))
        XCTAssertTrue(identifiers.contains(MontyAccessibilityID.battlePersistedResult))
        XCTAssertTrue(identifiers.contains(MontyAccessibilityID.montyTestFirstBattleAutoplay))
        XCTAssertTrue(identifiers.contains(MontyAccessibilityID.montyTestResultSummary))

        for battleID in MontyBattleCatalog.demoBattleIDs {
            let flowIdentifiers = MontyAccessibilityCatalog.launchFlowIdentifiers(
                battleID: battleID,
                chosenSideID: MontySideID.montgomery
            )
            XCTAssertTrue(flowIdentifiers.contains(MontyAccessibilityID.sharedBattleSurface(battleID)))
            XCTAssertTrue(flowIdentifiers.contains(MontyAccessibilityID.persistedResult(battleID)))
            XCTAssertTrue(flowIdentifiers.contains(MontyAccessibilityID.battleBoard))
        }
    }

    func testCycle138ScreenshotQATargetsCoverCampaignBoardDebriefAndMontyTest() {
        let targets = MontyScreenshotQACatalog.targets

        XCTAssertTrue(MontyScreenshotQACatalog.isReady)
        XCTAssertEqual(MontyScreenshotQACatalog.cycleRange, 133...138)
        XCTAssertEqual(targets.count, 17)
        XCTAssertTrue(targets.allSatisfy(\.hasStableViewport))
        XCTAssertTrue(targets.contains { $0.surface == .campaign && $0.requiredAccessibilityIdentifiers.contains(MontyAccessibilityID.campaignList) })
        XCTAssertTrue(targets.contains { $0.surface == .montyTest && $0.requiredAccessibilityIdentifiers.contains(MontyAccessibilityID.montyTestResultSummary) })

        for battleID in MontyBattleCatalog.demoBattleIDs {
            XCTAssertTrue(targets.contains { $0.battleID == battleID && $0.surface == .briefing })
            XCTAssertTrue(targets.contains { $0.battleID == battleID && $0.surface == .sideSelection })
            XCTAssertTrue(targets.contains { $0.battleID == battleID && $0.surface == .playableBoard && $0.viewport == .desktop })
            XCTAssertTrue(targets.contains { $0.battleID == battleID && $0.surface == .playableBoard && $0.viewport == .compact })
            XCTAssertTrue(targets.contains { $0.battleID == battleID && $0.surface == .debrief })
        }
    }

    func testCycle140UIAutomationScriptsDriveDemoBattlesThroughActions() throws {
        let scripts = MontyUIAutomationCatalog.scripts
        let results = try MontyUIAutomationRunner.runAll()

        XCTAssertTrue(MontyUIAutomationCatalog.isReady)
        XCTAssertEqual(MontyUIAutomationCatalog.cycleRange, 139...140)
        XCTAssertEqual(scripts.count, MontyBattleCatalog.demoBattleIDs.count * 2)
        XCTAssertEqual(results.count, scripts.count)

        for result in results {
            XCTAssertTrue(result.passed, result.finalResultSummary)
            XCTAssertTrue(result.completedToDebrief, result.finalResultSummary)
            XCTAssertTrue(result.bothSidesActed, result.finalResultSummary)
            XCTAssertTrue(result.persistedResult, result.finalResultSummary)
            XCTAssertTrue(result.observedAccessibilityIdentifiers.contains(MontyAccessibilityID.battleMoveButton))
            XCTAssertTrue(result.observedAccessibilityIdentifiers.contains(MontyAccessibilityID.battleShootButton))
            XCTAssertTrue(result.observedAccessibilityIdentifiers.contains(MontyAccessibilityID.battleAssaultButton))
            XCTAssertTrue(result.observedAccessibilityIdentifiers.contains(MontyAccessibilityID.battleAITurnButton))
            XCTAssertTrue(result.observedAccessibilityIdentifiers.contains(MontyAccessibilityID.battlePersistedResult))
        }
    }

    func testCycle140VisualAccessibilityAndUIQAAcceptanceReportIsReady() throws {
        let report = try MontyCycle140AcceptanceCatalog.report()

        XCTAssertTrue(report.isReady, report.blockers.joined(separator: "\n"))
        XCTAssertTrue(MontyCycle140AcceptanceCatalog.acceptanceReadyThroughCycle140)
        XCTAssertEqual(report.cycleStart, 121)
        XCTAssertEqual(report.cycleEnd, 140)
        XCTAssertTrue(report.visualAuditPassed)
        XCTAssertEqual(report.automationScriptCount, MontyBattleCatalog.demoBattleIDs.count * 2)
        XCTAssertEqual(report.automationPassedCount, report.automationScriptCount)
    }

    func testCycle144ExtendedUIAutomationCoversAssaultAndBothSides() throws {
        let report = MontyExtendedUIAutomationCatalog.report

        XCTAssertTrue(report.isReady)
        XCTAssertTrue(MontyExtendedUIAutomationCatalog.isReady)
        XCTAssertEqual(report.cycleRange, 141...144)
        XCTAssertEqual(report.scriptCount, MontyBattleCatalog.demoBattleIDs.count * 2)
        XCTAssertTrue(report.scriptsCoverAssault)
        XCTAssertTrue(report.scriptsCoverBothSides)
        XCTAssertTrue(report.scriptsCoverAllDemoBattles)
    }

    func testCycle150InteractionPolishReportCoversCompactBoardControlsAndFeedback() {
        let report = MontyInteractionPolishCatalog.report

        XCTAssertTrue(report.isReady, report.blockers.joined(separator: "\n"))
        XCTAssertTrue(MontyInteractionPolishCatalog.isReady)
        XCTAssertEqual(report.cycleRange, 145...150)
        XCTAssertEqual(Set(report.requirements), Set(MontyInteractionPolishRequirement.allCases))
        XCTAssertEqual(report.compactBoardTargetCount, MontyBattleCatalog.demoBattleIDs.count)
        XCTAssertTrue(report.requiredControlIdentifiers.contains(MontyAccessibilityID.battleActionFeedback))
        XCTAssertTrue(report.requiredControlIdentifiers.contains(MontyAccessibilityID.battleRestartButton))
    }

    func testCycle156BuildMatrixCatalogCoversRootDZWGuderianAndXcodeSchemes() {
        let report = MontyBuildMatrixCatalog.report

        XCTAssertTrue(report.isReady)
        XCTAssertTrue(MontyBuildMatrixCatalog.isReady)
        XCTAssertEqual(report.cycleRange, 151...156)
        XCTAssertEqual(Set(report.commands.map(\.id)), Set(MontyVerificationCommandID.allCases))
        XCTAssertTrue(report.commands.contains { $0.workingDirectory == "." && $0.command == "swift test" })
        XCTAssertTrue(report.commands.contains { $0.workingDirectory == "guderian/dzw" && $0.command == "swift test" })
        XCTAssertTrue(report.commands.contains { $0.workingDirectory == "guderian" && $0.command == "swift build" })
        XCTAssertTrue(report.commands.contains { $0.command.contains("Monty.xcodeproj") && $0.command.contains("-scheme Monty") })
    }

    func testCycle160CampaignProgressCodecRoundTripsAndRejectsGuderianPayload() throws {
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
            score: 12,
            completedTurn: 2
        )

        let encoded = try MontyCampaignProgressCodec.encode(progress)
        let decoded = try MontyCampaignProgressCodec.decode(encoded)

        XCTAssertEqual(decoded, progress)
        XCTAssertEqual(decoded.lastSelectedSideByBattle[.alamElHalfa], MontySideID.opposition)
        XCTAssertEqual(decoded.completionRecord(for: .alamElHalfa), completion)
        XCTAssertFalse(MontyAppIdentity.campaignProgressStorageKey.localizedCaseInsensitiveContains("guderian"))

        let wrongAppPayload = encoded.replacingOccurrences(
            of: MontyAppIdentity.bundleIdentifier,
            with: "com.barbalet.guderian"
        )
        XCTAssertThrowsError(try MontyCampaignProgressCodec.decode(wrongAppPayload)) { error in
            XCTAssertEqual(error as? MontyProgressCodecError, .wrongApplication("com.barbalet.guderian"))
        }
    }

    func testCycle160SaveLoadHardeningAndAcceptanceReportAreReady() throws {
        let saveLoad = try MontySaveLoadHardeningCatalog.report()
        let acceptance = try MontyCycle160AcceptanceCatalog.report()

        XCTAssertTrue(saveLoad.isReadyThroughCycle160)
        XCTAssertTrue(MontySaveLoadHardeningCatalog.isReadyThroughCycle160)
        XCTAssertTrue(acceptance.isReady, acceptance.blockers.joined(separator: "\n"))
        XCTAssertTrue(MontyCycle160AcceptanceCatalog.acceptanceReadyThroughCycle160)
        XCTAssertEqual(acceptance.cycleStart, 141)
        XCTAssertEqual(acceptance.cycleEnd, 160)
        XCTAssertTrue(acceptance.extendedUIAutomationReady)
        XCTAssertTrue(acceptance.interactionPolishReady)
        XCTAssertTrue(acceptance.buildMatrixReady)
        XCTAssertTrue(acceptance.saveLoadReady)
    }

    func testHistoricalPlayableSurfaceCatalogPublishesRealSwiftUIView() {
        XCTAssertEqual(HistoricalPlayableSurfaceCatalog.publicSwiftUISurfaceName, "HistoricalPlayableBattleView")
        XCTAssertTrue(HistoricalPlayableSurfaceCatalog.hasPublicSwiftUIBattleSurface)
        XCTAssertTrue(HistoricalPlayableSurfaceCatalog.dzwStyleBattleSurface.sharedComponentNames.contains("HistoricalPlayableBattleView"))
    }

    func testCycle162RelaunchRehearsalCoversEveryDemoBattleAndSide() throws {
        let report = try MontyRelaunchRehearsalCatalog.report()

        XCTAssertTrue(report.isReadyThroughCycle162)
        XCTAssertTrue(MontyRelaunchRehearsalCatalog.isReadyThroughCycle162)
        XCTAssertEqual(report.cycleRange, 161...162)
        XCTAssertEqual(report.cases.count, MontyBattleCatalog.demoBattleIDs.count * 2)
        XCTAssertTrue(report.allDemoBattlesCovered)
        XCTAssertTrue(report.bothSidesCovered)
        XCTAssertTrue(report.rejectsWrongApplicationPayload)
        XCTAssertTrue(report.cases.allSatisfy(\.passed))
    }

    func testCycle168DocumentationCleanupReportCoversPublicCloseoutDocs() {
        let report = MontyDocumentationCleanupCatalog.report

        XCTAssertTrue(report.isReadyThroughCycle168, report.blockers.joined(separator: "\n"))
        XCTAssertTrue(MontyDocumentationCleanupCatalog.isReadyThroughCycle168)
        XCTAssertEqual(report.cycleRange, 163...168)
        XCTAssertEqual(Set(report.artifacts), Set(MontyDocumentationArtifact.allCases))
        XCTAssertEqual(Set(report.requirements), Set(MontyDocumentationRequirement.allCases))
        XCTAssertTrue(report.requirements.contains(.publicHistoricalPlayableBattleView))
        XCTAssertTrue(report.requirements.contains(.zeroCyclesRemaining))
    }

    func testCycle174FinalDemoRehearsalReachesDebriefThroughSharedSurface() throws {
        let report = try MontyFinalDemoRehearsalCatalog.report()

        XCTAssertTrue(report.isReadyThroughCycle174, report.blockers.joined(separator: "\n"))
        XCTAssertTrue(MontyFinalDemoRehearsalCatalog.isReadyThroughCycle174)
        XCTAssertEqual(report.cycleRange, 169...174)
        XCTAssertEqual(report.uiAutomationRunCount, MontyBattleCatalog.demoBattleIDs.count * 2)
        XCTAssertEqual(report.uiAutomationPassedCount, report.uiAutomationRunCount)
        XCTAssertEqual(report.autoplayCompletedCount, report.autoplayRunCount)
        XCTAssertEqual(report.autoplayBothSidesActedCount, report.autoplayRunCount)
        XCTAssertTrue(report.montyTestCompleted)
        XCTAssertTrue(report.montyTestEmbedsSharedSurface)
        XCTAssertEqual(report.sharedSwiftUISurfaceName, HistoricalPlayableSurfaceCatalog.sharedHostSurfaceName)
    }

    func testCycle180FinalAcceptanceReportIsReadyAndLeavesNoCyclesRemaining() throws {
        let report = try MontyCycle180AcceptanceCatalog.report()

        XCTAssertTrue(report.isReady, report.blockers.joined(separator: "\n"))
        XCTAssertTrue(MontyCycle180AcceptanceCatalog.acceptanceReadyThroughCycle180)
        XCTAssertEqual(report.cycleStart, 161)
        XCTAssertEqual(report.cycleEnd, 180)
        XCTAssertEqual(report.cyclesRemaining, 0)
        XCTAssertEqual(Set(report.passedGates), Set(MontyFinalAcceptanceGate.allCases))
        XCTAssertEqual(Set(report.verificationCommands.map(\.id)), Set(MontyVerificationCommandID.allCases))
        XCTAssertTrue(report.verificationCommands.allSatisfy { $0.status == .passed })
        XCTAssertFalse(report.knownLimitations.isEmpty)
    }

    func testCycle210DirectBoardSelectionTargetsAndClearsThroughSharedResolver() throws {
        let session = try MontyDemoBoardSession(
            battleID: .alamElHalfa,
            chosenSideID: MontySideID.montgomery
        )
        let opening = session.snapshot()
        let activeUnit = try XCTUnwrap(opening.units.first { $0.sideID == opening.activeSideID })
        let opposingUnit = try XCTUnwrap(opening.units.first { $0.sideID != opening.activeSideID })

        XCTAssertEqual(
            HistoricalBoardInteractionResolver.unitTapIntent(for: activeUnit, in: opening),
            .selectUnit(activeUnit.id)
        )
        XCTAssertEqual(
            HistoricalBoardInteractionResolver.unitTapIntent(for: opposingUnit, in: opening),
            .selectTarget(opposingUnit.id)
        )

        session.selectUnit(activeUnit.id)
        var selected = session.snapshot()
        XCTAssertEqual(selected.units.first(where: \.selected)?.id, activeUnit.id)

        session.selectTarget(opposingUnit.id)
        selected = session.snapshot()
        XCTAssertEqual(selected.units.first(where: \.targeted)?.id, opposingUnit.id)

        session.clearSelection()
        let cleared = session.snapshot()
        XCTAssertFalse(cleared.units.contains(where: \.selected))
        XCTAssertFalse(cleared.units.contains(where: \.targeted))
        XCTAssertEqual(cleared.lastAction.title, "Selection cleared")
    }

    func testCycle210CriticalPlayabilityReportTracksGuderianBoundaryAndRemainingWork() {
        let report = MontyCycle210CriticalPlayabilityCatalog.report()

        XCTAssertTrue(report.isReadyThroughCycle210)
        XCTAssertTrue(MontyCycle210CriticalPlayabilityCatalog.isReadyThroughCycle210)
        XCTAssertEqual(report.cycleStart, 181)
        XCTAssertEqual(report.cycleEnd, 210)
        XCTAssertEqual(report.cyclesRemaining, 30)
        XCTAssertEqual(Set(report.completedRequirements), Set(MontyCriticalPlayabilityRequirement.allCases))
        XCTAssertEqual(Set(report.guderianBoundaryFiles), Set(MontyGuderianGameplayBoundary.allCases))
        XCTAssertTrue(MontyGuderianGameplayBoundary.nativeBoardSession.sourcePath.contains("NativeBoardSession.swift"))
        XCTAssertTrue(HistoricalPlayableSurfaceCatalog.boardInteractionProfile.supportsGuderianStyleBoardCommands)
        XCTAssertTrue(HistoricalPlayableSurfaceCatalog.boardReadabilityProfile.preventsDenseAlwaysOnBoardText)
        XCTAssertTrue(report.deferredRisks.contains { $0.contains("MontyDemoBoardSession") })
    }

    func testCycle240ReadabilityAuditsCoverEveryDemoBattleFromBothSides() throws {
        let cases = try MontyCycle240CriticalAcceptanceCatalog.readabilityCases()

        XCTAssertEqual(cases.count, MontyBattleCatalog.demoBattleIDs.count * 2)
        XCTAssertEqual(Set(cases.map(\.battleID)), Set(MontyBattleCatalog.demoBattleIDs))
        XCTAssertEqual(Set(cases.map(\.sideID)), [MontySideID.montgomery, MontySideID.opposition])
        XCTAssertTrue(cases.allSatisfy(\.passed))
        XCTAssertTrue(cases.allSatisfy { $0.audit.directBoardNameLabelCount == 0 })
        XCTAssertTrue(cases.allSatisfy { $0.audit.estimatedOverlappingTokenPairs == 0 })
        XCTAssertTrue(cases.allSatisfy { $0.audit.usesIDOnlyUnitTokens })
    }

    func testCycle240CriticalAcceptanceReportIsReadyAndLeavesNoCyclesRemaining() throws {
        let report = try MontyCycle240CriticalAcceptanceCatalog.report()

        XCTAssertTrue(report.isReadyThroughCycle240)
        XCTAssertTrue(MontyCycle240CriticalAcceptanceCatalog.isReadyThroughCycle240)
        XCTAssertEqual(report.cycleStart, 211)
        XCTAssertEqual(report.cycleEnd, 240)
        XCTAssertEqual(report.cyclesRemaining, 0)
        XCTAssertEqual(Set(report.completedRequirements), Set(MontyCriticalAcceptanceRequirement.allCases))
        XCTAssertEqual(report.readabilityCases.count, MontyBattleCatalog.demoBattleIDs.count * 2)
        XCTAssertEqual(report.autoplayRunCount, MontyBattleCatalog.demoBattleIDs.count * 2)
        XCTAssertEqual(report.autoplayCompletedCount, report.autoplayRunCount)
        XCTAssertEqual(report.autoplayBothSidesActedCount, report.autoplayRunCount)
        XCTAssertTrue(HistoricalPlayableSurfaceCatalog.boardViewportProfile.isCriticalViewportReady)
        XCTAssertTrue(report.visualSmokeArtifacts.contains { $0.path.contains("cycle240") })
        XCTAssertFalse(report.knownLimitations.isEmpty)
    }

    func testOrderDiceCycle20MigrationReportAuditsCurrentPhaseDrivenGap() {
        let report = MontyOrderDiceCycle20Catalog.report()

        XCTAssertTrue(report.isReadyThroughCycle20, report.defaultReadinessBlockers.joined(separator: "\n"))
        XCTAssertTrue(MontyOrderDiceCycle20Catalog.isReadyThroughOrderDiceCycle20)
        XCTAssertFalse(report.isDefaultOrderDiceReady)
        XCTAssertEqual(report.cycleStart, 1)
        XCTAssertEqual(report.cycleEnd, 20)
        XCTAssertEqual(report.cyclesRemaining, 180)
        XCTAssertTrue(report.rulesReferenceURL.contains("bolt_action_reference.pdf"))
        XCTAssertEqual(report.documentationPath, "docs/monty_order_dice_cycle_001_020.md")
        XCTAssertEqual(Set(report.auditedDependencies.map(\.area)), Set(MontyOrderDiceMigrationDependencyArea.allCases))
        XCTAssertEqual(Set(report.contractComparisons.map(\.gap)), Set(MontyOrderDiceContractGap.allCases))
        XCTAssertTrue(report.auditedDependencies.contains { $0.area == .montyDemoBoardSession && $0.containsLegacyPhaseAssumption })
        XCTAssertTrue(report.contractComparisons.contains { $0.gap == .orderAssignmentNotImplemented && $0.blocksDefaultOrderDiceReadiness })
        XCTAssertTrue(report.contractComparisons.contains { $0.gap == .phaseGatedMovement && $0.blocksDefaultOrderDiceReadiness })
        XCTAssertTrue(report.contractComparisons.contains { $0.gap == .phaseGatedShooting && $0.blocksDefaultOrderDiceReadiness })
        XCTAssertTrue(report.contractComparisons.contains { $0.gap == .phaseGatedAssault && $0.blocksDefaultOrderDiceReadiness })
        XCTAssertTrue(report.defaultReadinessBlockers.contains { $0.contains("issueOrder") })
    }

    func testOrderDiceCycle20CompatibilityGateRecordsOriginalSessionGap() throws {
        let session = try MontyDemoBoardSession(
            battleID: .alamElHalfa,
            chosenSideID: MontySideID.montgomery
        )
        let opening = session.snapshot()
        let activeUnit = try XCTUnwrap(opening.units.first { $0.sideID == opening.activeSideID })

        XCTAssertEqual(opening.phase, .movement)

        session.selectUnit(activeUnit.id)
        XCTAssertTrue(session.issueOrderToSelectedUnit(.advance))
        XCTAssertEqual(session.snapshot().phase, .movement)

        let report = MontyOrderDiceCycle20Catalog.report()
        XCTAssertTrue(report.compatibilityGates.allSatisfy(\.passed))
        XCTAssertTrue(report.compatibilityGates.contains { $0.gate == .issueOrderAuditedAsNoOp && $0.blocksDefaultOrderDiceReadiness })
        XCTAssertTrue(report.compatibilityGates.contains { $0.gate == .dzwOrdersAvailable && !$0.blocksDefaultOrderDiceReadiness })
        XCTAssertTrue(report.compatibilityGates.contains { $0.gate == .sharedSurfaceAvailable && !$0.blocksDefaultOrderDiceReadiness })
        XCTAssertTrue(MontyOrderDiceCycle60Catalog.sessionAdapterContract.implementsIssueOrder)
    }

    func testOrderDiceCycle20ShimDecisionKeepsRulesOutOfMonty() {
        let report = MontyOrderDiceCycle20Catalog.report()

        XCTAssertEqual(Set(report.shimDecisions.map(\.component)), Set(MontyOrderDiceShimComponent.allCases))
        XCTAssertTrue(report.shimDecisions.allSatisfy { !$0.rulesAuthorityRemainsDownstream })
        XCTAssertTrue(report.shimDecisions.contains {
            $0.component == .montyDemoBoardSession &&
                $0.disposition == .keepAsThinCompatibilityAdapter
        })
        XCTAssertTrue(report.shimDecisions.contains {
            $0.component == .historicalPlayableBattleView &&
                $0.disposition == .consumeSharedDZWContract
        })
        XCTAssertTrue(report.shimDecisions.contains {
            $0.component == .montyRunToDebriefControls &&
                $0.disposition == .quarantineAsLegacyHelper
        })
    }

    func testOrderDiceCycle40SideOwnershipMapsSelectedSideToHumanDrawnDice() throws {
        let cases = try MontyOrderDiceCycle40Catalog.sideOwnershipCases()

        XCTAssertEqual(cases.count, MontyBattleCatalog.demoBattleIDs.count * 4)
        XCTAssertEqual(Set(cases.map(\.battleID)), Set(MontyBattleCatalog.demoBattleIDs))

        for battleID in MontyBattleCatalog.demoBattleIDs {
            for chosenSideID in [MontySideID.montgomery, MontySideID.opposition] {
                let launchCases = cases.filter {
                    $0.battleID == battleID && $0.selectedHumanSideID == chosenSideID
                }
                XCTAssertEqual(launchCases.count, 2, "\(battleID.rawValue) \(chosenSideID)")
                XCTAssertEqual(launchCases.filter { $0.controller == .human }.map(\.sideID), [chosenSideID])
                XCTAssertEqual(launchCases.filter(\.canHumanControlDrawnDie).map(\.sideID), [chosenSideID])
                XCTAssertTrue(launchCases.allSatisfy { $0.orderDiceCount > 0 })
                XCTAssertEqual(Set(launchCases.map(\.enginePlayerSlot)), [.playerOne, .playerTwo])
            }
        }

        let secondAlameinMontgomery = try XCTUnwrap(cases.first {
            $0.battleID == .secondElAlamein &&
                $0.selectedHumanSideID == MontySideID.montgomery &&
                $0.sideID == MontySideID.montgomery
        })
        XCTAssertEqual(secondAlameinMontgomery.orderDiceCount, 3)
    }

    func testOrderDiceCycle40ForceProfilesAssignQualityWeaponsVehiclesPinsAndOrders() {
        let profiles = MontyOrderDiceCycle40Catalog.forceProfiles()

        XCTAssertEqual(profiles.count, MontyDemoDataPackCatalog.all.map(\.forceGroups.count).reduce(0, +))
        XCTAssertTrue(profiles.allSatisfy { !$0.weaponClasses.isEmpty })
        XCTAssertTrue(profiles.allSatisfy { !$0.recommendedOrders.isEmpty })

        let engineers = profiles.first { $0.forceGroupID == "alamein-engineers" }
        XCTAssertEqual(engineers?.pinBehavior, .rallyPriority)
        XCTAssertEqual(engineers?.officerModifier, 1)
        XCTAssertTrue(engineers?.weaponClasses.contains(.engineers) == true)
        XCTAssertTrue(engineers?.recommendedOrders.contains(.rally) == true)

        let antiTankScreen = profiles.first { $0.forceGroupID == "alam-anti-tank-screen" }
        XCTAssertEqual(antiTankScreen?.quality, .veteran)
        XCTAssertEqual(antiTankScreen?.vehicleClass, .artillery)
        XCTAssertTrue(antiTankScreen?.weaponClasses.contains(.antiTank) == true)
        XCTAssertTrue(antiTankScreen?.recommendedOrders.contains(.ambush) == true)

        let ssPanzer = profiles.first { $0.forceGroupID == "epsom-ss-panzer" }
        XCTAssertEqual(ssPanzer?.quality, .veteran)
        XCTAssertEqual(ssPanzer?.vehicleClass, .tank)
        XCTAssertEqual(ssPanzer?.pinBehavior, .counterattackRisk)
        XCTAssertTrue(ssPanzer?.recommendedOrders.contains(.run) == true)
    }

    func testOrderDiceCycle40TerrainProfilesClassifyRoadsCoverObstaclesAndMinefields() {
        let terrain = MontyOrderDiceCycle40Catalog.terrainProfiles()

        XCTAssertEqual(terrain.count, MontyDemoDataPackCatalog.all.map(\.scenario.map.elements.count).reduce(0, +))
        XCTAssertTrue(terrain.allSatisfy { !$0.classes.isEmpty })
        XCTAssertTrue(terrain.filter { $0.elementKind == .road }.allSatisfy(\.allowsRoadBonus))
        XCTAssertTrue(terrain.filter { $0.elementKind == .minefield }.allSatisfy { $0.blocksRun && $0.classes.contains(.minefield) })
        XCTAssertTrue(terrain.filter { $0.elementKind == .river }.allSatisfy { $0.blocksRun && $0.classes.contains(.impassable) })
        XCTAssertTrue(terrain.filter { $0.elementKind == .ridge }.allSatisfy { $0.blocksLineOfSight && $0.coverClass == .hardCover })

        XCTAssertTrue(terrain.contains { $0.battleID == .operationEpsom && $0.elementID == "epsom-odon-crossing" && $0.allowsRoadBonus })
        XCTAssertTrue(terrain.contains { $0.battleID == .secondElAlamein && $0.elementID == "alamein-devils-gardens" && $0.classes.contains(.minefield) })
    }

    func testOrderDiceCycle40PacingProfilesUseActivationBudgetsInsteadOfPhaseCounts() throws {
        let report = try MontyOrderDiceCycle40Catalog.report()

        XCTAssertTrue(report.isReadyThroughCycle40)
        XCTAssertTrue(MontyOrderDiceCycle40Catalog.isReadyThroughOrderDiceCycle40)
        XCTAssertEqual(report.cycleStart, 21)
        XCTAssertEqual(report.cycleEnd, 40)
        XCTAssertEqual(report.cyclesRemaining, 160)
        XCTAssertEqual(report.documentationPath, "docs/monty_order_dice_cycle_021_040.md")
        XCTAssertEqual(report.pacingProfiles.count, MontyBattleCatalog.demoBattleIDs.count)
        XCTAssertTrue(report.pacingProfiles.allSatisfy(\.debriefRequiresActivationCount))
        XCTAssertTrue(report.pacingProfiles.allSatisfy(\.phaseCountScoringDeprecated))

        let alam = try XCTUnwrap(report.pacingProfiles.first { $0.battleID == .alamElHalfa })
        XCTAssertEqual(alam.orderDicePerTurn, 4)
        XCTAssertEqual(alam.targetActivationBudget, 32)
        XCTAssertGreaterThanOrEqual(alam.activationSafetyCap, alam.targetActivationBudget)
        XCTAssertEqual(alam.objectiveVictoryPointsBySide[MontySideID.montgomery], 10)
        XCTAssertEqual(alam.objectiveVictoryPointsBySide[MontySideID.opposition], 5)

        let secondAlamein = try XCTUnwrap(report.pacingProfiles.first { $0.battleID == .secondElAlamein })
        XCTAssertEqual(secondAlamein.orderDicePerTurn, 5)
        XCTAssertEqual(secondAlamein.targetActivationBudget, 50)
        XCTAssertEqual(secondAlamein.objectiveVictoryPointsBySide[MontySideID.montgomery], 12)
    }

    func testOrderDiceCycle60LaunchFlowCarriesOrderDiceState() throws {
        let flow = try MontyLaunchFlowResolver.makeLaunchFlow(
            battleID: .secondElAlamein,
            chosenSideID: MontySideID.opposition
        )
        let state = flow.orderDiceLaunchState

        XCTAssertTrue(state.isReadyForOrderDiceLaunchFlow)
        XCTAssertEqual(state.battleID, .secondElAlamein)
        XCTAssertEqual(state.selectedHumanSideID, MontySideID.opposition)
        XCTAssertEqual(state.seed, flow.launch.seed)
        XCTAssertEqual(state.orderCup.count, flow.dataPack.forceGroups.count)
        XCTAssertEqual(state.orderCup.filter(\.humanControlledWhenDrawn).count, 2)
        XCTAssertEqual(state.sideOwnership.filter { $0.canHumanControlDrawnDie }.map(\.sideID), [MontySideID.opposition])
        XCTAssertTrue(flow.isReadyForSharedBattleSurface)
    }

    func testOrderDiceCycle60SessionIssuesOrdersAndExposesOrderSnapshots() throws {
        let session = try MontyDemoBoardSession(
            battleID: .alamElHalfa,
            chosenSideID: MontySideID.montgomery
        )
        let opening = session.snapshot()
        let activeUnits = opening.units.filter { $0.sideID == opening.activeSideID }.sorted { $0.id < $1.id }
        let firstUnit = try XCTUnwrap(activeUnits.first)
        let secondUnit = try XCTUnwrap(activeUnits.dropFirst().first)

        XCTAssertEqual(firstUnit.availableOrders, HistoricalBoardOrder.allCases)

        session.selectUnit(firstUnit.id)
        XCTAssertTrue(session.issueOrderToSelectedUnit(.advance))
        var afterAdvance = try XCTUnwrap(session.snapshot().units.first { $0.id == firstUnit.id })
        XCTAssertEqual(afterAdvance.currentOrder, .advance)
        XCTAssertTrue(afterAdvance.availableOrders.isEmpty)
        XCTAssertTrue(afterAdvance.canMoveNow)
        XCTAssertTrue(afterAdvance.canShootNow)
        XCTAssertTrue(afterAdvance.orderDiceSummary.contains("Advance"))

        session.selectUnit(secondUnit.id)
        XCTAssertTrue(session.issueOrderToSelectedUnit(.down))
        let afterDown = try XCTUnwrap(session.snapshot().units.first { $0.id == secondUnit.id })
        XCTAssertEqual(afterDown.currentOrder, .down)
        XCTAssertTrue(afterDown.retainedOrder)
        XCTAssertTrue(afterDown.downOrderActive)
        XCTAssertFalse(afterDown.ambushOrderActive)

        session.selectUnit(firstUnit.id)
        XCTAssertFalse(session.issueOrderToSelectedUnit(.run))
        afterAdvance = try XCTUnwrap(session.snapshot().units.first { $0.id == firstUnit.id })
        XCTAssertEqual(afterAdvance.currentOrder, .advance)
    }

    func testOrderDiceCycle60SharedSurfaceSessionAndControlsReportIsReady() throws {
        let report = try MontyOrderDiceCycle60Catalog.report()

        XCTAssertTrue(report.isReadyThroughCycle60)
        XCTAssertTrue(MontyOrderDiceCycle60Catalog.isReadyThroughOrderDiceCycle60)
        XCTAssertEqual(report.cycleStart, 41)
        XCTAssertEqual(report.cycleEnd, 60)
        XCTAssertEqual(report.cyclesRemaining, 140)
        XCTAssertEqual(report.documentationPath, "docs/monty_order_dice_cycle_041_060.md")
        XCTAssertTrue(report.launchStates.allSatisfy(\.isReadyForOrderDiceLaunchFlow))
        XCTAssertTrue(report.sharedUIContract.requiredOrderIdentifiers.contains(MontyAccessibilityID.battleOrderFireButton))
        XCTAssertTrue(report.sharedUIContract.requiredOrderIdentifiers.contains(MontyAccessibilityID.battleOrderDownButton))
        XCTAssertTrue(report.sessionAdapterContract.isReadyForCycle55)
        XCTAssertTrue(report.controlContract.isReadyForCycle60)
        XCTAssertTrue(MontyAccessibilityCatalog.sharedPlayableSurfaceIdentifiers.contains(MontyAccessibilityID.battleOrderRunButton))
    }
}
