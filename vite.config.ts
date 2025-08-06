import tailwindcss from '@tailwindcss/vite';
import { sveltekit } from '@sveltejs/kit/vite';
import { defineConfig } from 'vite';

export default defineConfig({
	plugins: [tailwindcss(), sveltekit()],
	server: {
		watch: {
			usePolling: true, // Force polling if file changes aren't detected properly
			interval: 100, // Polling interval (ms)
			ignored: ['**/node_modules/**'] // What not to watch
		}
	}
});
