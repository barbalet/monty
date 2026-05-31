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
                    .accessibilityIdentifier(MontyAccessibilityID.campaignRow(scenario.id))
                }
            }
            .navigationTitle(MontyAppIdentity.appName)
            .accessibilityIdentifier(MontyAccessibilityID.campaignList)
        } detail: {
            if let scenario = selectedScenario {
                MontyBattleDetailView(scenario: scenario)
                    .id(scenario.id)
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
    @AppStorage(MontyAppIdentity.campaignProgressStorageKey) private var encodedProgress = ""
    @AppStorage(MontyAppIdentity.selectedSideStorageKey) private var lastSelectedSideID = MontySideID.montgomery
    @State private var chosenSideID = MontySideID.montgomery
    @State private var launchFlow: MontyLaunchFlow?
    @State private var battleSession: MontyDemoBoardSession?
    @State private var battleSnapshot: HistoricalBoardSnapshot<MontyBattleID>?
    @State private var completionRecord: MontyBattleCompletionRecord?
    @State private var progress = MontyCampaignProgress()
    @State private var launchError: String?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                header
                sideSelector
                launchSurface
                objectives
                mapPreview
                sources
            }
            .padding(24)
            .frame(maxWidth: 980, alignment: .leading)
        }
        .background(MontyAppPalette.paper)
        .accessibilityIdentifier(MontyAccessibilityID.battleDetail(scenario.id))
        .onAppear(perform: loadProgress)
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
            HistoricalBattleSidePicker(
                scenario: scenario,
                selectedSideID: sideSelectionBinding,
                title: "Side Selection",
                accessibilityIdentifier: MontyAccessibilityID.battleSideSelector,
                optionAccessibilityIDPrefix: "monty-side",
                isEnabled: hasPlayableDataPack
            )

            if !hasPlayableDataPack {
                Text(scenario.status.rawValue)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .accessibilityIdentifier(MontyAccessibilityID.launchUnavailable(scenario.id))
            }

            if let launchError {
                Text(launchError)
                    .font(.caption)
                    .foregroundStyle(MontyAppPalette.accent)
                    .accessibilityIdentifier(MontyAccessibilityID.launchError(scenario.id))
            }
        }
    }

    private var sideSelectionBinding: Binding<String> {
        Binding(
            get: { chosenSideID },
            set: { prepareLaunch(sideID: $0) }
        )
    }

    private var hasPlayableDataPack: Bool {
        MontyDemoDataPackCatalog.dataPack(for: scenario.id) != nil
    }

    private var launchSurface: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(MontyAppIdentity.sharedBattleSurfaceName)
                .font(.title3.weight(.semibold))

            if let launchFlow, let battleSnapshot {
                MontyPlayableBattleSurfaceView(
                    scenario: scenario,
                    launchFlow: launchFlow,
                    snapshot: battleSnapshot,
                    completionRecord: completionRecord,
                    onSelectReadyUnit: selectReadyUnit,
                    onSelectNearestEnemy: selectNearestEnemy,
                    onSelectUnit: selectBoardUnit,
                    onSelectTarget: targetBoardUnit,
                    onClearSelection: clearBoardSelection,
                    onMove: moveSelectedUnit,
                    onShoot: shootSelectedTarget,
                    onAssault: assaultSelectedTarget,
                    onIssueOrder: issueOrder,
                    onResolvePending: resolvePendingChoice,
                    onNextPhase: advancePhase,
                    onAITurn: runAutomatedPhase,
                    onRestart: restartBattle,
                    onRunToDebrief: completePreview
                )
                .accessibilityIdentifier(MontyAccessibilityID.sharedBattleSurface(scenario.id))
            } else {
                Text(scenario.status == .dataLocked ? "Ready" : "Catalog ready")
                    .font(.callout)
                    .foregroundStyle(.secondary)
                    .accessibilityIdentifier(MontyAccessibilityID.sharedBattlePending(scenario.id))
            }

            if let completionRecord {
                VStack(alignment: .leading, spacing: 6) {
                    Text(completionRecord.victoryBandLabel)
                        .font(.headline)
                    Text(completionRecord.debriefSummary)
                        .font(.callout)
                        .foregroundStyle(.secondary)
                    Text("\(completionRecord.score) VP | Turn \(completionRecord.completedTurn)")
                        .font(.caption)
                        .foregroundStyle(MontyAppPalette.navy)
                        .accessibilityIdentifier(MontyAccessibilityID.persistedResult(scenario.id))
                }
                .padding(12)
                .background(MontyAppPalette.desert.opacity(0.25), in: RoundedRectangle(cornerRadius: 6))
                .accessibilityIdentifier(MontyAccessibilityID.debriefPanel(scenario.id))
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
            .accessibilityIdentifier(MontyAccessibilityID.mapPreview(scenario.id))
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

    private func prepareLaunch(sideID: String) {
        chosenSideID = sideID
        lastSelectedSideID = sideID
        completionRecord = nil
        do {
            let flow = try MontyLaunchFlowResolver.makeLaunchFlow(
                battleID: scenario.id,
                chosenSideID: sideID
            )
            let session = MontyDemoBoardSession(flow: flow)
            launchFlow = flow
            battleSession = session
            battleSnapshot = session.snapshot()
            progress.recordSelectedSide(sideID, for: scenario.id)
            persistProgress()
            launchError = nil
        } catch {
            launchFlow = nil
            battleSession = nil
            battleSnapshot = nil
            launchError = "\(error)"
        }
    }

    private func completePreview() {
        guard let launchFlow else {
            return
        }
        do {
            let result = try MontyDemoAutoplayRunner.runBattle(
                battleID: launchFlow.scenario.id,
                chosenSideID: chosenSideID
            )
            progress = result.progress
            completionRecord = result.completionRecord
            battleSnapshot = result.report.finalSnapshot
            persistProgress()
            launchError = nil
        } catch {
            launchError = "\(error)"
        }
    }

    private func restartBattle() {
        guard let launchFlow else {
            return
        }

        let session = MontyDemoBoardSession(flow: launchFlow)
        battleSession = session
        battleSnapshot = session.snapshot()
        completionRecord = nil
        launchError = nil
        progress.recordSelectedSide(chosenSideID, for: scenario.id)
        persistProgress()
    }

    private func selectReadyUnit() {
        battleSession?.selectFirstActiveUnit()
        refreshSnapshot()
    }

    private func selectNearestEnemy() {
        battleSession?.selectNearestEnemyToSelectedUnit()
        refreshSnapshot()
    }

    private func selectBoardUnit(_ id: Int) {
        battleSession?.selectUnit(id)
        refreshSnapshot()
    }

    private func targetBoardUnit(_ id: Int) {
        battleSession?.selectTarget(id)
        refreshSnapshot()
    }

    private func clearBoardSelection() {
        battleSession?.clearSelection()
        refreshSnapshot()
    }

    private func moveSelectedUnit() {
        _ = battleSession?.moveSelectedUnitTowardNearestObjective(maxDistance: 5)
        refreshSnapshot()
    }

    private func shootSelectedTarget() {
        _ = battleSession?.shootSelectedTarget()
        refreshSnapshot()
    }

    private func assaultSelectedTarget() {
        guard let session = battleSession,
              let attacker = session.snapshot().units.first(where: { $0.selected }),
              let target = session.snapshot().units.first(where: { $0.targeted }) else {
            refreshSnapshot()
            return
        }

        _ = session.assaultUnit(attacker.id, targetID: target.id, advance: true)
        refreshSnapshot()
    }

    private func issueOrder(_ order: HistoricalBoardOrder) {
        _ = battleSession?.issueOrderToSelectedUnit(order)
        refreshSnapshot()
    }

    private func resolvePendingChoice() {
        _ = battleSession?.resolveFirstPendingChoice()
        refreshSnapshot()
    }

    private func advancePhase() {
        battleSession?.advancePhase()
        refreshSnapshot()
    }

    private func runAutomatedPhase() {
        guard let session = battleSession,
              let launchFlow else {
            return
        }

        let snapshot = session.snapshot()
        guard let decision = MontyOrderDiceAIActivationAdvisor.decision(
            flow: launchFlow,
            snapshot: snapshot
        ) else {
            refreshSnapshot()
            return
        }

        let plan = launchFlow.autoplayConfiguration.plan(for: snapshot.activeSideID)
        session.selectUnit(decision.unitID)
        if let targetID = decision.targetID {
            session.selectTarget(targetID)
        } else {
            session.selectNearestEnemyToSelectedUnit()
        }
        _ = session.issueOrder(decision.order, to: decision.unitID)

        switch decision.order {
        case .fire:
            _ = session.shootSelectedTarget()
            _ = session.resolveFirstPendingChoice()
        case .advance:
            _ = session.moveSelectedUnitTowardPriorityObjective(
                named: plan.movementPriorityNames,
                maxDistance: plan.movementDistance
            ) || session.moveSelectedUnitTowardNearestObjective(maxDistance: plan.movementDistance)
            _ = session.shootSelectedTarget()
            _ = session.resolveFirstPendingChoice()
        case .run:
            if let targetID = decision.targetID {
                _ = session.assaultUnit(decision.unitID, targetID: targetID, advance: true)
                _ = session.resolveFirstPendingChoice()
            } else {
                _ = session.moveSelectedUnitTowardPriorityObjective(
                    named: plan.movementPriorityNames,
                    maxDistance: plan.movementDistance * 2
                ) || session.moveSelectedUnitTowardNearestObjective(maxDistance: plan.movementDistance * 2)
            }
        case .ambush, .rally, .down:
            break
        }
        refreshSnapshot()
    }

    private func refreshSnapshot() {
        battleSnapshot = battleSession?.snapshot()
    }

    private func loadProgress() {
        chosenSideID = lastSelectedSideID
        guard !encodedProgress.isEmpty else {
            return
        }

        do {
            progress = try MontyCampaignProgressCodec.decode(encodedProgress)
            completionRecord = progress.completionRecord(for: scenario.id)
            chosenSideID = progress.lastSelectedSideByBattle[scenario.id] ?? lastSelectedSideID
        } catch {
            launchError = "\(error)"
        }
    }

    private func persistProgress() {
        do {
            encodedProgress = try MontyCampaignProgressCodec.encode(progress)
        } catch {
            launchError = "\(error)"
        }
    }
}

