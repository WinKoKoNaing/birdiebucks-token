const hre = require("hardhat");

async function main() {
  const [deployer] = await hre.ethers.getSigners();

  console.log("Deploying contracts with the account:", deployer.address);

  console.log("Account balance:", (await deployer.getBalance()).toString());

  const BirdieBucksToken = await hre.ethers.getContractFactory(
    "BirdieBucksToken"
  );

  const birdieBucksToken = await BirdieBucksToken.deploy(
    "0x96cC568a75f54BDBda396736788fbbaaB27BF224"
  );

  await birdieBucksToken.deployed();

  console.log("BirdieBucks Token deployed: ", birdieBucksToken.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
