import MontyCore
import SwiftUI

@main
struct MontyTestApp: App {
    var body: some Scene {
        WindowGroup("MontyTest") {
            MontyTestFirstBattleAutoplayView()
                .frame(minWidth: 980, minHeight: 680)
        }
        .windowResizability(.contentMinSize)
    }
}

private struct MontyTestFirstBattleAutoplayView: View {
    @StateObject private var model = MontyTestViewModel()

    var body: some View {
        VStack(spacing: 0) {
            toolbar
            Divider()
            if let snapshot = model.snapshot {
                HStack(alignment: .top, spacing: 0) {
                    battleSurface(snapshot: snapshot)
                    Divider()
                    sidePanel(snapshot: snapshot)
                }
            } else {
                ContentUnavailableView("MontyTest", systemImage: "exclamationmark.triangle", description: Text(model.errorMessage ?? "Unable to load the first demo battle."))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .background(Color(red: 0.89, green: 0.86, blue: 0.77))
        .accessibilityElement(children: .contain)
        .accessibilityIdentifier(MontyAccessibilityID.montyTestFirstBattleAutoplay)
    }

    private var toolbar: some View {
        HStack(spacing: 10) {
            VStack(alignment: .leading, spacing: 2) {
                Text(model.title)
                    .font(.headline)
                Text(model.runState.rawValue)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Picker("Speed", selection: $model.speed) {
                ForEach(HistoricalAutoplaySpeed.allCases) { speed in
                    Text(speed.rawValue).tag(speed)
                }
            }
            .pickerStyle(.segmented)
            .frame(width: 240)
            .accessibilityIdentifier(MontyAccessibilityID.montyTestSpeedPicker)

            Button {
                model.step()
            } label: {
                Label("Step", systemImage: "forward.frame")
            }
            .disabled(!model.canStep)
            .accessibilityIdentifier(MontyAccessibilityID.montyTestStepButton)

            Button {
                model.pause()
            } label: {
                Label("Pause", systemImage: "pause.fill")
            }
            .disabled(model.runState != .running)
            .accessibilityIdentifier(MontyAccessibilityID.montyTestPauseButton)

            Button {
                model.reset()
            } label: {
                Label("Restart", systemImage: "arrow.clockwise")
            }
            .accessibilityIdentifier(MontyAccessibilityID.montyTestRestartButton)

            Button {
                model.runToDebrief()
            } label: {
                Label("Run", systemImage: "play.fill")
            }
            .buttonStyle(.borderedProminent)
            .disabled(model.runState.isTerminal)
            .accessibilityIdentifier(MontyAccessibilityID.montyTestRunToDebriefButton)
        }
        .padding(12)
    }

    private func battleSurface(snapshot: HistoricalBoardSnapshot<MontyBattleID>) -> some View {
        VStack {
            HistoricalPlayableBattleView(
                battleTitle: model.title,
                selectedSideTitle: "Montgomery command",
                opposingSideTitle: "Opposing command",
                snapshot: snapshot,
                debrief: model.result.map {
                    HistoricalPlayableDebriefSummary(
                        title: $0.completionRecord.victoryBandLabel,
                        summary: $0.completionRecord.debriefSummary,
                        scoreLine: "\($0.completionRecord.score) VP | Turn \($0.completionRecord.completedTurn)",
                        persistedResultIdentifier: MontyAccessibilityID.battlePersistedResult
                    )
                },
                onSelectReadyUnit: model.selectReadyUnit,
                onSelectNearestEnemy: model.selectNearestEnemy,
                onSelectUnit: model.selectBoardUnit,
                onSelectTarget: model.targetBoardUnit,
                onClearSelection: model.clearBoardSelection,
                onMove: model.moveSelectedUnit,
                onShoot: model.shootSelectedTarget,
                onAssault: model.assaultSelectedTarget,
                onIssueOrder: model.issueOrder,
                onResolvePending: model.resolvePendingChoice,
                onNextPhase: model.advancePhase,
                onAITurn: model.step,
                onRestart: model.reset,
                onRunToDebrief: model.runToDebrief
            )
        }
        .frame(minWidth: 620, maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        .accessibilityIdentifier(MontyAccessibilityID.montyTestPrimaryBattleSurface)
    }

    private func sidePanel(snapshot: HistoricalBoardSnapshot<MontyBattleID>) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            VStack(alignment: .leading, spacing: 6) {
                Text("Safety Cap")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
                ProgressView(value: model.phaseProgressFraction)
                Text("\(model.phaseAdvances) of \(model.maxPhaseAdvances) phase advances")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .accessibilityIdentifier(MontyAccessibilityID.montyTestSafetyCap)

            VStack(alignment: .leading, spacing: 6) {
                Text("Event Log")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
                ScrollView {
                    VStack(alignment: .leading, spacing: 5) {
                        ForEach(Array(snapshot.log.enumerated()), id: \.offset) { _, entry in
                            Text(entry)
                                .font(.caption)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                }
            }
            .accessibilityIdentifier(MontyAccessibilityID.montyTestEventLog)

            if let result = model.result {
                VStack(alignment: .leading, spacing: 8) {
                    Text(result.completionRecord.victoryBandLabel)
                        .font(.headline)
                    Text(result.report.finalResultSummary)
                        .font(.callout)
                        .foregroundStyle(.secondary)
                        .accessibilityIdentifier(MontyAccessibilityID.montyTestResultSummary)
                    Text(result.completionRecord.debriefSummary)
                        .font(.caption)
                }
                .padding(10)
                .background(Color.white.opacity(0.58), in: RoundedRectangle(cornerRadius: 6))
                .accessibilityIdentifier(MontyAccessibilityID.montyTestResultPanel)
            } else {
                Text(snapshot.lastAction.detail)
                    .font(.callout)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            Spacer()
        }
        .padding(14)
        .frame(width: 300)
    }

    private func zoneView(_ zone: HistoricalBoardZoneSnapshot, proxy: GeometryProxy) -> some View {
        RoundedRectangle(cornerRadius: 4)
            .fill(zoneColor(zone.kind).opacity(0.45))
            .frame(width: max(34, scaledWidth(zone.width, proxy: proxy)), height: max(18, scaledHeight(zone.height, proxy: proxy)))
            .position(position(zone.origin, proxy: proxy))
            .overlay {
                Text(zone.name)
                    .font(.caption2.weight(.medium))
                    .foregroundStyle(.white)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                    .padding(2)
            }
            .accessibilityIdentifier(MontyAccessibilityID.battleZone(zone.id))
    }

    private func objectiveView(_ objective: HistoricalBoardObjectiveSnapshot, proxy: GeometryProxy) -> some View {
        Circle()
            .strokeBorder(Color.white, lineWidth: 2)
            .background(Circle().fill(Color(red: 0.64, green: 0.18, blue: 0.16)))
            .frame(width: 18, height: 18)
            .position(position(objective.location, proxy: proxy))
            .help(objective.name)
            .accessibilityIdentifier(MontyAccessibilityID.battleObjectiveToken(objective.id))
    }

    private func unitView(_ unit: HistoricalBoardUnitSnapshot, proxy: GeometryProxy) -> some View {
        VStack(spacing: 2) {
            Image(systemName: unit.kind == "Armour" ? "shield.lefthalf.filled" : "flag.fill")
                .font(.caption)
            Text(unit.name)
                .font(.caption2.weight(.semibold))
                .lineLimit(1)
        }
        .foregroundStyle(.white)
        .padding(.horizontal, 6)
        .padding(.vertical, 5)
        .background(unitColor(unit.sideID), in: RoundedRectangle(cornerRadius: 5))
        .overlay {
            RoundedRectangle(cornerRadius: 5)
                .stroke(unit.selected || unit.targeted ? Color.yellow : Color.clear, lineWidth: 2)
        }
        .frame(width: 104)
        .position(position(unit.position, proxy: proxy))
        .accessibilityIdentifier(MontyAccessibilityID.battleUnitToken(unit.id))
    }

    private func zoneColor(_ kind: HistoricalMapElementKind) -> Color {
        switch kind {
        case .ridge:
            return Color(red: 0.23, green: 0.42, blue: 0.28)
        case .minefield:
            return Color(red: 0.55, green: 0.18, blue: 0.12)
        case .road, .bridge:
            return Color(red: 0.24, green: 0.28, blue: 0.33)
        case .town, .objective:
            return Color(red: 0.44, green: 0.29, blue: 0.18)
        default:
            return Color.gray
        }
    }

    private func unitColor(_ sideID: String) -> Color {
        sideID == MontySideID.montgomery
            ? Color(red: 0.12, green: 0.27, blue: 0.42)
            : Color(red: 0.44, green: 0.18, blue: 0.15)
    }

    private func position(_ point: HistoricalBattleCoordinate, proxy: GeometryProxy) -> CGPoint {
        CGPoint(
            x: min(max(12, point.x / 100 * proxy.size.width), proxy.size.width - 12),
            y: min(max(12, point.y / 64 * proxy.size.height), proxy.size.height - 12)
        )
    }

    private func scaledWidth(_ width: Double, proxy: GeometryProxy) -> Double {
        width / 100 * proxy.size.width
    }

    private func scaledHeight(_ height: Double, proxy: GeometryProxy) -> Double {
        height / 64 * proxy.size.height
    }
}

@MainActor
private final class MontyTestViewModel: ObservableObject {
    @Published var snapshot: HistoricalBoardSnapshot<MontyBattleID>?
    @Published var result: MontyDemoAutoplayResult?
    @Published var errorMessage: String?
    @Published var speed: HistoricalAutoplaySpeed = .standard

    private var controller: MontyTestFirstBattleRunController?

    init() {
        reset()
    }

    var title: String {
        controller?.flow.scenario.title ?? "MontyTest"
    }

    var runState: HistoricalAutoplayRunState {
        controller?.runState ?? .failed
    }

    var canStep: Bool {
        controller?.controller.canStep ?? false
    }

    var phaseAdvances: Int {
        controller?.phaseAdvances ?? 0
    }

    var maxPhaseAdvances: Int {
        controller?.controller.maxPhaseAdvances ?? 1
    }

    var phaseProgressFraction: Double {
        controller?.controller.phaseProgressFraction ?? 0
    }

    func reset() {
        do {
            controller = try MontyTestFirstBattleRunController()
            snapshot = controller?.latestSnapshot
            result = nil
            errorMessage = nil
        } catch {
            controller = nil
            snapshot = nil
            result = nil
            errorMessage = "\(error)"
        }
    }

    func step() {
        do {
            _ = try controller?.stepOnce()
            refreshFromController()
        } catch {
            errorMessage = "\(error)"
        }
    }

    func pause() {
        controller?.pause()
        refreshFromController()
    }

    func runToDebrief() {
        do {
            result = try controller?.runToDebrief()
            refreshFromController()
        } catch {
            errorMessage = "\(error)"
        }
    }

    func selectReadyUnit() {
        controller?.session.selectFirstActiveUnit()
        refreshFromSession()
    }

    func selectNearestEnemy() {
        controller?.session.selectNearestEnemyToSelectedUnit()
        refreshFromSession()
    }

    func selectBoardUnit(_ id: Int) {
        controller?.session.selectUnit(id)
        refreshFromSession()
    }

    func targetBoardUnit(_ id: Int) {
        controller?.session.selectTarget(id)
        refreshFromSession()
    }

    func clearBoardSelection() {
        controller?.session.clearSelection()
        refreshFromSession()
    }

    func moveSelectedUnit() {
        _ = controller?.session.moveSelectedUnitTowardNearestObjective(maxDistance: 5)
        refreshFromSession()
    }

    func shootSelectedTarget() {
        _ = controller?.session.shootSelectedTarget()
        refreshFromSession()
    }

    func assaultSelectedTarget() {
        guard let session = controller?.session,
              let attacker = session.snapshot().units.first(where: { $0.selected }),
              let target = session.snapshot().units.first(where: { $0.targeted }) else {
            refreshFromSession()
            return
        }

        _ = session.assaultUnit(attacker.id, targetID: target.id, advance: true)
        refreshFromSession()
    }

    func issueOrder(_ order: HistoricalBoardOrder) {
        _ = controller?.session.issueOrderToSelectedUnit(order)
        refreshFromSession()
    }

    func resolvePendingChoice() {
        _ = controller?.session.resolveFirstPendingChoice()
        refreshFromSession()
    }

    func advancePhase() {
        controller?.session.advancePhase()
        refreshFromSession()
    }

    private func refreshFromController() {
        snapshot = controller?.latestSnapshot
        if result == nil, let controller, let report = controller.lastReport {
            result = MontyDemoAutoplayResult(
                flow: controller.flow,
                report: report,
                completionRecord: controller.completionRecord ?? controller.flow.debriefPreview(),
                progress: controller.progress
            )
        }
    }

    private func refreshFromSession() {
        snapshot = controller?.session.snapshot()
    }
}
