import type { Note } from './musicTheory';

// Simple audio function - customize the sound parameters here
let synth: import('tone').Synth | null = null;
let filter: import('tone').Filter | null = null;
let isInitialized = false;

async function initAudio() {
	// Only initialize on client side (browser)
	if (typeof window === 'undefined') return;

	if (!isInitialized) {
		// Dynamic import to avoid SSR issues
		const Tone = await import('tone');
		await Tone.start();

		// Create a lowpass filter
		filter = new Tone.Filter({
			type: 'lowpass',
			frequency: 2000, // Cutoff frequency in Hz (adjust to taste: 500-5000)
			Q: 1 // Resonance (0.1 - 30, higher = more resonant)
		}).toDestination();

		// Customize your sound here - these are the only settings
		synth = new Tone.Synth({
			oscillator: {
				type: 'sawtooth' // Change to: 'sine', 'square', 'sawtooth', 'triangle'
			},
			envelope: {
				attack: 0.02, // How quickly the sound starts (0.001 - 1)
				decay: 0.5, // How quickly it reaches sustain level (0.01 - 2)
				sustain: 0.5, // Level maintained while "holding" the note (0 - 1)
				release: 1.0 // How quickly the sound fades (0.01 - 3)
			}
		}).connect(filter); // Connect synth to filter instead of destination

		// Set volume (-30 to 0 dB, -8 is a good default)
		synth.volume.value = -8;

		isInitialized = true;
	}
}

// Simple function to play a note
export async function playNote(note: Note) {
	// Only work on client side
	if (typeof window === 'undefined') return;

	if (!synth) {
		await initAudio();
	}

	const noteString = `${note.name}${note.octave}`;
	synth?.triggerAttackRelease(noteString, '8n'); // '8n' = eighth note duration
}
