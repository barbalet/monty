public enum MontySecondElAlameinDataPack {
    public static let defaultSeed: UInt32 = 1_942_1023

    public static let scenario = MontyBattleScenario(
        id: .secondElAlamein,
        order: 4,
        title: "Second Battle of El Alamein",
        dateLabel: "23 Oct-4 Nov 1942",
        theater: MontyCommandPhase.northAfricaTunisia.rawValue,
        status: .dataLocked,
        historicalResult: "Allied victory",
        designIntent: "A set-piece desert breakthrough. The Montgomery side clears minefield corridors, opens infantry assault lanes, and releases armour through the gaps; the Axis side shifts reserves, counterattacks the corridors, and preserves withdrawal roads.",
        sourceLinks: [
            HistoricalSourceLink(
                title: "Second Battle of El Alamein",
                url: "https://en.wikipedia.org/wiki/Second_Battle_of_El_Alamein"
            ),
        ],
        sideOptions: [
            HistoricalSideOption(
                id: MontySideID.montgomery,
                role: .protagonist,
                title: "Montgomery's Eighth Army",
                historicalForce: "British Empire, Commonwealth, Free French, Greek, and supporting Allied forces",
                commander: "Bernard Montgomery",
                armyListName: "British",
                playerBriefing: "Clear minefield lanes, keep infantry and armour synchronized, and break through before Axis reserves stabilize.",
                aiBriefing: "Use artillery, engineers, and infantry lanes to open a deliberate corridor for armour."
            ),
            HistoricalSideOption(
                id: MontySideID.opposition,
                role: .opponent,
                title: "German and Italian Panzer Army Africa",
                historicalForce: "German and Italian Panzer Army Africa",
                commander: nil,
                armyListName: "German",
                playerBriefing: "Hold minefield boxes, shift reserves to threatened lanes, and preserve withdrawal roads if the line cracks.",
                aiBriefing: "Counterattack opened corridors and keep withdrawal routes coherent."
            ),
        ],
        map: HistoricalBattleMap(
            title: "El Alamein minefield corridor",
            elements: [
                HistoricalMapElement(
                    id: "alamein-devils-gardens",
                    name: "Devil's gardens",
                    kind: .minefield,
                    points: [
                        HistoricalBattleCoordinate(x: 18, y: 18),
                        HistoricalBattleCoordinate(x: 74, y: 36),
                    ],
                    note: "Minefield belt that the Montgomery-side engineers must breach."
                ),
                HistoricalMapElement(
                    id: "alamein-northern-corridor",
                    name: "Northern assault corridor",
                    kind: .phaseLine,
                    points: [
                        HistoricalBattleCoordinate(x: 18, y: 16),
                        HistoricalBattleCoordinate(x: 78, y: 20),
                    ],
                    note: "Infantry assault lane intended to open the armoured route."
                ),
                HistoricalMapElement(
                    id: "alamein-southern-corridor",
                    name: "Southern fixing corridor",
                    kind: .phaseLine,
                    points: [
                        HistoricalBattleCoordinate(x: 16, y: 38),
                        HistoricalBattleCoordinate(x: 72, y: 42),
                    ],
                    note: "Secondary lane that pins Axis reserves and protects the breakthrough."
                ),
                HistoricalMapElement(
                    id: "alamein-tel-el-eisa",
                    name: "Tel el Eisa ridge",
                    kind: .ridge,
                    points: [
                        HistoricalBattleCoordinate(x: 56, y: 14),
                        HistoricalBattleCoordinate(x: 82, y: 18),
                    ],
                    note: "High ground anchoring the northern end of the battlefield."
                ),
                HistoricalMapElement(
                    id: "alamein-axis-reserve-route",
                    name: "Axis reserve route",
                    kind: .road,
                    points: [
                        HistoricalBattleCoordinate(x: 80, y: 18),
                        HistoricalBattleCoordinate(x: 86, y: 44),
                    ],
                    note: "Axis lateral movement and withdrawal route."
                ),
                HistoricalMapElement(
                    id: "alamein-armour-exploitation-zone",
                    name: "Armour exploitation zone",
                    kind: .objective,
                    points: [
                        HistoricalBattleCoordinate(x: 72, y: 28),
                    ],
                    note: "The breakthrough space that must be opened for Allied armour."
                ),
            ],
            deploymentZones: [
                HistoricalDeploymentZone(
                    id: "alamein-eighth-army-start",
                    sideID: MontySideID.montgomery,
                    name: "Eighth Army start line",
                    origin: HistoricalBattleCoordinate(x: 8, y: 12),
                    width: 24,
                    height: 34,
                    note: "Infantry, engineers, artillery, and armour assembled west of the minefields."
                ),
                HistoricalDeploymentZone(
                    id: "alamein-axis-line",
                    sideID: MontySideID.opposition,
                    name: "Axis defensive belt",
                    origin: HistoricalBattleCoordinate(x: 64, y: 12),
                    width: 26,
                    height: 36,
                    note: "Minefield boxes, anti-tank guns, infantry posts, and mobile reserves."
                ),
            ]
        ),
        objectives: [
            HistoricalObjective(
                id: "alamein-clear-minefields",
                name: "Clear minefield corridors",
                sideID: MontySideID.montgomery,
                victoryPoints: 4,
                location: HistoricalBattleCoordinate(x: 42, y: 27),
                radius: 8,
                description: "Open at least one reliable lane through the minefield belt."
            ),
            HistoricalObjective(
                id: "alamein-open-armour-route",
                name: "Open the armoured route",
                sideID: MontySideID.montgomery,
                victoryPoints: 5,
                location: HistoricalBattleCoordinate(x: 72, y: 28),
                radius: 7,
                description: "Release armour into the exploitation zone after infantry and engineers break the crust."
            ),
            HistoricalObjective(
                id: "alamein-pin-reserves",
                name: "Pin Axis reserves",
                sideID: MontySideID.montgomery,
                victoryPoints: 3,
                location: HistoricalBattleCoordinate(x: 66, y: 40),
                radius: 6,
                description: "Force Axis mobile groups to react to multiple lanes rather than a single breach."
            ),
            HistoricalObjective(
                id: "alamein-axis-seal-corridor",
                name: "Seal the breach",
                sideID: MontySideID.opposition,
                victoryPoints: 5,
                location: HistoricalBattleCoordinate(x: 58, y: 30),
                radius: 7,
                description: "Counterattack opened lanes and prevent the armoured exploitation from becoming irreversible."
            ),
        ],
        victory: HistoricalVictoryProfile(
            targetScore: 12,
            targetTurnUpperBound: 10,
            bands: [
                HistoricalVictoryBand(
                    id: "alamein-axis-delay",
                    label: "Axis delay",
                    scoreRange: 0...5,
                    summary: "The minefields and reserves blunt the Eighth Army timetable."
                ),
                HistoricalVictoryBand(
                    id: "alamein-historical-breakthrough",
                    label: "Historical breakthrough",
                    scoreRange: 6...11,
                    summary: "The Eighth Army cracks the line after a costly, deliberate fight."
                ),
                HistoricalVictoryBand(
                    id: "alamein-decisive-breakthrough",
                    label: "Decisive breakthrough",
                    scoreRange: 12...16,
                    summary: "The minefield belt opens early and Axis reserves lose coherence."
                ),
            ]
        ),
        tags: ["demo", "north-africa", "breakthrough", "minefields", "data-pack"]
    )

    public static let forceGroups: [MontyBattleForceGroup] = [
        MontyBattleForceGroup(id: "alamein-engineers", sideID: MontySideID.montgomery, name: "Eighth Army engineers", role: "Minefield clearance", note: "Opens deliberate lanes through the Devil's gardens."),
        MontyBattleForceGroup(id: "alamein-infantry", sideID: MontySideID.montgomery, name: "Commonwealth assault infantry", role: "Crust assault", note: "Holds cleared gaps long enough for armour to pass."),
        MontyBattleForceGroup(id: "alamein-armour", sideID: MontySideID.montgomery, name: "Armoured exploitation groups", role: "Breakthrough", note: "Exploits the cleared lane once the anti-tank crust is disrupted."),
        MontyBattleForceGroup(id: "alamein-axis-boxes", sideID: MontySideID.opposition, name: "Axis minefield boxes", role: "Defensive belt", note: "Combines mines, infantry, and guns to slow the assault."),
        MontyBattleForceGroup(id: "alamein-axis-reserves", sideID: MontySideID.opposition, name: "Axis mobile reserves", role: "Counterattack", note: "Seals opened corridors before Allied armour breaks through."),
    ]

    public static let autoplayConfiguration = HistoricalAutoplayConfiguration(
        battleID: MontyBattleID.secondElAlamein,
        battleTitle: scenario.title,
        seed: defaultSeed,
        contract: HistoricalAutoplayContract(
            primarySurfaceName: "MontyTestSecondBattleAutoplayView",
            requiredAccessibilityIdentifiers: [
                "monty-test-second-battle-autoplay",
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
                movementPriorityNames: ["Clear minefield corridors", "Open the armoured route", "Pin Axis reserves"],
                movementDistance: 5
            ),
            HistoricalAutoplaySidePlan(
                sideID: MontySideID.opposition,
                controllerLabel: "Axis AI",
                movementPriorityNames: ["Seal the breach", "Axis reserve route", "Devil's gardens"],
                movementDistance: 5
            ),
        ]
    )

    public static let debriefLines: [MontyDebriefLine] = [
        MontyDebriefLine(id: "alamein-debrief-axis-delay", sideID: MontySideID.opposition, trigger: "corridors-stalled", summary: "Axis minefields and reserves have slowed the Eighth Army timetable."),
        MontyDebriefLine(id: "alamein-debrief-historical", sideID: MontySideID.montgomery, trigger: "corridors-open", summary: "The Eighth Army has opened the minefield belt and forced Axis withdrawal pressure."),
        MontyDebriefLine(id: "alamein-debrief-decisive", sideID: MontySideID.montgomery, trigger: "armour-through", summary: "Allied armour has exploited the cleared corridor before Axis reserves can seal it."),
    ]

    public static let dataPack = MontyDemoBattleDataPack(
        scenario: scenario,
        forceGroups: forceGroups,
        autoplayConfiguration: autoplayConfiguration,
        debriefLines: debriefLines
    )
}

