import AppKit

class ClosedCaptioningPanel: NSPanel {
    override var canBecomeKey: Bool { false }
    override var canBecomeMain: Bool { false }

    init() {
        let metrics = ClosedCaptioningPanel.defaultFrame()
        super.init(
            contentRect: metrics,
            styleMask: [.nonactivatingPanel, .fullSizeContentView, .resizable],
            backing: .buffered,
            defer: false
        )
        configure()
    }

    private func configure() {
        isFloatingPanel = true
        level = .floating
        hidesOnDeactivate = false
        collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        isMovable = true
        isMovableByWindowBackground = true
        backgroundColor = .clear
        isOpaque = false
        hasShadow = false
        titlebarAppearsTransparent = true
        titleVisibility = .hidden
        standardWindowButton(.closeButton)?.isHidden = true
        standardWindowButton(.miniaturizeButton)?.isHidden = true
        standardWindowButton(.zoomButton)?.isHidden = true
    }

    static func defaultFrame() -> NSRect {
        guard let screen = NSScreen.main else {
            return NSRect(x: 0, y: 40, width: 700, height: 120)
        }
        let width: CGFloat = 700
        let height: CGFloat = 120
        let visibleFrame = screen.visibleFrame
        let x = visibleFrame.midX - width / 2
        let y = visibleFrame.minY + 48
        return NSRect(x: x, y: y, width: width, height: height)
    }
}
