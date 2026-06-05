"use client";

type Props = {
  isLive: boolean;
  user?: { displayName?: string; pfpUrl?: string; fid?: number } | null;
};

export function SpaceHeader({ isLive, user }: Props) {
  return (
    <header className="flex items-center justify-between px-4 py-3 border-b border-white/10 bg-slate-950/80 backdrop-blur shrink-0">
      <div className="flex items-center gap-2.5">
        <div className="relative">
          <div className="w-8 h-8 rounded-full bg-blue-600 flex items-center justify-center">
            <svg width="16" height="16" viewBox="0 0 16 16" fill="none">
              <path
                d="M8 1C4.134 1 1 4.134 1 8s3.134 7 7 7 7-3.134 7-7-3.134-7-7-7zm0 2a5 5 0 110 10A5 5 0 018 3z"
                fill="white"
                opacity="0.3"
              />
              <circle cx="8" cy="8" r="3" fill="white" />
            </svg>
          </div>
          {isLive && (
            <span className="absolute -top-0.5 -right-0.5 w-2.5 h-2.5 bg-red-500 rounded-full ring-2 ring-slate-950 animate-pulse" />
          )}
        </div>

        <div>
          <p className="text-sm font-semibold leading-none">Space Transcriptor</p>
          <p className="text-xs text-slate-400 mt-0.5">
            {isLive ? "Live · Farcaster Spaces" : "Waiting for Space…"}
          </p>
        </div>
      </div>

      {user && (
        <div className="flex items-center gap-1.5">
          {user.pfpUrl && (
            // eslint-disable-next-line @next/next/no-img-element
            <img
              src={user.pfpUrl}
              alt={user.displayName ?? ""}
              className="w-7 h-7 rounded-full object-cover ring-1 ring-white/10"
            />
          )}
          <span className="text-xs text-slate-400 hidden sm:block">
            {user.displayName ?? `FID ${user.fid}`}
          </span>
        </div>
      )}
    </header>
  );
}
