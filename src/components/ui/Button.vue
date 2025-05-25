<script setup lang="ts">
defineOptions({
	name: 'BaseButton'
})

interface Props {
	variant: 'primary' | 'secondary' | 'filter-primary' | 'filter-secondary' | 'pagination' | 'apply',
	text: string
	size?: 'small' | 'big' | 'medium'
	link?: string
	active?: boolean
	disabled?: boolean
}

withDefaults(defineProps<Props>(), {
	variant: 'primary',
	text: 'Button',
	size: 'small',
	active: false,
	disabled: false
})
</script>

<template>
	<button 
		:class="[variant, size, { active, disabled }]" 
		class="button"
		:disabled="disabled"
		v-bind="$attrs"
	>
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

	/* Filter button variants */
	&.filter-primary {
		background-color: #3b82f6;
		color: #ffffff;
		border: none;
		border-radius: 6px;
		font-weight: 500;
		font-size: 14px;
		
		&:hover {
			background-color: #2563eb;
			translate: none;
		}
		
		&:focus {
			outline: none;
			box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.3);
		}
	}

	&.filter-secondary {
		background-color: #ffffff;
		color: #374151;
		border: 1px solid #d1d5db;
		border-radius: 6px;
		font-weight: 500;
		font-size: 14px;
		
		&:hover {
			background-color: #f9fafb;
			translate: none;
		}
		
		&:focus {
			outline: none;
			box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.3);
		}
	}

	/* Pagination button variant */
	&.pagination {
		background-color: #ffffff;
		color: #374151;
		border: 1px solid #d1d5db;
		border-radius: 6px;
		font-size: 14px;
		font-weight: normal;
		
		&:hover {
			background-color: #f9fafb;
			translate: none;
		}
		
		&:focus {
			outline: none;
			box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.3);
		}
		
		&.active {
			background-color: #3b82f6;
			color: #ffffff;
			border-color: #3b82f6;
		}
	}

	/* Apply button variant */
	&.apply {
		background-color: #2563eb;
		color: #ffffff;
		border: none;
		border-radius: 6px;
		font-size: 14px;
		font-weight: 500;
		
		&:hover {
			background-color: #1d4ed8;
			translate: none;
		}
		
		&:focus {
			outline: none;
			box-shadow: 0 0 0 2px #3b82f6, 0 0 0 4px rgba(59, 130, 246, 0.1);
		}
	}

	&:hover {
		translate: 0 -3px;
		background-color: var(--color-primary-hover);
	}

	/* Override hover translate for specific variants */
	&.filter-primary:hover,
	&.filter-secondary:hover,
	&.pagination:hover,
	&.apply:hover {
		translate: none;
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

	&.medium {
		.text {
			padding: 10px 16px;
		}
		
		&.pagination .text {
			padding: 8px 12px;
		}
		
		&.apply .text {
			padding: 8px 16px;
		}
	}

	&.big {
		.text {
			padding: 22px 40px;
		}
	}

	/* Special styling for filter buttons */
	&.filter-primary,
	&.filter-secondary {
		.text {
			border-radius: 6px;
		}
	}

	/* Special styling for pagination buttons */
	&.pagination {
		.text {
			border-radius: 6px;
		}
	}

	/* Special styling for apply button */
	&.apply {
		.text {
			border-radius: 6px;
		}
	}

	/* Disabled state */
	&.disabled,
	&:disabled {
		opacity: 0.5;
		cursor: not-allowed;
		pointer-events: none;
		
		&:hover {
			translate: none;
		}
	}
}
</style>