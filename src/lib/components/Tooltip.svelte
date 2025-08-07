<script lang="ts">
	export let showTooltip;
	export let tooltipContent;
	export let tooltipX;
	export let tooltipY;
</script>

{#if showTooltip}
	<div
		class="pointer-events-none fixed z-50 max-w-xs rounded border border-ctp-surface2 bg-ctp-mantle px-3 py-2 text-sm text-ctp-text shadow-lg"
		style="left: {tooltipX}px; top: {tooltipY}px; transform: translateX(-50%) translateY(-100%);"
	>
		{tooltipContent}
	</div>
{/if}
