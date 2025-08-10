<script lang="ts">
	export let tuningsData;
	export let selectedTuningIndex: number;
	export let setTuning;
	export let notes;
	export let scaleRoot;
	export let handleRootChange;
	export let scalesData;
	export let selectedScaleIndex: number;
	export let handleScaleChange;
	export let selectedModeIndex: number;
	export let handleModeChange;
	export let onlyShowActiveNotes: boolean;
	export let displayDegrees: boolean;
	export let setOnlyShowActiveNotes;
	export let setDisplayDegrees;
</script>

<div class="mx-2 flex flex-wrap items-center justify-between gap-2">
	<!-- Preset Selector -->
	<div class="flex min-w-0 flex-shrink-0 flex-row items-center gap-1">
		<select
			class="rounded border-1 border-ctp-surface2 bg-ctp-mantle px-2 py-1 text-sm font-semibold text-ctp-text shadow focus:border-ctp-peach focus:outline-ctp-peach"
			bind:value={selectedTuningIndex}
			on:change={(e) => setTuning((e.target as HTMLSelectElement).selectedIndex)}
		>
			{#each tuningsData as tuning, i}
				<option value={i}>{tuning.name}</option>
			{/each}
		</select>
		<select
			class="rounded border-1 border-ctp-surface2 bg-ctp-mantle px-2 py-1 text-sm font-semibold text-ctp-text shadow focus:border-ctp-peach focus:outline-ctp-peach"
			bind:value={scaleRoot.name}
			on:change={handleRootChange}
		>
			{#each notes as note}
				<option value={note}>{note}</option>
			{/each}
		</select>
		<select
			class="rounded border-1 border-ctp-surface2 bg-ctp-mantle px-2 py-1 text-sm font-semibold text-ctp-text shadow focus:border-ctp-peach focus:outline-ctp-peach"
			on:change={handleScaleChange}
			bind:value={selectedScaleIndex}
		>
			{#each scalesData as scale, i}
				<option value={i}>{scale.name}</option>
			{/each}
		</select>
		<select
			class="rounded border-1 border-ctp-surface2 bg-ctp-mantle px-2 py-1 text-sm font-semibold text-ctp-text shadow focus:border-ctp-peach focus:outline-ctp-peach"
			on:change={handleModeChange}
			bind:value={selectedModeIndex}
		>
			{#each scalesData[selectedScaleIndex].modes as mode, j}
				<option value={j}>{mode.name}</option>
			{/each}
		</select>
	</div>
	<!-- Toggle Options -->
	<div class="flex flex-shrink-0 flex-row items-center gap-2">
		<label class="inline-flex cursor-pointer items-center">
			<input
				type="checkbox"
				class="peer sr-only"
				bind:checked={onlyShowActiveNotes}
				on:change={setOnlyShowActiveNotes}
			/>
			<span class="mr-2 text-sm font-medium text-ctp-text">Only show active Notes</span>
			<div
				class="peer relative h-5 w-9 rounded-full border-ctp-surface2 bg-ctp-mantle outline outline-ctp-surface2 peer-checked:bg-ctp-surface2 peer-checked:outline-ctp-text after:absolute after:start-[2px] after:top-0.5 after:h-4 after:w-4 after:rounded-full after:bg-ctp-text after:transition-all after:content-[''] peer-checked:after:translate-x-full rtl:peer-checked:after:-translate-x-full"
			></div>
		</label>
		<label class="inline-flex cursor-pointer items-center">
			<span class="mr-2 text-sm font-medium text-ctp-text">Display Degrees</span>
			<input
				type="checkbox"
				class="peer sr-only"
				bind:checked={displayDegrees}
				on:change={setDisplayDegrees}
			/>
			<div
				class="peer relative h-5 w-9 rounded-full border-ctp-surface2 bg-ctp-mantle outline outline-ctp-surface2 peer-checked:bg-ctp-surface2 peer-checked:outline-ctp-text after:absolute after:start-[2px] after:top-0.5 after:h-4 after:w-4 after:rounded-full after:bg-ctp-text after:transition-all after:content-[''] peer-checked:after:translate-x-full rtl:peer-checked:after:-translate-x-full"
			></div>
		</label>
	</div>
</div>
