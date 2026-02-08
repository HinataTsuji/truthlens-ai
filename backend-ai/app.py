import os
import json
from flask import Flask, request, jsonify
from flask_cors import CORS
import google.generativeai as genai
from dotenv import load_dotenv
from PIL import Image
import io

load_dotenv()
genai.configure(api_key=os.getenv("GEMINI_API_KEY"))

app = Flask(__name__)
CORS(app) # Allows frontend to talk to this server

# System Instruction - Complete Fact-Checking Agent Prompt
SYSTEM_PROMPT = """You are an expert fact-checking AI agent specialized in detecting misinformation and fake news.

Your role is to analyze claims, news articles, and images to determine their veracity using the following process:

1. **Extract Claims**: Identify all factual claims made in the provided text or image.
2. **Verify with Google Search**: Use the Google Search grounding tool to find authoritative sources that confirm or refute each claim.
3. **Assess Credibility**: Evaluate the reliability of sources, check for contradictions, and identify potential red flags.
4. **Provide Verdict**: Classify the overall content as TRUE, FALSE, MISLEADING, or UNVERIFIED.

You must respond ONLY with valid JSON in the following format (no markdown, no code blocks, just raw JSON):

{
  "Verdict": "TRUE|FALSE|MISLEADING|UNVERIFIED",
  "Confidence": "85%",
  "Explanation": "Detailed explanation of your analysis, citing specific sources and reasoning",
  "KeyFindings": [
    "First key finding about the claim",
    "Second key finding with evidence",
    "Third important observation"
  ],
  "Sources": [
    "https://example.com/source1",
    "https://example.com/source2"
  ],
  "RedFlags": [
    "Any warning signs or concerns found",
    "Additional red flags if applicable"
  ]
}

Guidelines:
- Be objective and evidence-based
- Always cite authoritative sources when available
- Provide confidence percentage (0-100%)
- Include specific quotes or data points when relevant
- Flag emotional language, sensationalism, or lack of sources as red flags
- For images, extract text using OCR and analyze any visual manipulations
- If insufficient information is available, use UNVERIFIED verdict
- Return ONLY valid JSON, no additional text or formatting"""

model = genai.GenerativeModel(
    model_name="gemini-1.5-pro",
    system_instruction=SYSTEM_PROMPT,
    tools=[{'google_search_retrieval': {}}] # Critical for live news
)

@app.route('/health', methods=['GET'])
def health():
    """Health check endpoint"""
    return jsonify({"status": "healthy", "service": "truthlens-backend"}), 200

@app.route('/analyze', methods=['POST'])
def analyze():
    try:
        text = request.form.get('text')
        file = request.files.get('image')
        
        # Validate input
        if not text and not file:
            return jsonify({
                "error": "No input provided. Please provide text or an image."
            }), 400
        
        prompt_content = []
        
        # Add text if provided
        if text and text.strip():
            prompt_content.append(f"Analyze the following claim or news article:\n\n{text}")
        
        # Add image if provided
        if file:
            try:
                # Process image with Pillow for validation
                image_bytes = file.read()
                image = Image.open(io.BytesIO(image_bytes))
                
                # Verify it's a valid image
                image.verify()
                
                # Reset file pointer and create image data
                file.seek(0)
                image_data = {
                    "mime_type": file.content_type or "image/jpeg",
                    "data": file.read()
                }
                
                if not text:
                    prompt_content.append("Extract and analyze any text from this image, then fact-check the claims found:")
                
                prompt_content.append(image_data)
            except Exception as img_error:
                return jsonify({
                    "error": f"Invalid image file: {str(img_error)}"
                }), 400
        
        # Generate content with Gemini
        try:
            response = model.generate_content(prompt_content)
            response_text = response.text
            
            # Parse JSON response
            try:
                # Clean response text (remove markdown code blocks if present)
                cleaned_text = response_text.strip()
                if cleaned_text.startswith("```"):
                    # Remove markdown code blocks
                    lines = cleaned_text.split("\n")
                    cleaned_text = "\n".join(lines[1:-1]) if len(lines) > 2 else cleaned_text
                    cleaned_text = cleaned_text.replace("```json", "").replace("```", "").strip()
                
                result = json.loads(cleaned_text)
                return jsonify(result), 200
            except json.JSONDecodeError as json_err:
                # If JSON parsing fails, return raw response
                return jsonify({
                    "Verdict": "ERROR",
                    "Confidence": "0%",
                    "Explanation": "Failed to parse AI response as JSON",
                    "raw_response": response_text,
                    "error": str(json_err)
                }), 500
                
        except Exception as gemini_error:
            return jsonify({
                "error": f"Gemini API error: {str(gemini_error)}"
            }), 500
            
    except Exception as e:
        return jsonify({
            "error": f"Server error: {str(e)}"
        }), 500

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5000, debug=False)
