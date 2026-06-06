import SwiftUI

struct RootTabView: View {
    @EnvironmentObject private var captioning: CaptioningManager
    @EnvironmentObject private var session: FlameHubSession

    var body: some View {
        TabView {
            JumbotronView(onEnableCaptioning: { captioning.isEnabled = true })
                .tabItem { Label("Home",      systemImage: "waveform") }

            CaptioningScreen()
                .tabItem { Label("Captions",  systemImage: "captions.bubble.fill") }

            FlameHubView()
                .tabItem { Label("FlameHub",  systemImage: "flame.fill") }
        }
        .tint(Color("SpacePurple"))
    }
}
