const express = require('express');
const multer = require('multer');
const upload = multer({ storage: multer.memoryStorage() }); // 使用内存存储，适合小文件
const app = express();
const router = express.Router();
const { bucket } = require('../firebase.js');
const db = require('../firebase.js').db;

router.post('/upload', upload.single('file'), async (req, res) => {

    let publicUrl

    if (!req.file) {
        return res.status(400).send('No file uploaded.');
    }
    //bucket: cloud storage的容器，最頂層的資料夾
    //blob: 二進位檔，每個文件都是一個blob，在這邊指的是上傳的文件
    //blobStream: 二進位檔的串流，用來上傳文件
    const blob = bucket.file(req.file.originalname);
    const blobStream = blob.createWriteStream({
        metadata: {
            contentType: req.file.mimetype
        }
    });

    //callback函數，'error'、'finish'是事件名稱
    blobStream.on('error', (error) => {
        console.error(error);
        res.status(500).send('Something went wrong!');
    });

    blobStream.on('finish', () => {
        // 构建公开访问的URL
        publicUrl = `https://storage.googleapis.com/${bucket.name}/${blob.name}`;

        doc = {
            'url': publicUrl,
            'scam_prob': 0,
            'alert': false,
            'reason': '',
            'record_text': ''
        }
    
        doc_ref = db.collection('record1').doc('test_data');
        doc_ref.set(doc);

        res.status(200).send({url: publicUrl});
    });

    blobStream.end(req.file.buffer);

    
});

module.exports = router;
