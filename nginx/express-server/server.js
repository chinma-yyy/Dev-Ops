const express = require('express');
const os = require('os');

const app = express();
const port = process.env.PORT || 3001;
;

app.get('/hostname', (req, res) => {
    const hostname = os.hostname();
    res.send(`Hostname: ${hostname}`);
});

app.listen(port, () => {
    console.log(`Server is running on http://localhost:${port}`);
});
