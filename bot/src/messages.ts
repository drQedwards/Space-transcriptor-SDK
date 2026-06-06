import type { Proposal, Vote } from "./subgraph.js";

const PURPLE_DAO_URL =
  "https://nouns.build/dao/ethereum/0xa45662638e9f3bbb7a6fecb4b17853b7ba0f3a60";

const VOTE_LABEL = ["Against", "For", "Abstain"] as const;

export function newProposalMessage(proposal: Proposal): string {
  const url = `${PURPLE_DAO_URL}/vote/${proposal.proposalNumber}`;
  return [
    `🟣 New Purple DAO Proposal #${proposal.proposalNumber}`,
    ``,
    `"${proposal.title}"`,
    ``,
    `Proposer: ${truncate(proposal.proposer)}`,
    `Status: ${proposal.status}`,
    ``,
    `Vote starts: ${formatUnix(proposal.voteStart)}`,
    `Vote ends: ${formatUnix(proposal.voteEnd)}`,
    ``,
    url,
  ].join("\n");
}

export function newVoteMessage(vote: Vote): string {
  const label = VOTE_LABEL[vote.support] ?? "Unknown";
  const weight = Number(vote.weight).toLocaleString();
  const url = `${PURPLE_DAO_URL}/vote/${vote.proposal.proposalNumber}`;
  const reasonSnippet = vote.reason
    ? `\n\nReason: "${truncate(vote.reason, 120)}"`
    : "";
  return [
    `🗳️ New vote on Prop #${vote.proposal.proposalNumber}`,
    ``,
    `"${vote.proposal.title}"`,
    ``,
    `Voter: ${truncate(vote.voter)} voted ${label} (${weight} votes)${reasonSnippet}`,
    ``,
    url,
  ].join("\n");
}

export function proposalStatusChangeMessage(
  proposal: Proposal,
  oldStatus: string
): string {
  const url = `${PURPLE_DAO_URL}/vote/${proposal.proposalNumber}`;
  const statusEmoji: Record<string, string> = {
    SUCCEEDED: "✅",
    DEFEATED: "❌",
    EXECUTED: "🚀",
    QUEUED: "⏳",
    CANCELED: "🚫",
    VETOED: "🚫",
  };
  const emoji = statusEmoji[proposal.status] ?? "📋";
  return [
    `${emoji} Prop #${proposal.proposalNumber} status changed`,
    ``,
    `"${proposal.title}"`,
    ``,
    `${oldStatus} → ${proposal.status}`,
    ``,
    `For: ${proposal.forVotes} | Against: ${proposal.againstVotes} | Abstain: ${proposal.abstainVotes}`,
    ``,
    url,
  ].join("\n");
}

function truncate(str: string, max = 42): string {
  if (str.length <= max) return str;
  return str.slice(0, max - 3) + "...";
}

function formatUnix(unixSeconds: string): string {
  const ms = Number(unixSeconds) * 1000;
  if (!ms) return "TBD";
  return new Date(ms).toUTCString();
}
