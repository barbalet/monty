public struct MontyBattleForceGroup: Identifiable, Codable, Hashable, Sendable {
    public let id: String
    public let sideID: String
    public let name: String
    public let role: String
    public let note: String

    public init(id: String, sideID: String, name: String, role: String, note: String) {
        self.id = id
        self.sideID = sideID
        self.name = name
        self.role = role
        self.note = note
    }
}

public struct MontyDebriefLine: Identifiable, Codable, Hashable, Sendable {
    public let id: String
    public let sideID: String
    public let trigger: String
    public let summary: String

    public init(id: String, sideID: String, trigger: String, summary: String) {
        self.id = id
        self.sideID = sideID
        self.trigger = trigger
        self.summary = summary
    }
}

public struct MontyDemoBattleDataPack: Codable, Hashable, Sendable {
    public let scenario: MontyBattleScenario
    public let forceGroups: [MontyBattleForceGroup]
    public let autoplayConfiguration: HistoricalAutoplayConfiguration<MontyBattleID>
    public let debriefLines: [MontyDebriefLine]

    public init(
        scenario: MontyBattleScenario,
        forceGroups: [MontyBattleForceGroup],
        autoplayConfiguration: HistoricalAutoplayConfiguration<MontyBattleID>,
        debriefLines: [MontyDebriefLine]
    ) {
        self.scenario = scenario
        self.forceGroups = forceGroups
        self.autoplayConfiguration = autoplayConfiguration
        self.debriefLines = debriefLines
    }

    public var isCycle80Ready: Bool {
        scenario.id == .alamElHalfa &&
            scenario.status == .dataLocked &&
            scenario.hasTwoPlayableSides &&
            scenario.map.elements.count >= 6 &&
            scenario.objectives.count >= 4 &&
            forceGroups.count >= 4 &&
            autoplayConfiguration.sidePlans.count == 2 &&
            debriefLines.count >= 3
    }
}

public enum MontyAlamElHalfaDataPack {
    public static let defaultSeed: UInt32 = 1_942_0830

