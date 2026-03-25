// functions/redeem-gro.js
const { ethers } = require('ethers');
exports.handler = async (event) => {
  const { userAddress, amount, phoneNumber } = JSON.parse(event.body);
  // 1. Burn GRO
  const groContract = new ethers.Contract(...);
  await groContract.burn(userAddress, ethers.utils.parseEther(amount.toString()));
  // 2. Call Kopokopo API for airtime
  await fetch('https://api.kopokopo.com/v1/payouts', {
    method: 'POST',
    body: JSON.stringify({ phoneNumber, amount: amount * 0.5 }), // 100 GRO = 50 KES
  });
};
