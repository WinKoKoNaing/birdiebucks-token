const { expect } = require("chai");
const hre = require("hardhat");

describe("BirdieBucksToken contract", function () {
  // global vars
  let Token;
  let birdieBuckToken;
  let owner;
  let addr1;
  let addr2;
  let addr3;

  const transferAmount = 100;

  beforeEach(async function () {
    // Get the ContractFactory and Signers here.
    Token = await hre.ethers.getContractFactory("BirdieBucksToken");
    [owner, addr1, addr2, addr3] = await hre.ethers.getSigners();

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

    it("Should be the total amount of tax is 300", async function () {
      expect(await birdieBuckToken.taxPercentage()).to.equal(300);
    });

    it("Should assign taxAccount", async function () {
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
});
