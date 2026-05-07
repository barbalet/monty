import MontyCore
import SwiftUI

public struct MontyCampaignView: View {
    @State private var selectedBattleID: MontyBattleID? = MontyBattleCatalog.all.first?.id

    public init() {}

    public var body: some View {
        NavigationSplitView {
            List(selection: $selectedBattleID) {
                ForEach(MontyBattleCatalog.all) { scenario in
                    NavigationLink(value: scenario.id) {
                        MontyCampaignRow(scenario: scenario)
                    }
                    .accessibilityIdentifier("monty-campaign-row-\(scenario.id.rawValue)")
                }
            }
            .navigationTitle(MontyAppIdentity.appName)
            .accessibilityIdentifier("monty-campaign-list")
        } detail: {
            if let scenario = selectedScenario {
                MontyBattleDetailView(scenario: scenario)
            } else {
                Text("Select a battle")
                    .foregroundStyle(.secondary)
            }
        }
        .background(MontyAppPalette.paper)
    }

    private var selectedScenario: MontyBattleScenario? {
        guard let selectedBattleID else {
            return MontyBattleCatalog.all.first
        }
        return MontyBattleCatalog.scenario(id: selectedBattleID)
    }
}

private struct MontyCampaignRow: View {
    let scenario: MontyBattleScenario

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack(spacing: 8) {
                Text("\(scenario.order)")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.white)
                    .frame(width: 28, height: 22)
                    .background(MontyAppPalette.navy, in: RoundedRectangle(cornerRadius: 4))

                Text(scenario.title)
                    .font(.headline)
                    .lineLimit(2)
            }

            Text(scenario.dateLabel)
                .font(.caption)
                .foregroundStyle(.secondary)

            Text(scenario.status.rawValue)
                .font(.caption2.weight(.medium))
                .foregroundStyle(statusColor)
        }
        .padding(.vertical, 4)
    }

    private var statusColor: Color {
        switch scenario.status {
        case .demoPlayable, .playable, .dataLocked:
            return MontyAppPalette.olive
        case .catalogReady:
            return MontyAppPalette.navy
        case .planned:
            return .secondary
        }
    }
}

private struct MontyBattleDetailView: View {
    let scenario: MontyBattleScenario

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                header
                sideSelector
                objectives
                mapPreview
                sources
            }
            .padding(24)
            .frame(maxWidth: 980, alignment: .leading)
        }
        .background(MontyAppPalette.paper)
        .accessibilityIdentifier("monty-battle-detail-\(scenario.id.rawValue)")
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(scenario.title)
                .font(.largeTitle.weight(.semibold))
                .foregroundStyle(MontyAppPalette.ink)

            Text("\(scenario.dateLabel) | \(scenario.theater)")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            Text(scenario.designIntent)
                .font(.body)
                .foregroundStyle(MontyAppPalette.ink)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private var sideSelector: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Side Selection")
                .font(.title3.weight(.semibold))

            HStack(alignment: .top, spacing: 12) {
                ForEach(scenario.sideOptions) { side in
                    Button {
                    } label: {
                        Label(side.title, systemImage: side.role == .protagonist ? "person.crop.circle" : "shield.lefthalf.filled")
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .buttonStyle(.bordered)
                    .accessibilityIdentifier("monty-side-\(side.id)")
                    .help(side.playerBriefing)
                }
            }
        }
    }

    private var objectives: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Objectives")
                .font(.title3.weight(.semibold))

            ForEach(scenario.objectives) { objective in
                HStack(alignment: .top, spacing: 10) {
                    Text("\(objective.victoryPoints)")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(.white)
                        .frame(width: 24, height: 24)
                        .background(MontyAppPalette.accent, in: Circle())

                    VStack(alignment: .leading, spacing: 3) {
                        Text(objective.name)
                            .font(.headline)
                        Text(objective.description)
                            .font(.callout)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
    }

    private var mapPreview: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(scenario.map.title)
                .font(.title3.weight(.semibold))

            ZStack {
                RoundedRectangle(cornerRadius: 6)
                    .fill(MontyAppPalette.desert.opacity(0.35))
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(MontyAppPalette.olive.opacity(0.5), lineWidth: 1)
                    )

                ForEach(scenario.map.elements) { element in
                    MontyMapElementMark(element: element)
                }
            }
            .frame(height: 240)
            .accessibilityIdentifier("monty-map-preview-\(scenario.id.rawValue)")
        }
    }

    private var sources: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Sources")
                .font(.title3.weight(.semibold))

            ForEach(scenario.sourceLinks, id: \.url) { source in
                Text(source.title)
                    .font(.callout)
                    .foregroundStyle(MontyAppPalette.navy)
            }
        }
    }
}

private struct MontyMapElementMark: View {
    let element: HistoricalMapElement

    var body: some View {
        let point = element.points.first ?? HistoricalBattleCoordinate(x: 50, y: 28)
        Text(element.name)
            .font(.caption2.weight(.medium))
            .foregroundStyle(.white)
            .lineLimit(2)
            .padding(.horizontal, 6)
            .padding(.vertical, 4)
            .background(color, in: RoundedRectangle(cornerRadius: 4))
            .position(x: point.x * 8.4, y: point.y * 4.2)
            .accessibilityIdentifier("monty-map-element-\(element.id)")
    }

    private var color: Color {
        switch element.kind {
        case .ridge:
            return MontyAppPalette.olive
        case .minefield:
            return MontyAppPalette.accent
        case .road, .bridge:
            return MontyAppPalette.navy
        case .objective:
            return MontyAppPalette.desert
        default:
            return .gray
        }
    }
}
