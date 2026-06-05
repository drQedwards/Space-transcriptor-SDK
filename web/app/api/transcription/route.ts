import { NextRequest, NextResponse } from "next/server";

export const runtime = "edge";

export async function GET(req: NextRequest) {
  const spaceId = req.nextUrl.searchParams.get("spaceId");

  if (!spaceId) {
    return NextResponse.json({ error: "spaceId required" }, { status: 400 });
  }

  return NextResponse.json({
    spaceId,
    transcript: "",
    isLive: false,
    updatedAt: new Date().toISOString(),
  });
}
