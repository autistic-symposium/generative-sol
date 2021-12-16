# FilmmakerDAO Season 0 NFT Drop

FilmmakerDAO Season 0 NFT drop, named "Storytelling Card", is a [Loot Project](https://www.lootproject.com/) inspired NFT collection. The NFT SVGs are generated randomly on chain with the metadata in the smart contract. 

You may deploy this smart contract on Ethereum or EVM compatible network.


---

## Setup

* Set an account and project on [Infura](https://infura.io/dashboard) or [Alchemy])(https://dashboard.alchemyapi.io/)
* Set a test account in MetaMask and copy your private key. I use Rinkeby for dev (you can get some funds in [this faucet](https://faucet.rinkeby.io/)).

```bash
cp env_example .env
vim .env
```

Install dependencies:

```bash
npm install
```


---

## Deploying on Rinkeby

Set the default network "rinkeby" at `hardhat.config.js`.

Compile the contract:

```shell
npx hardhat compile
```

Deploy the contract:

```
npx hardhat run scripts/deploy.js
```

You should be able to see it at [Rinkeby Etherscan](https://rinkeby.etherscan.io/).

### Interacting with the contract

```bash
npx hardhat console --network rinkeby
```

Ad-hoc minting:

```
> const Film = await ethers.getContractFactory('FilmmakerDAO');
> const film = await Film.attach('<contract>')
> await film.claim(<tokenID>)
```

You should be able to see the NFT on [OpenSea Testnet](https://testnets.opensea.io/account).


### Verify Smart Contract

Install Hardhat Etherscan plugin (compatible with Etherscan and Polygonscan)

```
npm install --save-dev @nomiclabs/hardhat-etherscan
```

Verify the smart contract with contract address

```
npx hardhat verify --network rinkeby YOUR_CONTRACT_ADDRESS
```

### Useful commands

Test a smart contract:

```bash
npx hardhat test
```

Clean artifacts:

```bash
npx hardhat clean
```



---

## Deploying on Mainnet

Same steps, simply set the default network to "mainnet" and make sure the private key in `.env` is from the desired account.

