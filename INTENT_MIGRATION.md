# Intent: Framework Migration (Django, Vue 3, Tailwind CSS)
**Date:** 2025-12-19 23:45
**Author:** Fredrick Amnehagen <fredrick@loopaware.com>

## Goal
Modernize the application stack by migrating from Flask/Vanilla JS to:
- **Backend:** Python Django with Django REST Framework (DRF).
- **Frontend:** Vue.js 3 (Composition API) with Vite.
- **Styling:** Tailwind CSS.

## Architecture
- **Decoupled Structure**: `backend/` for Django, `frontend/` for Vue.
- **Frontend Build**: Vite builds the Vue app into `app/static/`, which Nginx serves as static files.
- **API Communication**: Vue app communicates with Django via `/api/` proxy.
- **Media Management**: Django handles mushroom art generation and serves it via `/media/`.

## Changes
- Created `backend/` with full Django project structure.
- Created `frontend/` with Vue 3 + Tailwind CSS scaffold.
- Updated `requirements.txt` for Django dependencies.
- Updated `scripts/backend_setup.sh` to install Node.js and build the frontend.
- Updated `.github/workflows/update-app.yml` to support the new build pipeline.
