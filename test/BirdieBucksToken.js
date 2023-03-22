const { expect, assert } = require("chai");
const hre = require("hardhat");

describe("BirdieBucksToken contract", function () {
  // global vars
  let Token;
  let birdieBuckToken;
  let owner;
  let addr1;
  let addr2;
  let addr3;
  let addr4;
  let addr5;

  const transferAmount = 100;

  beforeEach(async function () {
    // Get the ContractFactory and Signers here.
    Token = await hre.ethers.getContractFactory("BirdieBucksToken");
    [owner, addr1, addr2, addr3, addr4, addr5] = await hre.ethers.getSigners();

    birdieBuckToken = await Token.deploy(addr3.address);
  });

  describe("Deployment", function () {
    it("Should set the right owner", async function () {
      expect(await birdieBuckToken.owner()).to.equal(owner.address);
    });

    it("Should assign the total supply of tokens to the owner", async function () {
      const ownerBalance = await birdieBuckToken.balanceOf(owner.address);
      expect(await birdieBuckToken.totalSupply()).to.equal(ownerBalance);
    });

    it("Should be the total amount of tax is 300", async function () {
      expect(await birdieBuckToken.taxPercentage()).to.equal(300);
    });

    it("Should update taxAccount", async function () {
      await birdieBuckToken.updateTaxAccount(addr3.address);
      expect(await birdieBuckToken.taxAccount()).to.equal(addr3.address);
    });
  });

  describe("Transactions", function () {
    it("Should transfer tokens from owner to addr1", async function () {
      const taxAmount =
        (transferAmount * (await birdieBuckToken.taxPercentage())) / 10000;

      // Transfer 50 tokens from owner to addr1
      await birdieBuckToken.transfer(addr1.address, transferAmount);

      expect(await birdieBuckToken.balanceOf(addr1.address)).to.equal(
        transferAmount - taxAmount
      );

      expect(
        await birdieBuckToken.balanceOf(birdieBuckToken.taxAccount())
      ).to.equal(taxAmount);

      // Transfer 50 tokens from addr1 to addr2
      // await hardhatToken.connect(addr1).transfer(addr2.address, 50);
      // expect(await hardhatToken.balanceOf(addr2.address)).to.equal(50);
    });
  });

  describe("Variables", function () {
    it("Should update the tax amount", async function () {
      await birdieBuckToken.updateTaxPercentage(400);
      expect(await birdieBuckToken.taxPercentage()).to.equal(400);
    });

    it("Should update the tax address", async function () {
      await birdieBuckToken.updateTaxAccount(addr3.address);
      expect(await birdieBuckToken.taxAccount()).to.equal(addr3.address);
    });
  });

  describe("White and black list", function () {
    it("Should add address to whitelist", async function () {
      await birdieBuckToken.addToWhiteList(addr4.address);
      assert.equal(await birdieBuckToken.whiteList(addr4.address), true);
    });

    it("Should add address to blacklist", async function () {
      await birdieBuckToken.addToBlackList(addr4.address);
      assert.equal(await birdieBuckToken.blackList(addr4.address), true);
    });

    it("Should remove address from whitelist", async function () {
      await birdieBuckToken.addToWhiteList(addr4.address);
      await birdieBuckToken.removeFromWhiteList(addr4.address);
      assert.equal(await birdieBuckToken.whiteList(addr4.address), false);
    });

    it("Should remove address from blacklist", async function () {
      await birdieBuckToken.addToBlackList(addr4.address);
      await birdieBuckToken.removeFromBlackList(addr4.address);
      assert.equal(await birdieBuckToken.blackList(addr4.address), false);
    });
  });
});