private struct MontyPlayableBattleSurfaceView: View {
    let scenario: MontyBattleScenario
    let launchFlow: MontyLaunchFlow
    let snapshot: HistoricalBoardSnapshot<MontyBattleID>
    let completionRecord: MontyBattleCompletionRecord?
    let onSelectReadyUnit: () -> Void
    let onSelectNearestEnemy: () -> Void
    let onSelectUnit: (Int) -> Void
    let onSelectTarget: (Int) -> Void
    let onClearSelection: () -> Void
    let onMove: () -> Void
    let onShoot: () -> Void
    let onAssault: () -> Void
    let onIssueOrder: (HistoricalBoardOrder) -> Void
    let onResolvePending: () -> Void
    let onNextPhase: () -> Void
    let onAITurn: () -> Void
    let onRestart: () -> Void
    let onRunToDebrief: () -> Void

    var body: some View {
        HistoricalPlayableBattleView(
            battleTitle: scenario.title,
            selectedSideTitle: launchFlow.selectedSide?.title ?? launchFlow.chosenSideID,
            opposingSideTitle: launchFlow.opposingSide?.title ?? "",
            snapshot: snapshot,
            debrief: completionRecord.map {
                HistoricalPlayableDebriefSummary(
                    title: $0.victoryBandLabel,
                    summary: $0.debriefSummary,
                    scoreLine: "\($0.score) VP | Turn \($0.completedTurn)"
                )
            },
            onSelectReadyUnit: onSelectReadyUnit,
            onSelectNearestEnemy: onSelectNearestEnemy,
            onSelectUnit: onSelectUnit,
            onSelectTarget: onSelectTarget,
            onClearSelection: onClearSelection,
            onMove: onMove,
            onShoot: onShoot,
            onAssault: onAssault,
            onIssueOrder: onIssueOrder,
            onResolvePending: onResolvePending,
            onNextPhase: onNextPhase,
            onAITurn: onAITurn,
            onRestart: onRestart,
            onRunToDebrief: onRunToDebrief
        )
    }

