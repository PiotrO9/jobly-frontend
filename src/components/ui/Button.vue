<script setup lang="ts">
interface Props {
	variant: 'primary' | 'secondary',
	text: string
	size?: 'small' | 'big'
	link?: string
}

withDefaults(defineProps<Props>(), {
	variant: 'primary',
	text: 'Button',
	size: 'small'
})
</script>

<template>
	<button :class="[variant, size]" class="button">
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
	border-radius: 999px;
	cursor: pointer;
	outline: none;
	border: none;
	font-size: 16px;
	transition: 
		translate 0.3s ease-in-out, 
		background-color 0.3s ease-in-out, 
		border-color 0.3s ease-in-out,
		color 0.3s ease-in-out;
	text-align: center;
	line-height: 1;
	padding: 0;
	margin: 0;
	border-width: 1px;
	border-style: solid;

	&.primary {
		background-color: var(--color-primary);
		border-color: var(--color-primary);
		color: var(--color-background);
		font-weight: 700;
		
		&:hover {
			background-color: var(--color-primary-hover);
			border-color: var(--color-primary-hover);
		}
	}

	&.secondary {
		background-color: var(--color-background);
		border-color: #e4e4ed;
		color: #33334e;
		font-weight: 500;
		
		&:hover {
			background-color: var(--color-primary);
			border-color: var(--color-secondary);
			color: var(--color-background);
		}
	}

	&:hover {
		translate: 0 -3px;
		background-color: var(--color-primary-hover);
	}

	.text {
		display: flex;
		align-items: center;
		justify-content: center;
		border-radius: 999px;
	}

	&.small {
		.text {
			padding: 16px 24px;
		}
	}

	&.big {
		.text {
			padding: 22px 40px;
		}
	}
}
</style>