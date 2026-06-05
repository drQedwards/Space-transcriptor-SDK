"use client";

import { useEffect, useRef, useState } from "react";
import { useMiniApp } from "@/components/MiniAppProvider";
import { CaptionDisplay } from "@/components/CaptionDisplay";
import { SpaceHeader } from "@/components/SpaceHeader";
import { ConnectBar } from "@/components/ConnectBar";

export default function Home() {
  const { isReady, context } = useMiniApp();
  const [transcript, setTranscript] = useState("");
  const [isLive, setIsLive] = useState(false);

  useEffect(() => {
    if (!isReady) return;
    const interval = setInterval(() => {
      setIsLive((v) => !v);
    }, 2000);
    return () => clearInterval(interval);
  }, [isReady]);

  return (
    <main className="flex flex-col h-screen max-h-screen overflow-hidden">
      <SpaceHeader isLive={isLive} user={context?.user} />

      <div className="flex-1 overflow-hidden">
        <CaptionDisplay transcript={transcript} isLive={isLive} />
      </div>

      <ConnectBar onTranscriptChange={setTranscript} />
    </main>
  );
}
