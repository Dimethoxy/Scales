<script lang="ts">
	export let accidentalDegrees;
	export let naturalDegrees;
	export let toggleDegree;
	export let handleDegreeMouseEnter;
	export let handleDegreeMouseLeave;
</script>

<div class="flex flex-1 flex-col items-center">
	<div class="flex justify-center gap-2">
		{#each accidentalDegrees as d}
			{#if d.spacerBefore}
				<div class="h-12 w-12"></div>
			{/if}
			<button
				type="button"
				class="flex h-12 w-12 cursor-pointer items-center justify-center rounded-full border border-ctp-surface2 text-xl font-bold text-ctp-crust {d.active
					? d.color
					: 'bg-ctp-mantle  text-ctp-surface2'} relative"
				on:click={() => toggleDegree(d.index)}
				on:mouseenter={(e) => handleDegreeMouseEnter(e, d)}
				on:mouseleave={handleDegreeMouseLeave}
			>
				{#if d.label === 'R'}
					<span
						class="pointer-events-none absolute top-2 left-2 h-7.5 w-7.5 rounded-full border-2 border-ctp-mantle"
					></span>
				{/if}
				{d.label}
			</button>
		{/each}
	</div>
	<div class="flex justify-center gap-2">
		{#each naturalDegrees as d}
			<button
				type="button"
				class="flex h-12 w-12 cursor-pointer items-center justify-center rounded-full border border-ctp-surface2 text-xl font-bold text-ctp-crust {d.active
					? d.color
					: 'bg-ctp-mantle text-ctp-surface2'} relative"
				on:click={() => toggleDegree(d.index)}
				on:mouseenter={(e) => handleDegreeMouseEnter(e, d)}
				on:mouseleave={handleDegreeMouseLeave}
			>
				{#if d.label === 'R'}
					<span
						class="pointer-events-none absolute top-0.5 left-0.5 h-10.5 w-10.5 rounded-full border-3 border-ctp-surface2"
					></span>
				{/if}
				{d.label}
			</button>
		{/each}
	</div>
</div>
