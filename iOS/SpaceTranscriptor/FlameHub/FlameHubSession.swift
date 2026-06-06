import UIKit

// Holds the corrected device context for flamehub.app.
// iOS 26 Safari reports a frozen UA ("iPhone OS 18_7") for web-compat reasons.
// We override it with the real values so the server handles POST routing correctly.
@MainActor
final class FlameHubSession: ObservableObject {
    @Published var isConnected = false

    // Node identity (FlamePrint)
    let nodeUID    = "genesis_flame@FlameNet"
    let appVersion = "0.7.0-alpha"

    var osVersion: String {
        let v = ProcessInfo.processInfo.operatingSystemVersion
        return "\(v.majorVersion).\(v.minorVersion).\(v.patchVersion)"
    }

    var deviceModel: String {
        var info = utsname()
        uname(&info)
        return withUnsafeBytes(of: &info.machine) { raw in
            raw.bindMemory(to: CChar.self)
                .compactMap { $0 == 0 ? nil : String(UInt8(bitPattern: $0)) }
                .joined()
        }
    }

    // Corrected UA — replaces frozen "iPhone OS 18_7" with actual iOS 26.x
    var correctedUserAgent: String {
        let os = osVersion.replacingOccurrences(of: ".", with: "_")
        let model = deviceModel   // e.g. "iPhone18,3"
        return "Mozilla/5.0 (\(model); CPU iPhone OS \(os) like Mac OS X) " +
               "AppleWebKit/605.1.15 (KHTML, like Gecko) " +
               "Version/26.0 Mobile/15E148 Safari/604.1 SpaceTranscriptor/\(appVersion)"
    }

    func registerDeviceContext() {
        print("[FlameHubSession] device: \(deviceModel) ios: \(osVersion) ua: \(correctedUserAgent)")
        isConnected = true
    }
}
