// functions/validate-id.js
const { initializeApp } = require('firebase/app');
const { getFirestore, collection, addDoc } = require('firebase/firestore');

const app = initializeApp({ /* Firebase config */ });
const db = getFirestore(app);

function isValidKenyanID(idNumber) {
  // Basic regex check (8 digits)
  return /^\d{8}$/.test(idNumber);
}

function isDuplicateID(idNumber) {
  // Check Firestore for duplicates
  return getDocs(query(collection(db, 'kycSubmissions'), where('idNumber', '==', idNumber)))
    .then((snapshot) => !snapshot.empty);
}

exports.handler = async (event) => {
  const { idNumber } = JSON.parse(event.body);

  if (!isValidKenyanID(idNumber)) {
    return {
      statusCode: 400,
      body: JSON.stringify({ error: 'Invalid Kenyan ID format' }),
    };
  }

  if (await isDuplicateID(idNumber)) {
    return {
      statusCode: 400,
      body: JSON.stringify({ error: 'ID already registered' }),
    };
  }

  return {
    statusCode: 200,
    body: JSON.stringify({ valid: true }),
  };
};
