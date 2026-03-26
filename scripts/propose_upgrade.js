// scripts/propose_upgrade.js
const { ethers, upgrades } = require("hardhat");

async function main() {
  const GropesaV2 = await ethers.getContractFactory("GropesaV2");
  const timelock = await ethers.getContractAt("TimelockController", "0xTimelockAddress");

  // Encode the upgrade call
  const proxyAdmin = await upgrades.erc1967.getAdminAddress("0xGropesaProxyAddress");
  const upgradePayload = GropesaV2.interface.encodeFunctionData("upgradeTo", [
    "0xGropesaV2ImplementationAddress"
  ]);

  // Queue the upgrade in the timelock
  await timelock.queueTransaction(
    proxyAdmin,
    0,
    "upgradeTo(address)",
    upgradePayload,
    Math.floor(Date.now() / 1000) + 86400 // 24 hours from now
  );
  console.log("Upgrade queued! Execute in 24 hours.");
}

main();
