require("@nomicfoundation/hardhat-toolbox");

module.exports = {
  solidity: "0.8.20",
  networks: {
    localhost: {
      url: "http://127.0.0.1:8545",  // local Hardhat node
    },
    sepolia: {
      url: "https://eth-sepolia.g.alchemy.com/v2/qv1oHmXQDMgUAXQ1llBuM", // replace with your HTTPS RPC URL
      accounts: ["0135f055c86dd3955e77e356ee26b6ec10fd6cba4b523157f18203a32d2f0a6e"] // replace with your MetaMask exported private key
    }
  }
};
