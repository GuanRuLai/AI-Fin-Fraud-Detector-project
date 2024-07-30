const express = require('express');
const cors = require('./middleware/cors.js');
const testRouters = require('./api/test.js');
const uploadFileRouters = require('./api/uploadFile.js');
const deleteFileRouters = require('./api/deleteFile.js');
const getRecordRouters = require('./api/getRecord.js');
const app = express();
const port = 8000;

app.use(express.json());
app.use(cors);

app.use('/api', testRouters);
app.use('/api', uploadFileRouters);
app.use('/api', deleteFileRouters);
app.use('/api', getRecordRouters);

app.listen(port, () => {
    console.log(`Server is running on port ${port}`);
});
