@_exported import DerZweiteWeltkriegHistorical

public enum MontyAppIdentity {
    public static let appName = "Monty"
    public static let bundleIdentifier = "com.barbalet.monty"
    public static let storagePrefix = "com.barbalet.monty"
    public static let campaignProgressStorageKey = "\(storagePrefix).campaign-progress"
    public static let selectedSideStorageKey = "\(storagePrefix).selected-side"
    public static let sharedBattleSurfaceName = HistoricalPlayableSurfaceCatalog.sharedHostSurfaceName
}

public enum MontySideID {
    public static let montgomery = "montgomery"
    public static let opposition = "opposition"
}

public enum MontyBattleID: String, CaseIterable, Codable, Hashable, Sendable, HistoricalBattleID {
    case battleOfFrance
    case dunkirk
    case alamElHalfa
    case secondElAlamein
    case elAgheila
    case tripoli
    case medenine
    case marethLine
    case wadiAkarit
    case enfidaville
    case operationHusky
    case operationFustian
    case operationBaytown
    case volturnoLine
    case moroRiver
    case normandyLandings
    case battleForCaen
    case villersBocage
    case operationEpsom
    case operationCharnwood
    case operationGoodwood
    case operationCobra
    case falaisePocket
    case liberationOfParis
    case operationAstonia
    case operationMarketGarden
    case scheldt
    case operationPheasant
    case battleOfTheBulge
    case operationVeritable
    case operationGrenade
    case operationPlunder
    case operationVarsity
    case ruhrPocket
    case hamburg
}

public enum MontyCommandPhase: String, CaseIterable, Codable, Hashable, Sendable {
    case befFrance = "British Expeditionary Force in France"
    case northAfricaTunisia = "Eighth Army in North Africa and Tunisia"
    case sicilyItaly = "Eighth Army in Sicily and Italy"
    case normandyFrance = "Allied ground forces in Normandy and France"
    case channelLowCountries = "21st Army Group on the Channel Coast and Low Countries"
    case ardennesRhinelandGermany = "21st Army Group in the Ardennes, Rhineland, and Germany"
}

public typealias MontyBattleScenario = HistoricalBattleScenario<MontyBattleID>
