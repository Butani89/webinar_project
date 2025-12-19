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
        countdownElement.textContent = "Webinariet har startat! Klicka på länkarna nedan för att ansluta.";
        countdownElement.style.color = "var(--primary-color)";
    } else {
        const days = Math.floor(distance / (1000 * 60 * 60 * 24));
        const hours = Math.floor((distance % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
        const minutes = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60));
        
        countdownElement.textContent = `Sändningen startar om: ${days}d ${hours}t ${minutes}m`;
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
    const experience = document.getElementById('experience').value;
    const date = document.getElementById('date').value;
    const jobtitle = ""; 

    submitBtn.textContent = "Bearbetar anmälan...";
    submitBtn.disabled = true;

    // Fetch-anrop till Python-backend
    fetch('/api/register', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ name, email, company, experience, date, jobtitle }),
    })
    .then(response => response.json().then(data => ({ status: response.status, body: data })))
    .then(({ status, body }) => {
        if (status === 201) {
            formFeedback.style.display = 'block';
            formFeedback.style.color = 'var(--primary-color)'; 
            formFeedback.innerHTML = `Tack för din anmälan, ${name}! Din plats är nu reserverad. <br>Här är din unika bio-genererade svamp-avatar:`;
            
            // Add mushroom image
            if (body.image_url) {
                const img = document.createElement('img');
                img.src = body.image_url;
                img.alt = 'Your Mushroom Avatar';
                img.style.width = '120px';
                img.style.height = '120px';
                img.style.display = 'block';
                img.style.margin = '15px auto';
                img.style.borderRadius = '10px';
                img.style.boxShadow = 'var(--shadow)';
                formFeedback.appendChild(img);
            }

            document.getElementById('webinarForm').reset();
        } else {
            throw new Error(body.message || 'Serverfel vid registrering');
        }
    })
    .catch(error => {
        console.error('Error:', error);
        formFeedback.style.display = 'block';
        formFeedback.style.color = '#d9534f';
        formFeedback.textContent = error.message || "Ett fel uppstod. Kontrollera din anslutning.";
    })
    .finally(() => {
        submitBtn.textContent = "Anmäl mig till webinaret";
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
