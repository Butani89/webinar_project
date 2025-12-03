const form = document.getElementById('signupForm');
const message = document.getElementById('message');

form.addEventListener('submit', function(event) {
    event.preventDefault();

    const name = document.getElementById('name').value;
    const email = document.getElementById('email').value;
    const company = document.getElementById('company').value;
    const jobtitle = document.getElementById('jobtitle').value;

    // Enkel validering
    if(name.length < 2) {
        message.style.color = "red";
        message.textContent = "Namnet är för kort.";
        return;
    }

    // SKICKA TILL SERVERN (Detta är nytt)
    fetch('/api/register', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
        },
        body: JSON.stringify({ name, email, company, jobtitle }),
    })
    .then(response => {
        if (response.ok) {
            message.style.color = "green";
            message.textContent = "Tack " + name + "! Din anmälan är sparad i databasen.";
            form.reset();
        } else {
            message.style.color = "red";
            message.textContent = "Något gick fel vid sparningen.";
        }
    })
    .catch(error => {
        console.error('Error:', error);
        message.style.color = "red";
        message.textContent = "Kunde inte nå servern.";
    });
});
