import type { Metadata } from "next";
import "./globals.css";
import { Providers } from "./providers";

export const metadata: Metadata = {
  title: "Space Transcriptor",
  description: "Live closed captions for Farcaster Spaces",
  other: {
    "fc:miniapp": JSON.stringify({
      version: "1",
      name: "Space Transcriptor",
      iconUrl: "https://space-transcriptor.vercel.app/icon.png",
      homeUrl: "https://space-transcriptor.vercel.app",
      splashImageUrl: "https://space-transcriptor.vercel.app/splash.png",
      splashBackgroundColor: "#0f172a",
      webhookUrl: "https://space-transcriptor.vercel.app/api/webhook",
    }),
  },
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en">
      <body className="bg-slate-950 text-white antialiased">
        <Providers>{children}</Providers>
      </body>
    </html>
  );
}
