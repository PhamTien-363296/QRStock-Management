import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'
import tailwindcss from '@tailwindcss/vite'

export default defineConfig({
  plugins: [react(), tailwindcss()],
  server: {
    historyApiFallback: true,
    port: 3000,
    proxy: {
      "/api": {
        target: "http://localhost:5000", 
        changeOrigin: true,
        secure: false, 
      }
    },
    headers: {
      "Cache-Control": "no-store, no-cache, must-revalidate, proxy-revalidate",
      Pragma: "no-cache",
      Expires: "0",
    },
    host: "localhost", 
    strictPort: true,
    hmr: {
      clientPort: 443,
    },
    allowedHosts: true,
  }
})
