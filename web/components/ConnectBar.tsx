"use client";

import { useAccount, useConnect, useDisconnect } from "wagmi";
import { farcasterMiniApp } from "@farcaster/miniapp-sdk/wagmi";
import { cn } from "@/lib/cn";

type Props = {
  onTranscriptChange: (text: string) => void;
};

export function ConnectBar({ onTranscriptChange }: Props) {
  const { address, isConnected } = useAccount();
  const { connect, isPending } = useConnect();
  const { disconnect } = useDisconnect();

  const short = address
    ? `${address.slice(0, 6)}…${address.slice(-4)}`
    : null;

  return (
    <footer className="shrink-0 border-t border-white/10 px-4 py-3 bg-slate-950/80 backdrop-blur">
      <div className="flex items-center justify-between gap-3">
        <div className="flex items-center gap-2 min-w-0">
          <span
            className={cn(
              "w-2 h-2 rounded-full shrink-0",
              isConnected ? "bg-green-400" : "bg-slate-600"
            )}
          />
          <span className="text-xs text-slate-400 truncate">
            {isConnected ? short : "Not connected"}
          </span>
        </div>

        <div className="flex items-center gap-2">
          {isConnected ? (
            <>
              <button
                onClick={() =>
                  onTranscriptChange(
                    "Testing live captions from Farcaster Spaces — words appear in real time as the speaker talks, keeping everyone in the loop with zero friction."
                  )
                }
                className="text-xs px-3 py-1.5 rounded-lg bg-blue-600/20 text-blue-400 border border-blue-500/20 hover:bg-blue-600/30 transition-colors"
              >
                Demo
              </button>
              <button
                onClick={() => disconnect()}
                className="text-xs px-3 py-1.5 rounded-lg bg-white/5 text-slate-400 border border-white/10 hover:bg-white/10 transition-colors"
              >
                Disconnect
              </button>
            </>
          ) : (
            <button
              disabled={isPending}
              onClick={() => connect({ connector: farcasterMiniApp() })}
              className={cn(
                "text-xs px-4 py-1.5 rounded-lg font-semibold transition-colors",
                "bg-blue-600 text-white hover:bg-blue-500",
                isPending && "opacity-50 cursor-not-allowed"
              )}
            >
              {isPending ? "Connecting…" : "Connect Wallet"}
            </button>
          )}
        </div>
      </div>
    </footer>
  );
}