    @ViewBuilder
    private var battleLayout: some View {
        ViewThatFits(in: .horizontal) {
            HStack(alignment: .top, spacing: 12) {
                MontyBattleBoardView(snapshot: snapshot)
                    .frame(minWidth: 500, minHeight: 320)
                    .layoutPriority(2)

                sidebar
                    .frame(width: 280)
            }

            VStack(alignment: .leading, spacing: 10) {
                MontyBattleBoardView(snapshot: snapshot)
                    .frame(minHeight: 300)
                sidebar
            }
        }
    }

    private var sidebar: some View {
        MontyBattleSidebarView(
            scenario: scenario,
            snapshot: snapshot,
            completionRecord: completionRecord,
            selectedUnit: selectedUnit,
            targetedUnit: targetedUnit
        )
    }

    private var header: some View {
        HStack(alignment: .firstTextBaseline) {
            VStack(alignment: .leading, spacing: 3) {
                Label(launchFlow.selectedSide?.title ?? launchFlow.chosenSideID, systemImage: "flag.fill")
                    .font(.headline)
                    .foregroundStyle(MontyAppPalette.ink)
                    .lineLimit(1)

                Text("Opposition: \(launchFlow.opposingSide?.title ?? "")")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }

            Spacer(minLength: 12)

            Text("Turn \(snapshot.turnNumber) | \(snapshot.activeSideID) | \(snapshot.phase.rawValue)")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.white)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
                .padding(.horizontal, 8)
                .padding(.vertical, 5)
                .background(MontyAppPalette.navy, in: RoundedRectangle(cornerRadius: 4))
        }
    }

    private var selectedUnit: HistoricalBoardUnitSnapshot? {
        snapshot.units.first(where: \.selected)
    }

    private var targetedUnit: HistoricalBoardUnitSnapshot? {
        snapshot.units.first(where: \.targeted)
    }
}

