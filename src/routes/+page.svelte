<script lang="ts">
	import { data_ } from './../../node_modules/@sveltejs/kit/src/core/sync/write_root.js';
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
			active: false,
			color: 'bg-ctp-red',
			description: 'Root note; establishes tonal center and stability.'
		},
		{
			index: 1,
			label: 'b2',
			row: 'accidental',
			active: false,
			color: 'bg-ctp-peach',
			description: 'Minor second; very dissonant, often used for tension or exotic scales.'
		},
		{
			index: 2,
			label: '2',
			row: 'natural',
			active: false,
			color: 'bg-ctp-yellow',
			description: 'Major second; adds brightness and melodic movement.'
		},
		{
			index: 3,
			label: 'b3',
			row: 'accidental',
			active: false,
			color: 'bg-ctp-green',
			description: 'Minor third; gives minor tonality, evokes sadness or introspection.'
		},
		{
			index: 4,
			label: '3',
			row: 'natural',
			active: false,
			color: 'bg-ctp-teal',
			description: 'Major third; defines major tonality, sounds happy and uplifting.'
		},
		{
			index: 5,
			label: '4',
			row: 'natural',
			active: false,
			color: 'bg-ctp-blue',
			description: 'Perfect fourth; neutral, can sound suspended or unresolved.'
		},
		{
			index: 6,
			label: 'b5',
			row: 'accidental',
			active: false,
			color: 'bg-ctp-mauve',
			spacerBefore: true,
			description: 'Diminished fifth (tritone); very dissonant, used for tension and drama.'
		},
		{
			index: 7,
			label: '5',
			row: 'natural',
			active: false,
			color: 'bg-ctp-pink',
			description: 'Perfect fifth; stable and consonant, forms the basis of power chords.'
		},
		{
			index: 8,
			label: 'b6',
			row: 'accidental',
			active: false,
			color: 'bg-ctp-lavender',
			description: 'Minor sixth; adds melancholy, used in minor and exotic scales.'
		},
		{
			index: 9,
			label: '6',
			row: 'natural',
			active: false,
			color: 'bg-ctp-sky',
			description: 'Major sixth; warm and sweet, common in major and modal scales.'
		},
		{
			index: 10,
			label: 'b7',
			row: 'accidental',
			active: false,
			color: 'bg-ctp-sapphire',
			description: 'Minor seventh; bluesy, jazzy, adds tension and color.'
		},
		{
			index: 11,
			label: '7',
			row: 'natural',
			active: false,
			color: 'bg-ctp-flamingo',
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
</script>

<main>
	<!-- Tailwind safelist hack to preserve dynamic bg-ctp-* classes -->
	<div class="hidden">
		<div class="bg-ctp-red"></div>
		<div class="bg-ctp-peach"></div>
		<div class="bg-ctp-yellow"></div>
		<div class="bg-ctp-green"></div>
		<div class="bg-ctp-teal"></div>
		<div class="bg-ctp-blue"></div>
		<div class="bg-ctp-mauve"></div>
		<div class="bg-ctp-pink"></div>
		<div class="bg-ctp-lavender"></div>
		<div class="bg-ctp-sky"></div>
		<div class="bg-ctp-sapphire"></div>
		<div class="bg-ctp-flamingo"></div>
		<div class="bg-ctp-mantle"></div>
	</div>

	<div class="my-2">
		<!-- String amount controls -->
		<div class="justify-left mb-4 flex items-center gap-4 px-8">
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

			<!-- Spacer -->
			<div class="flex-1"></div>

			<!-- Fret amount controls -->
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
		<!-- Fretboard -->
		<div class="my-2 overflow-x-auto">
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
							<!-- String tuning -->
							<div class="w-16 text-center text-sm font-bold text-ctp-text">
								{string.root.name}{string.root.octave}
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

		<div class="my-4">
			<!-- Accidental degrees -->
			<div class="flex justify-center gap-2">
				{#each accidentalDegrees as d}
					{#if d.spacerBefore}
						<div class="h-16 w-16"></div>
					{/if}
					<button
						type="button"
						class="flex h-16 w-16 cursor-pointer items-center justify-center rounded-full border border-ctp-surface2 text-2xl text-ctp-crust {d.active
							? d.color
							: 'bg-ctp-mantle  text-ctp-surface2'}"
						on:click={() => {
							d.active = !d.active;
							console.log(d.index);
						}}
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
						class="flex h-16 w-16 cursor-pointer items-center justify-center rounded-full border border-ctp-surface2 text-2xl text-ctp-crust {d.active
							? d.color
							: 'bg-ctp-mantle text-ctp-surface2'}"
						on:click={() => {
							d.active = !d.active;
							console.log(d.color);
						}}
					>
						{d.label}
					</button>
				{/each}
			</div>
		</div>
	</div>
</main>
