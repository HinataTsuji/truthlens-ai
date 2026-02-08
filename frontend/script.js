// Image preview functionality
document.getElementById('newsImage').addEventListener('change', function(e) {
    const file = e.target.files[0];
    const preview = document.getElementById('imagePreview');
    
    if (file) {
        const reader = new FileReader();
        reader.onload = function(e) {
            preview.innerHTML = `<img src="${e.target.result}" alt="Preview">`;
        };
        reader.readAsDataURL(file);
    } else {
        preview.innerHTML = '';
    }
});

async function analyzeNews() {
    const textInput = document.getElementById('newsText').value.trim();
    const imageInput = document.getElementById('newsImage').files[0];
    
    // Validate input
    if (!textInput && !imageInput) {
        alert('Please provide text or upload an image to analyze.');
        return;
    }
    
    // Show loading, hide results
    document.getElementById('loadingIndicator').style.display = 'block';
    document.getElementById('resultsSection').style.display = 'none';
    document.getElementById('analyzeBtn').disabled = true;
    
    try {
        // Create FormData
        const formData = new FormData();
        if (textInput) {
            formData.append('text', textInput);
        }
        if (imageInput) {
            formData.append('image', imageInput);
        }
        
        // Send request to gateway API
        const apiUrl = 'http://localhost:3000/api/verify';
        const response = await fetch(apiUrl, {
            method: 'POST',
            body: formData
        });
        
        if (!response.ok) {
            const errorData = await response.json();
            throw new Error(errorData.error || 'Analysis failed');
        }
        
        const result = await response.json();
        
        // Display results
        displayResults(result);
        
    } catch (error) {
        console.error('Analysis error:', error);
        alert(`Error: ${error.message}\n\nPlease make sure the backend services are running.`);
    } finally {
        document.getElementById('loadingIndicator').style.display = 'none';
        document.getElementById('analyzeBtn').disabled = false;
    }
}

function displayResults(result) {
    // Show results section
    document.getElementById('resultsSection').style.display = 'block';
    
    // Scroll to results
    document.getElementById('resultsSection').scrollIntoView({ behavior: 'smooth' });
    
    // Update verdict
    const verdictBadge = document.getElementById('verdictBadge');
    const verdictLabel = document.getElementById('verdictLabel');
    verdictLabel.textContent = result.Verdict || 'UNKNOWN';
    
    // Apply verdict styling
    verdictBadge.className = 'verdict-badge';
    const verdictClass = (result.Verdict || 'UNVERIFIED').toLowerCase();
    verdictBadge.classList.add(verdictClass);
    
    // Update confidence
    const confidenceValue = result.Confidence || '0%';
    const confidenceNum = parseInt(confidenceValue);
    document.getElementById('confidenceBar').style.width = confidenceValue;
    document.getElementById('confidenceText').textContent = confidenceValue;
    
    // Update explanation
    document.getElementById('explanationText').textContent = result.Explanation || 'No explanation provided.';
    
    // Update key findings
    const keyFindingsSection = document.getElementById('keyFindingsSection');
    const keyFindingsList = document.getElementById('keyFindingsList');
    if (result.KeyFindings && result.KeyFindings.length > 0) {
        keyFindingsSection.style.display = 'block';
        keyFindingsList.innerHTML = result.KeyFindings
            .map(finding => `<li>${escapeHtml(finding)}</li>`)
            .join('');
    } else {
        keyFindingsSection.style.display = 'none';
    }
    
    // Update sources
    const sourcesSection = document.getElementById('sourcesSection');
    const sourcesList = document.getElementById('sourcesList');
    if (result.Sources && result.Sources.length > 0) {
        sourcesSection.style.display = 'block';
        sourcesList.innerHTML = result.Sources
            .map(source => `<li><a href="${escapeHtml(source)}" target="_blank" rel="noopener noreferrer">${escapeHtml(source)}</a></li>`)
            .join('');
    } else {
        sourcesSection.style.display = 'none';
    }
    
    // Update red flags
    const redFlagsSection = document.getElementById('redFlagsSection');
    const redFlagsList = document.getElementById('redFlagsList');
    if (result.RedFlags && result.RedFlags.length > 0) {
        redFlagsSection.style.display = 'block';
        redFlagsList.innerHTML = result.RedFlags
            .map(flag => `<li>${escapeHtml(flag)}</li>`)
            .join('');
    } else {
        redFlagsSection.style.display = 'none';
    }
}

// Helper function to escape HTML
function escapeHtml(text) {
    const div = document.createElement('div');
    div.textContent = text;
    return div.innerHTML;
}
