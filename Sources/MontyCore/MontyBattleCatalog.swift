public enum MontyBattleCatalog {
    public static let demoBattleIDs: [MontyBattleID] = [
        .alamElHalfa,
        .secondElAlamein,
        .operationEpsom,
    ]

    public static let all: [MontyBattleScenario] = [
        make(
            .battleOfFrance,
            order: 1,
            date: "10-27 May 1940",
            title: "Battle of France / BEF Dyle-Escaut withdrawal",
            phase: .befFrance,
            command: "3rd Infantry Division, BEF II Corps",
            montgomeryForce: "British 3rd Infantry Division and BEF attachments",
            oppositionForce: "German Army Group B and Army Group A pressure",
            result: "Axis victory",
            intent: "Preserve the division, block road junctions, and hand off intact rearguards while German columns force crossings and equipment losses.",
            sourceTitle: "Battle of France",
            sourceURL: "https://en.wikipedia.org/wiki/Battle_of_France"
        ),
        make(
            .dunkirk,
            order: 2,
            date: "26 May-4 Jun 1940",
            title: "Battle of Dunkirk / Operation Dynamo",
            phase: .befFrance,
            command: "3rd Infantry Division; temporary II Corps command",
            montgomeryForce: "BEF and Allied rearguards around the Dunkirk perimeter",
            oppositionForce: "German ground forces and Luftwaffe pressure",
            result: "Allied evacuation under German campaign victory",
            intent: "Hold canal lines, beaches, and embarkation capacity against German pressure compressing the pocket.",
            sourceTitle: "Battle of Dunkirk",
            sourceURL: "https://en.wikipedia.org/wiki/Battle_of_Dunkirk"
        ),
        MontyAlamElHalfaDataPack.scenario,
        make(
            .secondElAlamein,
            order: 4,
            date: "23 Oct-4 Nov 1942",
            title: "Second Battle of El Alamein",
            phase: .northAfricaTunisia,
            command: "Eighth Army",
            montgomeryForce: "British Empire, Commonwealth, Free French, Greek, and supporting Allied forces",
            oppositionForce: "German and Italian Panzer Army Africa",
            result: "Allied victory",
            intent: "Clear minefields, open armoured corridors, and prevent Axis reserves from keeping withdrawal roads coherent.",
            sourceTitle: "Second Battle of El Alamein",
            sourceURL: "https://en.wikipedia.org/wiki/Second_Battle_of_El_Alamein"
        ),
        make(
            .elAgheila,
            order: 5,
            date: "11-18 Dec 1942",
            title: "Battle of El Agheila",
            phase: .northAfricaTunisia,
            command: "Eighth Army",
            montgomeryForce: "Eighth Army pursuit forces, including 2nd New Zealand Division and 7th Armoured Division",
            oppositionForce: "German-Italian Panzer Army Africa",
            result: "Axis withdrawal from Cyrenaica",
            intent: "Execute an outflanking desert hook while Axis rearguards delay and escape toward Tripolitania.",
            sourceTitle: "Battle of El Agheila",
            sourceURL: "https://en.wikipedia.org/wiki/Battle_of_El_Agheila"
        ),
        make(
            .tripoli,
            order: 6,
            date: "22-23 Jan 1943",
            title: "Battle of Tripoli",
            phase: .northAfricaTunisia,
            command: "Eighth Army",
            montgomeryForce: "British Eighth Army, Commonwealth armour, and New Zealand columns",
            oppositionForce: "German-Italian Panzer Army and Tripoli defenders",
            result: "Allied victory",
            intent: "Race to seize Tripoli with usable routes and port facilities while Axis forces demolish infrastructure and preserve retreating troops.",
            sourceTitle: "Battle of Tripoli",
            sourceURL: "https://en.wikipedia.org/wiki/Battle_of_Tripoli_%281943%29"
        ),
        make(
            .medenine,
            order: 7,
            date: "6 Mar 1943",
            title: "Battle of Medenine",
            phase: .northAfricaTunisia,
            command: "Eighth Army",
            montgomeryForce: "Eighth Army fortified line near Medenine",
            oppositionForce: "German and Italian armour under Rommel and Messe",
            result: "Allied victory",
            intent: "Absorb Operation Capri with hidden guns and prepared artillery while Axis armour tries a short spoiling attack.",
            sourceTitle: "Battle of Medenine",
            sourceURL: "https://en.wikipedia.org/wiki/Battle_of_Medenine"
        ),
        make(
            .marethLine,
            order: 8,
            date: "16-31 Mar 1943",
            title: "Battle of the Mareth Line",
            phase: .northAfricaTunisia,
            command: "Eighth Army",
            montgomeryForce: "Eighth Army, New Zealand Corps, Indian, Free French, and Greek formations",
            oppositionForce: "Italian First Army and German detachments",
            result: "British victory",
            intent: "Force the line or turn it through Tebaga Gap while Axis defenders hold bunkers, wadis, and counterattack reserves.",
            sourceTitle: "Battle of the Mareth Line",
            sourceURL: "https://en.wikipedia.org/wiki/Battle_of_the_Mareth_Line"
        ),
        make(
            .wadiAkarit,
            order: 9,
            date: "6-7 Apr 1943",
            title: "Battle of Wadi Akarit",
            phase: .northAfricaTunisia,
            command: "Eighth Army",
            montgomeryForce: "Eighth Army assault divisions at the Gabes Gap",
            oppositionForce: "Italian First Army and German defenders",
            result: "Allied victory",
            intent: "Concentrate infantry, guns, and armour through limited terrain while Axis defenders hold high ground and seal penetrations.",
            sourceTitle: "Battle of Wadi Akarit",
            sourceURL: "https://en.wikipedia.org/wiki/Battle_of_Wadi_Akarit"
        ),
        make(
            .enfidaville,
            order: 10,
            date: "19-21 Apr 1943",
            title: "Battle of Enfidaville",
            phase: .northAfricaTunisia,
            command: "Eighth Army",
            montgomeryForce: "Eighth Army coastal and mountain assault groups",
            oppositionForce: "Italian First Army and German units near Enfidaville",
            result: "Inconclusive with local Allied gains",
            intent: "Pin Axis forces for the wider Tunisian collapse while defenders deny a clean breakthrough.",
            sourceTitle: "Battle of Enfidaville",
            sourceURL: "https://en.wikipedia.org/wiki/Battle_of_Enfidaville"
        ),
        make(
            .operationHusky,
            order: 11,
            date: "9 Jul-17 Aug 1943",
            title: "Allied invasion of Sicily / Operation Husky",
            phase: .sicilyItaly,
            command: "Eighth Army under 15th Army Group",
            montgomeryForce: "Eighth Army landings around Syracuse and the east coast",
            oppositionForce: "Italian Sixth Army and German XIV Panzer Corps elements",
            result: "Allied victory",
            intent: "Secure beaches and push toward Catania while Axis forces stage delaying lines and manage evacuation pressure.",
            sourceTitle: "Allied invasion of Sicily",
            sourceURL: "https://en.wikipedia.org/wiki/Allied_invasion_of_Sicily"
        ),
        make(
            .operationFustian,
            order: 12,
            date: "13-16 Jul 1943",
            title: "Operation Fustian / Primosole Bridge",
            phase: .sicilyItaly,
            command: "Eighth Army airborne and XIII Corps operation",
            montgomeryForce: "British 1st Parachute Brigade and XIII Corps relief forces",
            oppositionForce: "German paratroopers, Italian defenders, and counterattack groups",
            result: "Allied bridge captured after delay",
            intent: "Link parachute troops with ground columns while Axis forces isolate the bridgehead and disrupt relief timing.",
            sourceTitle: "Operation Fustian",
            sourceURL: "https://en.wikipedia.org/wiki/Operation_Fustian"
        ),
        make(
            .operationBaytown,
            order: 13,
            date: "3-8 Sep 1943",
            title: "Operation Baytown",
            phase: .sicilyItaly,
            command: "Eighth Army",
            montgomeryForce: "British XIII Corps, Canadian 1st Division, and British 5th Division",
            oppositionForce: "German LXXVI Panzer Corps and Italian coastal forces",
            result: "Allied victory",
            intent: "Cross the Straits of Messina and expand through Calabria against demolitions, terrain, and selective resistance.",
            sourceTitle: "Operation Baytown",
            sourceURL: "https://en.wikipedia.org/wiki/Operation_Baytown"
        ),
        make(
            .volturnoLine,
            order: 14,
            date: "3-6 Oct 1943",
            title: "Volturno Line / Operation Devon at Termoli-Biferno",
            phase: .sicilyItaly,
            command: "Eighth Army on the Adriatic flank",
            montgomeryForce: "British commandos, 78th Division, and supporting Canadian/British armour",
            oppositionForce: "German 16th Panzer Division and Volturno Line defenders",
            result: "Allied victory",
            intent: "Hold Termoli until bridging and armour arrive while Axis counterattacks hit before the Biferno crossing is secure.",
            sourceTitle: "Volturno Line",
            sourceURL: "https://en.wikipedia.org/wiki/Volturno_Line"
        ),
        make(
            .moroRiver,
            order: 15,
            date: "4 Dec 1943-4 Jan 1944",
            title: "Moro River campaign / Ortona",
            phase: .sicilyItaly,
            command: "Eighth Army transition before Montgomery's return to Britain",
            montgomeryForce: "Canadian, Indian, British, and New Zealand formations of Eighth Army",
            oppositionForce: "German 10th Army and LXXVI Panzer Corps",
            result: "Costly Allied advance",
            intent: "Force river crossings, gully positions, and Ortona approaches while Axis defenders exploit mud, ridges, and urban defence.",
            sourceTitle: "Moro River campaign",
            sourceURL: "https://en.wikipedia.org/wiki/Moro_River_campaign"
        ),
        make(
            .normandyLandings,
            order: 16,
            date: "6 Jun 1944",
            title: "Normandy landings / D-Day",
            phase: .normandyFrance,
            command: "Allied ground forces for Operation Overlord",
            montgomeryForce: "British, Canadian, American, and airborne landing forces",
            oppositionForce: "German Seventh Army coastal and mobile reserves",
            result: "Allied beachhead established",
            intent: "Link beaches and airborne lodgements while Axis forces contain exits and counterattack before lodgements merge.",
            sourceTitle: "Normandy landings",
            sourceURL: "https://en.wikipedia.org/wiki/Normandy_landings",
            montgomeryArmyList: "Allied"
        ),
        make(
            .battleForCaen,
            order: 17,
            date: "6 Jun-6 Aug 1944",
            title: "Battle for Caen",
            phase: .normandyFrance,
            command: "Allied ground forces / 21st Army Group",
            montgomeryForce: "British Second Army and First Canadian Army",
            oppositionForce: "German panzer, SS, and infantry formations around Caen",
            result: "Allied victory",
            intent: "Seize ground while fixing German armour around Caen's villages, ridges, and ruins.",
            sourceTitle: "Battle for Caen",
            sourceURL: "https://en.wikipedia.org/wiki/Battle_for_Caen"
        ),
        make(
            .villersBocage,
            order: 18,
            date: "13 Jun 1944",
            title: "Battle of Villers-Bocage",
            phase: .normandyFrance,
            command: "21st Army Group, British Second Army sector",
            montgomeryForce: "British 7th Armoured Division",
            oppositionForce: "Panzer Lehr elements and German heavy tank detachments",
            result: "German tactical victory",
            intent: "Recover momentum and hold road exits while German armour uses shock, line of sight, and village cover.",
            sourceTitle: "Battle of Villers-Bocage",
            sourceURL: "https://en.wikipedia.org/wiki/Battle_of_Villers-Bocage"
        ),
        make(
            .operationEpsom,
            order: 19,
            date: "26-30 Jun 1944",
            title: "Operation Epsom",
            phase: .normandyFrance,
            command: "21st Army Group, British Second Army",
            montgomeryForce: "British VIII Corps and 15th Scottish Division spearhead",
            oppositionForce: "German Seventh Army and II SS Panzer Corps counterattacks",
            result: "Allied partial success",
            intent: "Widen an Odon bridgehead toward Hill 112 while German forces contain the salient and counterattack its shoulders.",
            sourceTitle: "Operation Epsom",
            sourceURL: "https://en.wikipedia.org/wiki/Operation_Epsom"
        ),
        make(
            .operationCharnwood,
            order: 20,
            date: "8-9 Jul 1944",
            title: "Operation Charnwood",
            phase: .normandyFrance,
            command: "21st Army Group, British and Canadian forces",
            montgomeryForce: "British I Corps and Canadian formations north of Caen",
            oppositionForce: "German Caen garrison and panzer reserves",
            result: "Allied tactical victory",
            intent: "Capture northern Caen and river approaches while German defenders trade ruined districts for time and cohesion.",
            sourceTitle: "Operation Charnwood",
            sourceURL: "https://en.wikipedia.org/wiki/Operation_Charnwood"
        ),
        make(
            .operationGoodwood,
            order: 21,
            date: "18-20 Jul 1944",
            title: "Operation Goodwood",
            phase: .normandyFrance,
            command: "21st Army Group, British Second Army",
            montgomeryForce: "British armoured corps east of Caen",
            oppositionForce: "German panzer divisions and anti-tank belts",
            result: "Limited Allied advance",
            intent: "Punch through bombardment lanes and open ground while Axis defenders hold depth positions and anti-tank kill zones.",
            sourceTitle: "Operation Goodwood",
            sourceURL: "https://en.wikipedia.org/wiki/Operation_Goodwood"
        ),
        make(
            .operationCobra,
            order: 22,
            date: "25-31 Jul 1944",
            title: "Operation Cobra",
            phase: .normandyFrance,
            command: "Allied ground forces in Normandy",
            montgomeryForce: "U.S. First Army breakthrough force under the Allied ground plan",
            oppositionForce: "German Seventh Army and Panzer Lehr sector",
            result: "Allied breakthrough",
            intent: "Exploit the St. Lo rupture while German forces stabilize shattered lines and protect withdrawal routes.",
            sourceTitle: "Operation Cobra",
            sourceURL: "https://en.wikipedia.org/wiki/Operation_Cobra",
            montgomeryArmyList: "Allied"
        ),
        make(
            .falaisePocket,
            order: 23,
            date: "12-21 Aug 1944",
            title: "Falaise pocket",
            phase: .normandyFrance,
            command: "Allied ground forces / 21st Army Group coordination",
            montgomeryForce: "Canadian, British, Polish, American, and French forces closing the pocket",
            oppositionForce: "German Army Group B escape columns",
            result: "Decisive Allied victory",
            intent: "Seal Chambois, Trun, and Falaise exits while German columns keep corridors open long enough to save formations.",
            sourceTitle: "Falaise pocket",
            sourceURL: "https://en.wikipedia.org/wiki/Falaise_pocket",
            montgomeryArmyList: "Allied"
        ),
        make(
            .liberationOfParis,
            order: 24,
            date: "19-25 Aug 1944",
            title: "Liberation of Paris",
            phase: .normandyFrance,
            command: "Allied ground forces before the 1 September command change",
            montgomeryForce: "French Resistance, French 2nd Armoured Division, and U.S. support",
            oppositionForce: "German Paris garrison",
            result: "Allied and French victory",
            intent: "Coordinate uprising pressure and armoured entry while the garrison chooses strongpoints, delay, or withdrawal.",
            sourceTitle: "Liberation of Paris",
            sourceURL: "https://en.wikipedia.org/wiki/Liberation_of_Paris",
            montgomeryArmyList: "Allied"
        ),
        make(
            .operationAstonia,
            order: 25,
            date: "10-12 Sep 1944",
            title: "Operation Astonia / Le Havre",
            phase: .channelLowCountries,
            command: "21st Army Group",
            montgomeryForce: "British I Corps, 79th Armoured Division assets, artillery, and naval support",
            oppositionForce: "German fortress garrison at Le Havre",
            result: "Allied victory",
            intent: "Break prepared defences and secure port infrastructure while the garrison survives bombardment and strongpoints districts.",
            sourceTitle: "Operation Astonia",
            sourceURL: "https://en.wikipedia.org/wiki/Operation_Astonia"
        ),
        make(
            .operationMarketGarden,
            order: 26,
            date: "17-25 Sep 1944",
            title: "Operation Market Garden",
            phase: .channelLowCountries,
            command: "21st Army Group",
            montgomeryForce: "First Allied Airborne Army, British XXX Corps, and supporting ground forces",
            oppositionForce: "German Army Group B, including II SS Panzer Corps elements",
            result: "Allied operational failure",
            intent: "Link airborne bridgeheads along a single road while German forces cut the corridor and contain Arnhem.",
            sourceTitle: "Operation Market Garden",
            sourceURL: "https://en.wikipedia.org/wiki/Operation_Market_Garden",
            montgomeryArmyList: "Allied"
        ),
        make(
            .scheldt,
            order: 27,
            date: "2 Oct-8 Nov 1944",
            title: "Battle of the Scheldt",
            phase: .channelLowCountries,
            command: "21st Army Group, First Canadian Army task",
            montgomeryForce: "Canadian, British, Polish, and Royal Marine forces opening Antwerp",
            oppositionForce: "German Fifteenth Army and Scheldt fortress defenders",
            result: "Allied victory",
            intent: "Clear causeways, islands, and approaches to Antwerp while German defenders deny port access and mine time.",
            sourceTitle: "Battle of the Scheldt",
            sourceURL: "https://en.wikipedia.org/wiki/Battle_of_the_Scheldt",
            montgomeryArmyList: "Allied"
        ),
        make(
            .operationPheasant,
            order: 28,
            date: "20 Oct-4 Nov 1944",
            title: "Operation Pheasant",
            phase: .channelLowCountries,
            command: "21st Army Group",
            montgomeryForce: "British Second Army, Canadian, and Polish forces in North Brabant",
            oppositionForce: "German Fifteenth Army and retreating formations",
            result: "Allied victory",
            intent: "Clear towns and road nets after Market Garden while German forces hold canals and delay the northern flank.",
            sourceTitle: "Operation Pheasant",
            sourceURL: "https://en.wikipedia.org/wiki/Operation_Pheasant",
            montgomeryArmyList: "Allied"
        ),
        make(
            .battleOfTheBulge,
            order: 29,
            date: "16 Dec 1944-25 Jan 1945",
            title: "Battle of the Bulge / northern shoulder",
            phase: .ardennesRhinelandGermany,
            command: "21st Army Group; temporary command of U.S. First and Ninth Armies",
            montgomeryForce: "U.S. First and Ninth Armies with British reserves on the northern shoulder",
            oppositionForce: "German Fifth and Sixth Panzer Armies",
            result: "Allied victory",
            intent: "Stabilize separated American fronts and build counterattack reserves while German armour drives for Meuse crossings and Antwerp.",
            sourceTitle: "Battle of the Bulge",
            sourceURL: "https://en.wikipedia.org/wiki/Battle_of_the_Bulge",
            montgomeryArmyList: "Allied"
        ),
        make(
            .operationVeritable,
            order: 30,
            date: "8 Feb-11 Mar 1945",
            title: "Operation Veritable",
            phase: .ardennesRhinelandGermany,
            command: "21st Army Group, First Canadian Army",
            montgomeryForce: "First Canadian Army with British XXX Corps in the Reichswald",
            oppositionForce: "German First Parachute Army and Rhineland defenders",
            result: "Allied victory",
            intent: "Grind through Reichswald defences while German forces use flooded terrain, villages, and reserves to slow the Rhine approach.",
            sourceTitle: "Operation Veritable",
            sourceURL: "https://en.wikipedia.org/wiki/Operation_Veritable",
            montgomeryArmyList: "Allied"
        ),
        make(
            .operationGrenade,
            order: 31,
            date: "23 Feb-10 Mar 1945",
            title: "Operation Grenade",
            phase: .ardennesRhinelandGermany,
            command: "21st Army Group, U.S. Ninth Army",
            montgomeryForce: "U.S. Ninth Army advancing to the Rhine",
            oppositionForce: "German forces west of the Roer and Rhine",
            result: "Allied victory",
            intent: "Time the Roer crossing and linkup with Veritable while German defenders destroy bridges and shield withdrawal.",
            sourceTitle: "Operation Grenade",
            sourceURL: "https://en.wikipedia.org/wiki/Operation_Grenade",
            montgomeryArmyList: "Allied"
        ),
        make(
            .operationPlunder,
            order: 32,
            date: "23-28 Mar 1945",
            title: "Operation Plunder",
            phase: .ardennesRhinelandGermany,
            command: "21st Army Group",
            montgomeryForce: "British Second Army, U.S. Ninth Army, and Canadian support crossing the Rhine",
            oppositionForce: "German Army Group H and Rhine defenders",
            result: "Allied victory",
            intent: "Coordinate assault crossings, smoke, artillery, and engineers while German defenders contest bridgeheads early.",
            sourceTitle: "Operation Plunder",
            sourceURL: "https://en.wikipedia.org/wiki/Operation_Plunder",
            montgomeryArmyList: "Allied"
        ),
        make(
            .operationVarsity,
            order: 33,
            date: "24 Mar 1945",
            title: "Operation Varsity",
            phase: .ardennesRhinelandGermany,
            command: "21st Army Group airborne support operation",
            montgomeryForce: "British 6th Airborne Division and U.S. 17th Airborne Division",
            oppositionForce: "German defenders east of the Rhine",
            result: "Allied victory",
            intent: "Capture drop-zone objectives behind the Rhine while German defenders attack scattered landings before ground relief arrives.",
            sourceTitle: "Operation Varsity",
            sourceURL: "https://en.wikipedia.org/wiki/Operation_Varsity",
            montgomeryArmyList: "Allied"
        ),
        make(
            .ruhrPocket,
            order: 34,
            date: "1-18 Apr 1945",
            title: "Ruhr pocket",
            phase: .ardennesRhinelandGermany,
            command: "21st Army Group, U.S. Ninth Army northern arm",
            montgomeryForce: "U.S. Ninth Army and Allied encirclement forces",
            oppositionForce: "German Army Group B in the Ruhr",
            result: "Allied victory",
            intent: "Close industrial routes and surrender pockets while German forces attempt breakout, local counterattacks, or organized collapse.",
            sourceTitle: "Ruhr pocket",
            sourceURL: "https://en.wikipedia.org/wiki/Ruhr_pocket",
            montgomeryArmyList: "Allied"
        ),
        make(
            .hamburg,
            order: 35,
            date: "18 Apr-3 May 1945",
            title: "Battle of Hamburg",
            phase: .ardennesRhinelandGermany,
            command: "21st Army Group, British Second Army",
            montgomeryForce: "British Second Army advancing into north-west Germany",
            oppositionForce: "German Hamburg garrison and northern German defenders",
            result: "British victory",
            intent: "Capture Hamburg and secure north-west Germany while German defenders delay the endgame and preserve surrender corridors.",
            sourceTitle: "Battle of Hamburg",
            sourceURL: "https://en.wikipedia.org/wiki/Battle_of_Hamburg_%281945%29"
        ),
    ]

    public static let phaseCounts: [MontyCommandPhase: Int] = [
        .befFrance: 2,
        .northAfricaTunisia: 8,
        .sicilyItaly: 5,
        .normandyFrance: 9,
        .channelLowCountries: 4,
        .ardennesRhinelandGermany: 7,
    ]

    public static func scenario(id: MontyBattleID) -> MontyBattleScenario? {
        all.first { $0.id == id }
    }

    public static func phase(for scenario: MontyBattleScenario) -> MontyCommandPhase? {
        switch scenario.order {
        case 1...2:
            return .befFrance
        case 3...10:
            return .northAfricaTunisia
        case 11...15:
            return .sicilyItaly
        case 16...24:
            return .normandyFrance
        case 25...28:
            return .channelLowCountries
        case 29...35:
            return .ardennesRhinelandGermany
        default:
            return nil
        }
    }

    private static func make(
        _ id: MontyBattleID,
        order: Int,
        date: String,
        title: String,
        phase: MontyCommandPhase,
        command: String,
        montgomeryForce: String,
        oppositionForce: String,
        result: String,
        intent: String,
        sourceTitle: String,
        sourceURL: String,
        status: HistoricalBattleStatus = .catalogReady,
        montgomeryArmyList: String = "British",
        oppositionArmyList: String = "German"
    ) -> MontyBattleScenario {
        MontyBattleScenario(
            id: id,
            order: order,
            title: title,
            dateLabel: date,
            theater: phase.rawValue,
            status: status,
            historicalResult: result,
            designIntent: intent,
            sourceLinks: [
                HistoricalSourceLink(title: sourceTitle, url: sourceURL),
            ],
            sideOptions: [
                HistoricalSideOption(
                    id: MontySideID.montgomery,
                    role: .protagonist,
                    title: "Montgomery-side command",
                    historicalForce: montgomeryForce,
                    commander: "Bernard Montgomery",
                    armyListName: montgomeryArmyList,
                    playerBriefing: "Preserve tempo, cohesion, and the operational objective under \(command).",
                    aiBriefing: "Follow Montgomery-side priorities for tempo, cohesion, and objective pressure."
                ),
                HistoricalSideOption(
                    id: MontySideID.opposition,
                    role: .opponent,
                    title: "Opposing army",
                    historicalForce: oppositionForce,
                    commander: nil,
                    armyListName: oppositionArmyList,
                    playerBriefing: "Delay, contain, counterattack, or exploit Allied friction before Montgomery's timetable resolves.",
                    aiBriefing: "Contest Montgomery-side tempo and protect the opposing force's escape, defence, or counterattack route."
                ),
            ],
            map: placeholderMap(id: id, title: title),
            objectives: placeholderObjectives(id: id),
            victory: placeholderVictoryProfile(id: id),
            tags: [phase.rawValue, status.rawValue]
        )
    }

    private static func placeholderMap(id: MontyBattleID, title: String) -> HistoricalBattleMap {
        HistoricalBattleMap(
            title: "\(title) operations map",
            elements: [
                HistoricalMapElement(
                    id: "\(id.rawValue)-axis",
                    name: "Primary operational axis",
                    kind: .phaseLine,
                    points: [
                        HistoricalBattleCoordinate(x: 10, y: 12),
                        HistoricalBattleCoordinate(x: 84, y: 42),
                    ],
                    note: "Catalog placeholder for the main advance, withdrawal, or containment line."
                ),
                HistoricalMapElement(
                    id: "\(id.rawValue)-objective-area",
                    name: "Contested objective area",
                    kind: .objective,
                    points: [
                        HistoricalBattleCoordinate(x: 56, y: 28),
                    ],
                    note: "Catalog placeholder for the scenario's decisive ground."
                ),
            ],
            deploymentZones: [
                HistoricalDeploymentZone(
                    id: "\(id.rawValue)-montgomery-deployment",
                    sideID: MontySideID.montgomery,
                    name: "Montgomery-side deployment",
                    origin: HistoricalBattleCoordinate(x: 8, y: 10),
                    width: 24,
                    height: 18,
                    note: "Initial Allied command area."
                ),
                HistoricalDeploymentZone(
                    id: "\(id.rawValue)-opposition-deployment",
                    sideID: MontySideID.opposition,
                    name: "Opposing deployment",
                    origin: HistoricalBattleCoordinate(x: 64, y: 30),
                    width: 24,
                    height: 18,
                    note: "Initial opposing force area."
                ),
            ]
        )
    }

    private static func placeholderObjectives(id: MontyBattleID) -> [HistoricalObjective] {
        [
            HistoricalObjective(
                id: "\(id.rawValue)-tempo",
                name: "Preserve Montgomery's timetable",
                sideID: MontySideID.montgomery,
                victoryPoints: 5,
                location: HistoricalBattleCoordinate(x: 56, y: 28),
                radius: 5,
                description: "Keep the Montgomery-side command on schedule for the operational result."
            ),
            HistoricalObjective(
                id: "\(id.rawValue)-contain",
                name: "Disrupt Allied cohesion",
                sideID: MontySideID.opposition,
                victoryPoints: 5,
                location: HistoricalBattleCoordinate(x: 42, y: 26),
                radius: 5,
                description: "Delay, contain, or counterattack enough to break the Montgomery-side timetable."
            ),
        ]
    }

    private static func placeholderVictoryProfile(id: MontyBattleID) -> HistoricalVictoryProfile {
        HistoricalVictoryProfile(
            targetScore: 10,
            targetTurnUpperBound: 8,
            bands: [
                HistoricalVictoryBand(
                    id: "\(id.rawValue)-historical-pressure",
                    label: "Historical pressure",
                    scoreRange: 0...3,
                    summary: "The battle follows its historical pressure pattern."
                ),
                HistoricalVictoryBand(
                    id: "\(id.rawValue)-operational-success",
                    label: "Operational success",
                    scoreRange: 4...7,
                    summary: "The selected side gains meaningful tempo without a decisive collapse."
                ),
                HistoricalVictoryBand(
                    id: "\(id.rawValue)-decisive-tempo",
                    label: "Decisive tempo",
                    scoreRange: 8...12,
                    summary: "The selected side changes the battle's operational timetable."
                ),
            ]
        )
    }
}
