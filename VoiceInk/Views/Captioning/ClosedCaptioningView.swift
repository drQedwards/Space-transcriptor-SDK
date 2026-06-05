import SwiftUI

struct ClosedCaptioningView: View {
    @ObservedObject var engine: VoiceInkEngine
    @ObservedObject var windowManager: ClosedCaptioningWindowManager

    @AppStorage("closedCaptioningFontSize") private var fontSize: Double = 18
    @AppStorage("closedCaptioningOpacity") private var backgroundOpacity: Double = 0.82

    private var displayText: String {
        engine.partialTranscript.isEmpty ? " " : engine.partialTranscript
    }

    private var isActive: Bool {
        engine.recordingState == .recording || engine.recordingState == .transcribing
    }

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            Color.clear

            captionBox
                .padding(12)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
    }

    // MARK: - Caption Box

    private var captionBox: some View {
        VStack(alignment: .leading, spacing: 0) {
            labelBar
            textArea
        }
        .background(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(Color.black.opacity(backgroundOpacity))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .strokeBorder(captionBorderColor, lineWidth: 1.5)
        )
        .animation(.easeInOut(duration: 0.25), value: isActive)
    }

    private var captionBorderColor: Color {
        isActive ? Color.blue.opacity(0.5) : Color.white.opacity(0.08)
    }

    // MARK: - Label Bar

    private var labelBar: some View {
        HStack(spacing: 6) {
            if isActive {
                Circle()
                    .fill(Color.red)
                    .frame(width: 7, height: 7)
                    .transition(.scale.combined(with: .opacity))
            }

            Text(isActive ? "LIVE" : "CC")
                .font(.system(size: 9, weight: .heavy, design: .monospaced))
                .foregroundStyle(isActive ? .red : .white.opacity(0.4))
                .kerning(1.5)

            Spacer(minLength: 0)

            Button {
                windowManager.hide()
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 9, weight: .bold))
                    .foregroundStyle(.white.opacity(0.5))
                    .padding(4)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 10)
        .padding(.top, 7)
        .padding(.bottom, 4)
    }

    // MARK: - Text Area

    private var textArea: some View {
        ScrollViewReader { proxy in
            ScrollView(.vertical, showsIndicators: false) {
                Text(displayText)
                    .font(.system(size: fontSize, weight: .semibold, design: .monospaced))
                    .foregroundStyle(.white)
                    .lineSpacing(4)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 12)
                    .padding(.bottom, 10)
                    .id("bottom")
            }
            .onChange(of: engine.partialTranscript) {
                proxy.scrollTo("bottom", anchor: .bottom)
            }
        }
        .mask(
            LinearGradient(
                stops: [
                    .init(color: .clear, location: 0.0),
                    .init(color: .black, location: 0.12),
                    .init(color: .black, location: 1.0)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        )
        .transaction { $0.disablesAnimations = true }
    }
}

// MARK: - Settings Panel

struct ClosedCaptioningSettingsView: View {
    @AppStorage("closedCaptioningFontSize") private var fontSize: Double = 18
    @AppStorage("closedCaptioningOpacity") private var backgroundOpacity: Double = 0.82
    @AppStorage("closedCaptioningEnabled") private var isEnabled: Bool = false

    var body: some View {
        Form {
            Section {
                Toggle("Show Closed Captions", isOn: $isEnabled)
            } header: {
                Text("Closed Captioning")
            } footer: {
                Text("Displays live transcription as a floating caption overlay at the bottom of your screen.")
                    .font(.system(size: 11))
                    .foregroundStyle(.secondary)
            }

            Section("Appearance") {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text("Font Size")
                        Spacer()
                        Text("\(Int(fontSize)) pt")
                            .foregroundStyle(.secondary)
                            .font(.system(size: 12, design: .monospaced))
                    }
                    Slider(value: $fontSize, in: 12...32, step: 1)
                }

                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text("Background Opacity")
                        Spacer()
                        Text("\(Int(backgroundOpacity * 100))%")
                            .foregroundStyle(.secondary)
                            .font(.system(size: 12, design: .monospaced))
                    }
                    Slider(value: $backgroundOpacity, in: 0.4...1.0, step: 0.05)
                }
            }
        }
        .formStyle(.grouped)
    }
}
