const WARPCAST_BASE_URL =
  process.env.WARPCAST_BASE_URL ?? "https://api.warpcast.com";

// Sends a Direct Cast to a specific FID via Warpcast API
// Requires WARPCAST_API_KEY (from developer.warpcast.com > API Keys > Direct Cast)
export async function sendDirectCast(
  recipientFid: number,
  message: string
): Promise<void> {
  const apiKey = process.env.WARPCAST_API_KEY;
  if (!apiKey) throw new Error("WARPCAST_API_KEY is not set");

  const res = await fetch(`${WARPCAST_BASE_URL}/v2/ext-send-direct-cast`, {
    method: "PUT",
    headers: {
      Authorization: `Bearer ${apiKey}`,
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      recipientFid,
      message,
      idempotencyKey: `${Date.now()}-${recipientFid}`,
    }),
  });

  if (!res.ok) {
    const text = await res.text();
    throw new Error(`Warpcast DC failed ${res.status}: ${text}`);
  }
}

// Post a public cast via Warpcast auth token
// Requires WARPCAST_AUTH_TOKEN
export async function postCast(
  text: string,
  channelKey?: string
): Promise<void> {
  const token = process.env.WARPCAST_AUTH_TOKEN;
  if (!token) throw new Error("WARPCAST_AUTH_TOKEN is not set");

  const body: Record<string, unknown> = { text };
  if (channelKey) body.channelKey = channelKey;

  const res = await fetch(`${WARPCAST_BASE_URL}/v2/casts`, {
    method: "POST",
    headers: {
      Authorization: `Bearer ${token}`,
      "Content-Type": "application/json",
    },
    body: JSON.stringify(body),
  });

  if (!res.ok) {
    const text = await res.text();
    throw new Error(`Warpcast cast failed ${res.status}: ${text}`);
  }
}
