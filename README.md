# Webinar Registration Project ("Svamparnas Värld")

A modern, full-stack application for managing webinar registrations, built with Django, Vue.js 3, and Tailwind CSS.

## Architecture

The project is decoupled into a backend (API) and a frontend (SPA).

- **Backend**: Django + Django REST Framework.
- **Frontend**: Vue 3 (Vite) + Tailwind CSS + Lucide Icons.
- **Infrastructure**: Platform-agnostic setup using OpenTofu (Azure & Proxmox) and Ansible.

## Development

### Backend Setup
1. `cd backend`
2. `python3 -m venv venv`
3. `source venv/bin/activate`
4. `pip install -r ../requirements.txt`
5. `python manage.py migrate`
6. `python manage.py runserver`

### Frontend Setup
1. `cd frontend`
2. `npm install`
3. `npm run dev`

## Testing

### Backend Tests
`cd backend && pytest`

### Frontend Tests
`cd frontend && npm test`

### E2E Tests (Playwright)
`cd frontend && npm run test:e2e`

## Deployment

The project uses a strict Git-based workflow for deployment.

- **Production Branch (`production`)**: Pushes to this branch trigger the automated deployment pipeline which provisions infrastructure via **OpenTofu** and configures servers via **Ansible**.
- **Development Branch (`development`)**: Pushes here trigger integration tests on a local Docker-based replica of the infrastructure.

For detailed architecture and setup instructions, see:
- [Infrastructure Architecture](docs/deployment/architecture.md)
- [CI/CD Workflow](docs/deployment/ci-cd.md)
- [Infrastructure README](infra/README.md)