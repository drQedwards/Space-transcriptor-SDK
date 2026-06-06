import SwiftUI

@main
struct SpaceTranscriptorApp: App {
    @StateObject private var captioningManager = CaptioningManager()
    @StateObject private var flameHubSession  = FlameHubSession()

    var body: some Scene {
        WindowGroup {
            RootTabView()
                .environmentObject(captioningManager)
                .environmentObject(flameHubSession)
                // Report true device identity on iOS 26+ (frozen Safari UA workaround)
                .onAppear { flameHubSession.registerDeviceContext() }
        }
    }
}
