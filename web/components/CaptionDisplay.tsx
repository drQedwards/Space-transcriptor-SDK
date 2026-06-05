"use client";

import { useEffect, useRef } from "react";
import { cn } from "@/lib/cn";

type Props = {
  transcript: string;
  isLive: boolean;
};

export function CaptionDisplay({ transcript, isLive }: Props) {
  const bottomRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    bottomRef.current?.scrollIntoView({ behavior: "smooth" });
  }, [transcript]);

  const isEmpty = transcript.trim().length === 0;

  return (
    <div className="h-full flex flex-col justify-end p-4 overflow-hidden">
      {isEmpty ? (
        <EmptyState isLive={isLive} />
      ) : (
        <div className="overflow-y-auto max-h-full">
          <div
            className={cn(
              "rounded-xl p-5",
              "bg-black/70 backdrop-blur",
              "border border-white/10",
              isLive && "border-blue-500/30"
            )}
          >
            {isLive && (
              <div className="flex items-center gap-1.5 mb-3">
                <span className="w-2 h-2 rounded-full bg-red-500 animate-pulse" />
                <span className="text-[10px] font-bold tracking-widest text-red-400 uppercase">
                  Live
                </span>
              </div>
            )}

            <p className="font-mono text-base leading-relaxed text-white whitespace-pre-wrap">
              {transcript}
              {isLive && (
                <span className="inline-block w-2 h-4 bg-blue-400 ml-1 animate-blink align-middle" />
              )}
            </p>
          </div>
          <div ref={bottomRef} />
        </div>
      )}
    </div>
  );
}

function EmptyState({ isLive }: { isLive: boolean }) {
  return (
    <div className="flex flex-col items-center justify-center h-full gap-4 text-center px-8">
      <div className="relative">
        <div
          className={cn(
            "w-16 h-16 rounded-2xl flex items-center justify-center",
            "bg-blue-600/20 border border-blue-500/20"
          )}
        >
          <svg width="28" height="28" viewBox="0 0 28 28" fill="none">
            <rect x="2" y="8" width="24" height="14" rx="3" stroke="#60a5fa" strokeWidth="1.5" />
            <path d="M7 14h6M7 18h10" stroke="#60a5fa" strokeWidth="1.5" strokeLinecap="round" />
          </svg>
        </div>
        {isLive && (
          <span className="absolute -top-1 -right-1 w-4 h-4 bg-red-500 rounded-full flex items-center justify-center">
            <span className="text-[8px] font-black text-white">●</span>
          </span>
        )}
      </div>

      <div>
        <p className="font-semibold text-white">
          {isLive ? "Listening…" : "No transcript yet"}
        </p>
        <p className="text-sm text-slate-400 mt-1">
          {isLive
            ? "Words will appear here as the Space unfolds"
            : "Join a Farcaster Space to start live captioning"}
        </p>
      </div>
    </div>
  );
}
