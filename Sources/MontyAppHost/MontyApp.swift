import MontyAppUI
import MontyCore
import SwiftUI

@main
struct MontyApp: App {
    var body: some Scene {
        WindowGroup(MontyAppIdentity.appName) {
            MontyCampaignView()
                .frame(minWidth: 1120, minHeight: 760)
        }
        .windowResizability(.contentMinSize)
    }
}
