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
          forest: '#0f1c0e',
          mycelium: '#2d5a27',
          gold: '#f59e0b',
          amber: '#d97706',
          earth: '#451a03',
          mist: '#ecf3ec',
          bone: '#f8fafc'
        }
      },
      backgroundImage: {
        'forest-pattern': "url('https://www.transparenttextures.com/patterns/leaf.png')",
        'glow-gradient': 'radial-gradient(circle at center, rgba(45, 90, 39, 0.1) 0%, transparent 70%)',
      },
      animation: {
        'fade-in-down': 'fadeInDown 0.8s cubic-bezier(0.16, 1, 0.3, 1)',
        'fade-in-up': 'fadeInUp 0.8s cubic-bezier(0.16, 1, 0.3, 1)',
        'float': 'float 6s ease-in-out infinite',
        'pulse-soft': 'pulseSoft 4s ease-in-out infinite',
      },
      keyframes: {
        fadeInDown: {
          '0%': { opacity: '0', transform: 'translateY(-20px)' },
          '100%': { opacity: '1', transform: 'translateY(0)' },
        },
        fadeInUp: {
          '0%': { opacity: '0', transform: 'translateY(20px)' },
          '100%': { opacity: '1', transform: 'translateY(0)' },
        },
        float: {
          '0%, 100%': { transform: 'translateY(0)' },
          '50%': { transform: 'translateY(-10px)' },
        },
        pulseSoft: {
          '0%, 100%': { opacity: '1' },
          '50%': { opacity: '0.8' },
        }
      }
    },
  },
  plugins: [],
}
