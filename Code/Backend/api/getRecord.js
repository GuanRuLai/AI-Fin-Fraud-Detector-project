const express = require('express');
const { db } = require('../firebase.js');
const router = express.Router();

// API 以提取所有錄音記錄
router.get('/records', async (req, res) => {
    try {
        const recordsRef = db.collection('record1');
        const snapshot = await recordsRef.get();

        if (snapshot.empty) {
            return res.status(404).send({ message: 'No records found.' });
        }

        let records = [];
        snapshot.forEach(doc => {
            let record = doc.data();
            record.id = doc.id;  // 包含文件 ID
            // 檢查分析是否完成
            if (!record.scam_level) {
                record.status = 'Processing...';
            } else {
                record.status = 'Analysis complete';
            }
            records.push(record);
        });

        res.status(200).json(records);
    } catch (error) {
        console.error('Error retrieving records:', error);
        res.status(500).send({ message: 'Failed to fetch records' });
    }
});

router.get('/record/:id', async (req, res) => {
    const recordId = req.params.id;

    try {
        const recordRef = db.collection('record1').doc(recordId);
        const doc = await recordRef.get();

        if (!doc.exists) {
            return res.status(404).send({ message: 'Record not found.' });
        }

        let record = doc.data();
        record.id = doc.id;  // 包含文件 ID

        // 檢查並設置預設值
        record.scam_level = record.scam_level || 'Processing...';
        record.alert = record.alert !== undefined ? record.alert : 'Processing...';
        record.score = record.score !== undefined ? record.score : 'Processing...';

        res.status(200).json(record);
    } catch (error) {
        console.error('Error retrieving record:', error);
        res.status(500).send({ message: 'Failed to fetch record' });
    }
});

module.exports = router;


module.exports = router;
