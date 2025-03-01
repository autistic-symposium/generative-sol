## smart contract for the "on-chain generative storytelling NFT collection"

<br>

<p align="center">
<img width="300" src="https://github.com/go-outside-labs/generative-sol/assets/138340846/5d2276d0-5623-4ed8-9d83-6be7c840b43c">
<img width="300"  src="https://github.com/go-outside-labs/generative-sol/assets/138340846/92d91fb4-ba2e-448c-a1c8-3ddecbda1ccc">
</p>

<br>

* the **storytelling card** is a generative ERC721 collection loosely based on the **[loot project](https://www.lootproject.com/)**, celebrating the sunset of **[FilmmakerDAO](https://story.mirror.xyz/gbwXf_IOm4BkUNmWYWz5M-47Te8ELuQngClR8iHFxDU")**
* the cards are SVGs (pseudo-)randomly generated on the ethereum blockchain
* resources:
  * **[check out the contract](https://etherscan.io/address/0x9213256fe89fa0428e8546910a8d78180dbbdc38#code)**
  * **[dapp to mint a card](https://storyteller-mint-app-git-main-getstory.vercel.app/)**
  * **[check the source code for the minting dapp](https://github.com/autistic-symposium/eth-nft-dapp-js)**

 
<br>

---

### setting up

* set an account and project on **[infura](https://infura.io/dashboard)** or **[alchemy](https://dashboard.alchemyapi.io/)**
* set a test account in metamask and copy your private key (i used rinkeby for dev and you can get some funds in **[this faucet](https://faucet.rinkeby.io/))**
* set up an account at **[etherscan](https://etherscan.io/)** and grab the API key

```bash
cp env_example .env
vim .env
```

* install the dependencies:

```bash
npm install
```

<br>

---

### deploying on rinkeby

* set the default network "rinkeby" at `hardhat.config.js`
* compile the contract:

```shell
npx hardhat compile
```

* deploy the contract:

```
npx hardhat run scripts/deploy.js
```

* you should be able to see it at **[rinkeby etherscan](https://rinkeby.etherscan.io/)**

<br>

----

### interacting with the contract

```bash
npx hardhat console --network rinkeby
```

* ad-hoc minting:

```
> const Film = await ethers.getContractFactory('FilmmakerDAO');
> const film = await Film.attach('<contract>')
> await film.mint(<tokenID>)
```

* you should be able to see the NFT on the **[opensea (testnet)](https://testnets.opensea.io/account)**

<br>

----

### verifying the smart contract

* install hardhat etherscan plugin (compatible with etherscan and polygonscan)

```
npm install --save-dev @nomiclabs/hardhat-etherscan
```

* verify the smart contract with the contract address

```
npx hardhat verify --network rinkeby YOUR_CONTRACT_ADDRESS
```

<br>

----

### useful commands

* test a smart contract:

```bash
npx hardhat test
```

* clean artifacts:

```bash
npx hardhat clean
```
<br>

### deploying on mainnet

* same steps, simply set the default network to "mainnet" and make sure the private key in `.env` is from the desired account