private struct MontyBattleControlsView: View {
    let selectedUnit: HistoricalBoardUnitSnapshot?
    let targetedUnit: HistoricalBoardUnitSnapshot?
    let completionRecord: MontyBattleCompletionRecord?
    let onSelectReadyUnit: () -> Void
    let onSelectNearestEnemy: () -> Void
    let onMove: () -> Void
    let onShoot: () -> Void
    let onAssault: () -> Void
    let onResolvePending: () -> Void
    let onNextPhase: () -> Void
    let onAITurn: () -> Void
    let onRestart: () -> Void
    let onRunToDebrief: () -> Void

    private let columns = [
        GridItem(.adaptive(minimum: 118, maximum: 170), spacing: 8),
    ]

    var body: some View {
        LazyVGrid(columns: columns, alignment: .leading, spacing: 8) {
            commandButton(
                title: "Select",
                systemImage: "scope",
                identifier: MontyAccessibilityID.battleSelectReadyUnitButton,
                action: onSelectReadyUnit
            )

            commandButton(
                title: "Target",
                systemImage: "target",
                identifier: MontyAccessibilityID.battleNearestEnemyButton,
                disabled: selectedUnit == nil,
                action: onSelectNearestEnemy
            )

            commandButton(
                title: "Move",
                systemImage: "arrow.up.right",
                identifier: MontyAccessibilityID.battleMoveButton,
                disabled: selectedUnit?.canMoveNow != true,
                action: onMove
            )

            commandButton(
                title: "Shoot",
                systemImage: "scope",
                identifier: MontyAccessibilityID.battleShootButton,
                disabled: selectedUnit?.canShootNow != true || targetedUnit == nil,
                action: onShoot
            )

            commandButton(
                title: "Assault",
                systemImage: "figure.run",
                identifier: MontyAccessibilityID.battleAssaultButton,
                disabled: selectedUnit?.canAssaultNow != true || targetedUnit == nil,
                action: onAssault
            )

            commandButton(
                title: "Resolve",
                systemImage: "checkmark.circle",
                identifier: MontyAccessibilityID.battleResolvePendingButton,
                action: onResolvePending
            )

            commandButton(
                title: "Phase",
                systemImage: "forward.end",
                identifier: MontyAccessibilityID.battleNextPhaseButton,
                action: onNextPhase
            )

            commandButton(
                title: "AI Phase",
                systemImage: "cpu",
                identifier: MontyAccessibilityID.battleAITurnButton,
                disabled: completionRecord != nil,
                action: onAITurn
            )

            commandButton(
                title: "Restart",
                systemImage: "arrow.clockwise",
                identifier: MontyAccessibilityID.battleRestartButton,
                action: onRestart
            )

            commandButton(
                title: "Debrief",
                systemImage: "checkmark.seal",
                identifier: MontyAccessibilityID.battleRunToDebriefButton,
                prominent: true,
                disabled: completionRecord != nil,
                action: onRunToDebrief
            )
        }
    }

