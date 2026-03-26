// functions/update-kyc-status.js
const rateLimit = require('express-rate-limit');

const limiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 5, // Limit each IP to 5 requests per window
});
// functions/update-kyc-status.js
const { ethers } = require('ethers');
const { initializeApp } = require('firebase/app');
const { getFirestore, doc, updateDoc } = require('firebase/firestore');
const ipfilter = require('express-ipfilter').IpFilter;

// Blocked IPs (add known bad IPs or ranges)
const blockedIPs = [
  '192.168.1.1', // Example: Replace with actual bad IPs
  '10.0.0.0/8', // Private IP range
  '172.16.0.0/12', // Private IP range
  '192.168.0.0/16', // Private IP range
];

exports.handler = async (event) => {
  // Block IPs
  const clientIP = event.headers['client-ip'] || event.headers['x-forwarded-for'];
  if (blockedIPs.includes(clientIP)) {
    return {
      statusCode: 403,
      body: JSON.stringify({ error: 'IP blocked' }),
    };
  }

  // Rest of your function...
  const { submissionId, status, userAddress } = JSON.parse(event.body);
  // ...
};
exports.handler = limiter(async (event) => {
  // Your existing logic...
});
// functions/update-kyc-status.js
const { Resend } = require('@resend/resend-js');
const resend = new Resend('YOUR_RESEND_API_KEY');

exports.handler = async (event) => {
  const { submissionId, status, userAddress, phoneNumber } = JSON.parse(event.body);

  // Update Firestore and smart contract (as before)...

  // Send SMS
  const { data, error } = await resend.sms.send({
    from: 'GroPesa <noreply@gropesa.com>',
    to: phoneNumber, // e.g., '+254712345678'
    text: status === 'approved'
      ? 'Your GroPesa KYC is approved! You can now redeem GRO.'
      : 'Your GroPesa KYC was rejected. Please resubmit.',
  });

  if (error) {
    console.error('SMS Error:', error);
  }

  return { statusCode: 200, body: JSON.stringify({ success: true }) };
};
