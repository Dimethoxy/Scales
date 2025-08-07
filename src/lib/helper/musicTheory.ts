// Types and helpers for musical notes, tunings, and fretboard logic

export type NoteName = 'C' | 'C#' | 'D' | 'D#' | 'E' | 'F' | 'F#' | 'G' | 'G#' | 'A' | 'A#' | 'B';
export const notes: NoteName[] = ['C', 'C#', 'D', 'D#', 'E', 'F', 'F#', 'G', 'G#', 'A', 'A#', 'B'];

export type Note = {
	name: NoteName;
	octave: number;
};

export function transpose(note: Note, semitones: number): Note {
	const currentIndex = notes.indexOf(note.name);
	const newIndex = (((currentIndex + semitones) % 12) + 12) % 12;
	const octaveChange = Math.floor((currentIndex + semitones) / 12);
	return {
		name: notes[newIndex],
		octave: note.octave + octaveChange
	};
}

export type InstrumentString = {
	index: number;
	root: Note;
};

export function generateStringNotes(root: Note, numFrets = 32): Note[] {
	const stringNotes: Note[] = [];
	for (let i = 0; i < numFrets; i++) {
		stringNotes.push(transpose(root, i));
	}
	return stringNotes;
}
