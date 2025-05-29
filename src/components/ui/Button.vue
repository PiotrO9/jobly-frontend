<script setup lang="ts">
defineOptions({
	name: 'BaseButton'
})

interface Props {
	variant?: 'primary' | 'secondary' | 'filter-primary' | 'filter-secondary' | 'pagination' | 'apply' | 'submit' | 'link-button' | 'back-button' | 'user-menu-button' | 'mobile-menu-toggle' | 'mobile-filter-toggle' | 'details' | 'add-skill' | 'remove-skill' | 'save' | 'logout',
	text?: string
	size?: 'small' | 'big' | 'medium'
	link?: string
	active?: boolean
	disabled?: boolean
	type?: 'button' | 'submit' | 'reset'
}

withDefaults(defineProps<Props>(), {
	variant: 'primary',
	text: 'Button',
	size: 'small',
	active: false,
	disabled: false,
	type: 'button'
})
</script>

<template>
	<button 
		:class="[variant, size, { active, disabled }]" 
		class="button"
		:disabled="disabled"
		:type="type"
		v-bind="$attrs"
	>
		<a v-if="link" :href="link" class="text">
			<slot>{{ text }}</slot>
		</a>
		<span v-else class="text">
			<slot>{{ text }}</slot>
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
		color 0.15s ease-in-out;
	text-align: center;
	line-height: 1;
	padding: 0;
	margin: 0;
	border-width: 1px;
	border-style: solid;
}

.button:hover {
	translate: 0 -3px;
	background-color: var(--color-primary-hover);
}

.button.primary {
	background-color: var(--color-primary);
	border-color: var(--color-primary);
	color: var(--color-background);
	font-weight: 700;
}

.button.primary:hover {
	background-color: var(--color-primary-hover);
	border-color: var(--color-primary-hover);
}

.button.secondary {
	background-color: var(--color-background);
	border-color: #e4e4ed;
	color: #33334e;
	font-weight: 500;
}

.button.secondary:hover {
	background-color: var(--color-primary);
	border-color: var(--color-secondary);
	color: var(--color-background);
}

.button.filter-primary {
	background-color: var(--color-info);
	color: var(--color-background);
	border: none;
	border-radius: 6px;
	font-weight: 500;
	font-size: 14px;
}

.button.filter-primary:hover {
	background-color: var(--color-primary-dark);
	translate: none;
}

.button.filter-primary:focus {
	outline: none;
	box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.3);
}

.button.filter-secondary {
	background-color: var(--color-background);
	color: var(--color-text-secondary);
	border: 1px solid var(--color-border-light);
	border-radius: 6px;
	font-weight: 500;
	font-size: 14px;
}

.button.filter-secondary:hover {
	background-color: var(--color-background-secondary);
	translate: none;
}

.button.filter-secondary:focus {
	outline: none;
	box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.3);
}

.button.pagination {
	background-color: var(--color-background);
	color: var(--color-text-secondary);
	border: 1px solid var(--color-border-light);
	border-radius: 6px;
	font-size: 14px;
	font-weight: normal;
}

.button.pagination:hover {
	background-color: var(--color-background-secondary);
	translate: none;
}

.button.pagination:focus {
	outline: none;
	box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.3);
}

.button.pagination.active {
	background-color: var(--color-info);
	color: var(--color-background);
	border-color: var(--color-info);
}

.button.apply {
	background-color: var(--color-primary-dark);
	color: var(--color-background);
	border: none;
	border-radius: 6px;
	font-size: 14px;
	font-weight: 500;
}

.button.apply:hover {
	background-color: #1d4ed8;
	translate: none;
}

.button.apply:focus {
	outline: none;
	box-shadow: 0 0 0 2px #3b82f6, 0 0 0 4px rgba(59, 130, 246, 0.1);
}

.button.filter-primary:hover,
.button.filter-secondary:hover,
.button.pagination:hover,
.button.apply:hover {
	translate: none;
}

