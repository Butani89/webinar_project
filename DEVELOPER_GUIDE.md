# Developer Guide

## Tech Stack
- **Backend**: Django 4.x, Django REST Framework, PostgreSQL.
- **Frontend**: Vue 3 (Composition API), Vite, Tailwind CSS, Lucide-vue-next.
- **Testing**: Pytest (Backend), Vitest (Frontend).
- **Deployment**: GitHub Actions, Azure CLI, Bicep.

## Coding Standards
- Follow PEP 8 for Python.
- Follow Vue 3 Style Guide (using `<script setup>` and TypeScript).
- Use Tailwind utility classes for styling.

## Testing
- **Backend**: Pytest (located in `backend/webinar/tests/`).
- **Frontend Unit**: Vitest (located alongside components).
- **E2E**: Playwright (located in `frontend/e2e/`).
    - Supports multiple platforms: Desktop (Chrome, Firefox, Safari), Mobile (Android/Pixel, iOS/iPhone), and Tablet (iPad).
    - Includes responsive design verification.

## API Documentation

## Adding New Features
1. Create a feature branch.
2. Implement backend changes in `backend/`.
3. Implement frontend changes in `frontend/`.
4. Add tests for the new functionality.
5. Create a Pull Request.

## Deployment Details
The `scripts/backend_setup.sh` is responsible for provisioning the BackendVM. It installs Node.js, builds the Vue app, and sets up Gunicorn for Django.