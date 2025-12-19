# Changes: Modernization and Fixes
**Date:** 2025-12-19 23:15
**Author:** Fredrick Amnehagen <fredrick@loopaware.com>

## Backend Fixes
- **Database Connection**: Added `ADMIN_PASSWORD` to the systemd service in `scripts/backend_setup.sh`.
- **Infrastructure**: Updated `infra/main.bicep` to include `adminPassword` and `duckDnsDomain` as parameters, passing them to the respective VMs.
- **Improved Error Handling**: Updated `app/main.py` with better logging and robust registration logic that handles database and art generation failures independently.

## Frontend Modernization
- **CSS Overhaul**: Completely rewrote `app/static/css/main.css` to use modern design principles (Glassmorphism, Flexbox/Grid, animations, and nature-inspired color palette).
- **Content Update**: Updated `app/static/index.html` to reflect a more professional and educational "World of Mushrooms" theme, removing festive Christmas references while maintaining the event date.
- **UX Improvements**: Updated `app/static/js/app.js` with improved messaging, modern countdown formatting, and better visual feedback during registration.

## HTTPS Fixes
- **Parameterized Domain**: Replaced hardcoded `webinar-deluxe` with `__DUCKDNS_DOMAIN__` in `infra/scripts/proxy_setup_template.sh` and Bicep files to allow for custom domains and avoid name collisions.
- **Resilience**: Improved the Nginx proxy setup script to handle DuckDNS updates more reliably.
