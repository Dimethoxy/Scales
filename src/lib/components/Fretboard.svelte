<script lang="ts">
	export let instrumentStrings;
	export let allStringNotes;
	export let stringNotesDegrees;
	export let notes;
	export let scaleRoot;
	export let degrees;
	export let numFrets;
	export let onlyShowActiveNotes;
	export let displayDegrees;
	export let getDegreeColor;
	export let retuneString;
</script>

<div class="my-1 overflow-x-auto">
	<div class="min-w-max">
		<div class="flex px-2">
			<div class="w-8"></div>
			{#each Array(numFrets + 1) as _, fret}
				<div class="flex min-w-12 flex-1 items-center justify-center text-lg text-ctp-subtext0">
					{fret}
				</div>
			{/each}
		</div>
		<div class="mx-1 rounded border-2 border-ctp-surface2 bg-ctp-base">
			{#each instrumentStrings as string, stringIndex}
				<div class="flex items-center border-1 border-ctp-surface2">
					<div
						class="flex w-8 flex-col items-center justify-center text-center text-sm font-bold text-ctp-text"
					>
						<button
							type="button"
							class="flex h-3 w-10 items-center justify-center border-none bg-transparent p-0 focus:outline-none"
							title="Tune up"
							aria-label="Tune string up"
							on:click={() => retuneString(stringIndex, 1)}
							style="background: none;"
						>
							<i class="fa-solid fa-chevron-up text-xs text-ctp-overlay2"></i>
						</button>
						<span class="scroll">{string.root.name}{string.root.octave}</span>
						<button
							type="button"
							class="flex h-3 w-10 items-center justify-center border-none bg-transparent p-0 focus:outline-none"
							title="Tune down"
							aria-label="Tune string down"
							on:click={() => retuneString(stringIndex, -1)}
							style="background: none;"
						>
							<i class="fa-solid fa-chevron-down text-xs text-ctp-overlay2"></i>
						</button>
					</div>
					{#each Array(numFrets + 1) as _, fret}
						{@const note = allStringNotes[stringIndex][fret]}
						{@const scaleDegree = stringNotesDegrees[stringIndex][fret]}
						<div class="relative flex h-12 min-w-12 flex-1 items-center justify-center">
							{#if fret > 0}
								<div class="absolute top-0 left-0 h-full w-px bg-ctp-surface0"></div>
							{/if}
							<div class="absolute h-px w-full bg-ctp-surface2" hidden></div>
							{#if note && (!onlyShowActiveNotes || scaleDegree >= 0)}
								<div
									class="text-md relative z-10 flex h-11 w-11 items-center justify-center rounded-full border border-ctp-surface0 font-bold text-ctp-crust {scaleDegree >=
									0
										? getDegreeColor(scaleDegree)
										: 'bg-ctp-mantle text-ctp-surface2'}"
								>
									{#if displayDegrees}
										{#if note}
											{#key note.name + note.octave}
												{@const noteIndex: number = notes.indexOf(note.name)}
												{@const rootIndex: number = notes.indexOf(scaleRoot.name)}
												{@const intervalFromRoot = (((noteIndex - rootIndex) % 12) + 12) % 12}
												{#if degrees[intervalFromRoot]?.label === 'R'}
													<span
														class="pointer-events-none absolute top-0.5 left-0.5 h-9.5 w-9.5 rounded-full border-3 border-ctp-surface2"
													></span>
												{/if}
												{degrees[intervalFromRoot]?.label}
											{/key}
										{/if}
									{:else if note}
										{#key note.name + note.octave}
											{@const noteIndex: number = notes.indexOf(note.name)}
											{@const rootIndex: number = notes.indexOf(scaleRoot.name)}
											{@const intervalFromRoot = (((noteIndex - rootIndex) % 12) + 12) % 12}
											{#if degrees[intervalFromRoot]?.label === 'R'}
												<span
													class="pointer-events-none absolute top-0.5 left-0.5 h-9.5 w-9.5 rounded-full border-3 border-ctp-surface2"
												></span>
											{/if}
											{note.name}
										{/key}
									{/if}
								</div>
							{/if}
						</div>
					{/each}
				</div>
			{/each}
		</div>
	</div>
</div>