public enum MontyOperationEpsomDataPack {
    public static let defaultSeed: UInt32 = 1_944_0626

    public static let scenario = MontyBattleScenario(
        id: .operationEpsom,
        order: 19,
        title: "Operation Epsom",
        dateLabel: "26-30 Jun 1944",
        theater: MontyCommandPhase.normandyFrance.rawValue,
        status: .dataLocked,
        historicalResult: "Allied partial success",
        designIntent: "A Normandy bridgehead and counterattack battle. The Montgomery side crosses the Odon, widens the salient, and pressures Hill 112; the German side contains the shoulders and counterattacks before the bridgehead becomes stable.",
        sourceLinks: [
            HistoricalSourceLink(
                title: "Operation Epsom",
                url: "https://en.wikipedia.org/wiki/Operation_Epsom"
            ),
        ],
        sideOptions: [
            HistoricalSideOption(
                id: MontySideID.montgomery,
                role: .protagonist,
                title: "British VIII Corps",
                historicalForce: "British VIII Corps and 15th Scottish Division spearhead",
                commander: "Bernard Montgomery",
                armyListName: "British",
                playerBriefing: "Cross the Odon, widen the bridgehead, and force German reserves to counterattack on British terms.",
                aiBriefing: "Prioritize Odon crossings, Hill 112 pressure, and salient shoulder security."
            ),
            HistoricalSideOption(
                id: MontySideID.opposition,
                role: .opponent,
                title: "German Seventh Army and II SS Panzer Corps",
                historicalForce: "German Seventh Army and II SS Panzer Corps counterattacks",
                commander: nil,
                armyListName: "German",
                playerBriefing: "Contain the salient, counterattack its shoulders, and keep Hill 112 from becoming a British anchor.",
                aiBriefing: "Counterattack bridgehead shoulders and deny Hill 112 pressure."
            ),
        ],
        map: HistoricalBattleMap(
            title: "Odon bridgehead and Hill 112",
            elements: [
                HistoricalMapElement(
                    id: "epsom-odon",
                    name: "River Odon",
                    kind: .river,
                    points: [
                        HistoricalBattleCoordinate(x: 18, y: 33),
                        HistoricalBattleCoordinate(x: 84, y: 31),
                    ],
                    note: "Crossing obstacle and bridgehead boundary."
                ),
                HistoricalMapElement(
                    id: "epsom-odon-crossing",
                    name: "Odon crossing",
                    kind: .bridge,
                    points: [
                        HistoricalBattleCoordinate(x: 44, y: 32),
                    ],
                    note: "Key crossing needed to stabilize the salient."
                ),
                HistoricalMapElement(
                    id: "epsom-hill-112",
                    name: "Hill 112 approaches",
                    kind: .ridge,
                    points: [
                        HistoricalBattleCoordinate(x: 62, y: 24),
                        HistoricalBattleCoordinate(x: 76, y: 24),
                    ],
                    note: "Dominant ground and operational pressure point."
                ),
                HistoricalMapElement(
                    id: "epsom-british-start",
                    name: "Scottish start line",
                    kind: .deployment,
                    points: [
                        HistoricalBattleCoordinate(x: 18, y: 44),
                    ],
                    note: "British infantry and armour assembly area."
                ),
                HistoricalMapElement(
                    id: "epsom-german-shoulder",
                    name: "German shoulder positions",
                    kind: .phaseLine,
                    points: [
                        HistoricalBattleCoordinate(x: 52, y: 18),
                        HistoricalBattleCoordinate(x: 82, y: 40),
                    ],
                    note: "German containment line around the salient."
                ),
                HistoricalMapElement(
                    id: "epsom-counterattack-route",
                    name: "II SS counterattack route",
                    kind: .road,
                    points: [
                        HistoricalBattleCoordinate(x: 86, y: 20),
                        HistoricalBattleCoordinate(x: 58, y: 34),
                    ],
                    note: "Primary counterattack route against the bridgehead shoulder."
                ),
            ],
            deploymentZones: [
                HistoricalDeploymentZone(
                    id: "epsom-british-deployment",
                    sideID: MontySideID.montgomery,
                    name: "VIII Corps start line",
                    origin: HistoricalBattleCoordinate(x: 12, y: 38),
                    width: 34,
                    height: 16,
                    note: "British start line south-west of the Odon crossing."
                ),
                HistoricalDeploymentZone(
                    id: "epsom-german-deployment",
                    sideID: MontySideID.opposition,
                    name: "German containment zone",
                    origin: HistoricalBattleCoordinate(x: 58, y: 14),
                    width: 30,
                    height: 30,
                    note: "Defensive shoulders and counterattack reserve lanes."
                ),
            ]
        ),
        objectives: [
            HistoricalObjective(
                id: "epsom-cross-odon",
                name: "Cross the Odon",
                sideID: MontySideID.montgomery,
                victoryPoints: 4,
                location: HistoricalBattleCoordinate(x: 44, y: 32),
                radius: 5,
                description: "Secure a crossing and keep it open for follow-on forces."
            ),
            HistoricalObjective(
                id: "epsom-widen-bridgehead",
                name: "Widen the bridgehead",
                sideID: MontySideID.montgomery,
                victoryPoints: 4,
                location: HistoricalBattleCoordinate(x: 56, y: 30),
                radius: 7,
                description: "Expand the salient enough to resist shoulder counterattacks."
            ),
            HistoricalObjective(
                id: "epsom-pressure-hill-112",
                name: "Pressure Hill 112",
                sideID: MontySideID.montgomery,
                victoryPoints: 4,
                location: HistoricalBattleCoordinate(x: 68, y: 24),
                radius: 6,
                description: "Threaten the dominant ground and draw German panzer reserves."
            ),
            HistoricalObjective(
                id: "epsom-contain-salient",
                name: "Contain the salient",
                sideID: MontySideID.opposition,
                victoryPoints: 5,
                location: HistoricalBattleCoordinate(x: 58, y: 34),
                radius: 7,
                description: "Counterattack the shoulders before British forces stabilize the bridgehead."
            ),
        ],
        victory: HistoricalVictoryProfile(
            targetScore: 11,
            targetTurnUpperBound: 9,
            bands: [
                HistoricalVictoryBand(id: "epsom-contained", label: "Contained salient", scoreRange: 0...4, summary: "German counterattacks keep the Odon bridgehead narrow and fragile."),
                HistoricalVictoryBand(id: "epsom-partial-success", label: "Partial success", scoreRange: 5...10, summary: "The bridgehead forms and forces German reserves into the sector."),
                HistoricalVictoryBand(id: "epsom-bridgehead-breakout", label: "Bridgehead breakout", scoreRange: 11...15, summary: "British forces widen the Odon salient and threaten Hill 112 on a stronger timetable."),
            ]
        ),
        tags: ["demo", "normandy", "bridgehead", "counterattack", "data-pack"]
    )

