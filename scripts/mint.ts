// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
import { ethers } from "hardhat";

async function main() {
  // Hardhat always runs the compile task when running scripts with its command
  // line interface.
  //
  // If this script is run directly using `node` you may want to call compile
  // manually to make sure everything is compiled
  // await hre.run('compile');

//   if (network === 'rinkeby') {
//     proxyRegistryAddress = "0xf57b2c51ded3a29e6891aba85459d600256cf317";
//   } else {
//     proxyRegistryAddress = "0xa5409ec958c83c3f309868babaca7c86dcb077c1";
//   }

  // We get the contract to deploy
  const Exobot = await ethers.getContractFactory("Exobot");
  const exobot = await Exobot.attach("0x53B1147F3bf6B66D554Afe86Ab677cC396Ec6805");

  exobot.mintRobot(1, {value: ethers.utils.parseEther("0.05")});
//   console.log("Exobot deployed to:", exobot.address);
    console.log("minted")
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
