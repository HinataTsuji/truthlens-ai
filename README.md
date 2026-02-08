# TruthLens AI 🔍

TruthLens is a multimodal fake news detection system. It uses **Gemini 1.5 Pro** to perform OCR on images and cross-reference text claims with live Google Search data.

## 🚀 Features
- **OCR Analysis:** Extract text from news screenshots automatically.
- **Live Fact-Checking:** Grounded responses using Google Search.
- **Confidence Scoring:** Visual representation of the AI's certainty.

## 🛠️ Setup
1. **Backend-AI (Python):** - `cd backend-ai && pip install -r requirements.txt`
   - Add `GEMINI_API_KEY` to `.env`.
   - Run `python app.py`.
2. **Gateway (Node.js):** - `cd gateway-api && npm install`
   - Run `node server.js`.
3. **Frontend:** - Open `index.html` in your browser.