    @ViewBuilder
    private func commandButton(
        title: String,
        systemImage: String,
        identifier: String,
        prominent: Bool = false,
        disabled: Bool = false,
        action: @escaping () -> Void
    ) -> some View {
        if prominent {
            Button(action: action) {
                commandLabel(title: title, systemImage: systemImage)
            }
            .buttonStyle(.borderedProminent)
            .tint(MontyAppPalette.olive)
            .disabled(disabled)
            .accessibilityIdentifier(identifier)
            .accessibilityHint(helpText(title: title, disabled: disabled))
            .help(helpText(title: title, disabled: disabled))
        } else {
            Button(action: action) {
                commandLabel(title: title, systemImage: systemImage)
            }
            .buttonStyle(.bordered)
            .tint(MontyAppPalette.navy)
            .disabled(disabled)
            .accessibilityIdentifier(identifier)
            .accessibilityHint(helpText(title: title, disabled: disabled))
            .help(helpText(title: title, disabled: disabled))
        }
    }

    private func commandLabel(title: String, systemImage: String) -> some View {
        Label(title, systemImage: systemImage)
            .lineLimit(1)
            .minimumScaleFactor(0.8)
            .frame(maxWidth: .infinity, minHeight: 30)
    }

    private func helpText(title: String, disabled: Bool) -> String {
        if disabled {
            return "\(title) is waiting for a legal unit, phase, target, or unresolved debrief state."
        }
        return "\(title) command"
    }
}

private struct MontyBattleSidebarView: View {
    let scenario: MontyBattleScenario
    let snapshot: HistoricalBoardSnapshot<MontyBattleID>
    let completionRecord: MontyBattleCompletionRecord?
    let selectedUnit: HistoricalBoardUnitSnapshot?
    let targetedUnit: HistoricalBoardUnitSnapshot?

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(snapshot.lastAction.title)
                    .font(.caption.weight(.bold))
                    .foregroundStyle(MontyAppPalette.ink)
                Text(snapshot.lastAction.detail)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(8)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(actionColor.opacity(0.14), in: RoundedRectangle(cornerRadius: 6))
            .accessibilityIdentifier(MontyAccessibilityID.battleActionFeedback)

