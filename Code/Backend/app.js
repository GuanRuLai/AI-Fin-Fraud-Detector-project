const express = require('express');
const cors = require('./middleware/cors.js');
const testRouters = require('./api/test.js');
const uploadFileRouters = require('./api/uploadFile.js');
const app = express();
const port = 8000;

app.use(express.json());
app.use(cors);

app.use('/api', testRouters);
app.use('/api', uploadFileRouters);

app.listen(port, () => {
    console.log(`Server is running on port ${port}`);
});
