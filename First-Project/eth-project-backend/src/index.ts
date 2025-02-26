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
    console.log(logs);
}

pollBlock(21495003);