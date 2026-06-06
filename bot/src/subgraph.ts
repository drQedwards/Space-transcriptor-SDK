import { GraphQLClient, gql } from "graphql-request";

// Purple DAO contract on Ethereum mainnet
// https://nouns.build/dao/ethereum/0xa45662638e9f3bbb7a6fecb4b17853b7ba0f3a60
export const PURPLE_DAO_ADDRESS = "0xa45662638e9f3bbb7a6fecb4b17853b7ba0f3a60";

export const SUBGRAPH_URL =
  process.env.BUILDER_SUBGRAPH_ETHEREUM_URL ??
  "https://api.goldsky.com/api/public/project_clkk1ucdyf6ak38svcatie9tf/subgraphs/nouns-builder-ethereum-mainnet/stable/gn";

const client = new GraphQLClient(SUBGRAPH_URL);

export interface Proposal {
  id: string;
  proposalNumber: string;
  title: string;
  proposer: string;
  status: "PENDING" | "ACTIVE" | "CANCELED" | "DEFEATED" | "SUCCEEDED" | "QUEUED" | "EXECUTED" | "VETOED";
  forVotes: string;
  againstVotes: string;
  abstainVotes: string;
  voteStart: string;
  voteEnd: string;
  timeCreated: string;
  transactionHash: string;
}

export interface Vote {
  id: string;
  proposal: { id: string; proposalNumber: string; title: string };
  voter: string;
  support: number; // 0=against, 1=for, 2=abstain
  weight: string;
  reason: string;
  transactionHash: string;
}

const PROPOSALS_QUERY = gql`
  query Proposals($dao: String!) {
    proposals(
      where: { dao: $dao }
      orderBy: timeCreated
      orderDirection: desc
      first: 20
    ) {
      id
      proposalNumber
      title
      proposer
      status
      forVotes
      againstVotes
      abstainVotes
      voteStart
      voteEnd
      timeCreated
      transactionHash
    }
  }
`;

const RECENT_VOTES_QUERY = gql`
  query RecentVotes($dao: String!, $since: String!) {
    votes(
      where: { dao: $dao, blockTimestamp_gt: $since }
      orderBy: blockTimestamp
      orderDirection: desc
      first: 50
    ) {
      id
      proposal {
        id
        proposalNumber
        title
      }
      voter
      support
      weight
      reason
      transactionHash
    }
  }
`;

const PROPOSAL_BY_PROPOSER_QUERY = gql`
  query ProposalsByProposer($dao: String!, $proposer: String!) {
    proposals(
      where: { dao: $dao, proposer: $proposer }
      orderBy: timeCreated
      orderDirection: desc
      first: 10
    ) {
      id
      proposalNumber
      title
      proposer
      status
      forVotes
      againstVotes
      abstainVotes
      voteStart
      voteEnd
      timeCreated
      transactionHash
    }
  }
`;

export async function fetchProposals(daoAddress: string): Promise<Proposal[]> {
  const data = await client.request<{ proposals: Proposal[] }>(
    PROPOSALS_QUERY,
    { dao: daoAddress.toLowerCase() }
  );
  return data.proposals;
}

export async function fetchRecentVotes(
  daoAddress: string,
  since: string
): Promise<Vote[]> {
  const data = await client.request<{ votes: Vote[] }>(RECENT_VOTES_QUERY, {
    dao: daoAddress.toLowerCase(),
    since,
  });
  return data.votes;
}

export async function fetchProposalsByProposer(
  daoAddress: string,
  proposer: string
): Promise<Proposal[]> {
  const data = await client.request<{ proposals: Proposal[] }>(
    PROPOSAL_BY_PROPOSER_QUERY,
    {
      dao: daoAddress.toLowerCase(),
      proposer: proposer.toLowerCase(),
    }
  );
  return data.proposals;
}