    public static let forceGroups: [MontyBattleForceGroup] = [
        MontyBattleForceGroup(id: "epsom-scottish-infantry", sideID: MontySideID.montgomery, name: "15th Scottish Division", role: "Infantry spearhead", note: "Forces the crossings and holds the first bridgehead line."),
        MontyBattleForceGroup(id: "epsom-british-armour", sideID: MontySideID.montgomery, name: "VIII Corps armour", role: "Bridgehead expansion", note: "Pushes through the infantry bridgehead toward Hill 112."),
        MontyBattleForceGroup(id: "epsom-german-screen", sideID: MontySideID.opposition, name: "German forward screen", role: "Delay", note: "Contains British crossings before reserves arrive."),
        MontyBattleForceGroup(id: "epsom-ss-panzer", sideID: MontySideID.opposition, name: "II SS Panzer Corps counterattack group", role: "Counterattack", note: "Strikes the bridgehead shoulders to prevent consolidation."),
    ]

    public static let autoplayConfiguration = HistoricalAutoplayConfiguration(
        battleID: MontyBattleID.operationEpsom,
        battleTitle: scenario.title,
        seed: defaultSeed,
        contract: HistoricalAutoplayContract(
            primarySurfaceName: "MontyTestEpsomAutoplayView",
            requiredAccessibilityIdentifiers: [
                "monty-test-epsom-autoplay",
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
                movementPriorityNames: ["Cross the Odon", "Widen the bridgehead", "Pressure Hill 112"],
                movementDistance: 5
            ),
            HistoricalAutoplaySidePlan(
                sideID: MontySideID.opposition,
                controllerLabel: "German AI",
                movementPriorityNames: ["Contain the salient", "German shoulder positions", "II SS counterattack route"],
                movementDistance: 6
            ),
        ]
    )

