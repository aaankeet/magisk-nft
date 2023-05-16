const { ethers } = require('hardhat');

async function main() {
  const MAGISK = await ethers.getContractFactory('MagiskNft');
  const magisk = await MAGISK.deploy();
  await magisk.deployed();

  console.log(
    `Contract Deployed at: https://sepolia.etherscan.io/address/${magisk.address}`
  );
}

main().catch((error) => {
  console.error('An error occurred:', error);
  process.exit(1);
});
