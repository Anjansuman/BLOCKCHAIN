import { id, JsonRpcProvider } from "ethers";

const provider = new JsonRpcProvider('https://eth-mainnet.g.alchemy.com/v2/TgGXzYqTMmhDdpu_YhmX6wu_2Es4KLcx');

async function pollBlock(blockNumber: number) {
    const logs = await provider.getLogs({
        // this address value is to tell Eth to get the value of the block which have data related to this address
        address: "0xdac17f958d2ee523a2206206994597c13d831ec7",
        fromBlock: blockNumber,
        toBlock: blockNumber,
        // topics will get all the indexed with it's provided input
        topics: [id("Transfer(address,address,uint256)")]
    })

    // instead of consoling, put it to your data base
    console.log(logs);
}

pollBlock(21495003);

// we can do something like calling this function infinitely to store the data of every blocks in Eth in our DB and then access them faster but doing it from the 1st blockNumber is not feasible so do it from when your DApp is deployed