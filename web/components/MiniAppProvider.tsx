"use client";

import sdk, { type MiniAppContext } from "@farcaster/miniapp-sdk";
import {
  createContext,
  useContext,
  useEffect,
  useState,
  type ReactNode,
} from "react";

type MiniAppCtx = {
  isReady: boolean;
  context: MiniAppContext | null;
};

const Ctx = createContext<MiniAppCtx>({ isReady: false, context: null });

export function MiniAppProvider({ children }: { children: ReactNode }) {
  const [isReady, setIsReady] = useState(false);
  const [context, setContext] = useState<MiniAppContext | null>(null);

  useEffect(() => {
    sdk.context.then((ctx) => {
      setContext(ctx);
      sdk.actions.ready();
      setIsReady(true);
    });
  }, []);

  return <Ctx.Provider value={{ isReady, context }}>{children}</Ctx.Provider>;
}

export function useMiniApp() {
  return useContext(Ctx);
}
