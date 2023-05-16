require('@nomicfoundation/hardhat-toolbox');
// require('@nomicfoundation/hardhat-verify');
require('dotenv').config();

const INFURA_API_KEY = process.env.INFURA_API_KEY;
const PRIVATE_KEY = process.env.PRIVATE_KEY;

module.exports = {
  networks: {
    hardhat: {},
    sepolia: {
      url: INFURA_API_KEY,
      accounts: [PRIVATE_KEY],
    },
  },
  solidity: '0.8.15',
  etherscan: {
    apiKey: process.env.ETHERSCAN_API_KEY,
  },
};
