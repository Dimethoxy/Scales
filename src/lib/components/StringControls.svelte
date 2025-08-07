<script lang="ts">
	export let instrumentStrings;
	export let addString;
	export let removeString;
</script>

<div class="flex items-center gap-2">
	<span class="text-2xl text-ctp-text">String Amount: {instrumentStrings.length}</span>
	<button
		type="button"
		class="flex h-6 w-6 items-center justify-center rounded border-1 border-ctp-surface2 bg-ctp-mantle text-ctp-text hover:bg-ctp-text hover:text-ctp-crust disabled:opacity-50"
		disabled={instrumentStrings.length <= 1}
		on:click={() => removeString(instrumentStrings.length - 1)}>-</button
	>
	<button
		type="button"
		class="flex h-6 w-6 items-center justify-center rounded border-1 border-ctp-surface2 bg-ctp-mantle text-ctp-text hover:bg-ctp-text hover:text-ctp-crust disabled:opacity-50"
		on:click={addString}>+</button
	>
</div>
