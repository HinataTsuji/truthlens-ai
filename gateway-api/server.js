const express = require('express');
const axios = require('axios');
const multer = require('multer');
const FormData = require('form-data');
const cors = require('cors');

const upload = multer();
const app = express();

// Enable CORS for all routes
app.use(cors());

// Parse JSON bodies
app.use(express.json());

// Health check endpoint
app.get('/health', (req, res) => {
    res.json({ status: 'healthy', service: 'truthlens-gateway' });
});

app.post('/api/verify', upload.single('image'), async (req, res) => {
    try {
        const backendUrl = process.env.BACKEND_URL || 'http://localhost:5000';
        
        // Create FormData to properly forward multipart/form-data
        const formData = new FormData();
        
        // Add text field if present
        if (req.body.text) {
            formData.append('text', req.body.text);
        }
        
        // Add image file if present
        if (req.file) {
            formData.append('image', req.file.buffer, {
                filename: req.file.originalname,
                contentType: req.file.mimetype
            });
        }
        
        // Validate that at least one input is provided
        if (!req.body.text && !req.file) {
            return res.status(400).json({ 
                error: 'No input provided. Please provide text or an image.' 
            });
        }
        
        // Forward to the Python Flask microservice
        const response = await axios.post(`${backendUrl}/analyze`, formData, {
            headers: {
                ...formData.getHeaders()
            },
            maxContentLength: Infinity,
            maxBodyLength: Infinity
        });
        
        res.json(response.data);
    } catch (error) {
        console.error('Gateway error:', error.message);
        
        // Handle different error types
        if (error.response) {
            // Backend returned an error response
            res.status(error.response.status).json({
                error: error.response.data.error || 'Backend verification failed',
                details: error.response.data
            });
        } else if (error.request) {
            // No response received from backend
            res.status(503).json({ 
                error: 'Backend service unavailable',
                details: 'Could not reach the backend service'
            });
        } else {
            // Other errors
            res.status(500).json({ 
                error: 'Gateway processing error',
                details: error.message 
            });
        }
    }
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`Gateway running on port ${PORT}`));