.button.disabled,
.button:disabled {
	opacity: 0.5;
	cursor: not-allowed;
	pointer-events: none;
}

.button.disabled:hover,
.button:disabled:hover {
	translate: none;
}

.text {
	display: flex;
	align-items: center;
	justify-content: center;
	border-radius: 999px;
	color: inherit;
	text-decoration: none;
}

.button.small .text {
	padding: 16px 24px;
}

.button.medium .text {
	padding: 10px 16px;
}

.button.medium.pagination .text {
	padding: 8px 12px;
}

.button.medium.apply .text {
	padding: 8px 16px;
}

.button.big .text {
	padding: 22px 40px;
}

.button.filter-primary .text,
.button.filter-secondary .text,
.button.pagination .text,
.button.apply .text {
	border-radius: 6px;
}

/* Submit Button */
.button.submit {
	background-color: var(--color-primary);
	color: white;
	border: none;
	padding: 0;
	border-radius: 6px;
	font-size: 16px;
	font-weight: 600;
	cursor: pointer;
	transition: all 0.2s ease;
	margin-top: 0.5rem;
}

.button.submit .text {
	padding: 0.75rem 1rem;
	border-radius: 6px;
}

.button.submit:hover:not(:disabled) {
	background-color: var(--color-primary-hover);
	translate: none;
}

.button.submit:disabled {
	background-color: var(--color-text-quaternary);
	cursor: not-allowed;
}

/* Link Button */
.button.link-button {
	background: none;
	border: none;
	color: var(--color-primary);
	cursor: pointer;
	font-weight: 600;
	text-decoration: underline;
	font-size: inherit;
	padding: 0;
	margin: 0;
}

.button.link-button .text {
	padding: 0;
	border-radius: 0;
}

.button.link-button:hover {
	color: var(--color-primary-hover);
	translate: none;
}

/* Back Button */
.button.back-button {
	display: inline-flex;
	align-items: center;
	gap: 0.5rem;
	background-color: var(--color-background-secondary);
	color: var(--color-text-secondary);
	border: 1px solid var(--color-border);
	border-radius: 6px;
	cursor: pointer;
	transition: all 0.2s ease;
	padding: 0;
	font-size: 14px;
	font-weight: 500;
}

.button.back-button .text {
	padding: 0.5rem 1rem;
	border-radius: 6px;
	display: flex;
	align-items: center;
	gap: 0.5rem;
}

.button.back-button:hover {
	background-color: var(--color-info);
	color: var(--color-background);
	border-color: var(--color-info);
	translate: none;
}

.button.back-button:focus {
	outline: none;
	box-shadow: 0 0 0 2px #3b82f6, 0 0 0 4px rgba(59, 130, 246, 0.1);
}

/* User Menu Button */
.button.user-menu-button {
	display: flex;
	align-items: center;
	gap: 0.75rem;
	background-color: var(--color-background-secondary);
	border: 1px solid var(--color-border);
	border-radius: 8px;
	cursor: pointer;
	transition: all 0.2s ease;
	padding: 0;
	font-size: 14px;
}

.button.user-menu-button .text {
	padding: 0.5rem 1rem;
	border-radius: 8px;
	display: flex;
	align-items: center;
	gap: 0.75rem;
}

.button.user-menu-button:hover {
	background-color: var(--color-background-light);
	border-color: var(--color-border-light);
	translate: none;
}

/* Mobile Menu Toggle */
.button.mobile-menu-toggle {
	display: flex;
	flex-direction: column;
	justify-content: center;
	align-items: center;
	width: 2.5rem;
	height: 2.5rem;
	background: none;
	border: none;
	cursor: pointer;
	gap: 0.25rem;
	padding: 0;
	margin: 0;
}

.button.mobile-menu-toggle .text {
	padding: 0;
	border-radius: 0;
}

.button.mobile-menu-toggle:hover {
	translate: none;
}

