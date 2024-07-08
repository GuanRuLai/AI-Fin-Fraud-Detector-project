import express from 'express';
import uploadRoutes from '../api/uploadFile.js'

const app = express();
const port = 8000;

app.listen(port, () => {
    console.log(`Server is running on port ${port}`)
})