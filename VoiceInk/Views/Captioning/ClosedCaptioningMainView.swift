import SwiftUI

struct ClosedCaptioningMainView: View {
    @EnvironmentObject private var engine: VoiceInkEngine
    @AppStorage("closedCaptioningEnabled") private var isEnabled: Bool = false
    @StateObject private var windowManager = ClosedCaptioningWindowManager()

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                JumbotronView.captioningHero {
                    isEnabled.toggle()
                }
                .padding(.horizontal, 24)
                .padding(.top, 24)

                ClosedCaptioningSettingsView()
                    .padding(.horizontal, 24)
                    .padding(.bottom, 24)
            }
        }
        .scrollContentBackground(.hidden)
        .background(Color(NSColor.controlBackgroundColor))
        .onAppear {
            if isEnabled {
                windowManager.show(engine: engine)
            }
        }
        .onChange(of: isEnabled) { _, enabled in
            if enabled {
                windowManager.show(engine: engine)
            } else {
                windowManager.hide()
            }
        }
    }
}
