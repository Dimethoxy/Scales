<script lang="ts">
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
					on:click={() => (d.active = !d.active)}
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
					on:click={() => (d.active = !d.active)}
				>
					{d.label}
				</button>
			{/each}
		</div>
	</div>
</main>
