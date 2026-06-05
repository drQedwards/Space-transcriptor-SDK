# Farcaster Grant Campaign — Copy-Paste Casts

Post these in order as a thread on Warpcast. Tag @v, @dwr.eth, @jessepollak, and drop in /purple and /base channels.

---

## Cast 1 — Hook (post this as the root cast)

```
🎙️ I built open-source closed captioning for Farcaster Spaces.

Real-time Whisper.cpp transcription → floating overlay on macOS, Android, + a Farcaster Miniapp on Base.

Applying for ecosystem grants to keep building.

Full thread 🧵
```

---

## Cast 2 — What's Built

```
What shipped (all MIT licensed on GitHub):

macOS: floating NSPanel overlay that captions any app without stealing focus. SwiftUI Jumbotron UI, AppStorage font/opacity controls.

Android: WindowManager foreground service overlay — Compose UI floats over any app. Works on 97% of Android devices (minSdk 26).

Farcaster Miniapp: Next.js 14, @farcaster/miniapp-sdk, wagmi v2 on Base. Deployed on Vercel.

→ drQedwards/Space-transcriptor-SDK
```

---

## Cast 3 — Why It Matters for Farcaster

```
Farcaster Spaces has no transcription infrastructure today.

That means:
→ deaf/HoH community can't follow Spaces
→ non-native speakers miss context
→ no search/archive of Space content
→ no composability with Frames or Base protocols

Space Transcriptor closes all of that. The transcript can be cast, archived on Base, or attached as a Frame. It's accessibility + content infrastructure.
```

---

## Cast 4 — Grant Ask

```
Applying to:

🟣 Purple DAO — 4 ETH
For: Frames v2 transcript casting, Spaces audio model tuning, iOS SDK port

🔵 Base Builder Grants — 5 ETH retroactive
For: work already shipped (macOS + Android + Miniapp + 6 CI workflows)

If you're a Purple DAO or Base ecosystem grant reviewer, the full proposals are in the repo:
github.com/drQedwards/Space-transcriptor-SDK/tree/main/grants
```

---

## Cast 5 — Call to Action

```
If this is useful to you:

⭐ Star the repo
🔁 Recast this thread
💜 Signal in /purple
💙 Signal in /base

Tips welcome on Base:
0x09CbC0D92AABE6F53Ac7E84F0Ba0FbfD05eB80f2

cc @v @dwr.eth @jessepollak

Let's make every Farcaster Space accessible 🎙️
```

---

## Channel Posts

### Drop in /purple:
```
Hey /purple — I built open-source closed captioning infrastructure for Farcaster Spaces.

macOS overlay + Android SDK + Farcaster Miniapp on Base, all shipped and MIT licensed.

Proposal for 4 ETH is up: github.com/drQedwards/Space-transcriptor-SDK/blob/main/grants/purple-dao-proposal.md

This is accessibility infra for the Farcaster ecosystem. Would love Purple's support to take it to the next level (Frames v2 transcripts + iOS SDK).

drqeth.eth | FID 2112173
```

### Drop in /base:
```
Built a Farcaster Miniapp on Base for live closed captioning of Spaces — with a full Android SDK and macOS overlay tool.

Applying for Base Builder Grants (retroactive, 5 ETH).

Everything is MIT licensed, deployed on Vercel, and CI-tested:
github.com/drQedwards/Space-transcriptor-SDK

The next step is anchoring transcripts on Base as calldata + Frames v2 integration.

0x09CbC0D92AABE6F53Ac7E84F0Ba0FbfD05eB80f2
```

### Drop in /dev:
```
Shipped a complete Whisper.cpp transcription SDK with:

→ Swift macOS: NSPanel floating overlay, @StateObject lifecycle, AnyCancellable engine observation
→ Kotlin Android: WindowManager overlay service with ComposeLifecycleOwner shim (runs Compose inside a Service)
→ Next.js Farcaster Miniapp: @farcaster/miniapp-sdk + wagmi v2 on Base

6 GitHub Actions workflows: macOS build, Android lint + APK, Vercel deploy, CodeQL, dependency-review, PR checks.

All open source: github.com/drQedwards/Space-transcriptor-SDK
```
