const admin = require('firebase-admin');
const serviceAccount = require('../secret/ai-fraud-detector-firebase-adminsdk-ytulo-74e13d8b34.json');  // 确保路径正确

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  storageBucket: 'ai-fraud-detector.appspot.com'
});

const bucket = admin.storage().bucket();

async function readFileFromStorage(filename) {
  const file = bucket.file(filename);

  try {
    const [contents] = await file.download();
    console.log('File contents:', contents.toString());
  } catch (error) {
    console.error('Error reading file from storage:', error);
  }
}

// 替換為實際的文件名
readFileFromStorage('WhisperTest.txt');