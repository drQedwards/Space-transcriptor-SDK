import { readFileSync, writeFileSync, existsSync } from "fs";
import { resolve } from "path";

// State file tracks what we've already notified about so we don't double-send.
// In GitHub Actions, this file is committed back to the repo after each run.
const STATE_FILE = resolve(process.env.STATE_FILE ?? "bot/state.json");

export interface BotState {
  lastCheckedAt: string; // ISO timestamp
  notifiedProposals: string[]; // proposal IDs we've sent "new proposal" DCs for
  notifiedVotes: string[]; // vote tx hashes we've sent DCs for
  notifiedStatusChanges: Record<string, string>; // proposalId -> last known status
}

const DEFAULT_STATE: BotState = {
  lastCheckedAt: new Date(Date.now() - 2 * 60 * 60 * 1000).toISOString(), // 2h ago
  notifiedProposals: [],
  notifiedVotes: [],
  notifiedStatusChanges: {},
};

export function loadState(): BotState {
  if (!existsSync(STATE_FILE)) return { ...DEFAULT_STATE };
  try {
    return JSON.parse(readFileSync(STATE_FILE, "utf8")) as BotState;
  } catch {
    return { ...DEFAULT_STATE };
  }
}

export function saveState(state: BotState): void {
  writeFileSync(STATE_FILE, JSON.stringify(state, null, 2), "utf8");
}
