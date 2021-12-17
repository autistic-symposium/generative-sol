/**
 * @type import('hardhat/config').HardhatUserConfig
 */
 require("@nomiclabs/hardhat-waffle");
 require("@nomiclabs/hardhat-ethers");
 require("@nomiclabs/hardhat-truffle5");
 require("@nomiclabs/hardhat-etherscan");
 
 require("dotenv").config();
 
const privateKey = process.env.PRIVATE_KEY;
const apiEndpoint = process.env.API_ENDPOINT;
const apiEtherscan = process.env.API_ETHERSCAN;


task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();
  for (const account of accounts) {
    console.log(account.address);
  }
});

module.exports = {
  defaultNetwork: "mainnet",
  solidity: "0.8.4",
  networks: {
    hardhat: {},
    localhost: {
      url: "http://127.0.0.1:8545",
      accounts: [privateKey]
    },
    rinkeby: {
      url: "https://rinkeby.infura.io/v3/" + apiEndpoint,
      accounts: [privateKey]
    },
    mainnet: {
      url: "https://mainnet.infura.io/v3/" + apiEndpoint,
      accounts: [privateKey]
    },
    matic: {
      url: "https://polygon-mainnet.g.alchemy.com/v2/TlXf_qnaoJ2S3nR3JtAI3P0ponXcAS6T",
      accounts: [privateKey]
    }
  },
  etherscan: {
    apiKey: apiEtherscan
  },

};
