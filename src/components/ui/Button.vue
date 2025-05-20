<script setup lang="ts">
// TODO

interface Props {
	variant: 'primary',
	text: string
	link?: string
}

withDefaults(defineProps<Props>(), {
	variant: 'primary',
	text: 'Button'
})
</script>

<template>
	<button :class="variant" class="button">
		<a v-if="link" :href="link" class="text">
			{{ text }}
		</a>
		<span v-else class="text">
			{{ text }}
		</span>
	</button>
</template>

<style scoped>
.button {
	background-color: var(--color-primary);
	color: white;
	border-radius: 999px;
	cursor: pointer;
	outline: none;
	border: none;
	font-size: 16px;
	font-weight: 700;
	transition: translate 0.3s ease-in-out, background-color 0.3s ease-in-out;
	text-align: center;
	line-height: 1;
	padding: 0;
	margin: 0;

	&:hover {
		translate: 0 -3px;
		background-color: var(--color-primary-hover);
	}

	.text {
		display: flex;
		align-items: center;
		justify-content: center;
		padding: 16px 24px;
		border-radius: 999px;
	}
}
</style>