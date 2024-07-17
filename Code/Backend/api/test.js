const express = require('express');
const db = require('../firebase.js').db;  // 确保正确导入db对象
const router = express.Router();

router.post('/test', async (req, res) => {
    const { name } = req.body;

    // 检查name是否存在且不为空
    if (!name) {
        return res.status(400).json({ message: 'Name parameter is required and cannot be empty.' });
    }

    try {
        // 创建新文档
        const docRef = db.collection('users').doc('username');
        await docRef.set({ username: name });

        // 因为刚刚已经设置了 username，无需再次获取
        res.status(201).json({ message: 'User created successfully', username: name });
    } catch (error) {
        console.log('Error creating document:', error);
        res.status(500).json({ message: 'Error creating user', error: error.message });
    }
});

module.exports = router;
