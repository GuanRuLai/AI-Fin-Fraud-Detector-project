import express from 'express';
import multer from 'multer';
import fs from 'fs';

const router = express.Router();

const storage = multer.diskStorage({
    destination: (req, file, cb) => {
        cb(null, 'uploads/');
    },
    filename: (req, file, cb) => {
        cb(null, `${Date.now()}-${file.originalname}`);
    }
});

const upload = multer({ storage: storage });

router.post('/upload', upload.single('file'), (req, res) => {
    const tempPath = req.file.path;
    const targetPath = `uploads/${Date.now()}-${req.file.originalname}`;

});