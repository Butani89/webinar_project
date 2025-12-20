import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
import path from 'path'

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [vue()],
  resolve: {
    alias: {
      '@': path.resolve(__dirname, './src'),
    },
  },
  base: '/static/',
  server: {
    host: 'localhost',
    port: 5173,
    strictPort: true,
  },
  build: {
    outDir: path.resolve(__dirname, './dist'),
    assetsDir: '',
    manifest: true,
    rollupOptions: {
      input: path.resolve(__dirname, './src/main.ts'),
    },
  },
  test: {
    globals: true,
    environment: 'jsdom',
  },
})