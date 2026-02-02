import { defineConfig } from '@vben/vite-config';

// Mock localStorage for Node.js environment
if (typeof globalThis.localStorage === 'undefined') {
  globalThis.localStorage = {
    getItem: () => null,
    setItem: () => {},
    removeItem: () => {},
    clear: () => {},
    length: 0,
    key: () => null,
  };
}

export default defineConfig(async () => {
  return {
    application: {
      devtools: false,
    },
    vite: {
      define: {
        global: 'globalThis',
        'process.env': {},
      },
    },
  };
});
