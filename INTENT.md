# Intent: Modernization and Fixes
**Date:** 2025-12-19 22:59
**Author:** Fredrick Amnehagen <fredrick@loopaware.com>

## Goals
1. **Fix Database Connection**: Ensure `ADMIN_PASSWORD` and other necessary environment variables are correctly passed to the Flask application service.
2. **Fix HTTPS**: Ensure the Nginx proxy is correctly configured for SSL and can handle certificate renewal.
3. **Refactor Backend**: Improve error handling and structure in `app/main.py`.
4. **Modernize Website**: 
    - Update `app/static/css/main.css` with a modern, clean design (Glassmorphism, better typography).
    - Update `app/static/index.html` content to better match the "World of Mushrooms" theme.
    - Improve `app/static/js/app.js` for better interactivity.
5. **Code Review**: Address any technical debt or inconsistencies found in the codebase.

## Proposed Changes
- Modify `scripts/backend_setup.sh` to include `ADMIN_PASSWORD` in the systemd service.
- Update `app/main.py` to be more robust.
- Rewrite `app/static/css/main.css` for a modern look.
- Update `app/static/index.html` with new copy and better structure.
- Update `infra/scripts/proxy_setup_template.sh` to be more resilient.
