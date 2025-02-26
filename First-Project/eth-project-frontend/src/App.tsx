import { useAccount, useConnect, useDisconnect, useReadContract, WagmiProvider } from "wagmi";
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import { config } from "./Config";
import { ABI } from "./ABI";


const client = new QueryClient();

function App() {

  return <WagmiProvider config={config} >
    <QueryClientProvider client={client} >
      <div className="h-screen bg-black flex flex-col justify-center items-center">
        <ConnectWallet />
        <TotalSupply />
      </div>
    </QueryClientProvider>
  </WagmiProvider>
}

function TotalSupply() {

  const { address } = useAccount();

  const { data, isLoading, error } = useReadContract({
    address: '0xdac17f958d2ee523a2206206994597c13d831ec7',
    abi: ABI,
    functionName: 'balanceOf',
    args: [address]
  })

  if(isLoading) {
    return <div className="text-white">
      Loading...
    </div>
  }

  return (
    <div className="text-white">
        Balance: {JSON.stringify(data?.toString())}
    </div>
  )
}

function ConnectWallet() {
  const { connect, connectors } = useConnect();
  const { address } = useAccount();
  const { disconnect } = useDisconnect();

  if(address) {
    return <div className="text-white">
      You are connected {address}
      <button onClick={() => {disconnect()}}
        className="bg-gray-500 text-green-300 ml-3 p-2 rounded-lg hover:bg-gray-600"  
      >Disconnect</button>
    </div>
  }


  return <div className="">
    {connectors.map((c: any) => <button className="bg-gray-500 text-green-300 p-2 rounded-lg m-3 hover:bg-gray-600"
      onClick={() => connect({ connector: c })}
    >
        Connect via {c.name}
    </button>)}
  </div>
}

export default App
