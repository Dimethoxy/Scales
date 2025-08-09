<script lang="ts">
	let themes = ['latte', 'frappe', 'macchiato', 'mocha'];
	let selectedTheme = 'mocha';

	import { onMount } from 'svelte';
	onMount(() => {
		const storedTheme = localStorage.getItem('theme');
		if (storedTheme && themes.includes(storedTheme)) {
			selectedTheme = storedTheme;
		}
		document.documentElement.className = selectedTheme;
	});

	function changeTheme(e: Event) {
		const value = (e.target as HTMLSelectElement).value;
		selectedTheme = value;
		document.documentElement.className = value;
		localStorage.setItem('theme', value);
	}
</script>

<header class="flex items-center justify-between bg-ctp-crust px-4 py-2 text-ctp-text">
	<div class="flex items-center">
		<h1 class="text-4xl font-bold">Scales Trainer</h1>
		<h6 class="mx-1 mb-4">v1.1.0</h6>
	</div>
	<div class="flex items-center space-x-2">
		<label for="theme-select" class="font-medium">Theme</label>
		<select
			id="theme-select"
			bind:value={selectedTheme}
			on:change={changeTheme}
			class="rounded bg-ctp-base px-2 py-1"
		>
			{#each themes as theme}
				<option value={theme}>{theme.charAt(0).toUpperCase() + theme.slice(1)}</option>
			{/each}
		</select>
	</div>
</header>
