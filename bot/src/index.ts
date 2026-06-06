/**
 * Space Transcriptor — Purple DAO Proposal Notification Bot
 *
 * Runs hourly via GitHub Actions CRON. Queries the Nouns Builder Goldsky
 * subgraph for Purple DAO activity (new proposals, votes, status changes)
 * and sends Warpcast Direct Casts to @drqeth.eth (FID 2112173).
 *
 * Set WATCH_PROPOSER to only notify about proposals from a specific address.
 */

import {
  PURPLE_DAO_ADDRESS,
  fetchProposals,
  fetchRecentVotes,
  fetchProposalsByProposer,
} from "./subgraph.js";
import { sendDirectCast } from "./warpcast.js";
import {
  loadState,
  saveState,
} from "./state.js";
import {
  newProposalMessage,
  newVoteMessage,
  proposalStatusChangeMessage,
} from "./messages.js";

// FID of @drqeth.eth — receives all DCs
const NOTIFY_FID = Number(process.env.NOTIFY_FID ?? "2112173");

// Optional: only watch proposals from this address (your wallet)
const WATCH_PROPOSER = process.env.WATCH_PROPOSER ?? "";

async function run(): Promise<void> {
  console.log("🤖 Space Transcriptor proposal bot starting...");

  const state = loadState();
  const now = new Date();
  const sinceUnix = String(Math.floor(new Date(state.lastCheckedAt).getTime() / 1000));

  console.log(`Checking for activity since ${state.lastCheckedAt}`);

  let notified = 0;

  // ── 1. New proposals ────────────────────────────────────────────────────────
  const allProposals = WATCH_PROPOSER
    ? await fetchProposalsByProposer(PURPLE_DAO_ADDRESS, WATCH_PROPOSER)
    : await fetchProposals(PURPLE_DAO_ADDRESS);

  for (const proposal of allProposals) {
    // New proposal alert (proposalId not yet notified)
    if (!state.notifiedProposals.includes(proposal.id)) {
      const createdAt = Number(proposal.timeCreated) * 1000;
      if (createdAt > new Date(state.lastCheckedAt).getTime()) {
        console.log(`📋 New proposal #${proposal.proposalNumber}: ${proposal.title}`);
        await sendDirectCast(NOTIFY_FID, newProposalMessage(proposal));
        state.notifiedProposals.push(proposal.id);
        notified++;
      } else {
        // Proposal existed before — still add to tracked set
        state.notifiedProposals.push(proposal.id);
      }
    }

    // Status change alert
    const prevStatus = state.notifiedStatusChanges[proposal.id];
    if (prevStatus && prevStatus !== proposal.status) {
      console.log(
        `📋 Prop #${proposal.proposalNumber} status: ${prevStatus} → ${proposal.status}`
      );
      await sendDirectCast(
        NOTIFY_FID,
        proposalStatusChangeMessage(proposal, prevStatus)
      );
      notified++;
    }
    state.notifiedStatusChanges[proposal.id] = proposal.status;
  }

  // ── 2. New votes ─────────────────────────────────────────────────────────────
  const votes = await fetchRecentVotes(PURPLE_DAO_ADDRESS, sinceUnix);

  // If WATCH_PROPOSER is set, only notify for votes on proposals by that proposer
  const watchedProposalIds = WATCH_PROPOSER
    ? allProposals.map((p) => p.id)
    : null;

  for (const vote of votes) {
    if (state.notifiedVotes.includes(vote.transactionHash)) continue;
    if (watchedProposalIds && !watchedProposalIds.includes(vote.proposal.id)) continue;

    console.log(
      `🗳️ Vote on Prop #${vote.proposal.proposalNumber} by ${vote.voter.slice(0, 10)}...`
    );
    await sendDirectCast(NOTIFY_FID, newVoteMessage(vote));
    state.notifiedVotes.push(vote.transactionHash);
    notified++;

    // Avoid rate-limiting — small delay between DCs
    await sleep(300);
  }

  // Trim state arrays so they don't grow unboundedly (keep last 500)
  state.notifiedVotes = state.notifiedVotes.slice(-500);
  state.notifiedProposals = state.notifiedProposals.slice(-200);

  state.lastCheckedAt = now.toISOString();
  saveState(state);

  console.log(`✅ Done. Sent ${notified} notification(s).`);
}

function sleep(ms: number): Promise<void> {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

run().catch((err) => {
  console.error("Bot error:", err);
  process.exit(1);
});
