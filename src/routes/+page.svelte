<script lang="ts">
	import { notes, transpose, generateStringNotes } from '../lib/helper/musicTheory';
	import type { NoteName, Note, InstrumentString } from '../lib/helper/musicTheory';

	import scalesDataRaw from '../lib/helper/scales.json';
	import tuningsDataRaw from '../lib/helper/tunings.json';

	import PresetSelector from '../lib/components/PresetSelector.svelte';
	import Fretboard from '../lib/components/Fretboard.svelte';
	import StringControls from '../lib/components/StringControls.svelte';
	import FretControls from '../lib/components/FretControls.svelte';
	import DegreeSelector from '../lib/components/DegreeSelector.svelte';
	import Tooltip from '../lib/components/Tooltip.svelte';

	// Tuning presets
	type TuningPreset = {
		name: string;
		strings: { name: NoteName; octave: number }[];
	};
	const baseTuningsData: TuningPreset[] = tuningsDataRaw.tunings.map((preset: any) => ({
		name: preset.name,
		strings: preset.strings.map((s: any) => ({
			name: s.name as NoteName,
			octave: s.octave
		}))
	}));
	const customTuning: TuningPreset = {
		name: 'Custom',
		strings: []
	};
	const tuningsData: TuningPreset[] = [...baseTuningsData, customTuning];

	let selectedTuningIndex = 0;
	let isCustomTuning = false;

	function setTuning(index: number) {
		selectedTuningIndex = index;
		isCustomTuning = tuningsData[selectedTuningIndex].name === 'Custom';
		const preset = tuningsData[selectedTuningIndex];
		instrumentStrings = preset.strings.map((s, i) => ({ index: i, root: { ...s } }));
	}

	function matchCurrentTuningToPreset() {
		const current = instrumentStrings.map((s) => `${s.root.name}${s.root.octave}`);
		let foundMatch = false;
		for (let i = 0; i < baseTuningsData.length; i++) {
			const preset = baseTuningsData[i];
			const presetStrings = preset.strings.map((s) => `${s.name}${s.octave}`);
			if (
				current.length === presetStrings.length &&
				current.every((val, idx) => val === presetStrings[idx])
			) {
				selectedTuningIndex = i;
				isCustomTuning = false;
				foundMatch = true;
				break;
			}
		}
		if (!foundMatch) {
			selectedTuningIndex = tuningsData.length - 1;
			isCustomTuning = true;
		}
	}

	// Dynamic list of instrument strings
	let instrumentStrings: InstrumentString[] = tuningsData[0].strings.map((s, i) => ({
		index: i,
		root: { ...s }
	}));

	//All string notes recalculate when any root changes
	$: allStringNotes = instrumentStrings.map((string) => generateStringNotes(string.root));

	// Scales and modes loaded from JSON
	let scaleRoot: Note = { name: 'C', octave: 4 };
	type ScalePreset = {
		name: string;
		modes: { name: string; degrees?: number[] }[];
	};
	const baseScalesData: ScalePreset[] = scalesDataRaw.scales;

	// Add 'Custom' scale and mode
	const customScale: ScalePreset = {
		name: 'Custom',
		modes: [{ name: 'Custom' }]
	};
	const scalesData: ScalePreset[] = [...baseScalesData, customScale];

	let selectedScaleIndex = 0;
	let selectedModeIndex = 0;
	let isCustom = false;

	function handleRootChange(e: Event) {
		const selectedName = (e.target as HTMLSelectElement).value as NoteName;
		scaleRoot = { ...scaleRoot, name: selectedName };
	}

	function handleScaleChange(e: Event) {
		selectedScaleIndex = (e.target as HTMLSelectElement).selectedIndex;
		selectedModeIndex = 0;
		isCustom = scalesData[selectedScaleIndex].name === 'Custom';
	}

	function handleModeChange(e: Event) {
		selectedModeIndex = (e.target as HTMLSelectElement).selectedIndex;
		isCustom = scalesData[selectedScaleIndex].name === 'Custom';
	}

	function offsetDegrees(degrees: number[], offset: number): number[] {
		return degrees.map((d) => (d + offset) % 12);
	}

	// Toggle Options
	let onlyShowActiveNotes = false;
	let displayDegrees = false;

	// Reactive statement: update degrees when scale/mode changes, unless 'Custom' is selected
	$: {
		if (!isCustom) {
			const scale = scalesData[selectedScaleIndex];
			const mode = scale.modes[selectedModeIndex];
			const modeDegrees = mode.degrees || [];
			degrees = degrees.map((d) => ({
				...d,
				active: modeDegrees.includes(d.index)
			}));
		}
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
			label: 'R',
			row: 'natural',
			active: true,
			color: 'bg-ctp-text',
			description: 'Root note: Establishes tonal center and stability.'
		},
		{
			index: 1,
			label: 'b2',
			row: 'accidental',
			active: true,
			color: 'bg-ctp-lavender',
			description: 'Minor second: Very dissonant, often used for tension or exotic scales.'
		},
		{
			index: 2,
			label: '2',
			row: 'natural',
			active: true,
			color: 'bg-ctp-blue',
			description: 'Major second: Adds brightness and melodic movement.'
		},
		{
			index: 3,
			label: 'b3',
			row: 'accidental',
			active: true,
			color: 'bg-ctp-sky',
			description: 'Minor third: Gives minor tonality, evokes sadness or introspection.'
		},
		{
			index: 4,
			label: '3',
			row: 'natural',
			active: true,
			color: 'bg-ctp-sapphire',
			description: 'Major third: Defines major tonality, sounds happy and uplifting.'
		},
		{
			index: 5,
			label: '4',
			row: 'natural',
			active: true,
			color: 'bg-ctp-green',
			description: 'Perfect fourth: Neutral, can sound suspended or unresolved.'
		},
		{
			index: 6,
			label: 'b5',
			row: 'accidental',
			active: true,
			color: 'bg-ctp-yellow',
			spacerBefore: true,
			description:
				'Diminished fifth: Also called Tritone, very dissonant, used for tension and drama.'
		},
		{
			index: 7,
			label: '5',
			row: 'natural',
			active: true,
			color: 'bg-ctp-peach',
			description: 'Perfect fifth: Stable and consonant, forms the basis of power chords.'
		},
		{
			index: 8,
			label: 'b6',
			row: 'accidental',
			active: true,
			color: 'bg-ctp-maroon',
			description: 'Minor sixth: Adds melancholy, used in minor and exotic scales.'
		},
		{
			index: 9,
			label: '6',
			row: 'natural',
			active: true,
			color: 'bg-ctp-red',
			description: 'Major sixth: Warm and sweet, common in major and modal scales.'
		},
		{
			index: 10,
			label: 'b7',
			row: 'accidental',
			active: true,
			color: 'bg-ctp-pink',
			description: 'Minor seventh: luesy, jazzy, adds tension and color.'
		},
		{
			index: 11,
			label: '7',
			row: 'natural',
			active: true,
			color: 'bg-ctp-mauve',
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

	// Helper: compare two arrays for equality (order and values)
	function arraysEqual(a: number[], b: number[]): boolean {
		if (a.length !== b.length) return false;
		const sortedA = [...a].sort((x, y) => x - y);
		const sortedB = [...b].sort((x, y) => x - y);
		return sortedA.every((val, i) => val === sortedB[i]);
	}

	// Toggle degree active state and try to match a known scale/mode
	function toggleDegree(index: number) {
		degrees[index].active = !degrees[index].active;
		const currentActive = degrees.filter((d) => d.active).map((d) => d.index);
		let foundMatch = false;
		// Search all scales/modes except Custom
		for (let i = 0; i < baseScalesData.length; i++) {
			const scale = baseScalesData[i];
			for (let j = 0; j < scale.modes.length; j++) {
				const modeDegrees = scale.modes[j].degrees;
				if (modeDegrees && arraysEqual(currentActive, modeDegrees)) {
					selectedScaleIndex = i;
					selectedModeIndex = j;
					isCustom = false;
					foundMatch = true;
					break;
				}
			}
			if (foundMatch) break;
		}
		if (!foundMatch) {
			selectedScaleIndex = scalesData.length - 1;
			selectedModeIndex = 0;
			isCustom = true;
		}
	}

	let numFrets = 16;

	function addString() {
		const newIndex = instrumentStrings.length;
		let newRoot: Note;
		if (instrumentStrings.length === 0) {
			newRoot = { name: 'E', octave: 2 };
		} else {
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
		matchCurrentTuningToPreset();
	}

	function removeString(index: number) {
		instrumentStrings = instrumentStrings.filter((s) => s.index !== index);
		instrumentStrings = instrumentStrings.map((s, i) => ({ ...s, index: i }));
		matchCurrentTuningToPreset();
	}

	function retuneString(stringIndex: number, semitones: number) {
		const root = instrumentStrings[stringIndex].root;
		instrumentStrings[stringIndex].root = transpose(root, semitones);
		instrumentStrings = [...instrumentStrings];
		matchCurrentTuningToPreset();
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
		<PresetSelector
			{tuningsData}
			{selectedTuningIndex}
			{setTuning}
			{notes}
			{scaleRoot}
			{handleRootChange}
			{scalesData}
			{selectedScaleIndex}
			{handleScaleChange}
			{selectedModeIndex}
			{handleModeChange}
			{onlyShowActiveNotes}
			{displayDegrees}
			setOnlyShowActiveNotes={(e: Event) => {
				const target = e.target as HTMLInputElement | null;
				if (target) {
					onlyShowActiveNotes = target.checked;
				}
			}}
			setDisplayDegrees={(e: Event) => (displayDegrees = (e.target as HTMLInputElement).checked)}
		/>

		<Fretboard
			{instrumentStrings}
			{allStringNotes}
			{stringNotesDegrees}
			{notes}
			{scaleRoot}
			{degrees}
			{numFrets}
			{onlyShowActiveNotes}
			{displayDegrees}
			{getDegreeColor}
			{retuneString}
		/>

		<div class="my-4 flex flex-row items-center justify-between px-8">
			<StringControls {instrumentStrings} {addString} {removeString} />
			<DegreeSelector
				{accidentalDegrees}
				{naturalDegrees}
				{toggleDegree}
				{handleDegreeMouseEnter}
				{handleDegreeMouseLeave}
			/>
			<FretControls {numFrets} setNumFrets={(n: number) => (numFrets = n)} />
		</div>

		<Tooltip {showTooltip} {tooltipContent} {tooltipX} {tooltipY} />
	</div>
</main>
