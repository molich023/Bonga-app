// functions/sync-gro.js
const { ethers } = require('ethers');

exports.handler = async (event) => {
  const { userAddress, pendingRewards } = JSON.parse(event.body);
  const provider = new ethers.providers.JsonRpcProvider('https://polygon-rpc.com/');
  const wallet = new ethers.Wallet(process.env.PRIVATE_KEY, provider);
  const groContract = new ethers.Contract(
    process.env.GRO_CONTRACT_ADDRESS,
    [
      'function addPendingRewards(address user, uint256 amount) external',
    ],
    wallet
  );
  const tx = await groContract.addPendingRewards(userAddress, pendingRewards);
  await tx.wait();
  return { statusCode: 200, body: JSON.stringify({ txHash: tx.hash }) };
};
