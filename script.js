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
    const factText = mushroomFacts[randomIndex];
    
    const factElement = document.getElementById('mushroomFact');
    factElement.textContent = factText;
}

// Function to handle webinar registration (Sends to Database)
function handleWebinarRegistration(event) {
    event.preventDefault(); // Prevent page reload
    
    const formFeedback = document.getElementById('form-feedback');
    const submitBtn = document.querySelector('.submit-btn');
    
    // Get values from the form
    // We use id="name", "email" etc. as defined in HTML
    const name = document.getElementById('name').value;
    const email = document.getElementById('email').value;
    const company = document.getElementById('company').value || "Privat";
    
    // Combine Experience + Date to fit into the 'jobtitle' database column
    const experience = document.getElementById('experience').value || "Intresserad";
    const date = document.getElementById('date').value;
    const jobtitle = `${experience} (Datum: ${date})`;

    // Update UI to show loading
    submitBtn.textContent = "Skickar...";
    submitBtn.disabled = true;

    // Send data to the Azure Python Backend
    fetch('/api/register', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify({ name, email, company, jobtitle }),
    })
    .then(response => {
        if (response.ok) {
            // Success (Green text)
            formFeedback.style.display = 'block';
            formFeedback.style.color = '#556B2F'; 
            formFeedback.textContent = `Tack, ${name}! Din anmälan till ${date} är mottagen.`;
            document.getElementById('webinarForm').reset();
        } else {
            // Server error
            throw new Error('Server error');
        }
    })
    .catch(error => {
        // Network error (Red text)
        console.error('Error:', error);
        formFeedback.style.display = 'block';
        formFeedback.style.color = '#8B4513'; // Brown/Red for error
        formFeedback.textContent = "Kunde inte nå servern. Försök igen senare.";
    })
    .finally(() => {
        // Reset button
        submitBtn.textContent = "Anmäl mig!";
        submitBtn.disabled = false;
    });
}

// Attach event listeners when DOM is loaded
document.addEventListener('DOMContentLoaded', () => {
    // 1. Fact Button
    const factBtn = document.getElementById('factBtn');
    if (factBtn) {
        factBtn.addEventListener('click', displayRandomFact);
    }
    
    // 2. Form Submission
    const webinarForm = document.getElementById('webinarForm');
    if (webinarForm) {
        webinarForm.addEventListener('submit', handleWebinarRegistration);
    }
});
