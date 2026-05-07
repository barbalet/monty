@testable import MontyCore
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
}
