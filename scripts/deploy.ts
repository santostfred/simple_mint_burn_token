import { ethers } from 'hardhat';

async function main() {
  const smbt = await ethers.getContractFactory('SimpleMintBurnToken');
  const smbtDeployed = await smbt.deploy();

  await smbtDeployed.waitForDeployment();

  console.log('SimpleMintBurnToken Contract Deployed at ' + smbtDeployed.target);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});