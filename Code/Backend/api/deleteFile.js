const express = require('express');
const { bucket } = require('../firebase.js');  // 確保已正確設定並引入
const db = require('../firebase.js').db;

const router = express.Router();

// 刪除特定的錄音文件和其元數據
router.delete('/delete/:id', async (req, res) => {
    const recordId = req.params.id;

    try {
        // 獲取文件信息
        const docRef = db.collection('record1').doc(recordId);
        const doc = await docRef.get();

        if (!doc.exists) {
            return res.status(404).send('Document not found.');
        }

        const { audio_url, text_url } = doc.data();

        // 從 URL 提取文件名
        const audioFileName = audio_url.split('/').pop();
        const textFileName = text_url.split('/').pop();

        // 刪除 Cloud Storage 中的音頻文件
        const audioFile = bucket.file(audioFileName);
        await audioFile.delete();

        // 刪除 Cloud Storage 中的文字文件
        const textFile = bucket.file(textFileName);
        await textFile.delete();

        // 刪除 Firestore 中的文檔
        await docRef.delete();

        res.send('Record and its metadata have been successfully deleted.');
    } catch (error) {
        console.error('Error deleting record:', error);
        res.status(500).send('Error deleting record.');
    }
});

module.exports = router;
