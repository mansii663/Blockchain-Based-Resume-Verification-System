const hre = require("hardhat");

async function main() {
  const ResumeVerifier = await hre.ethers.getContractFactory("ResumeVerifier");
  const resumeVerifier = await ResumeVerifier.deploy();

  await resumeVerifier.waitForDeployment();

  console.log(`✅ ResumeVerifier deployed to: ${await resumeVerifier.getAddress()}`);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
