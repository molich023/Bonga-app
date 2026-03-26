// scripts/fund_link.js
const { ethers } = require("hardhat");
async function main() {
  const [deployer] = await ethers.getSigners();
  const linkToken = await ethers.getContractAt("IERC20", "0x326C977E6efc84E512bB9C30f76E30c160eD06FB"); // LINK on Mumbai
  const tx = await linkToken.transfer("0xYourGROAddress", ethers.utils.parseEther("0.1"));
  await tx.wait();
  console.log("Funded GRO with 0.1 LINK");
}
main();
