async function fetchAttendees() {
    const tableBody = document.querySelector('#attendeeTable tbody');
    const loadingText = document.getElementById('loading');
    
    loadingText.style.display = 'block';
    tableBody.innerHTML = ''; // Clear table

    try {
        const response = await fetch('/api/attendees');
        if (!response.ok) {
            throw new Error('Network response was not ok');
        }
        const attendees = await response.json();

        loadingText.style.display = 'none';

        if (attendees.length === 0) {
            tableBody.innerHTML = '<tr><td colspan="6" style="text-align:center">Inga deltagare registrerade ännu.</td></tr>';
            return;
        }

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

    } catch (error) {
        console.error('Error fetching attendees:', error);
        loadingText.textContent = 'Kunde inte hämta deltagare. Försök igen.';
        loadingText.style.color = 'red';
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

// Load on start
document.addEventListener('DOMContentLoaded', fetchAttendees);