            VStack(alignment: .leading, spacing: 5) {
                Text("Inspector")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
                Text(selectedUnit?.name ?? "No unit selected")
                    .font(.callout.weight(.semibold))
                    .lineLimit(2)
                Text(targetedUnit.map { "Target: \($0.name)" } ?? "No target")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }

            VStack(alignment: .leading, spacing: 6) {
                Text("Objectives")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)

                ForEach(snapshot.objectives) { objective in
                    HStack(alignment: .firstTextBaseline, spacing: 6) {
                        Circle()
                            .fill(objective.controllingSideID == MontySideID.montgomery ? MontyAppPalette.navy : MontyAppPalette.accent)
                            .frame(width: 7, height: 7)
                        Text(objective.name)
                            .font(.caption)
                            .lineLimit(2)
                    }
                }
            }
            .accessibilityIdentifier(MontyAccessibilityID.battleObjectives)

            VStack(alignment: .leading, spacing: 6) {
                Text("Log")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)

                ScrollView {
                    VStack(alignment: .leading, spacing: 4) {
                        ForEach(Array(snapshot.log.suffix(8).enumerated()), id: \.offset) { _, entry in
                            Text(entry)
                                .font(.caption2)
                                .foregroundStyle(MontyAppPalette.ink)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                }
                .frame(maxHeight: 110)
            }
            .accessibilityIdentifier(MontyAccessibilityID.battleLog)

            if let completionRecord {
                VStack(alignment: .leading, spacing: 5) {
                    Text(completionRecord.victoryBandLabel)
                        .font(.headline)
                    Text(completionRecord.debriefSummary)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text("\(completionRecord.score) VP | Turn \(completionRecord.completedTurn)")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(MontyAppPalette.navy)
                        .accessibilityIdentifier(MontyAccessibilityID.battlePersistedResult)
                }
                .padding(8)
                .background(MontyAppPalette.desert.opacity(0.22), in: RoundedRectangle(cornerRadius: 6))
                .accessibilityIdentifier(MontyAccessibilityID.battleDebriefPanel)
            }
        }
        .padding(10)
        .background(MontyAppPalette.paper.opacity(0.74), in: RoundedRectangle(cornerRadius: 6))
        .accessibilityIdentifier(MontyAccessibilityID.battleSidebar)
    }

    private var actionColor: Color {
        switch snapshot.lastAction.status {
        case .idle:
            return MontyAppPalette.navy
        case .succeeded:
            return MontyAppPalette.olive
        case .blocked:
            return MontyAppPalette.accent
        }
    }
}

private struct MontyBattleBoardView: View {
    let snapshot: HistoricalBoardSnapshot<MontyBattleID>

