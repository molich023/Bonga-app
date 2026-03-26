// functions/approve-kyc.js
const { ethers } = require('ethers');
const { initializeApp } = require('firebase/app');
const { getFirestore, doc, updateDoc } = require('firebase/firestore');
const { Resend } = require('@resend/resend-js');

const resend = new Resend('YOUR_RESEND_API_KEY');
const app = initializeApp({ /* Firebase config */ });
const db = getFirestore(app);

exports.handler = async (event) => {
  const { submissionId, status, userAddress, phoneNumber } = JSON.parse(event.body);

  // Update Firestore
  await updateDoc(doc(db, 'kycSubmissions', submissionId), { status });

  // Update smart contract
  const provider = new ethers.providers.JsonRpcProvider('https://polygon-rpc.com');
  const wallet = new ethers.Wallet(process.env.PRIVATE_KEY, provider);
  const groPesa = new ethers.Contract(
    process.env.GRO_PESA_CONTRACT_ADDRESS,
    ['function setKYCStatus(address user, bool status) external'],
    wallet
  );
  await groPesa.setKYCStatus(userAddress, status === 'approved');

  // Send SMS
  await resend.sms.send({
    from: 'GroPesa <noreply@gropesa.com>',
    to: phoneNumber,
    text: status === 'approved'
      ? 'Your GroPesa KYC is approved! Redeem GRO now.'
      : 'Your GroPesa KYC was rejected. Please resubmit.',
  });

  return { statusCode: 200, body: JSON.stringify({ success: true }) };
};
