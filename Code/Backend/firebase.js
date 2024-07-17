const admin = require('firebase-admin');
const serviceAccount = require('./secret/ai-fraud-detector-firebase-adminsdk-ytulo-74e13d8b34.json');  // 确保路径正确

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  storageBucket: "ai-fraud-detector.appspot.com"
});

const db = admin.firestore();
const auth = admin.auth();
const storage = admin.storage();
const bucket = storage.bucket();

module.exports = { admin, db, auth, storage, bucket };
