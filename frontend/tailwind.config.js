/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{vue,js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {
      colors: {
        brand: {
          obsidian: '#050a05',
          mycelium: '#1e4d14',
          gold: '#fbbf24',
          amber: '#f59e0b',
          earth: '#2d1a0a',
          mist: '#f0f9f0',
          bone: '#ffffff'
        }
      },
      backgroundImage: {
        'cinematic-gradient': 'linear-gradient(to bottom, rgba(5, 10, 5, 0.8), rgba(5, 10, 5, 1))',
        'forest-pattern': "url('https://www.transparenttextures.com/patterns/leaf.png')",
      },
      animation: {
        'fade-in-down': 'fadeInDown 1.2s cubic-bezier(0.16, 1, 0.3, 1)',
        'fade-in-up': 'fadeInUp 1.2s cubic-bezier(0.16, 1, 0.3, 1)',
        'float': 'float 8s ease-in-out infinite',
        'shimmer': 'shimmer 2s infinite linear',
      },
      keyframes: {
        shimmer: {
          '0%': { transform: 'translateX(-100%)' },
          '100%': { transform: 'translateX(100%)' }
        },
        // ... (rest of keyframes)

    },
  },
  plugins: [],
}
