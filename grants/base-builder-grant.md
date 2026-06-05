# Base Builder Grant Application — Space Transcriptor SDK

**Builder:** drqeth.eth  
**FID:** 2112173  
**Wallet (Base):** `0x09CbC0D92AABE6F53Ac7E84F0Ba0FbfD05eB80f2`  
**GitHub:** `drQedwards/Space-transcriptor-SDK`  
**Deployed:** space-transcriptor.vercel.app  
**Ask:** 5 ETH (retroactive)

---

## What I Built

Space Transcriptor is an open-source real-time closed captioning SDK for Farcaster Spaces. It ships as three coordinated components:

### 1. macOS Swift SDK
Live Whisper.cpp speech-to-text with a floating `NSPanel` overlay that sits above any running app — Farcaster clients, browsers, video calls — without stealing focus. Fully animated SwiftUI hero screen (Jumbotron), settings with `@AppStorage`-backed font/opacity controls, and `@MainActor` window manager with `AnyCancellable` recording state observation.

### 2. Android Kotlin SDK
`WindowManager` foreground service overlay (`SYSTEM_ALERT_WINDOW`) rendering a Compose UI over any app. Animated Jetpack Compose hero screen matching the macOS design. DataStore-backed user preferences. `FarcasterMiniAppActivity` WebView wrapper. Build verified locally: `gradle assembleDebug` + `gradle lintDebug` both green against SDK 35 / AGP 8.5.2.

### 3. Farcaster Miniapp on Base
Next.js 14 App Router miniapp using `@farcaster/miniapp-sdk`, wagmi v2 with `farcasterMiniApp()` connector on **Base + Base Sepolia**. Live caption display, Farcaster context-aware UI (user PFP, FID), edge runtime API routes for transcription events. Deployed on Vercel with full CI via `vercel.yml`.

### CI/CD Infrastructure
6 GitHub Actions workflows: macOS Swift build + test, Android lint + APK, Vercel preview + production deploy, CodeQL security scan, dependency review (blocks high/critical CVEs), PR checks. Total: 1,305 lines of production Kotlin + ~800 lines Swift + ~600 lines TypeScript, all committed and pushed.

---

## Why This Matters for Base

- The miniapp runs natively on Base with Base Sepolia testnet support for future wallet-gated features (tip the transcriptionist, pay-per-Space access).
- Every transcript can be anchored on Base as calldata — making Farcaster Spaces searchable, archivable, and composable with other Base protocols (Frames, NFTs, attestations).
- The Android SDK targets `minSdk = 26` (97% of Android devices), maximizing reach for Farcaster's mobile-first user base.
- All code is MIT licensed on GitHub — other Farcaster clients (Warpcast, Nook, etc.) can integrate the overlay SDK in their own apps.

---

## Traction / Proof of Work

- 2 PRs merged to main:
  - PR #1: macOS captioning overlay + Jumbotron UI
  - PR #2: Full CI/CD suite + Farcaster Miniapp
- Branch in review: `claude/android-kotlin-oQq7u` (complete Android port)
- All CI workflows designed and battle-tested — fixed 4 real CI failures (hardcoded Xcode path, YAML secret comparison bug, missing xcpretty, release tag pattern)

---

## Grant Ask — 5 ETH Retroactive

This grant recognizes work already shipped. No strings attached — the code is already public and MIT licensed.

If awarded, funds will be used for:

| Use | ETH |
|---|---|
| Whisper model optimization for Spaces audio | 1.5 |
| Farcaster Frames v2 transcript attachment | 1.5 |
| iOS Swift Package for third-party Farcaster clients | 1.0 |
| Infra: ENS + Vercel Pro + IPFS | 1.0 |
| **Total** | **5.0** |

---

## Receiving Address

`0x09CbC0D92AABE6F53Ac7E84F0Ba0FbfD05eB80f2` on Base

---

## Links

- GitHub: github.com/drQedwards/Space-transcriptor-SDK
- Miniapp: space-transcriptor.vercel.app
- Farcaster: @drqeth.eth
