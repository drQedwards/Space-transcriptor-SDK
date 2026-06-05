"use client";

import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import { WagmiProvider, createConfig, http } from "wagmi";
import { base, baseSepolia } from "wagmi/chains";
import { farcasterMiniApp } from "@farcaster/miniapp-sdk/wagmi";
import { useState } from "react";

function makeWagmiConfig() {
  return createConfig({
    chains: [base, baseSepolia],
    transports: {
      [base.id]: http(),
      [baseSepolia.id]: http(),
    },
    connectors: [farcasterMiniApp()],
  });
}

export function Providers({ children }: { children: React.ReactNode }) {
  const [wagmiConfig] = useState(makeWagmiConfig);
  const [queryClient] = useState(() => new QueryClient());

  return (
    <WagmiProvider config={wagmiConfig}>
      <QueryClientProvider client={queryClient}>
        {children}
      </QueryClientProvider>
    </WagmiProvider>
  );
}