    public static let scenario = MontyBattleScenario(
        id: .alamElHalfa,
        order: 3,
        title: "Battle of Alam el Halfa",
        dateLabel: "30 Aug-5 Sep 1942",
        theater: MontyCommandPhase.northAfricaTunisia.rawValue,
        status: .dataLocked,
        historicalResult: "British victory",
        designIntent: "Prepared ridge defence against an Axis outflanking attack. The Montgomery side wins by keeping the ridge, minefield belt, anti-tank screen, and air interdiction tempo intact; the Axis side wins by finding a flank route before fuel and time expire.",
        sourceLinks: [
            HistoricalSourceLink(
                title: "Battle of Alam el Halfa",
                url: "https://en.wikipedia.org/wiki/Battle_of_Alam_el_Halfa"
            ),
        ],
        sideOptions: [
            HistoricalSideOption(
                id: MontySideID.montgomery,
                role: .protagonist,
                title: "Montgomery's Eighth Army",
                historicalForce: "British Eighth Army, including New Zealand and armoured formations",
                commander: "Bernard Montgomery",
                armyListName: "British",
                playerBriefing: "Hold Alam el Halfa ridge, keep the anti-tank gun line coherent, and use air/artillery pressure to drain Axis momentum.",
                aiBriefing: "Defend ridge objectives, preserve anti-tank lanes, and avoid wasteful counter-thrusts."
            ),
            HistoricalSideOption(
                id: MontySideID.opposition,
                role: .opponent,
                title: "Panzerarmee Afrika",
                historicalForce: "German and Italian Panzer Army Africa under Erwin Rommel",
                commander: "Erwin Rommel",
                armyListName: "German",
                playerBriefing: "Probe minefields, push the southern flank, and break onto the ridge before fuel and daylight advantages disappear.",
                aiBriefing: "Probe for minefield gaps, pressure the southern approach, and avoid stalling in anti-tank lanes."
            ),
        ],
        map: HistoricalBattleMap(
            title: "Alam el Halfa ridge",
            elements: [
                HistoricalMapElement(
                    id: "alam-ridge",
                    name: "Alam el Halfa ridge",
                    kind: .ridge,
                    points: [
                        HistoricalBattleCoordinate(x: 24, y: 22),
                        HistoricalBattleCoordinate(x: 82, y: 24),
                    ],
                    note: "Primary defensive line and Montgomery-side victory anchor."
                ),
                HistoricalMapElement(
                    id: "alam-minefield-belt",
                    name: "Minefield belt",
                    kind: .minefield,
                    points: [
                        HistoricalBattleCoordinate(x: 18, y: 34),
                        HistoricalBattleCoordinate(x: 62, y: 38),
                    ],
                    note: "Axis movement friction and flank-channeling obstacle."
                ),
                HistoricalMapElement(
                    id: "alam-anti-tank-line",
                    name: "6-pounder anti-tank gun line",
                    kind: .phaseLine,
                    points: [
                        HistoricalBattleCoordinate(x: 34, y: 25),
                        HistoricalBattleCoordinate(x: 72, y: 27),
                    ],
                    note: "Prepared gun positions covering the ridge approaches."
                ),
                HistoricalMapElement(
                    id: "alam-southern-approach",
                    name: "Southern Axis approach",
                    kind: .road,
                    points: [
                        HistoricalBattleCoordinate(x: 10, y: 48),
                        HistoricalBattleCoordinate(x: 50, y: 36),
                    ],
                    note: "Primary Axis probe lane around the defensive boxes."
                ),
                HistoricalMapElement(
                    id: "alam-air-interdiction",
                    name: "Air interdiction zone",
                    kind: .other,
                    points: [
                        HistoricalBattleCoordinate(x: 44, y: 42),
                    ],
                    note: "Area where Montgomery-side air and artillery pressure can slow Axis tempo."
                ),
                HistoricalMapElement(
                    id: "alam-lateral-track",
                    name: "Ridge lateral track",
                    kind: .road,
                    points: [
                        HistoricalBattleCoordinate(x: 28, y: 18),
                        HistoricalBattleCoordinate(x: 82, y: 20),
                    ],
                    note: "Montgomery-side reserve movement and fallback route."
                ),
            ],
            deploymentZones: [
                HistoricalDeploymentZone(
                    id: "alam-eighth-army-boxes",
                    sideID: MontySideID.montgomery,
                    name: "Eighth Army prepared boxes",
                    origin: HistoricalBattleCoordinate(x: 30, y: 14),
                    width: 42,
                    height: 18,
                    note: "Prepared defensive boxes around the ridge and anti-tank line."
                ),
                HistoricalDeploymentZone(
                    id: "alam-axis-approach",
                    sideID: MontySideID.opposition,
                    name: "Axis southern approach",
                    origin: HistoricalBattleCoordinate(x: 6, y: 36),
                    width: 30,
                    height: 18,
                    note: "Axis entry lane for flank probes and armoured pressure."
                ),
            ]
        ),
        objectives: [
            HistoricalObjective(
                id: "alam-hold-ridge",
                name: "Hold Alam el Halfa ridge",
                sideID: MontySideID.montgomery,
                victoryPoints: 5,
                location: HistoricalBattleCoordinate(x: 58, y: 23),
                radius: 6,
                description: "Keep Axis armour off the ridge through the debrief trigger."
            ),
            HistoricalObjective(
                id: "alam-preserve-guns",
                name: "Preserve the anti-tank screen",
                sideID: MontySideID.montgomery,
                victoryPoints: 3,
                location: HistoricalBattleCoordinate(x: 54, y: 27),
                radius: 5,
                description: "Maintain the prepared 6-pounder line and avoid exposing reserves too early."
            ),
            HistoricalObjective(
                id: "alam-interdict-axis",
                name: "Disrupt Axis fuel tempo",
                sideID: MontySideID.montgomery,
                victoryPoints: 2,
                location: HistoricalBattleCoordinate(x: 44, y: 42),
                radius: 6,
                description: "Use air and artillery pressure to slow the Axis southern probe."
            ),
            HistoricalObjective(
                id: "alam-axis-breakthrough",
                name: "Break onto the ridge",
                sideID: MontySideID.opposition,
                victoryPoints: 5,
                location: HistoricalBattleCoordinate(x: 50, y: 25),
                radius: 6,
                description: "Find a minefield gap and place Axis armour on ridge ground before the clock closes."
            ),
        ],
        victory: HistoricalVictoryProfile(
            targetScore: 10,
            targetTurnUpperBound: 8,
            bands: [
                HistoricalVictoryBand(
                    id: "alam-axis-pressure",
                    label: "Axis pressure",
                    scoreRange: 0...4,
                    summary: "The Axis attack forces Montgomery's line to spend reserves and loses little tempo."
                ),
                HistoricalVictoryBand(
                    id: "alam-historical-defence",
                    label: "Historical defence",
                    scoreRange: 5...9,
                    summary: "The ridge holds and the battle follows the historical defensive pattern."
                ),
                HistoricalVictoryBand(
                    id: "alam-decisive-defence",
                    label: "Decisive defence",
                    scoreRange: 10...14,
                    summary: "The Axis probe is contained early and the Eighth Army keeps its reserve posture intact."
                ),
            ]
        ),
        tags: ["demo", "tutorial", "north-africa", "defensive", "data-pack"]
    )

