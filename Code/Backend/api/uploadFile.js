const express = require('express');
const multer = require('multer');
const upload = multer({ storage: multer.memoryStorage() });
const fetch = require('node-fetch');
const { bucket } = require('../firebase.js');
const db = require('../firebase.js').db;
const { v4: uuidv4 } = require('uuid');


const app = express();
const router = express.Router();

router.post('/upload', upload.single('file'), async (req, res) => {
    //req.file
        //fieldname: 'file',
        //originalname: 'test.wav',
        //encoding: '7bit',
        //mimetype: 'audio/wav',
    //req.body 
        // { phone_num: '123456789', record_time: '2021-10-10T10:10:10.000Z' }

    if (!req.file) {
        return res.status(400).send('No file uploaded.');
    }

    let audioPath;
    let textPath;
    const id = uuidv4();

    const blob = bucket.file(req.file.originalname);
    const blobStream = blob.createWriteStream({
        metadata: {
            contentType: req.file.mimetype
        }
    });

    blobStream.on('error', (error) => {
        console.error(error);
        res.status(500).send('Something went wrong!');
    });

    //處理轉文字
    blobStream.on('finish', async () => {
        audioPath = `https://storage.googleapis.com/${bucket.name}/id`;

        try {
            // 將音頻文件二進位數據發送到 Python API 進行轉錄
            const audioBuffer = req.file.buffer;
            const response = await fetch('http://127.0.0.1:8080/transcribe', {
                method: 'POST',
                headers: { 'Content-Type': 'application/octet-stream' },
                body: audioBuffer,
                model: 'whisper-1'
            });

            if (!response.ok) {
                throw new Error('Failed to transcribe audio');
            }

            const transcriptResult = await response.json();
            const recordText = transcriptResult.text || '';

            // 將轉錄結果保存為文字檔並上傳到 Cloud Storage
            const textFileName = req.file.originalname.replace(/\.[^/.]+$/, '') + '.txt';
            const textBlob = bucket.file(textFileName);
            const textBlobStream = textBlob.createWriteStream({
                metadata: {
                    contentType: 'text/plain'
                }
            });
            textBlobStream.end(recordText);
        } catch (error) {
            console.error('Error transcribing audio: ', error);
            res.status(500).send('Something went wrong while transcribing the audio!');
        }
    });

    blobStream.end(req.file.buffer);

    //將txt連結傳入NLP&AI的API
    //將回傳結果寫入資料庫
    //將結果回傳前端
});

module.exports = router;
