import SwiftUI

// Floating CC overlay — rendered in a UIWindow above .statusBar level.
// Positioned at the bottom of the screen with safe-area inset awareness.
struct CaptioningOverlayView: View {
    @Binding var transcript: String
    @AppStorage("ios.caption.fontSize") private var fontSize: Double = 18
    @AppStorage("ios.caption.opacity")  private var opacity: Double  = 0.9
    @State private var cursorVisible = true

    var body: some View {
        VStack {
            Spacer()
            if !transcript.isEmpty {
                overlayBubble
                    .padding(.horizontal, 16)
                    .padding(.bottom, 56) // above home indicator
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .animation(.spring(duration: 0.35), value: transcript)
        .onAppear {
            withAnimation(.easeInOut(duration: 0.55).repeatForever(autoreverses: true)) {
                cursorVisible = false
            }
        }
    }

    private var overlayBubble: some View {
        HStack(alignment: .center, spacing: 10) {
            Circle()
                .fill(Color("SpaceTeal"))
                .frame(width: 7, height: 7)

            Text(transcript)
                .font(.system(size: fontSize, design: .monospaced))
                .foregroundStyle(.white)
                .lineLimit(3)
                .frame(maxWidth: .infinity, alignment: .leading)

            Text("▌")
                .font(.system(size: fontSize, design: .monospaced))
                .foregroundStyle(.white.opacity(cursorVisible ? 1 : 0))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(.black.opacity(opacity * 0.88))
        )
    }
}
