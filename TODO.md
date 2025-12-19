# Project TODO List

This document tracks upcoming tasks and long-term goals for the Webinar project.

## High-Level Goals

- [ ] Enhance the automated deployment process for better reliability.
- [ ] Increase test coverage across the application.
- [ ] Add new features to the frontend to improve user experience.
- [ ] Improve observability with better logging and monitoring.

## Specific Tasks

### Backend
- [ ] Implement a structured logging solution in the Flask application (e.g., using `structlog`).
- [ ] Add unit tests for the `scripts/generate_art.py` module.
- [ ] Create integration tests for the API endpoints.
- [ ] Refactor database setup to use migrations (e.g., with Alembic).

### Frontend
- [ ] Add a "Contact Us" form to the website.
- [ ] Implement a more dynamic gallery with image uploads.
- [ ] Minify CSS and JavaScript assets for better performance.

### Infrastructure
- [ ] Refactor `infra/scripts/proxy_setup_template.sh` to be more modular and less monolithic.
- [ ] Parameterize the Bicep templates further to allow for easier reuse.
- [ ] Investigate and implement a more secure way to handle secrets during deployment.

## Bugs
- [ ] Fix the hardcoded URLs in the `index.html` meta tags (already fixed, but good to note).
