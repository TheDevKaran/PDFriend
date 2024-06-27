const express = require('express');
const bodyParser = require('body-parser');
const db = require('./db');

const app = express();
const port = 3000;

app.use(bodyParser.json());


app.post('/send', async (req, res) => {
    const {  message } = req.body;
    const otp = Math.floor(1000 + Math.random() * 9000).toString();

    try {
        await db.saveMessage( message, otp);
        res.json({ otp });
    } catch (err) {
        console.error('Error sending message:', err);
        res.status(500).json({ error: 'Failed to send message' });
    }
});

app.post('/receive', async (req, res) => {
    const { otp } = req.body;

    try {
        const message = await db.getMessage(otp);
        if (!message) {
            return res.status(404).json({ error: 'Message not found' });
        }
        res.json({ message });
    } catch (err) {
        console.error('Error receiving message:', err);
        res.status(500).json({ error: 'Failed to receive message' });
    }
});

app.listen(port, () => {
    console.log(`App listening at http://localhost:${port}`);
});
