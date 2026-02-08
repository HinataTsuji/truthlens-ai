const express = require('express');
const axios = require('axios');
const multer = require('multer');
const upload = multer();
const app = express();

app.post('/api/verify', upload.single('image'), async (req, res) => {
    try {
        // Forwarding to the Python Flask microservice
        const response = await axios.post('http://localhost:5000/analyze', req.body);
        res.json(response.data);
    } catch (error) {
        res.status(500).json({ error: "Verification failed" });
    }
});

app.listen(3000, () => console.log("Gateway running on port 3000"));
