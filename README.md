## 🎭 smart contract for my "on-chain generative storytelling NFT collection"

<br>

### tl; dr

* the **storytelling card** is a generative ERC721 collection loosely based on the "[loot project](https://www.lootproject.com/)".
* NFT SVGs are generated randomly on chain with the metadata in the smart contract (you can check the collection on [opensea](https://opensea.io/collection/storyteller-card)).
* you might deploy this smart contract on ethereum or EVM compatible network.
* mint yours at [generativestory.com](https://www.generativestory.com/). [Here](https://github.com/go-outside-labs/dapp) is the open-source code for the dapp.
 
<br>

![](https://user-images.githubusercontent.com/1130416/208617568-8c0ece72-27ba-434e-bef6-8534c6e0ef81.png)



<br>


---

### setup

* set an account and project on [infura](https://infura.io/dashboard) or [alchemy](https://dashboard.alchemyapi.io/).
* set a test account in metamask and copy your private key. I used rinkeby for dev (you can get some funds in [this faucet](https://faucet.rinkeby.io/)).
* set up an account at [etherscan](https://etherscan.io/) and grab the API key.

```bash
cp env_example .env
vim .env
```

install dependencies:

```bash
npm install
```

<br>


---

### deploying on rinkeby

set the default network "rinkeby" at `hardhat.config.js`.

compile the contract:

```shell
npx hardhat compile
```

deploy the contract:

```
npx hardhat run scripts/deploy.js
```

you should be able to see it at [rinkeby etherscan](https://rinkeby.etherscan.io/).

<br>

#### Interacting with the contract

```bash
npx hardhat console --network rinkeby
```

ad-hoc minting:

```
> const Film = await ethers.getContractFactory('FilmmakerDAO');
> const film = await Film.attach('<contract>')
> await film.mint(<tokenID>)
```

you should be able to see the NFT on [opensea (testnet)](https://testnets.opensea.io/account).

<br>

#### verify your smart contract

install hardhat etherscan plugin (compatible with etherscan and polygonscan)

```
npm install --save-dev @nomiclabs/hardhat-etherscan
```

verify the smart contract with contract address

```
npx hardhat verify --network rinkeby YOUR_CONTRACT_ADDRESS
```

<br>


#### useful commands

test a smart contract:

```bash
npx hardhat test
```

clean artifacts:

```bash
npx hardhat clean
```
<br>


---

### deploying on mainnet

same steps, simply set the default network to "mainnet" and make sure the private key in `.env` is from the desired account.