/* Mobile Filter Toggle */
.button.mobile-filter-toggle {
	position: fixed;
	top: 1rem;
	left: 1rem;
	z-index: 100;
	display: flex;
	align-items: center;
	gap: 0.5rem;
	background-color: var(--color-info);
	color: var(--color-background);
	border: none;
	border-radius: 0.5rem;
	font-size: 0.875rem;
	font-weight: 500;
	cursor: pointer;
	transition: all 0.2s ease;
	padding: 0;
}

.button.mobile-filter-toggle .text {
	padding: 0.75rem 1rem;
	border-radius: 0.5rem;
	display: flex;
	align-items: center;
	gap: 0.5rem;
}

.button.mobile-filter-toggle:hover {
	background-color: var(--color-primary-dark);
	translate: none;
}

.button.mobile-filter-toggle.toggle-behind {
	z-index: 45;
}

/* Details Button */
.button.details {
	background-color: var(--color-background-secondary);
	color: var(--color-text-secondary);
	font-size: 14px;
	font-weight: 500;
	border: 1px solid var(--color-border-light);
	border-radius: 6px;
	cursor: pointer;
	transition: all 0.2s ease-in-out;
	padding: 0;
}

.button.details .text {
	padding: 8px 16px;
	border-radius: 6px;
}

.button.details:hover {
	background-color: var(--color-primary-dark);
	color: var(--color-background);
	border-color: var(--color-primary-dark);
	translate: none;
}

.button.details:focus {
	outline: none;
	box-shadow: 0 0 0 2px #3b82f6, 0 0 0 4px rgba(59, 130, 246, 0.1);
}

/* Add Skill Button */
.button.add-skill {
	background-color: var(--color-primary);
	color: white;
	border: none;
	border-radius: 6px;
	font-size: 14px;
	font-weight: 500;
	cursor: pointer;
	transition: background-color 0.2s ease;
	padding: 0;
}

.button.add-skill .text {
	padding: 0.5rem 1rem;
	border-radius: 6px;
}

.button.add-skill:hover {
	background-color: var(--color-primary-hover);
	translate: none;
}

/* Remove Skill Button */
.button.remove-skill {
	background: none;
	border: none;
	color: var(--color-info-cyan);
	cursor: pointer;
	font-size: 1.25rem;
	line-height: 1;
	padding: 0;
	width: 1.5rem;
	height: 1.5rem;
	display: flex;
	align-items: center;
	justify-content: center;
	border-radius: 50%;
	transition: background-color 0.2s ease;
}

.button.remove-skill .text {
	padding: 0;
	border-radius: 50%;
	width: 100%;
	height: 100%;
	display: flex;
	align-items: center;
	justify-content: center;
}

.button.remove-skill:hover {
	background-color: rgba(3, 105, 161, 0.1);
	translate: none;
}

/* Save Button */
.button.save {
	background-color: var(--color-primary);
	color: white;
	border: none;
	border-radius: 6px;
	font-size: 16px;
	font-weight: 600;
	cursor: pointer;
	transition: background-color 0.2s ease;
	padding: 0;
}

.button.save .text {
	padding: 0.75rem 2rem;
	border-radius: 6px;
}

.button.save:hover:not(:disabled) {
	background-color: var(--color-primary-hover);
	translate: none;
}

.button.save:disabled {
	background-color: var(--color-text-quaternary);
	cursor: not-allowed;
}

/* Logout Button */
.button.logout {
	background-color: var(--color-error);
	color: var(--color-background);
	border: none;
	border-radius: 6px;
	font-size: 16px;
	font-weight: 600;
	cursor: pointer;
	transition: background-color 0.2s ease;
	padding: 0;
}

.button.logout .text {
	padding: 0.75rem 1.5rem;
	border-radius: 6px;
}

.button.logout:hover {
	background-color: var(--color-error-dark);
	translate: none;
}
</style>