    public static let forceGroups: [MontyBattleForceGroup] = [
        MontyBattleForceGroup(
            id: "alam-eighth-army-command",
            sideID: MontySideID.montgomery,
            name: "Eighth Army command net",
            role: "Defensive control",
            note: "Keeps prepared boxes, artillery timing, and reserve restraint synchronized."
        ),
        MontyBattleForceGroup(
            id: "alam-anti-tank-screen",
            sideID: MontySideID.montgomery,
            name: "6-pounder anti-tank screen",
            role: "Ridge defence",
            note: "Primary hard stop against Axis armour entering the ridge line."
        ),
        MontyBattleForceGroup(
            id: "alam-axis-vanguard",
            sideID: MontySideID.opposition,
            name: "Panzerarmee Afrika vanguard",
            role: "Flank probe",
            note: "Main Axis mobile pressure group seeking a southern approach."
        ),
        MontyBattleForceGroup(
            id: "alam-axis-support",
            sideID: MontySideID.opposition,
            name: "Italian and German support columns",
            role: "Sustain attack",
            note: "Keeps the probe supplied long enough to exploit a minefield gap."
        ),
    ]

    public static let autoplayConfiguration = HistoricalAutoplayConfiguration(
        battleID: MontyBattleID.alamElHalfa,
        battleTitle: scenario.title,
        seed: defaultSeed,
        contract: HistoricalAutoplayContract(
            primarySurfaceName: "MontyTestFirstBattleAutoplayView",
            requiredAccessibilityIdentifiers: [
                "monty-test-first-battle-autoplay",
                "monty-test-primary-battle-surface",
                "monty-test-run-to-debrief-button",
                "monty-test-step-button",
                "monty-test-pause-button",
                "monty-test-speed-picker",
                "monty-test-safety-cap",
                "monty-test-event-log",
                "monty-test-result-panel",
                "monty-test-result-summary",
            ]
        ),
        targetTurnUpperBound: scenario.victory.targetTurnUpperBound,
        sidePlans: [
            HistoricalAutoplaySidePlan(
                sideID: MontySideID.montgomery,
                controllerLabel: "Montgomery AI",
                movementPriorityNames: [
                    "Hold Alam el Halfa ridge",
                    "Preserve the anti-tank screen",
                    "Disrupt Axis fuel tempo",
                ],
                movementDistance: 4
            ),
            HistoricalAutoplaySidePlan(
                sideID: MontySideID.opposition,
                controllerLabel: "Axis AI",
                movementPriorityNames: [
                    "Break onto the ridge",
                    "Southern Axis approach",
                    "Minefield belt",
                ],
                movementDistance: 6
            ),
        ]
    )

    public static let debriefLines: [MontyDebriefLine] = [
        MontyDebriefLine(
            id: "alam-debrief-historical",
            sideID: MontySideID.montgomery,
            trigger: "ridge-held",
            summary: "The Eighth Army has held the ridge and converted prepared defence into operational tempo."
        ),
        MontyDebriefLine(
            id: "alam-debrief-axis-pressure",
            sideID: MontySideID.opposition,
            trigger: "ridge-contested",
            summary: "The Axis attack has found enough pressure to force Montgomery into early reserve commitments."
        ),
        MontyDebriefLine(
            id: "alam-debrief-decisive-defence",
            sideID: MontySideID.montgomery,
            trigger: "axis-stalled",
            summary: "The Axis probe has stalled in minefields and anti-tank lanes before the ridge can be seriously compromised."
        ),
    ]

    public static let dataPack = MontyDemoBattleDataPack(
        scenario: scenario,
        forceGroups: forceGroups,
        autoplayConfiguration: autoplayConfiguration,
        debriefLines: debriefLines
    )
}
