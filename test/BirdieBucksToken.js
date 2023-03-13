const { expect } = require("chai");
const hre = require("hardhat");

describe("BirdieBucksToken contract", function () {
  // global vars
  let Token;
  let birdieBuckToken;
  let owner;
  let addr1;
  let addr2;

  beforeEach(async function () {
    // Get the ContractFactory and Signers here.
    Token = await hre.ethers.getContractFactory("BirdieBucksToken");
    [owner, addr1, addr2] = await hre.ethers.getSigners();

    birdieBuckToken = await Token.deploy();
  });

  describe("Deployment", function () {
    it("Should set the right owner", async function () {
      expect(await birdieBuckToken.owner()).to.equal(owner.address);
    });

    it("Should assign the total supply of tokens to the owner", async function () {
      const ownerBalance = await birdieBuckToken.balanceOf(owner.address);
      expect(await birdieBuckToken.totalSupply()).to.equal(ownerBalance);
    });
  });
});
