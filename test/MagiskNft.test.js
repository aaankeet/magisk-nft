const { ethers } = require('hardhat');

describe('Magisk Nft', function () {
  beforeEach(async () => {
    const MagiskNft = await ethers.getContractFactory('MagiskNft');
    const magiskNft = await MagiskNft.deploy();
    await magiskNft.deployed();

    describe('Magisk Nft Deployment', function () {
      it(`should deploy magisk nft correctly`, async function () {
        const name = await magiskNft.NAME();
        assert.equal(name, 'Magisk Nft');
      });
    });
  });
});
