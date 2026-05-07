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

    func testDemoBattleScopeIsLockedAndAlamElHalfaDataPackIsReadyThroughCycle80() throws {
        XCTAssertEqual(
            MontyBattleCatalog.demoBattleIDs,
            [.alamElHalfa, .secondElAlamein, .operationEpsom]
        )

        let alam = try XCTUnwrap(MontyBattleCatalog.scenario(id: .alamElHalfa))
        let secondAlamein = try XCTUnwrap(MontyBattleCatalog.scenario(id: .secondElAlamein))
        let epsom = try XCTUnwrap(MontyBattleCatalog.scenario(id: .operationEpsom))

        XCTAssertEqual(alam.status, .dataLocked)
        XCTAssertEqual(secondAlamein.status, .catalogReady)
        XCTAssertEqual(epsom.status, .catalogReady)
        XCTAssertTrue(MontyAlamElHalfaDataPack.dataPack.isCycle80Ready)
        XCTAssertEqual(alam.map.elements.count, 6)
        XCTAssertEqual(alam.objectives.count, 4)
        XCTAssertEqual(Set(alam.objectives.compactMap(\.sideID)), [MontySideID.montgomery, MontySideID.opposition])
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

    func testMontyAppIdentityUsesStableStorageKeysAndSharedSurfaceName() {
        XCTAssertEqual(MontyAppIdentity.appName, "Monty")
        XCTAssertEqual(MontyAppIdentity.bundleIdentifier, "com.barbalet.monty")
        XCTAssertTrue(MontyAppIdentity.campaignProgressStorageKey.hasPrefix("com.barbalet.monty"))
        XCTAssertTrue(MontyAppIdentity.selectedSideStorageKey.hasPrefix("com.barbalet.monty"))
        XCTAssertEqual(MontyAppIdentity.sharedBattleSurfaceName, HistoricalPlayableSurfaceCatalog.sharedHostSurfaceName)
    }
}
