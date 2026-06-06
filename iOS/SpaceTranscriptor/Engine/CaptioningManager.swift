import SwiftUI
import AVFoundation

@MainActor
final class CaptioningManager: ObservableObject {
    @Published var isEnabled   = false
    @Published var transcript  = ""
    @Published var isRecording = false

    private var overlayWindow: UIWindow?
    private var audioEngine: AVAudioEngine?

    // Overlay window is shown above all app content using a secondary UIWindowScene key window.
    // On iOS 26 this uses the new UIWindowScene.activationState API.
    func showOverlay() {
        guard overlayWindow == nil else { return }
        guard let scene = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first else { return }

        let win = UIWindow(windowScene: scene)
        win.windowLevel = .statusBar + 1
        win.backgroundColor = .clear
        win.isUserInteractionEnabled = false

        let host = UIHostingController(
            rootView: CaptioningOverlayView(transcript: $transcript)
        )
        host.view.backgroundColor = .clear
        win.rootViewController = host
        win.makeKeyAndVisible()
        overlayWindow = win
    }

    func hideOverlay() {
        overlayWindow?.isHidden = true
        overlayWindow = nil
    }

    func toggleOverlay() {
        if overlayWindow == nil { showOverlay() } else { hideOverlay() }
    }

    // Called by Whisper.cpp bridge when a new segment is ready
    func onSegment(_ text: String) {
        transcript = text
    }
}
