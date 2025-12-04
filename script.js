// Lista med svampfakta
const svampFaktaLista = [
    "Världens största organism är en svamp (Armillaria ostoyae) som täcker över 9 kvadratkilometer i Oregon, USA.",
    "Svampen är varken en växt eller ett djur – de har ett eget rike (Fungi).",
    "Många svampar lyser i mörkret (bioluminescens) för att locka insekter som sprider deras sporer.",
    "Tryfflar är en typ av svamp som växer under jord och är extremt värdefulla i matlagning.",
    "Penisillin, ett av världens viktigaste antibiotika, kommer från mögelsvampen Penicillium."
];

// Funktion för att visa ett slumpmässigt fakta
function visaSlumpmassigtFakta() {
    const slumpIndex = Math.floor(Math.random() * svampFaktaLista.length);
    const faktaText = svampFaktaLista[slumpIndex];
    const faktaElement = document.getElementById('svampFakta');
    faktaElement.textContent = faktaText;
}

// Funktion för att hantera webinar-anmälan
function hanteraWebinarAnmalan(event) {
    event.preventDefault(); // Stoppa sidan från att ladda om
    
    const formFeedback = document.getElementById('form-feedback');
    const anmalanKnapp = document.querySelector('.anmalan-knapp');
    
    // Hämta värden från formuläret
    const name = document.getElementById('namn').value;
    const email = document.getElementById('email').value;
    
    // Om fälten är tomma sätter vi ett streck så databasen inte klagar
    const company = document.getElementById('company').value || "-";
    
    // Vi lägger ihop Jobbtitel + Datum så vi sparar datumet i databasen också!
    const jobtitleRaw = document.getElementById('jobtitle').value || "Entusiast";
    const datum = document.getElementById('datum').value;
    const jobtitle = `${jobtitleRaw} (Datum: ${datum})`;

    // Visa att vi jobbar
    anmalanKnapp.textContent = "Skickar...";
    anmalanKnapp.disabled = true;

    // SKICKA TILL AZURE-SERVERN
    fetch('/api/register', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify({ name, email, company, jobtitle }),
    })
    .then(response => {
        if (response.ok) {
            // Om allt gick bra (Grön text)
            formFeedback.style.display = 'block';
            formFeedback.style.color = '#556B2F'; 
            formFeedback.textContent = `Tack ${name}! Du är anmäld till ${datum}.`;
            document.getElementById('webinarForm').reset();
        } else {
            // Om servern sa nej
            throw new Error('Serverfel');
        }
    })
    .catch(error => {
        // Om vi inte fick kontakt med servern (Röd text)
        console.error('Error:', error);
        formFeedback.style.display = 'block';
        formFeedback.style.color = 'red';
        formFeedback.textContent = "Kunde inte nå servern. Försök igen senare.";
    })
    .finally(() => {
        // Återställ knappen
        anmalanKnapp.textContent = "Anmäl mig!";
        anmalanKnapp.disabled = false;
    });
}

// Kopplar funktionerna när sidan laddas
document.addEventListener('DOMContentLoaded', () => {
    const faktaKnapp = document.getElementById('visaFaktaKnapp');
    if (faktaKnapp) {
        faktaKnapp.addEventListener('click', visaSlumpmassigtFakta);
    }
    
    const webinarForm = document.getElementById('webinarForm');
    if (webinarForm) {
        webinarForm.addEventListener('submit', hanteraWebinarAnmalan);
    }
});
