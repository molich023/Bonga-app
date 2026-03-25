// netlify/functions/redeem_reward.js
const { ethers } = require('ethers');
const { Resend } = require('@resend/resend-js');
const resend = new Resend(process.env.RESEND_API_KEY);

exports.handler = async (event) => {
  if (event.httpMethod !== 'POST') {
    return { statusCode: 405, body: 'Method Not Allowed' };
  }

  try {
    const { userAddress, amount, phoneNumber, redemptionType } = JSON.parse(event.body);

    // 1. Validate input
    if (!userAddress || !amount || !phoneNumber) {
      return { statusCode: 400, body: JSON.stringify({ error: 'Missing parameters' }) };
    }

    // 2. Initialize Polygon provider
    const provider = new ethers.providers.JsonRpcProvider('https://polygon-rpc.com/');
    const wallet = new ethers.Wallet(process.env.PRIVATE_KEY, provider);

    // 3. Load GRO contract
    const groContract = new ethers.Contract(
      process.env.GRO_CONTRACT_ADDRESS,
      [
        'function transferFrom(address from, address to, uint256 amount) external returns (bool)',
        'function balanceOf(address account) external view returns (uint256)',
      ],
      wallet
    );

    // 4. Check user balance
    const userBalance = await groContract.balanceOf(userAddress);
    if (userBalance.lt(ethers.utils.parseEther(amount.toString()))) {
      return { statusCode: 400, body: JSON.stringify({ error: 'Insufficient GRO balance' }) };
    }

    // 5. Transfer GRO to redemption contract
    const tx = await groContract.transferFrom(
      userAddress,
      process.env.GRO_REDEMPTION_ADDRESS,
      ethers.utils.parseEther(amount.toString())
    );
    await tx.wait();

    // 6. Call PSP API (e.g., Kopokopo for airtime)
    let pspResponse;
    if (redemptionType === 'airtime') {
      pspResponse = await fetch('https://api.kopokopo.com/v1/payouts', {
        method: 'POST',
        headers: {
          'Authorization': `Bearer ${process.env.KOPOKOPO_API_KEY}`,
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          phoneNumber: phoneNumber.startsWith('+254') ? phoneNumber : `+254${phoneNumber.substring(1)}`,
          amount: amount * 0.5, // 100 GRO = 50 KES
          currency: 'KES',
          reference: `GRO_REDEMPTION_${Date.now()}`,
        }),
      });
    } else if (redemptionType === 'data') {
      // Similar API call for data bundles
      pspResponse = await fetch('https://api.kopokopo.com/v1/data-bundles', {
        method: 'POST',
        headers: {
          'Authorization': `Bearer ${process.env.KOPOKOPO_API_KEY}`,
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          phoneNumber: phoneNumber.startsWith('+254') ? phoneNumber : `+254${phoneNumber.substring(1)}`,
          bundleSize: '50MB', // 100 GRO = 50MB
        }),
      });
    }

    if (!pspResponse.ok) {
      throw new Error('PSP API failed');
    }

    // 7. Send SMS confirmation
    await resend.sms.send({
      from: 'GroPesa <noreply@gropesa.com>',
      to: phoneNumber.startsWith('+254') ? phoneNumber : `+254${phoneNumber.substring(1)}`,
      text: `You redeemed ${amount} GRO for ${redemptionType === 'airtime' ? 'KES' : '50MB data'}!`,
    });

    return {
      statusCode: 200,
      body: JSON.stringify({
        success: true,
        txHash: tx.hash,
        pspReference: (await pspResponse.json()).reference,
      }),
    };
  } catch (error) {
    console.error('Redemption error:', error);
    return {
      statusCode: 500,
      body: JSON.stringify({ error: error.message }),
    };
  }
};
