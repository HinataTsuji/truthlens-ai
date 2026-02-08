import os
from flask import Flask, request, jsonify
from flask_cors import CORS
import google.generativeai as genai
from dotenv import load_dotenv

load_dotenv()
genai.configure(api_key=os.getenv("GEMINI_API_KEY"))

app = Flask(__name__)
CORS(app) # Allows frontend to talk to this server

# System Instruction from previous step
SYSTEM_PROMPT = "You are an expert Fact-Checking Agent... (Insert long prompt here)"

model = genai.GenerativeModel(
    model_name="gemini-1.5-pro",
    system_instruction=SYSTEM_PROMPT,
    tools=[{'google_search_retrieval': {}}] # Critical for live news
)

@app.route('/analyze', methods=['POST'])
def analyze():
    text = request.form.get('text')
    file = request.files.get('image')
    
    prompt_content = [text] if text else []
    if file:
        image_data = {"mime_type": file.content_type, "data": file.read()}
        prompt_content.append(image_data)
        
    response = model.generate_content(prompt_content)
    return jsonify({"raw_analysis": response.text})

if __name__ == "__main__":
    app.run(port=5000)
