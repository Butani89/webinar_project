// List of mushroom facts
const mushroomFacts = [
    "Världens största organism är en svamp (Armillaria ostoyae) som täcker över 9 kvadratkilometer i Oregon, USA.",
    "Svampen är varken en växt eller ett djur – de har ett eget rike (Fungi).",
    "Många svampar lyser i mörkret (bioluminescens) för att locka insekter som sprider deras sporer.",
    "Tryfflar är en typ av svamp som växer under jord och är extremt värdefulla i matlagning.",
    "Penisillin, ett av världens viktigaste antibiotika, kommer från mögelsvampen Penicillium."
];

// Function to display a random fact
function displayRandomFact() {
    const randomIndex = Math.floor(Math.random() * mushroomFacts.length);
    document.getElementById('mushroomFact').textContent = mushroomFacts[randomIndex];
}

// --- NEW: COUNTDOWN TIMER FUNCTION ---
function updateCountdown() {
    const countdownElement = document.getElementById('countdown-text');
    
    // Måldatum: 24 December 2025 kl 10:00 (Julafton!)
    const eventDate = new Date("December 24, 2025 10:00:00").getTime();
    const now = new Date().getTime();
    const distance = eventDate - now;

    if (distance < 0) {
        countdownElement.textContent = "Webinariet har startat! God Jul och klicka på länkarna nedan.";
        countdownElement.style.color = "green";
    } else {
        const days = Math.floor(distance / (1000 * 60 * 60 * 24));
        const hours = Math.floor((distance % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
        const minutes = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60));
        
        countdownElement.textContent = `Du kan gå med i mötet om: ${days} dagar, ${hours} timmar och ${minutes} minuter`;
    }
}

// Function to handle webinar registration (Sends to Database)
function handleWebinarRegistration(event) {
    event.preventDefault(); 
    
    const formFeedback = document.getElementById('form-feedback');
    const submitBtn = document.querySelector('.submit-btn');
    
    // Hämtar data från formuläret
    const name = document.getElementById('name').value;
    const email = document.getElementById('email').value;
    const company = document.getElementById('company').value || "Privat";
    
    // Vi skickar nu erfarenhet och datum separat för bättre datastruktur
    const experience = document.getElementById('experience').value || "Intresserad";
    const date = document.getElementById('date').value;
    // jobtitle kan vara tomt eller användas för något annat i framtiden
    const jobtitle = ""; 

    submitBtn.textContent = "Skickar...";
    submitBtn.disabled = true;

    // Fetch-anrop till Python-backend
    fetch('/api/register', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ name, email, company, experience, date, jobtitle }),
    })
    .then(response => response.json().then(data => ({ status: response.status, body: data })))
    .then(({ status, body }) => {
        if (status === 201) { // Assuming 201 is success with image_url
            formFeedback.style.display = 'block';
            formFeedback.style.color = '#556B2F'; 
            formFeedback.innerHTML = `God Jul, ${name}! Din anmälan till ${date} är mottagen.`;
            
            // Add mushroom image
            if (body.image_url) {
                const img = document.createElement('img');
                img.src = body.image_url;
                img.alt = 'Your Mushroom';
                img.style.width = '64px';
                img.style.height = '64px';
                img.style.display = 'block';
                img.style.margin = '10px auto';
                formFeedback.appendChild(img);
            }

            document.getElementById('webinarForm').reset();
        } else {
            // Handle other successful but non-201 responses if necessary
            // For now, assume any non-201 with 'ok' status is a server error for simplification
            throw new Error(body.message || 'Server error');
        }
    })
    .catch(error => {
        console.error('Error:', error);
        formFeedback.style.display = 'block';
        formFeedback.style.color = '#8B4513';
        formFeedback.textContent = "Kunde inte nå servern. Försök igen senare.";
    })
    .finally(() => {
        submitBtn.textContent = "Anmäl mig!";
        submitBtn.disabled = false;
    });
}

// Attach event listeners when DOM is loaded
document.addEventListener('DOMContentLoaded', () => {
    // 1. Fact Button
    const factBtn = document.getElementById('factBtn');
    if (factBtn) factBtn.addEventListener('click', displayRandomFact);
    
    // 2. Form Submission
    const webinarForm = document.getElementById('webinarForm');
    if (webinarForm) webinarForm.addEventListener('submit', handleWebinarRegistration);

    // 3. Start Countdown (Updates every second)
    setInterval(updateCountdown, 1000);
    updateCountdown(); // Run immediately once
});
