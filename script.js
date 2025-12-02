// Vi hämtar formuläret från HTML-koden
const form = document.getElementById('signupForm');
const message = document.getElementById('message');

// När någon klickar på "Skicka" (submit)
form.addEventListener('submit', function(event) {
    
    // 1. Stoppa formuläret från att ladda om sidan (standardbeteende)
    event.preventDefault();

    // 2. Hämta värdena som användaren skrivit in
    const name = document.getElementById('name').value;
    const email = document.getElementById('email').value;
    const company = document.getElementById('company').value;

    // 3. Enkel Validering (kontroll)
    // HTML 'required' sköter det mesta, men vi dubbelkollar här
    if(name.length < 2) {
        message.style.color = "red";
        message.textContent = "Ditt namn måste vara minst 2 bokstäver.";
        return; // Avbryt funktionen
    }

    if(!email.includes('@') || !email.includes('.')) {
        message.style.color = "red";
        message.textContent = "Ange en giltig e-postadress.";
        return;
    }

    // 4. Om allt är OK:
    message.style.color = "green";
    message.textContent = "Tack " + name + "! Du är nu anmäld till webinariet.";
    
    // (Här skulle man i verkligheten skicka datan till en databas)
    // Vi rensar formuläret
    form.reset();
});