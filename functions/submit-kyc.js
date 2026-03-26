// functions/submit-kyc.js
const { initializeApp } = require('firebase/app');
const { getFirestore, collection, addDoc } = require('firebase/firestore');
const { getStorage, ref, uploadBytes } = require('firebase/storage');
const ipfilter = require('express-ipfilter').IpFilter;

const blockedIPs = ['192.168.1.1', '10.0.0.0/8'];
const app = initializeApp({ /* Firebase config */ });
const db = getFirestore(app);
const storage = getStorage(app);

exports.handler = async (event) => {
  // IP blocking
  const clientIP = event.headers['client-ip'] || event.headers['x-forwarded-for'];
  if (blockedIPs.includes(clientIP)) {
    return { statusCode: 403, body: JSON.stringify({ error: 'IP blocked' }) };
  }

  // Parse body
  const { idNumber, userAddress, phoneNumber } = JSON.parse(event.body);
  const idPhoto = event.body.idPhoto; // Base64 or file URL
  const selfie = event.body.selfie; // Base64 or file URL

  // Validate Kenyan ID
  if (!/^\d{8}$/.test(idNumber)) {
    return { statusCode: 400, body: JSON.stringify({ error: 'Invalid ID' }) };
  }

  // Check duplicates
  const duplicateCheck = await getDocs(
    query(collection(db, 'kycSubmissions'), where('idNumber', '==', idNumber))
  );
  if (!duplicateCheck.empty) {
    return { statusCode: 400, body: JSON.stringify({ error: 'Duplicate ID' }) };
  }

  // Upload files to Firebase Storage
  const idPhotoRef = ref(storage, `kyc/${idNumber}/idPhoto.jpg`);
  const selfieRef = ref(storage, `kyc/${idNumber}/selfie.jpg`);
  await uploadBytes(idPhotoRef, Buffer.from(idPhoto, 'base64'));
  await uploadBytes(selfieRef, Buffer.from(selfie, 'base64'));

  // Save to Firestore
  await addDoc(collection(db, 'kycSubmissions'), {
    idNumber,
    userAddress,
    phoneNumber,
    status: 'pending',
    timestamp: new Date(),
    idPhotoPath: `kyc/${idNumber}/idPhoto.jpg`,
    selfiePath: `kyc/${idNumber}/selfie.jpg`,
  });

  return { statusCode: 200, body: JSON.stringify({ success: true }) };
};
