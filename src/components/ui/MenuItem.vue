<script setup lang="ts">
interface Props {
	label: string
	link: string
	hasArrow?: boolean
}

withDefaults(defineProps<Props>(), {
	label: 'Menu item',
	link: '/',
	hasArrow: false
})
</script>

<template>
	<li class="menu-item">
		<a v-if="link" :href="link" class="menu-item-text">
			{{ label }}
		</a>
		<span v-else class="menu-item-text">
			{{ label }}
		</span>

		<span v-if="hasArrow" class="arrow">
			<img src="@/assets/icons/arrow.svg" alt="arrow">
		</span>

		<div class="menu-item-dropdown-content">
			<slot name="content"/>
		</div>
	</li>
</template>

<style scoped>
.menu-item {
	display: flex;
	align-items: center;
	justify-content: space-between;
	position: relative;
	transition: color 0.3s ease-in-out;

	.arrow {
		height: 24px;
		width: 24px;
		transition: 
			transform 0.3s ease-in-out,
			fill 0.3s ease-in-out;
	}

	&:hover {
		color: var(--color-primary);
		cursor: pointer;

		.arrow {
			transform: rotate(180deg);
			fill: var(--color-primary);
		}

		.menu-item-dropdown-content {
			opacity: 1;
			scale: 1;
			visibility: visible;
		}
	}

	.menu-item-dropdown-content {
		transition: 
			opacity 0.15s ease-in-out,
			scale 0.15s ease-in-out;
		opacity: 0;
		scale: 0.9;
		left: 0;
		position: absolute;
		top: 0px;
		visibility: hidden;
	}
}
</style>