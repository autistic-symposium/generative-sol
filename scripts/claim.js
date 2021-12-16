const hh = require("hardhat");

const contract = '0x5e82c1458a1E006818dfAC22697a77f9fe6b8720'
const tokenId = 1

async function main() {
  const Film = await hh.ethers.getContractFactory("FilmmakerDAO");
  const film = await Film.attach(contract)
  await film.claim(tokenId)
}


main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
