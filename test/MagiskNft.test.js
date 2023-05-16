const { ethers } = require('hardhat');
const { expect, assert } = require('chai');

describe('Magisk Nft', function () {
  let deployer, user;
  let magiskNft;

  beforeEach(async () => {
    [deployer, user] = await ethers.getSigners();

    magiskNft = await ethers.getContractFactory('MagiskNft');
    magiskNft = await magiskNft.deploy();
    // await magiskNft.deployed();
  });

  describe('Deployment', function () {
    it(`should deploy magisk nft correctly`, async function () {
      expect(await magiskNft.address).to.not.be.null;
      assert.equal(await magiskNft.NAME(), 'Magisk Nft');
      assert.equal(await magiskNft.SYMBOL(), 'MAGISK');
      assert.equal(await magiskNft.SILVER_NFT_ID(), 0);
      assert.equal(await magiskNft.GOLD_NFT_ID(), 1);
      assert.equal(
        await magiskNft.SILVER_NFT_PRICE(),
        ethers.utils.parseEther('0.5').toString()
      );
      assert.equal(
        await magiskNft.GOLD_NFT_PRICE(),
        ethers.utils.parseEther('0.8').toString()
      );
      assert.equal(await magiskNft.SILVER_USE_LIMIT(), 5);
      assert.equal(await magiskNft.GOLD_USE_LIMIT(), 10);
    });
  });
  describe(`Buy Nfts`, function () {
    // it(`should revert if msg.value is incorrect`, async function () {
    //   await magiskNft.connect(user);
    //   await expect(
    //     magiskNft.buySilverNft({
    //       value: ethers.utils.parseEther('0.002'),
    //     })
    //   ).to.be.reverted;
    // });
    it(`should emit event & update user balance`, async function () {
      const amount = ethers.utils.parseEther('0.5');
      const silverNftId = await magiskNft.SILVER_NFT_ID();
      const silverNftLimit = await magiskNft.SILVER_USE_LIMIT();

      await expect(
        magiskNft.connect(user).mintNft(silverNftId, { value: amount })
      )
        .to.emit(magiskNft, 'NFTMinted')
        .withArgs(user.address, silverNftId, silverNftLimit);

      const balance = await magiskNft.balanceOf(user.address, silverNftId);
      assert.equal(balance, 1);

      const goldNftId = await magiskNft.GOLD_NFT_ID();
      const goldNftUseLimit = await magiskNft.GOLD_USE_LIMIT();

      await expect(
        magiskNft
          .connect(user)
          .mintNft(goldNftId, { value: ethers.utils.parseEther('0.8') })
      )
        .to.emit(magiskNft, 'NFTMinted')
        .withArgs(user.address, goldNftId, goldNftUseLimit);

      assert.equal(await magiskNft.hasGoldNft(user.address), true);
    });
    // it(`should revert if user tries to buy again`, async function () {
    //   const amount = ethers.utils.parseEther('0.003');
    //   const tokenId = await magiskNft.SILVER_NFT_ID();
    //   const silverNftLimit = await magiskNft.SILVER_USE_LIMIT();

    //   await expect(magiskNft.connect(user).buySilverNft({ value: amount }))
    //     .to.emit(magiskNft, 'NFTMinted')
    //     .withArgs(user.address, tokenId, silverNftLimit);

    //   await expect(magiskNft.connect(user).buySilverNft({ value: amount })).to
    //     .be.reverted;
    // });
  });
});
