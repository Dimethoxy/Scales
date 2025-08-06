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
		{ index: 0, root: { name: 'E', octave: 2 } },
		{ index: 1, root: { name: 'A', octave: 2 } },
		{ index: 2, root: { name: 'D', octave: 3 } }
	];

	// Reactive statement - all string notes recalculate when any root changes
	$: allStringNotes = instrumentStrings.map((string) => generateStringNotes(string.root));

	function addString() {
		const newIndex = instrumentStrings.length;
		instrumentStrings = [
			...instrumentStrings,
			{
				index: newIndex,
				root: { name: 'E', octave: 2 }
			}
		];
		console.log('Added string, current strings:', instrumentStrings);
		console.log('All string notes:', allStringNotes);
	}

	function removeString(index: number) {
		instrumentStrings = instrumentStrings.filter((s) => s.index !== index);
		// Reindex remaining strings
		instrumentStrings = instrumentStrings.map((s, i) => ({ ...s, index: i }));
	}

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

	const buttonClasses =
		'flex h-22 w-22 cursor-pointer items-center justify-center rounded-full bg-ctp-mantle text-4xl';
	const buttonActiveClasses = 'bg-ctp-text text-ctp-crust';
	const buttonInactiveClasses = 'text-ctp-surface2';
	const buttonShadow = 'inset 0 0 5px 3px #00000055;';
	const buttonActiveShadow = '0 0 5px 3px #ffffffaa;';
</script>

<main>
	<div class="my-8">
		<!-- Debug button -->
		<div class="mb-4 flex justify-center">
			<button
				type="button"
				class="rounded bg-blue-500 px-4 py-2 text-white hover:bg-blue-600"
				on:click={addString}
			>
				Add String (Debug)
			</button>
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