    var body: some View {
        GeometryReader { proxy in
            ZStack {
                Rectangle()
                    .fill(Color(red: 0.67, green: 0.61, blue: 0.44))

                ForEach(snapshot.zones) { zone in
                    zoneView(zone, proxy: proxy)
                }

                ForEach(snapshot.objectives) { objective in
                    objectiveView(objective, proxy: proxy)
                }

                ForEach(snapshot.units) { unit in
                    unitView(unit, proxy: proxy)
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 6))
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(MontyAppPalette.navy.opacity(0.35), lineWidth: 1)
            )
        }
        .aspectRatio(1.55, contentMode: .fit)
        .accessibilityElement(children: .contain)
        .accessibilityIdentifier(MontyAccessibilityID.battleBoard)
    }

    private func zoneView(_ zone: HistoricalBoardZoneSnapshot, proxy: GeometryProxy) -> some View {
        RoundedRectangle(cornerRadius: 5)
            .fill(zoneColor(zone.kind).opacity(0.44))
            .frame(
                width: max(42, scaledWidth(zone.width, proxy: proxy)),
                height: max(22, scaledHeight(zone.height, proxy: proxy))
            )
            .position(position(zone.origin, proxy: proxy))
            .overlay {
                Text(zone.name)
                    .font(.caption2.weight(.semibold))
                    .foregroundStyle(.white)
                    .lineLimit(2)
                    .minimumScaleFactor(0.72)
                    .multilineTextAlignment(.center)
                    .padding(3)
            }
            .accessibilityLabel(zone.name)
            .accessibilityIdentifier(MontyAccessibilityID.battleZone(zone.id))
    }

    private func objectiveView(_ objective: HistoricalBoardObjectiveSnapshot, proxy: GeometryProxy) -> some View {
        ZStack {
            Circle()
                .fill(Color.white)
            Circle()
                .fill(objective.controllingSideID == MontySideID.montgomery ? MontyAppPalette.navy : MontyAppPalette.accent)
                .padding(3)
        }
        .frame(width: 22, height: 22)
        .position(position(objective.location, proxy: proxy))
        .help(objective.name)
        .accessibilityLabel(objective.name)
        .accessibilityIdentifier(MontyAccessibilityID.battleObjectiveToken(objective.id))
    }

    private func unitView(_ unit: HistoricalBoardUnitSnapshot, proxy: GeometryProxy) -> some View {
        VStack(spacing: 2) {
            Image(systemName: iconName(for: unit))
                .font(.caption.weight(.semibold))
            Text(unit.name)
                .font(.caption2.weight(.semibold))
                .lineLimit(1)
                .minimumScaleFactor(0.66)
        }
        .foregroundStyle(.white)
        .padding(.horizontal, 6)
        .padding(.vertical, 5)
        .frame(width: 108, height: 42)
        .background(unitColor(unit.sideID), in: RoundedRectangle(cornerRadius: 5))
        .overlay {
            RoundedRectangle(cornerRadius: 5)
                .stroke(unit.selected || unit.targeted ? Color.yellow : Color.white.opacity(0.18), lineWidth: unit.selected || unit.targeted ? 2 : 1)
        }
        .opacity(unit.destroyed ? 0.42 : 1)
        .position(position(unit.position, proxy: proxy))
        .help("\(unit.name), \(unit.role)")
        .accessibilityLabel("\(unit.name), \(unit.sideID), \(unit.kind)")
        .accessibilityIdentifier(MontyAccessibilityID.battleUnitToken(unit.id))
    }

    private func zoneColor(_ kind: HistoricalMapElementKind) -> Color {
        switch kind {
        case .ridge, .forest:
            return Color(red: 0.23, green: 0.42, blue: 0.28)
        case .minefield:
            return MontyAppPalette.accent
        case .road, .bridge, .phaseLine:
            return MontyAppPalette.navy
        case .river:
            return Color(red: 0.18, green: 0.39, blue: 0.52)
        case .town, .objective:
            return Color(red: 0.44, green: 0.29, blue: 0.18)
        default:
            return Color.gray
        }
    }

    private func unitColor(_ sideID: String) -> Color {
        sideID == MontySideID.montgomery ? MontyAppPalette.navy : MontyAppPalette.accent
    }

    private func iconName(for unit: HistoricalBoardUnitSnapshot) -> String {
        switch unit.kind {
        case "Armour":
            return "shield.lefthalf.filled"
        case "Gun":
            return "scope"
        case "Command":
            return "flag.2.crossed.fill"
        default:
            return "flag.fill"
        }
    }

    private func position(_ point: HistoricalBattleCoordinate, proxy: GeometryProxy) -> CGPoint {
        CGPoint(
            x: min(max(18, point.x / 100 * proxy.size.width), proxy.size.width - 18),
            y: min(max(18, point.y / 64 * proxy.size.height), proxy.size.height - 18)
        )
    }

    private func scaledWidth(_ width: Double, proxy: GeometryProxy) -> Double {
        width / 100 * proxy.size.width
    }

    private func scaledHeight(_ height: Double, proxy: GeometryProxy) -> Double {
        height / 64 * proxy.size.height
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
            .accessibilityIdentifier(MontyAccessibilityID.mapElement(element.id))
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
