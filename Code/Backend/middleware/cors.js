const cors = require('cors');

const corsOptions = {
    origin: 'http://localhost:3000',
    methods: 'GET,PUT,POST,DELETE'
};

module.exports = cors(corsOptions);
