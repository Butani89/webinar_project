let adminPassword = null;

// Handle Login
function login() {
    const passwordInput = document.getElementById('passwordInput');
    const password = passwordInput.value;
    const errorMsg = document.getElementById('loginError');

    if (!password) return;

    // Temporarily store password and try to fetch
    adminPassword = password;
    fetchAttendees().then(success => {
        if (success) {
            // Switch views
            document.getElementById('login-section').style.display = 'none';
            document.getElementById('dashboard-section').style.display = 'block';
            errorMsg.style.display = 'none';
            passwordInput.value = ''; // Clear input
        } else {
            adminPassword = null;
            errorMsg.style.display = 'block';
        }
    });
}

// Handle Logout
function logout() {
    adminPassword = null;
    document.getElementById('dashboard-section').style.display = 'none';
    document.getElementById('login-section').style.display = 'block';
}

// Fetch Data
async function fetchAttendees() {
    const tableBody = document.querySelector('#attendeeTable tbody');
    const loadingText = document.getElementById('loading');
    
    // Only show loading if we are already in dashboard view (reloading)
    if (document.getElementById('dashboard-section').style.display === 'block') {
        loadingText.style.display = 'block';
        tableBody.innerHTML = ''; 
    }

    try {
        const response = await fetch('/api/attendees', {
            headers: {
                'X-Admin-Password': adminPassword
            }
        });

        if (response.status === 401) {
            return false; // Auth failed
        }

        if (!response.ok) {
            throw new Error('Network response was not ok');
        }

        const attendees = await response.json();

        loadingText.style.display = 'none';

        if (attendees.length === 0) {
            tableBody.innerHTML = '<tr><td colspan="6" style="text-align:center">Inga deltagare registrerade ännu.</td></tr>';
        } else {
            tableBody.innerHTML = ''; // Ensure clear
            attendees.forEach(attendee => {
                const row = document.createElement('tr');
                row.innerHTML = `
                    <td>${attendee.id}</td>
                    <td>${escapeHtml(attendee.name)}</td>
                    <td>${escapeHtml(attendee.email)}</td>
                    <td>${escapeHtml(attendee.company || '-')}</td>
                    <td>${escapeHtml(attendee.experience || '-')}</td>
                    <td>${escapeHtml(attendee.date)}</td>
                `;
                tableBody.appendChild(row);
            });
        }
        return true; // Auth success

    } catch (error) {
        console.error('Error fetching attendees:', error);
        loadingText.textContent = 'Kunde inte hämta deltagare. Försök igen.';
        loadingText.style.color = 'red';
        return false;
    }
}

// Basic XSS protection
function escapeHtml(text) {
    if (!text) return text;
    return text
        .replace(/&/g, "&amp;")
        .replace(/</g, "&lt;")
        .replace(/>/g, "&gt;")
        .replace(/"/g, "&quot;")
        .replace(/'/g, "&#039;");
}

// Allow Enter key in password field
document.getElementById('passwordInput').addEventListener('keypress', function (e) {
    if (e.key === 'Enter') {
        login();
    }
});

// Do not auto-load on start anymore, wait for login