require('dotenv').config()
import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";


const { WALLET_PRIVATE_KEY } = process.env;

const config: HardhatUserConfig = {
  solidity: "0.8.24",
  networks: {
    // for mainnet
    'base-mainnet': {
      url: 'https://mainnet.base.org',
      accounts: [`${WALLET_PRIVATE_KEY}`],
      gasPrice: 1000000000,
    },
    // for testnet
    'base-sepolia': {
      url: 'https://sepolia.base.org',
      accounts: [`${WALLET_PRIVATE_KEY}`],
      gasPrice: 1000000000,
    },
    // for local dev environment
    'base-local': {
      url: 'http://localhost:8545',
      accounts: [`${WALLET_PRIVATE_KEY}`],
      gasPrice: 1000000000,
    },
  },
  defaultNetwork: 'hardhat',
};

export default config;
