# FilmmakerDAO Season 0 NFT Drop

* Smart contract for [FilmmakerDAO](http://filmmakerdao.com/) season 0 NFT drop.
* Based on the [Loot Project](https://www.lootproject.com/) and [DeveloperDAO](https://www.developerdao.com/).
* **YOU CAN USE AND ADAPT THIS SCRIPT BUT PLEASE ADD ATTRIBUTION TO [@bt3gl](https://twitter.com/bt3gl) AS THE AUTHOR**

---

## Setup

* Set an account and project on [Infura](https://infura.io/dashboard) or [Alchemy](https://dashboard.alchemyapi.io/).
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

Mint a NFT:

```
> const Film = await ethers.getContractFactory('FilmmakerDAO');
undefined
> const film = await Film.attach('<contract>')
undefined
> await film.claim(1)
```



You should be able to see the NFT on [OpenSea Testnet](https://testnets.opensea.io/account).


### Useful commands

```bash
npx hardhat clean
npx hardhat test
```

---

## Deploying on Mainnet

Same steps, simply set the default network to "mainnet" and make sure the private key in `.env` is from the desired account.


