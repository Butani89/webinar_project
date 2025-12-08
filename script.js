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
    
    // Vi bakar in datum och erfarenhet i "jobtitle"-fältet för databasen
    const experience = document.getElementById('experience').value || "Intresserad";
    const date = document.getElementById('date').value;
    const jobtitle = `${experience} (Datum: ${date})`;

    submitBtn.textContent = "Skickar...";
    submitBtn.disabled = true;

    // Fetch-anrop till Python-backend
    fetch('/api/register', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ name, email, company, jobtitle }),
    })
    .then(response => {
        if (response.ok) {
            formFeedback.style.display = 'block';
            formFeedback.style.color = '#556B2F'; 
            formFeedback.textContent = `God Jul, ${name}! Din anmälan till ${date} är mottagen.`;
            document.getElementById('webinarForm').reset();
        } else {
            throw new Error('Server error');
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
