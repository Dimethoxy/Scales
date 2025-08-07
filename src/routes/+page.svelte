<script lang="ts">
	type NoteName = 'C' | 'C#' | 'D' | 'D#' | 'E' | 'F' | 'F#' | 'G' | 'G#' | 'A' | 'A#' | 'B';
	const notes: NoteName[] = ['C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B'];

	type Note = {
		name: NoteName;
		octave: number;
	};

	function transpose(note: Note, semitones: number): Note {
		const currentIndex = notes.indexOf(note.name);
		const newIndex = (((currentIndex + semitones) % 12) + 12) % 12;
		const octaveChange = Math.floor((currentIndex + semitones) / 12);

		return {
			name: notes[newIndex],
			octave: note.octave + octaveChange
		};
	}

	type InstrumentString = {
		index: number;
		root: Note;
	};

	function generateStringNotes(root: Note): Note[] {
		const stringNotes: Note[] = [];
		for (let i = 0; i < 32; i++) {
			stringNotes.push(transpose(root, i));
		}
		return stringNotes;
	}

	// Dynamic list of instrument strings
	let instrumentStrings: InstrumentString[] = [
		{ index: 0, root: { name: 'E', octave: 4 } },
		{ index: 1, root: { name: 'B', octave: 3 } },
		{ index: 2, root: { name: 'G', octave: 3 } },
		{ index: 3, root: { name: 'D', octave: 3 } },
		{ index: 4, root: { name: 'A', octave: 2 } },
		{ index: 5, root: { name: 'E', octave: 2 } }
	];

	// Reactive statement - all string notes recalculate when any root changes
	$: allStringNotes = instrumentStrings.map((string) => generateStringNotes(string.root));

	// Current root note for the scale
	let scaleRoot: Note = { name: 'C', octave: 4 };

	function handleRootChange(e: Event) {
		const selectedName = (e.target as HTMLSelectElement).value as NoteName;
		scaleRoot = { ...scaleRoot, name: selectedName };
	}

	type Degree = {
		index: number;
		label: string;
		row: 'natural' | 'accidental';
		active: boolean;
		color: string;
		description: string;
		spacerBefore?: boolean;
	};

	let degrees: Degree[] = [
		{
			index: 0,
			label: '1',
			row: 'natural',
			active: true,
			color: 'bg-ctp-text',
			description: 'Root note: Establishes tonal center and stability.'
		},
		{
			index: 1,
			label: 'b2',
			row: 'accidental',
			active: false,
			color: 'bg-ctp-teal',
			description: 'Minor second: Very dissonant, often used for tension or exotic scales.'
		},
		{
			index: 2,
			label: '2',
			row: 'natural',
			active: true,
			color: 'bg-ctp-green',
			description: 'Major second: Adds brightness and melodic movement.'
		},
		{
			index: 3,
			label: 'b3',
			row: 'accidental',
			active: false,
			color: 'bg-ctp-yellow',
			description: 'Minor third: Gives minor tonality, evokes sadness or introspection.'
		},
		{
			index: 4,
			label: '3',
			row: 'natural',
			active: true,
			color: 'bg-ctp-peach',
			description: 'Major third: Defines major tonality, sounds happy and uplifting.'
		},
		{
			index: 5,
			label: '4',
			row: 'natural',
			active: true,
			color: 'bg-ctp-red',
			description: 'Perfect fourth: Neutral, can sound suspended or unresolved.'
		},
		{
			index: 6,
			label: 'b5',
			row: 'accidental',
			active: false,
			color: 'bg-ctp-pink',
			spacerBefore: true,
			description:
				'Diminished fifth: Also called Tritone, very dissonant, used for tension and drama.'
		},
		{
			index: 7,
			label: '5',
			row: 'natural',
			active: true,
			color: 'bg-ctp-mauve',
			description: 'Perfect fifth: Stable and consonant, forms the basis of power chords.'
		},
		{
			index: 8,
			label: 'b6',
			row: 'accidental',
			active: false,
			color: 'bg-ctp-lavender',
			description: 'Minor sixth: Adds melancholy, used in minor and exotic scales.'
		},
		{
			index: 9,
			label: '6',
			row: 'natural',
			active: true,
			color: 'bg-ctp-blue',
			description: 'Major sixth: Warm and sweet, common in major and modal scales.'
		},
		{
			index: 10,
			label: 'b7',
			row: 'accidental',
			active: false,
			color: 'bg-ctp-sky',
			description: 'Minor seventh: luesy, jazzy, adds tension and color.'
		},
		{
			index: 11,
			label: '7',
			row: 'natural',
			active: true,
			color: 'bg-ctp-sapphire',
			description: 'Major seventh; dreamy, adds sophistication and tension.'
		}
	];

	$: naturalDegrees = degrees.filter((d) => d.row === 'natural');
	$: accidentalDegrees = degrees.filter((d) => d.row === 'accidental');

	// Reactive statement - get active scale degrees (semitone intervals from root)
	$: activeScaleDegrees = degrees.filter((d) => d.active).map((d) => d.index);

	// Function to get the scale degree of a note (returns -1 if not in scale)
	function getNoteScaleDegree(note: Note, scaleRoot: Note, activeIntervals: number[]): number {
		const noteIndex = notes.indexOf(note.name);
		const rootIndex = notes.indexOf(scaleRoot.name);
		const intervalFromRoot = (((noteIndex - rootIndex) % 12) + 12) % 12;
		const degreeIndex = activeIntervals.indexOf(intervalFromRoot);
		if (degreeIndex === -1) return -1;
		// Return the actual degree index, not the position in activeIntervals
		return activeIntervals[degreeIndex];
	}

	// Function to get color for a degree index
	function getDegreeColor(degreeIndex: number): string {
		const degree = degrees.find((d) => d.index === degreeIndex);
		return degree ? degree.color : 'bg-ctp-mantle';
	}

	// Reactive statement - for each string, determine which degree each note is in
	$: stringNotesDegrees = instrumentStrings.map((string) =>
		generateStringNotes(string.root).map((note) =>
			getNoteScaleDegree(note, scaleRoot, activeScaleDegrees)
		)
	);

	// Current degree active states (for toggling)
	let activeDegrees: boolean[] = Array(degrees.length).fill(false);

	// Toggle degree active state
	function toggleDegree(index: number) {
		activeDegrees[index] = !activeDegrees[index];
		degrees[index].active = activeDegrees[index];
	}

	let numFrets = 18;

	function addString() {
		const newIndex = instrumentStrings.length;
		let newRoot: Note;

		if (instrumentStrings.length === 0) {
			// Default root if no strings exist
			newRoot = { name: 'E', octave: 2 };
		} else {
			// Get the last string's root and transpose it down 5 semitones
			const lastString = instrumentStrings[instrumentStrings.length - 1];
			newRoot = transpose(lastString.root, -5);
		}

		instrumentStrings = [
			...instrumentStrings,
			{
				index: newIndex,
				root: newRoot
			}
		];
	}

	function removeString(index: number) {
		instrumentStrings = instrumentStrings.filter((s) => s.index !== index);
		// Reindex remaining strings
		instrumentStrings = instrumentStrings.map((s, i) => ({ ...s, index: i }));
	}

	// Move string root up/down by one semitone
	function retuneString(stringIndex: number, semitones: number) {
		const root = instrumentStrings[stringIndex].root;
		instrumentStrings[stringIndex].root = transpose(root, semitones);
		instrumentStrings = [...instrumentStrings];
	}

	// Tooltip state
	let showTooltip = false;
	let tooltipContent = '';
	let tooltipX = 0;
	let tooltipY = 0;
	let hoverTimeout: ReturnType<typeof setTimeout>;

	function handleDegreeMouseEnter(event: MouseEvent, degree: Degree) {
		clearTimeout(hoverTimeout);
		hoverTimeout = setTimeout(() => {
			const rect = (event.target as HTMLElement).getBoundingClientRect();
			tooltipX = rect.left + rect.width / 2;
			tooltipY = rect.top - 10;
			tooltipContent = degree.description;
			showTooltip = true;
		}, 500); // Show tooltip after 500ms hover
	}

	function handleDegreeMouseLeave() {
		clearTimeout(hoverTimeout);
		showTooltip = false;
	}
