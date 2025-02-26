import { http, createConfig } from 'wagmi'
import { mainnet } from 'wagmi/chains'
import { injected } from "wagmi/connectors";

export const config = createConfig({
    chains: [mainnet],
	transports: {
	    [mainnet.id]: http("https://eth-mainnet.g.alchemy.com/v2/TgGXzYqTMmhDdpu_YhmX6wu_2Es4KLcx"),
    },
    connectors: [
        injected()
    ]
})