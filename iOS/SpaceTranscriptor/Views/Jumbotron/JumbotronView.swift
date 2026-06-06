import SwiftUI

// Cross-platform animated hero — works on iOS 26+ and macOS 15+
struct JumbotronView: View {
    let onEnableCaptioning: () -> Void

    @State private var glowPulse  = false
    @State private var appeared   = false

    private let features: [(String, String, String)] = [
        ("mic.fill",              "Live Transcription", "Real-time Whisper speech-to-text"),
        ("captions.bubble.fill",  "CC Overlay",         "Float captions over any app"),
        ("flame.fill",            "FlameHub",           "Post transcripts to your FlameNet"),
        ("slider.horizontal.3",   "Customizable",       "Font, opacity, position"),
    ]

    var body: some View {
        ZStack {
            // Gradient background
            LinearGradient(
                colors: [Color(hex: "0A0A1A"), Color(hex: "12122A"), Color(hex: "0A0A0F")],
                startPoint: .top, endPoint: .bottom
            )
            .ignoresSafeArea()

            // Glow orbs
            GlowOrb(color: Color("SpacePurple").opacity(glowPulse ? 0.35 : 0.15), size: 280)
                .offset(x: 120, y: -180)
            GlowOrb(color: Color("SpaceBlue").opacity(glowPulse ? 0.20 : 0.10), size: 200)
                .offset(x: -130, y: 220)

            ScrollView {
                VStack(spacing: 0) {
                    Spacer(minLength: 48)

                    // Live badge
                    HStack(spacing: 6) {
                        Circle().fill(Color("SpaceTeal")).frame(width: 6, height: 6)
                        Text("LIVE CAPTIONS")
                            .font(.system(size: 11, weight: .bold))
                            .kerning(1.5)
                            .foregroundStyle(Color("SpaceTeal"))
                    }
                    .padding(.horizontal, 14).padding(.vertical, 6)
                    .background(Color("SpacePurple").opacity(0.15), in: Capsule())
                    .opacity(appeared ? 1 : 0)

                    Spacer(minLength: 20)

                    // Title
                    VStack(spacing: 0) {
                        Text("Space")
                            .font(.system(size: 52, weight: .black))
                            .foregroundStyle(.white)
                        Text("Transcriptor")
                            .font(.system(size: 52, weight: .black))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [Color("SpacePurple"), Color("SpaceBlue")],
                                    startPoint: .leading, endPoint: .trailing
                                )
                            )
                    }
                    .offset(y: appeared ? 0 : 24)
                    .opacity(appeared ? 1 : 0)

                    Spacer(minLength: 16)

                    Text("Real-time closed captioning for\nFlameHub Spaces & beyond")
                        .font(.system(size: 16))
                        .foregroundStyle(.white.opacity(0.6))
                        .multilineTextAlignment(.center)
                        .opacity(appeared ? 1 : 0)

                    Spacer(minLength: 40)

                    // Feature grid
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                        ForEach(features, id: \.0) { icon, title, desc in
                            FeatureCard(icon: icon, title: title, description: desc)
                        }
                    }
                    .padding(.horizontal, 24)

                    Spacer(minLength: 40)

                    Button(action: onEnableCaptioning) {
                        Label("Enable Closed Captions", systemImage: "captions.bubble.fill")
                            .font(.system(size: 16, weight: .semibold))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(Color("SpacePurple"))
                    .padding(.horizontal, 24)

                    Spacer(minLength: 32)
                }
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.8).delay(0.1)) { appeared = true }
            withAnimation(.easeInOut(duration: 1.8).repeatForever(autoreverses: true)) {
                glowPulse = true
            }
        }
    }
}

private struct FeatureCard: View {
    let icon: String
    let title: String
    let description: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 22))
                .foregroundStyle(Color("SpacePurple"))
            Text(title)
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(.white)
            Text(description)
                .font(.system(size: 11))
                .foregroundStyle(.white.opacity(0.5))
                .lineLimit(2)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(.white.opacity(0.05), in: RoundedRectangle(cornerRadius: 16))
    }
}

private struct GlowOrb: View {
    let color: Color
    let size: CGFloat

    var body: some View {
        Circle()
            .fill(color)
            .frame(width: size, height: size)
            .blur(radius: 60)
    }
}

extension Color {
    init(hex: String) {
        let v = UInt64(hex.trimmingCharacters(in: .init(charactersIn: "#")), radix: 16) ?? 0
        self.init(
            red:   Double((v >> 16) & 0xFF) / 255,
            green: Double((v >> 8)  & 0xFF) / 255,
            blue:  Double(v         & 0xFF) / 255
        )
    }
}
