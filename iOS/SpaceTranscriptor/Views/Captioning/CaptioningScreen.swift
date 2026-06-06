import SwiftUI

struct CaptioningScreen: View {
    @EnvironmentObject private var manager: CaptioningManager
    @AppStorage("ios.caption.fontSize")   private var fontSize: Double = 18
    @AppStorage("ios.caption.opacity")    private var opacity:  Double = 0.9

    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex: "0A0A0F").ignoresSafeArea()

                List {
                    // Preview
                    Section {
                        PreviewCard(fontSize: fontSize, opacity: opacity)
                    }
                    .listRowBackground(Color(hex: "0D0D14"))

                    // Enable toggle
                    Section {
                        Toggle(isOn: $manager.isEnabled) {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Enable Captions")
                                    .foregroundStyle(.white)
                                    .font(.system(size: 16, weight: .semibold))
                                Text("Show overlay during transcription")
                                    .foregroundStyle(.white.opacity(0.5))
                                    .font(.system(size: 13))
                            }
                        }
                        .tint(Color("SpacePurple"))
                    }
                    .listRowBackground(Color("SpaceCard"))

                    // Font size
                    Section("Font Size") {
                        VStack {
                            HStack {
                                Text("Size")
                                    .foregroundStyle(.white)
                                Spacer()
                                Text("\(Int(fontSize))pt")
                                    .foregroundStyle(Color("SpacePurple"))
                                    .monospacedDigit()
                            }
                            Slider(value: $fontSize, in: 12...32, step: 1)
                                .tint(Color("SpacePurple"))
                        }
                    }
                    .listRowBackground(Color("SpaceCard"))

                    // Opacity
                    Section("Background Opacity") {
                        VStack {
                            HStack {
                                Text("Opacity")
                                    .foregroundStyle(.white)
                                Spacer()
                                Text("\(Int(opacity * 100))%")
                                    .foregroundStyle(Color("SpacePurple"))
                                    .monospacedDigit()
                            }
                            Slider(value: $opacity, in: 0.4...1.0)
                                .tint(Color("SpacePurple"))
                        }
                    }
                    .listRowBackground(Color("SpaceCard"))
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("Closed Captions")
            .navigationBarTitleDisplayMode(.large)
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
    }
}

private struct PreviewCard: View {
    let fontSize: Double
    let opacity: Double
    @State private var cursorVisible = true

    var body: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.black.opacity(opacity * 0.85))

            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 6) {
                    Circle()
                        .fill(Color("SpaceTeal"))
                        .frame(width: 7, height: 7)
                    Text("LIVE")
                        .font(.system(size: 10, weight: .bold))
                        .kerning(1)
                        .foregroundStyle(Color("SpaceTeal"))
                }

                HStack(alignment: .bottom, spacing: 0) {
                    Text("Hello, welcome to Space Transcriptor")
                        .font(.system(size: fontSize, design: .monospaced))
                        .foregroundStyle(.white)
                    Text("▌")
                        .font(.system(size: fontSize, design: .monospaced))
                        .foregroundStyle(.white.opacity(cursorVisible ? 1 : 0))
                }
            }
            .padding(16)
        }
        .frame(height: 90)
        .onAppear {
            withAnimation(.easeInOut(duration: 0.6).repeatForever(autoreverses: true)) {
                cursorVisible = false
            }
        }
    }
}
