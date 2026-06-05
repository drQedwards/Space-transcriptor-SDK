# Space Transcriptor SDK — Purple DAO Grant Proposal

**Proposer:** drqeth.eth  
**FID:** 2112173  
**Wallet:** `0x09CbC0D92AABE6F53Ac7E84F0Ba0FbfD05eB80f2`  
**Repository:** `drQedwards/Space-transcriptor-SDK`  
**Ask:** 4 ETH

---

## TLDR

Space Transcriptor is an open-source closed captioning SDK for Farcaster Spaces and beyond. It delivers real-time Whisper.cpp transcription as a floating overlay on macOS, Android, and as a Farcaster Miniapp on Base. This proposal requests 4 ETH to fund the next phase: Farcaster Frames v2 transcript sharing, iOS port, and Spaces-optimized model tuning.

---

## Overview

Farcaster Spaces is one of the most exciting social primitives in the ecosystem — but today there is zero live transcription infrastructure for it. Hosts broadcast to audiences who may be hard of hearing, non-native English speakers, or simply unable to have audio on. Space Transcriptor closes that gap.

**What was shipped (all open source, MIT licensed):**

### macOS (Swift / SwiftUI)
- **Closed Captioning Panel** — `NSPanel` floating overlay, `.nonactivatingPanel`, full-size content view, transparent background, `level = .floating`. Sits above any app without stealing focus.
- **Jumbotron Hero UI** — animated gradient hero with pulsing glow orbs, entrance animations, 2-column feature grid, and CTA. Built in SwiftUI with `@State`-driven `easeInOut` pulse loops.
- **ClosedCaptioningWindowManager** — `@MainActor` `ObservableObject` that manages overlay lifecycle. Observes `engine.$recordingState` via `AnyCancellable`.
- **Whisper.cpp XCFramework** — fetched from source, cached in CI by upstream HEAD SHA.
- **Full CI/CD**: 5 GitHub Actions workflows (`swift.yml`, `release.yml`, `codeql.yml`, `pr-checks.yml`, `dependency-review.yml`). Uses `maxim-lobanov/setup-xcode@v1`, cached SPM packages, xcpretty, artifact upload, and ad-hoc + notarized signing paths.

### Android (Kotlin / Jetpack Compose)
- **ClosedCaptioningOverlayService** — foreground `Service` with `WindowManager` floating overlay. Uses a `ComposeView` with a custom `ComposeLifecycleOwner` shim (implements `LifecycleOwner`, `ViewModelStoreOwner`, `SavedStateRegistryOwner`) so Compose works inside a Service context. Driven by `StateFlow<String>` for transcript updates.
- **JumbotronScreen** — Compose animated hero mirroring the Swift implementation: `rememberInfiniteTransition` glow orbs, `animateFloatAsState` entrance animations, Material3 dark theme (SpacePurple / SpaceBlue / SpaceTeal palette).
- **CaptioningScreen** — DataStore-backed font size (12–32sp) and opacity (40–100%) sliders with live preview and `SYSTEM_ALERT_WINDOW` permission guard.
- **FarcasterMiniAppActivity** — `WebView` wrapper for the Farcaster miniapp URL with JS/DOM storage, custom UA header (`FarcasterMiniApp/1.0`), loading spinner.
- **Android CI** — `android.yml` on ubuntu-latest, lint + debug APK + release APK gated to main/tags.

### Farcaster Miniapp (Next.js 14 / Base)
- `@farcaster/miniapp-sdk` integrated, `sdk.actions.ready()` called on context resolve.
- `fc:miniapp` metadata in Next.js App Router layout.
- wagmi v2 with `farcasterMiniApp()` connector on Base + Base Sepolia.
- Live caption display component with blinking cursor, LIVE indicator, scrolling transcript box.
- Edge runtime API routes for transcription webhooks and Farcaster miniapp events.
- Deployed to Vercel (`space-transcriptor.vercel.app`) via `vercel.yml` CI workflow.

---

## What This Grant Funds (4 ETH)

| Milestone | ETH | Deliverable |
|---|---|---|
| **Farcaster Frames v2 Transcript Sharing** | 1.25 ETH | Users can attach a live transcript as a Frame to any cast. Transcript goes on-chain (Base calldata or IPFS). Anyone who missed a Space can read it. |
| **Spaces Audio Model Tuning** | 1 ETH | Whisper.cpp performs poorly on compressed, noisy audio streams typical of Farcaster Spaces (Opus 48k, variable bitrate). Fine-tune a small (tiny/base) model on Spaces-typical audio to reduce WER by ≥40%. |
| **iOS Closed Captioning SDK** | 1 ETH | Port `ClosedCaptioningPanel` to iOS using `UIWindow` overlay (level `.alert`), expose a Swift package so any Farcaster iOS client can integrate live captions in 3 lines of code. |
| **ENS + Hosting + Infra** | 0.75 ETH | `spacetranscriptor.eth` ENS, 12 months Vercel Pro (needed for edge transcription latency), and IPFS pinning for transcript storage. |

All code will be merged to `drQedwards/Space-transcriptor-SDK` under MIT license and referenced in the final deliverable report.

---

## Why Purple DAO

Purple exists to proliferate Farcaster. Closed captioning is accessibility infrastructure — it makes Farcaster Spaces usable by the deaf and hard-of-hearing community, non-native English speakers, and anyone in a noise-sensitive environment. No other project in the Farcaster ecosystem is building this. The Frames v2 transcript integration specifically creates a new primitive: the castable Space transcript, which extends reach for every Space recorded.

This is not a speculative project. All core components are already built, tested, and deployed. This grant funds the next tier of polish and Farcaster-native integration.

---

## Budget

| Item | Amount |
|---|---|
| Frames v2 transcript casting | 1.25 ETH |
| Whisper Spaces model tuning | 1.00 ETH |
| iOS SDK port | 1.00 ETH |
| ENS + hosting + IPFS | 0.75 ETH |
| **Total** | **4.00 ETH** |

---

## Multisig / Receiving Address

`0x09CbC0D92AABE6F53Ac7E84F0Ba0FbfD05eB80f2`

drqeth.eth — Base + ETH mainnet

---

## Timeline

| Week | Deliverable |
|---|---|
| 1–3 | Frames v2 integration shipped + tested on Warpcast |
| 4–6 | Spaces audio dataset collected, model fine-tuned, WER benchmarks published |
| 7–10 | iOS Swift Package published to SPM, README with integration guide |
| 11–12 | ENS registered, Vercel Pro live, IPFS pinning configured, final report cast |

---

## Links

- **GitHub:** github.com/drQedwards/Space-transcriptor-SDK
- **Miniapp:** space-transcriptor.vercel.app
- **Farcaster:** @drqeth.eth (FID 2112173)
- **Wallet:** 0x09CbC0D92AABE6F53Ac7E84F0Ba0FbfD05eB80f2

---

*This proposal is submitted on behalf of drqeth.eth. All grant funds will be used exclusively for the deliverables described above. A public deliverable report will be cast on Farcaster upon completion of each milestone.*
