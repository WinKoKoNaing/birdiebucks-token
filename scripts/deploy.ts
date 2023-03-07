const hre = require("hardhat");

async function main() {
  const BirdieBucksToken = await hre.ethers.getContractFactory(
    "BirdieBucksToken"
  );

  const birdieBucksToken = await BirdieBucksToken.deploy(100000000, 50);

  await birdieBucksToken.deployed();

  console.log("BirdieBucks Token deployed: ", birdieBucksToken.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
