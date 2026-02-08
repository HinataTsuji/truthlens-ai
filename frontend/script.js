async function analyzeNews() {
    const formData = new FormData();
    formData.append('text', document.getElementById('newsText').value);
    formData.append('image', document.getElementById('newsImage').files[0]);

    const response = await fetch('http://localhost:3000/api/verify', {
        method: 'POST',
        body: formData
    });

    const data = await response.json();
    const result = JSON.parse(data.raw_analysis); // Parse Gemini's JSON string
    
    // Update UI
    document.getElementById('verdictLabel').innerText = result.Verdict;
    document.getElementById('confidenceBar').style.width = result.Confidence;
    document.getElementById('reasoningText').innerText = result.Explanation;
}
