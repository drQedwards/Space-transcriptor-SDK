import SwiftUI

struct JumbotronView: View {
    let icon: String
    let title: String
    let subtitle: String
    let description: String
    var features: [JumbotronFeature] = []
    var ctaLabel: String? = nil
    var ctaAction: (() -> Void)? = nil
    var accentColor: Color = .blue

    @State private var glowPulse = false
    @State private var appeared = false

    var body: some View {
        ZStack {
            background
            content
        }
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .onAppear {
            withAnimation(.easeInOut(duration: 1.8).repeatForever(autoreverses: true)) {
                glowPulse = true
            }
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.1)) {
                appeared = true
            }
        }
    }

    // MARK: - Background

    private var background: some View {
        ZStack {
            LinearGradient(
                colors: [
                    accentColor.opacity(0.18),
                    accentColor.opacity(0.06),
                    Color.clear
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            Circle()
                .fill(accentColor.opacity(glowPulse ? 0.14 : 0.07))
                .frame(width: 260, height: 260)
                .blur(radius: 50)
                .offset(x: -60, y: -40)
                .animation(.easeInOut(duration: 1.8).repeatForever(autoreverses: true), value: glowPulse)

            Circle()
                .fill(accentColor.opacity(glowPulse ? 0.08 : 0.04))
                .frame(width: 180, height: 180)
                .blur(radius: 40)
                .offset(x: 80, y: 60)
                .animation(.easeInOut(duration: 2.2).repeatForever(autoreverses: true), value: glowPulse)

            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .strokeBorder(accentColor.opacity(0.18), lineWidth: 1)
        }
    }

    // MARK: - Content

    private var content: some View {
        VStack(spacing: 0) {
            heroSection
            if !features.isEmpty {
                Divider().opacity(0.2).padding(.horizontal, 28)
                featuresSection
            }
            if let label = ctaLabel, let action = ctaAction {
                ctaSection(label: label, action: action)
            }
        }
        .padding(.vertical, 32)
        .padding(.horizontal, 28)
    }

    private var heroSection: some View {
        VStack(spacing: 20) {
            ZStack {
                Circle()
                    .fill(accentColor.opacity(0.15))
                    .frame(width: 90, height: 90)
                    .blur(radius: glowPulse ? 18 : 12)

                Circle()
                    .fill(accentColor.opacity(0.1))
                    .frame(width: 72, height: 72)

                Image(systemName: icon)
                    .font(.system(size: 30, weight: .medium))
                    .foregroundStyle(accentColor)
                    .symbolRenderingMode(.hierarchical)
                    .scaleEffect(appeared ? 1.0 : 0.6)
                    .opacity(appeared ? 1.0 : 0.0)
            }
            .frame(width: 72, height: 72)

            VStack(spacing: 8) {
                Text(subtitle)
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(accentColor)
                    .kerning(1.2)
                    .textCase(.uppercase)
                    .opacity(appeared ? 1 : 0)
                    .offset(y: appeared ? 0 : 6)

                Text(title)
                    .font(.system(size: 28, weight: .bold, design: .default))
                    .multilineTextAlignment(.center)
                    .opacity(appeared ? 1 : 0)
                    .offset(y: appeared ? 0 : 8)

                Text(description)
                    .font(.system(size: 14))
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(3)
                    .padding(.horizontal, 12)
                    .opacity(appeared ? 1 : 0)
                    .offset(y: appeared ? 0 : 10)
            }
        }
        .padding(.bottom, features.isEmpty && ctaLabel == nil ? 0 : 24)
    }

    private var featuresSection: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
            ForEach(Array(features.enumerated()), id: \.offset) { index, feature in
                JumbotronFeatureCell(feature: feature, accentColor: accentColor)
                    .opacity(appeared ? 1 : 0)
                    .offset(y: appeared ? 0 : 12)
                    .animation(
                        .spring(response: 0.5, dampingFraction: 0.8).delay(0.2 + Double(index) * 0.06),
                        value: appeared
                    )
            }
        }
        .padding(.top, 20)
        .padding(.bottom, ctaLabel != nil ? 20 : 0)
    }

    private func ctaSection(label: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(label)
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(.white)
                .padding(.horizontal, 24)
                .padding(.vertical, 10)
                .background(accentColor)
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
        .padding(.top, 20)
        .opacity(appeared ? 1 : 0)
        .scaleEffect(appeared ? 1 : 0.9)
    }
}

// MARK: - Feature Model

struct JumbotronFeature {
    let icon: String
    let label: String
    let detail: String
}

// MARK: - Feature Cell

private struct JumbotronFeatureCell: View {
    let feature: JumbotronFeature
    let accentColor: Color

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: feature.icon)
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(accentColor)
                .symbolRenderingMode(.hierarchical)
                .frame(width: 22, height: 22)
                .padding(6)
                .background(accentColor.opacity(0.12))
                .clipShape(RoundedRectangle(cornerRadius: 7, style: .continuous))

            VStack(alignment: .leading, spacing: 2) {
                Text(feature.label)
                    .font(.system(size: 12, weight: .semibold))
                Text(feature.detail)
                    .font(.system(size: 11))
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }

            Spacer(minLength: 0)
        }
        .padding(10)
        .background(.background.opacity(0.5))
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
    }
}

// MARK: - Preview Helpers

extension JumbotronView {
    static func captioningHero(onEnable: @escaping () -> Void) -> JumbotronView {
        JumbotronView(
            icon: "captions.bubble.fill",
            title: "Closed Captioning",
            subtitle: "Live Transcription",
            description: "Display real-time captions as a floating overlay anywhere on your screen — accessible, always-on, and fully synchronized with your voice.",
            features: [
                JumbotronFeature(icon: "text.bubble.fill", label: "Real-Time", detail: "Words appear as you speak"),
                JumbotronFeature(icon: "rectangle.bottomhalf.filled", label: "Floating Overlay", detail: "Stays above all windows"),
                JumbotronFeature(icon: "paintpalette.fill", label: "Classic CC Style", detail: "High-contrast, readable text"),
                JumbotronFeature(icon: "arrow.up.left.and.down.right.magnifyingglass", label: "Adjustable", detail: "Drag and resize freely")
            ],
            ctaLabel: "Enable Captions",
            ctaAction: onEnable,
            accentColor: .blue
        )
    }
}
