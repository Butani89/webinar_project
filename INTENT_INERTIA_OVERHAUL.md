# Intent: Inertia.js + Django-Vite Overhaul
**Date:** 2025-12-20 02:30
**Author:** Fredrick Amnehagen <fredrick@loopaware.com>

## Goal
Transform the project into a modern, high-performance monolith using **Inertia.js** and **Django-Vite**. This migration simplifies the development flow while enabling a significantly more "premium" and "cinematic" user experience—selling the "experience of a lifetime."

## Architecture: The Unified Stack
- **Monolith with SPA Feel**: Inertia.js allows us to use Vue 3 for the UI while keeping the routing and controller logic in Django. No more manual REST API calls for initial page loads or form submissions.
- **Vite Integration**: `django-vite` provides seamless Hot Module Replacement (HMR) in development and hashed assets in production.
- **Unified Branding**: Established the "Obsidian Forest" brand identity with ultra-premium typography and cinematic visuals.

## Visual & UX Overhaul
- **Cinematic Hero**: Massive typography with gold shimmer gradients and high-contrast dark backgrounds.
- **Deep Mycelium Scene**: Updated Three.js visuals to match the "Obsidian" theme, with brighter gold spores and deeper forest blacks.
- **Premium Components**: Every section (Agenda, Speakers, Form) has been rebuilt with a focus on "Elite" accessibility and sharp, minimal aesthetics.
- **Inertia Protocol**: Form submissions now use `useForm`, providing instant feedback and state preservation.

## Technical Changes
- Added `inertia-django` and `django-vite` to backend.
- Set up `base.html` layout and Inertia middleware.
- Refactored Vue frontend into Inertia `Pages/` and `components/`.
- Updated Nginx and deployment scripts to support the unified monolithic structure.
