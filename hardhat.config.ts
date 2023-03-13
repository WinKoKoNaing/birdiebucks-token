import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import "solidity-coverage";
import "hardhat-gas-reporter";

const config: HardhatUserConfig = {
  solidity: "0.8.17",

  gasReporter: {
    enabled: true,
    currency: "USD",
    token: "BNB",
    gasPriceApi: "https://api.bscscan.com/api?module=proxy&action=eth_gasPrice",
    // noColors: true,
    coinmarketcap: "dc9f8269-87ea-435a-8ff1-405e4bb0370e",
  },
};

export default config;
