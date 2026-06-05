import SwiftUI
import AppKit
import Combine

@MainActor
class ClosedCaptioningWindowManager: ObservableObject {
    @Published var isVisible = false

    private var panel: ClosedCaptioningPanel?
    private var hostingController: NSHostingController<AnyView>?
    private var engineObserver: AnyCancellable?
    private var autoDismissTask: Task<Void, Never>?

    init() {}

    func show(engine: VoiceInkEngine) {
        guard !isVisible else { return }
        buildPanel(engine: engine)
        observeEngine(engine)
        isVisible = true
        panel?.orderFrontRegardless()
    }

    func hide() {
        guard isVisible else { return }
        autoDismissTask?.cancel()
        engineObserver?.cancel()
        engineObserver = nil
        isVisible = false
        panel?.orderOut(nil)
        panel = nil
        hostingController = nil
    }

    func toggle(engine: VoiceInkEngine) {
        isVisible ? hide() : show(engine: engine)
    }

    private func observeEngine(_ engine: VoiceInkEngine) {
        engineObserver?.cancel()
        engineObserver = engine.$recordingState
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                guard let self, self.isVisible, state == .idle else { return }
                self.scheduleAutoDismissIfNeeded()
            }
    }

    private func scheduleAutoDismissIfNeeded() {
        autoDismissTask?.cancel()
    }

    private func buildPanel(engine: VoiceInkEngine) {
        let p = ClosedCaptioningPanel()
        let view = AnyView(ClosedCaptioningView(engine: engine, windowManager: self))
        let hc = NSHostingController(rootView: view)
        p.contentView = hc.view
        panel = p
        hostingController = hc
    }
}
