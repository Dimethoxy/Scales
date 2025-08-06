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

	type Degree = {
		index: number;
		label: string;
		row: 'natural' | 'accidental';
		active: boolean;
		spacerBefore?: boolean;
	};

	let degrees: Degree[] = [
		{ index: 0, label: '1', row: 'natural', active: false },
		{ index: 1, label: 'b2', row: 'accidental', active: false },
		{ index: 2, label: '2', row: 'natural', active: false },
		{ index: 3, label: 'b3', row: 'accidental', active: false },
		{ index: 4, label: '3', row: 'natural', active: false },
		{ index: 5, label: '4', row: 'natural', active: false },
		{ index: 6, label: 'b5', row: 'accidental', active: false, spacerBefore: true },
		{ index: 7, label: '5', row: 'natural', active: false },
		{ index: 8, label: 'b6', row: 'accidental', active: false },
		{ index: 9, label: '6', row: 'natural', active: false },
		{ index: 10, label: 'b7', row: 'accidental', active: false },
		{ index: 11, label: '7', row: 'natural', active: false }
	];

	$: naturalDegrees = degrees.filter((d) => d.row === 'natural');
	$: accidentalDegrees = degrees.filter((d) => d.row === 'accidental');

	// Reactive statement - get active scale degrees (semitone intervals from root)
	$: activeScaleDegrees = degrees.filter((d) => d.active).map((d) => d.index);

	// Function to check if a note is in the current scale
	function isNoteInScale(note: Note, scaleRoot: Note, activeIntervals: number[]): boolean {
		const noteIndex = notes.indexOf(note.name);
		const rootIndex = notes.indexOf(scaleRoot.name);
		const intervalFromRoot = (((noteIndex - rootIndex) % 12) + 12) % 12;
		return activeIntervals.includes(intervalFromRoot);
	}

	// Reactive statement - for each string, determine which notes are in scale
	$: stringNotesInScale = instrumentStrings.map((string) =>
		generateStringNotes(string.root).map((note) =>
			isNoteInScale(note, scaleRoot, activeScaleDegrees)
		)
	);

	let numFrets = 24;

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

		// Log after reactive statements have updated
		setTimeout(() => {
			console.log('Added string, current strings:', instrumentStrings);
			console.log('All string notes:', allStringNotes);
			console.log('Scale root:', scaleRoot);
			console.log('Active scale degrees:', activeScaleDegrees);
			console.log('Notes in scale for each string:', stringNotesInScale);
		}, 0);
	}

	function removeString(index: number) {
		instrumentStrings = instrumentStrings.filter((s) => s.index !== index);
		// Reindex remaining strings
		instrumentStrings = instrumentStrings.map((s, i) => ({ ...s, index: i }));
	}

	const buttonClasses =
		'flex h-22 w-22 cursor-pointer items-center justify-center rounded-full bg-ctp-mantle text-4xl';
	const buttonActiveClasses = 'bg-ctp-text text-ctp-crust';
	const buttonInactiveClasses = 'text-ctp-surface2';
	const buttonShadow = 'inset 0 0 5px 3px #00000055;';
	const buttonActiveShadow = '0 0 5px 3px #ffffffaa;';
</script>

<main>
	<div class="my-8">
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
		<div class="my-8 overflow-x-auto">
			<div class="min-w-max">
				<!-- Fret numbers header -->
				<div class="mb-2 flex">
					<!-- Empty space for string tuning column -->
					<div class="w-18"></div>
					<!-- Fret numbers -->
					{#each Array(numFrets + 1) as _, fret}
						<div class="flex w-12 items-center justify-center text-sm text-ctp-subtext0">
							{fret}
						</div>
					{/each}
				</div>

				<!-- Fretboard grid -->
				<div class="rounded border border-ctp-surface0 bg-ctp-base p-2">
					{#each instrumentStrings as string, stringIndex}
						<div class="flex items-center border-b border-ctp-surface0 last:border-b-0">
							<!-- String tuning -->
							<div class="w-16 text-center text-sm font-bold text-ctp-text">
								{string.root.name}{string.root.octave}
							</div>

							<!-- Fret positions -->
							{#each Array(numFrets + 1) as _, fret}
								{@const note = allStringNotes[stringIndex][fret]}
								{@const isInScale = stringNotesInScale[stringIndex][fret]}
								<div class="relative flex h-12 w-12 items-center justify-center">
									<!-- Fret marker (visual fret line) -->
									{#if fret > 0}
										<div class="absolute top-0 left-0 h-full w-px bg-ctp-surface1"></div>
									{/if}

									<!-- String line -->
									<div class="absolute h-px w-full bg-ctp-surface2"></div>

									<!-- Note indicator -->
									{#if note}
										<div
											class="relative z-10 flex h-8 w-8 items-center justify-center rounded-full text-xs font-bold
											{isInScale ? 'bg-ctp-blue text-ctp-crust' : 'bg-ctp-surface0 text-ctp-subtext1'}"
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

		<div class="my-8">
			<!-- Accidental degrees -->
			<div class="flex justify-center gap-3">
				{#each accidentalDegrees as d}
					{#if d.spacerBefore}
						<div class="h-22 w-22"></div>
					{/if}
					<button
						type="button"
						class={buttonClasses +
							(d.active ? ' ' + buttonActiveClasses : ' ' + buttonInactiveClasses)}
						style={d.active ? `box-shadow: ${buttonActiveShadow}` : `box-shadow: ${buttonShadow}`}
						on:click={() => {
							d.active = !d.active;
							console.log(degrees);
						}}
					>
						{d.label}
					</button>
				{/each}
			</div>
			<!-- Natural degrees -->
			<div class="flex justify-center gap-3">
				{#each naturalDegrees as d}
					<button
						type="button"
						class={buttonClasses +
							(d.active ? ' ' + buttonActiveClasses : ' ' + buttonInactiveClasses)}
						style={d.active ? `box-shadow: ${buttonActiveShadow}` : `box-shadow: ${buttonShadow}`}
						on:click={() => {
							d.active = !d.active;
							console.log(degrees);
						}}
					>
						{d.label}
					</button>
				{/each}
			</div>
		</div>
	</div>
</main>
