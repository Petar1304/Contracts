
// Not needed anymore if metamask is not used
/**
 * @dev Changes metamasks network to Polygon
 */
async function changeNetworkToPolygon() {
    const polygon = {
        chainId: `0x${Number(137).toString(16)}`,
        chainName: "Polygon Mainnet",
        nativeCurrency: {
            name: "MATIC",
            symbol: "MATIC",
            decimals: 18
        },
        rpcUrls: ["https://polygon-rpc.com/"],
        blockExplorerUrls: ["https://polygonscan.com/"]
    };
    await window.ethereum.request({
        method: "wallet_addEthereumChain",
        params: [
            {
                ...polygon
            }
        ]
    });
}

/**
 * @dev Function to change metamasks network to Polygons Mumbai testnet
 */
async function changeNetworkToMumbai() {
    const mumbai = {
        chainId: `0x${Number(80001).toString(16)}`,
        chainName: "Mumbai Testnet",
        nativeCurrency: {
            name: "MATIC",
            symbol: "MATIC",
            decimals: 18
        },
        rpcUrls: ["https://rpc-mumbai.maticvigil.com/"],
        blockExplorerUrls: ["https://polygonscan.com/"]
    };
    await window.ethereum.request({
        method: "wallet_addEthereumChain",
        params: [
            {
                ...mumbai
            }
        ]
    });
}

/**
 * @dev Function that changes metamasks network to Polygon on Mumbai
 */
export async function changeNetwork() {
    if (NETWORK === 'matic') {
        if (window.etherum.networkVersion !== '137') {
            await changeNetworkToPolygon();
        }
    }
    else if (NETWORK === 'maticmum') {
        if (window.ethereum.networkVersion !== '80001') {
            await changeNetworkToMumbai();
        }
    }
}

/**
 * @dev Function that returns address of the currently selected account in Metamask
 * @returns string
 */
export async function connectMetamask(): Promise<string> {
    await changeNetwork();
    const provider = new ethers.providers.Web3Provider(window.ethereum);
    const address: string = (await provider.send("eth_requestAccounts", []))[0]
    return address;
}

/**
 * @dev Function that fetch list of addresses from metamask wallet
 * @returns addresses strings
 */
export async function getAddresses() : Promise<string[]> {
    const provider = new ethers.providers.Web3Provider(window.ethereum);
    const addresses = await provider.send("eth_requestAccounts", []);
    return addresses;
}
