# Intent: Brand Identity and Palette Implementation
**Date:** 2025-12-20 01:45
**Author:** Fredrick Amnehagen <fredrick@loopaware.com>

## Goal
Establish a strong, consistent visual identity for "Svamparnas Värld". This involves defining a specific color palette that reflects the theme and ensuring the entire application adheres to it.

## The Brand Palette
- **Forest** (`#0f1c0e`): The deep, mysterious core.
- **Mycelium** (`#2d5a27`): The life and growth.
- **Gold** (`#f59e0b`): The valuable spores and highlights.
- **Amber** (`#d97706`): The bio-luminescent glow.
- **Mist** (`#ecf3ec`): The atmospheric fog.
- **Bone** (`#f8fafc`): The clean, organic structure.

## Changes
- **Tailwind Configuration**: Defined the `brand` color group in `tailwind.config.js`.
- **Global Styles**: Updated `src/style.css` to use brand colors for base backgrounds and custom scrollbars.
- **UI Components**: Refactored all Vue components to use the new `brand-*` utility classes consistently.
- **3D Visuals**: Updated `BackgroundScene.vue` to align Three.js materials and background colors with the official palette.
- **Documentation**: Created `BRANDING.md` as a reference for the visual identity.