    public static let debriefLines: [MontyDebriefLine] = [
        MontyDebriefLine(id: "epsom-debrief-contained", sideID: MontySideID.opposition, trigger: "salient-contained", summary: "German counterattacks have kept the Odon salient too narrow for a clean exploitation."),
        MontyDebriefLine(id: "epsom-debrief-partial", sideID: MontySideID.montgomery, trigger: "bridgehead-held", summary: "The bridgehead has formed and German reserves have been pulled into the sector."),
        MontyDebriefLine(id: "epsom-debrief-breakout", sideID: MontySideID.montgomery, trigger: "hill-112-threatened", summary: "British forces are pressing Hill 112 and the bridgehead shoulders are secure enough to continue."),
    ]

    public static let dataPack = MontyDemoBattleDataPack(
        scenario: scenario,
        forceGroups: forceGroups,
        autoplayConfiguration: autoplayConfiguration,
        debriefLines: debriefLines
    )
}

public enum MontyDemoDataPackCatalog {
    public static let all: [MontyDemoBattleDataPack] = [
        MontyAlamElHalfaDataPack.dataPack,
        MontySecondElAlameinDataPack.dataPack,
        MontyOperationEpsomDataPack.dataPack,
    ]

    public static func dataPack(for id: MontyBattleID) -> MontyDemoBattleDataPack? {
        all.first { $0.scenario.id == id }
    }

    public static var allDemoIDs: [MontyBattleID] {
        all.map(\.scenario.id)
    }

    public static var cycle100Ready: Bool {
        allDemoIDs == MontyBattleCatalog.demoBattleIDs &&
            all.allSatisfy(\.isDemoReady)
    }
}
