// scripts/execute_upgrade.js
const { ethers } = require("hardhat");

async function main() {
  const timelock = await ethers.getContractAt("TimelockController", "0xTimelockAddress");
  const proxyAdmin = await upgrades.erc1967.getAdminAddress("0xGropesaProxyAddress");
  const upgradePayload = GropesaV2.interface.encodeFunctionData("upgradeTo", [
    "0xGropesaV2ImplementationAddress"
  ]);

  await timelock.executeTransaction(
    proxyAdmin,
    0,
    "upgradeTo(address)",
    upgradePayload,
    Math.floor(Date.now() / 1000) // Current timestamp
  );
  console.log("Upgrade executed!");
}

main();
