# Homebrew formula — Space Transcriptor macOS desktop app
# Build from source: brew install --build-from-source space-transcriptor
# TODO: fill sha256 after first tagged release is published to GitHub

class SpaceTranscriptor < Formula
  desc     "Real-time Whisper closed-captioning overlay for Farcaster Spaces"
  homepage "https://github.com/drQedwards/Space-transcriptor-SDK"
  # url and sha256 populated on first release tag (v1.0.0)
  # url "https://github.com/drQedwards/Space-transcriptor-SDK/archive/refs/tags/v1.0.0.tar.gz"
  # sha256 "<fill after release>"
  license  "MIT"
  head     "https://github.com/drQedwards/Space-transcriptor-SDK.git", branch: "main"

  depends_on :xcode => ["16.0", :build]
  depends_on :macos => :sequoia   # macOS 15+
  depends_on "cmake" => :build    # for whisper.cpp XCFramework
  depends_on "git"  => :build

  def install
    # Build whisper.cpp XCFramework (cached by SHA in CI; built fresh here)
    system "git", "clone", "--depth=1",
           "https://github.com/ggerganov/whisper.cpp.git",
           "whisper.cpp"
    cd "whisper.cpp" do
      system "cmake", "-B", "build",
             "-DWHISPER_BUILD_EXAMPLES=OFF",
             "-DWHISPER_BUILD_TESTS=OFF"
      system "cmake", "--build", "build", "--config", "Release"
    end

    # Build the macOS app
    system "xcodebuild",
           "-scheme", "VoiceInk",
           "-configuration", "Release",
           "-derivedDataPath", "build",
           "CODE_SIGN_IDENTITY=-",
           "CODE_SIGNING_REQUIRED=NO",
           "CODE_SIGNING_ALLOWED=NO",
           "ONLY_ACTIVE_ARCH=YES",
           "build"

    app_path = Dir["build/**/VoiceInk.app"].first
    raise "VoiceInk.app not found after build" unless app_path

    prefix.install app_path => "SpaceTranscriptor.app"

    # CLI shim so `space-transcriptor` works from terminal
    (bin/"space-transcriptor").write <<~SH
      #!/bin/bash
      exec open "#{prefix}/SpaceTranscriptor.app" "$@"
    SH
  end

  def caveats
    <<~EOS
      Space Transcriptor has been installed to:
        #{prefix}/SpaceTranscriptor.app

      To launch from terminal:
        space-transcriptor

      First launch: grant Microphone permission in System Settings > Privacy.
    EOS
  end

  test do
    assert_predicate prefix/"SpaceTranscriptor.app", :exist?
  end
end
