import SwiftUI
import WebKit

// WKWebView wrapper for flamehub.app
// Fixes the iOS 26 frozen-UA bug by injecting the real device identity
// so the server sees the correct OS/model rather than "iPhone OS 18_7".
struct FlameHubView: View {
    @EnvironmentObject private var session: FlameHubSession
    @State private var isLoading = true
    @State private var title = "FlameHub"

    var body: some View {
        NavigationStack {
            ZStack {
                FlameHubWebView(
                    session: session,
                    isLoading: $isLoading,
                    pageTitle: $title
                )
                .ignoresSafeArea(edges: .bottom)

                if isLoading {
                    ZStack {
                        Color(hex: "0A0A0F").ignoresSafeArea()
                        ProgressView()
                            .tint(Color("SpacePurple"))
                            .scaleEffect(1.4)
                    }
                }
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
    }
}

// MARK: - WKWebView representable

struct FlameHubWebView: UIViewRepresentable {
    let session: FlameHubSession
    @Binding var isLoading: Bool
    @Binding var pageTitle: String

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        config.mediaTypesRequiringUserActionForPlayback = []

        // Message handler so the page can call
        // window.webkit.messageHandlers.spaceTranscriptor.postMessage({...})
        config.userContentController.add(
            context.coordinator,
            name: "spaceTranscriptor"
        )

        // Inject the real device identity + fix the POST ritual bug
        let script = WKUserScript(
            source: FlameHubWebView.injectedScript(session: session),
            injectionTime: .atDocumentStart,
            forMainFrameOnly: false
        )
        config.userContentController.addUserScript(script)

        let webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = context.coordinator
        webView.uiDelegate = context.coordinator
        webView.backgroundColor = UIColor(Color(hex: "0A0A0F"))
        webView.scrollView.backgroundColor = UIColor(Color(hex: "0A0A0F"))
        webView.isOpaque = false

        // Override UA to expose true iOS 26 / iPhone 18,3 identity
        // instead of the frozen "iPhone OS 18_7" compatibility string
        webView.customUserAgent = session.correctedUserAgent

        webView.load(URLRequest(url: URL(string: "https://flamehub.app")!))
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {}

    // JS injected before document loads:
    // 1. Patches fetch so POST calls from the ritual handler are never silently dropped
    // 2. Exposes native device identity to the page
    private static func injectedScript(session: FlameHubSession) -> String {
        """
        // ── Space Transcriptor iOS bridge ────────────────────────────────────
        window.__spaceTranscriptor = {
          platform:   'ios',
          osVersion:  '\(session.osVersion)',
          model:      '\(session.deviceModel)',
          nodeUID:    '\(session.nodeUID)',
          appVersion: '\(session.appVersion)'
        };

        // Patch fetch to surface silent failures from ritual POST
        const _originalFetch = window.fetch;
        window.fetch = async function(...args) {
          try {
            const response = await _originalFetch.apply(this, args);
            if (!response.ok) {
              const body = await response.clone().text().catch(() => '');
              window.webkit?.messageHandlers?.spaceTranscriptor?.postMessage({
                type: 'fetchError',
                status: response.status,
                url: typeof args[0] === 'string' ? args[0] : args[0]?.url,
                body
              });
            }
            return response;
          } catch (err) {
            window.webkit?.messageHandlers?.spaceTranscriptor?.postMessage({
              type: 'fetchException',
              message: err?.message ?? String(err),
              url: typeof args[0] === 'string' ? args[0] : args[0]?.url
            });
            throw err;
          }
        };
        // ─────────────────────────────────────────────────────────────────────
        """
    }

    // MARK: - Coordinator

    final class Coordinator: NSObject, WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler {
        let parent: FlameHubWebView

        init(parent: FlameHubWebView) {
            self.parent = parent
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            parent.isLoading = false
            parent.pageTitle = webView.title ?? "FlameHub"
        }

        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            parent.isLoading = true
        }

        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            parent.isLoading = false
        }

        // Receives fetch errors surfaced by the injected script
        func userContentController(
            _ controller: WKUserContentController,
            didReceive message: WKScriptMessage
        ) {
            guard let body = message.body as? [String: Any] else { return }
            let type   = body["type"]   as? String ?? ""
            let url    = body["url"]    as? String ?? ""
            let status = body["status"] as? Int    ?? 0
            let msg    = body["message"] as? String ?? ""
            print("[FlameHub bridge] \(type) — url:\(url) status:\(status) \(msg)")
            // TODO: surface toast in SwiftUI when type == "fetchError" && status >= 400
        }
    }
}
