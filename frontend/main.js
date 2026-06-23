// 1. Keep your local URL for offline development troubleshooting
const localApiUrl = 'http://localhost:7071/api/GetResumeCounter';

// 2. PASTE your copied Azure URL here (make sure it's wrapped in single quotes!)
// const cloudApiUrl = 'https://REDACTED-DEV-HOST/api/GetResumeCounter'; // dev env
const cloudApiUrl = 'https://func-cloudresumebt-prod.azurewebsites.net/api/GetResumeCounter?code=REDACTED';

const getVisitCount = async () => {
    try {
        // 3. SWITCH this from localApiUrl to cloudApiUrl so it hits Azure!
        const response = await fetch(cloudApiUrl);
        
        const data = await response.json();
        document.getElementById("counter").innerText = data.count;
    } catch (error) {
        console.error("Error fetching visitor count:", error);
        document.getElementById("counter").innerText = "Unavailable";
    }
};

window.addEventListener('DOMContentLoaded', (event) => {
    getVisitCount();
});