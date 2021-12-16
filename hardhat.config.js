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
  defaultNetwork: "rinkeby",
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
    }
  },
  etherscan: {
    apiKey: apiEtherscan
  }
};
