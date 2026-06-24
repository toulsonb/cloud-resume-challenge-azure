// 1. Keep your local URL for offline development troubleshooting
const localApiUrl = 'http://localhost:7071/api/GetResumeCounter';

// 2. Production API URL (Secured via Azure CORS, no key required)
const cloudApiUrl = 'https://func-cloudresumebt-prod.azurewebsites.net/api/GetResumeCounter';

const getVisitCount = async () => {
    try {
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