</script>

<main>
	<div class="my-2">
		<!-- Preset selector at the top -->
		<div class="mx-2 flex flex-row items-center justify-start gap-4">
			<select
				class="text-md rounded border-1 border-ctp-surface2 bg-ctp-mantle px-2 py-1 font-semibold text-ctp-text shadow focus:border-ctp-blue focus:outline-none"
				bind:value={scaleRoot.name}
				on:change={handleRootChange}
			>
				{#each notes as note}
					<option value={note}>{note}</option>
				{/each}
			</select>
			<select
				class="text-md rounded border-1 border-ctp-surface2 bg-ctp-mantle px-2 py-1 font-semibold text-ctp-text shadow focus:border-ctp-blue focus:outline-none"
			>
				<option>Pentatonic</option>
				<option>Diatonic</option>
				<option>Harmonic Minor</option>
				<option>Melodic Minor</option>
			</select>
			<select
				class="text-md rounded border-1 border-ctp-surface2 bg-ctp-mantle px-2 py-1 font-semibold text-ctp-text shadow focus:border-ctp-blue focus:outline-none"
			>
				<option>Mode I</option>
				<option>Mode II</option>
				<option>Mode III</option>
				<option>Mode IV</option>
				<option>Mode V</option>
				<option>Mode VI</option>
				<option>Mode VII</option>
			</select>
		</div>

		<!-- Fretboard -->
		<div class="my-1 overflow-x-auto">
			<div class="min-w-max">
				<!-- Fret numbers header -->
				<div class="flex px-2">
					<!-- Empty space for string tuning column -->
					<div class="w-16"></div>
					<!-- Fret numbers -->
					{#each Array(numFrets + 1) as _, fret}
						<div class="flex min-w-12 flex-1 items-center justify-center text-lg text-ctp-subtext0">
							{fret}
						</div>
					{/each}
				</div>

				<!-- Fretboard grid -->
				<div class="mx-1 rounded border border-ctp-surface0 bg-ctp-base">
					{#each instrumentStrings as string, stringIndex}
						<div class="flex items-center border-b border-ctp-surface0 last:border-b-0">
							<!-- String tuning with vertical chevron buttons -->
							<div
								class="flex w-8 flex-col items-center justify-center text-center text-sm font-bold text-ctp-text"
							>
								<!-- Up button (chevron up) - minimal height -->
								<button
									type="button"
									class="flex h-3 w-12 items-center justify-center border-none bg-transparent p-0 focus:outline-none"
									title="Tune up"
									aria-label="Tune string up"
									on:click={() => retuneString(stringIndex, 1)}
									style="background: none;"
								>
									<i class="fa-solid fa-chevron-up text-xs text-ctp-overlay2"></i>
								</button>
								<!-- Root label -->
								<span class="scroll">{string.root.name}{string.root.octave}</span>
								<!-- Down button (chevron down) - minimal height -->
								<button
									type="button"
									class="flex h-3 w-12 items-center justify-center border-none bg-transparent p-0 focus:outline-none"
									title="Tune down"
									aria-label="Tune string down"
									on:click={() => retuneString(stringIndex, -1)}
									style="background: none;"
								>
									<i class="fa-solid fa-chevron-down text-xs text-ctp-overlay2"></i>
								</button>
							</div>

							<!-- Fret positions -->
							{#each Array(numFrets + 1) as _, fret}
								{@const note = allStringNotes[stringIndex][fret]}
								{@const scaleDegree = stringNotesDegrees[stringIndex][fret]}
								<div class="relative flex h-12 min-w-12 flex-1 items-center justify-center">
									<!-- Fret marker (visual fret line) -->
									{#if fret > 0}
										<div class="absolute top-0 left-0 h-full w-px bg-ctp-surface2"></div>
									{/if}

									<!-- String line -->
									<div class="absolute h-px w-full bg-ctp-surface2"></div>

									<!-- Note indicator -->
									{#if note}
										<div
											class="relative z-10 flex h-10 w-10 items-center justify-center rounded-full border border-ctp-surface0 text-xs font-bold text-ctp-crust

											{scaleDegree >= 0 ? getDegreeColor(scaleDegree) : 'bg-ctp-mantle text-ctp-surface2'}"
										>
											{note.name}
										</div>
									{/if}
								</div>
							{/each}
						</div>
					{/each}
				</div>
			</div>
		</div>

		<!-- Controls and degree selector at the bottom -->
		<div class="my-4 flex flex-row items-center justify-between px-8">
			<!-- String Amount controls (left) -->
			<div class="flex items-center gap-4">
				<span class="text-2xl text-ctp-text">String Amount: {instrumentStrings.length}</span>
				<button
					type="button"
					class="flex h-8 w-8 items-center justify-center rounded bg-ctp-red text-white hover:bg-ctp-red/80 disabled:opacity-50"
					disabled={instrumentStrings.length <= 1}
					on:click={() => removeString(instrumentStrings.length - 1)}
				>
					-
				</button>
				<button
					type="button"
					class="flex h-8 w-8 items-center justify-center rounded bg-ctp-peach text-white hover:bg-ctp-green/80"
					on:click={addString}
				>
					+
				</button>
			</div>

			<!-- Degree selectors (center) -->
			<div class="flex flex-1 flex-col items-center">
				<!-- Accidental degrees -->
				<div class="flex justify-center gap-2">
					{#each accidentalDegrees as d}
						{#if d.spacerBefore}
							<div class="h-12 w-12"></div>
						{/if}
						<button
							type="button"
							class="flex h-12 w-12 cursor-pointer items-center justify-center rounded-full border border-ctp-surface2 text-xl font-bold text-ctp-crust {d.active
								? d.color
								: 'bg-ctp-mantle  text-ctp-surface2'}"
							on:click={() => {
								d.active = !d.active;
								console.log(d.index);
							}}
							on:mouseenter={(e) => handleDegreeMouseEnter(e, d)}
							on:mouseleave={handleDegreeMouseLeave}
						>
							{d.label}
						</button>
					{/each}
				</div>
				<!-- Natural degrees -->
				<div class="flex justify-center gap-2">
					{#each naturalDegrees as d}
						<button
							type="button"
							class="flex h-12 w-12 cursor-pointer items-center justify-center rounded-full border border-ctp-surface2 text-xl font-bold text-ctp-crust {d.active
								? d.color
								: 'bg-ctp-mantle text-ctp-surface2'}"
							on:click={() => {
								d.active = !d.active;
								console.log(d.color);
							}}
							on:mouseenter={(e) => handleDegreeMouseEnter(e, d)}
							on:mouseleave={handleDegreeMouseLeave}
						>
							{d.label}
						</button>
					{/each}
				</div>
			</div>

			<!-- Fret Amount controls (right) -->
			<div class="flex items-center gap-4">
				<span class="text-2xl text-ctp-text">Fret Amount: {numFrets}</span>
				<button
					type="button"
					class="flex h-8 w-8 items-center justify-center rounded bg-ctp-red text-white hover:bg-ctp-red/80 disabled:opacity-50"
					disabled={numFrets <= 1}
					on:click={() => (numFrets = Math.max(1, numFrets - 1))}
				>
					-
				</button>
				<button
					type="button"
					class="flex h-8 w-8 items-center justify-center rounded bg-ctp-peach text-white hover:bg-ctp-green/80"
					on:click={() => (numFrets = Math.min(30, numFrets + 1))}
				>
					+
				</button>
			</div>
		</div>
	</div>

	<!-- Tooltip -->
	{#if showTooltip}
		<div
			class="pointer-events-none fixed z-50 max-w-xs rounded border border-ctp-surface2 bg-ctp-mantle px-3 py-2 text-sm text-ctp-text shadow-lg"
			style="left: {tooltipX}px; top: {tooltipY}px; transform: translateX(-50%) translateY(-100%);"
		>
			{tooltipContent}
		</div>
	{/if}
</main>
