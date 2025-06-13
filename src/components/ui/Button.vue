<script setup lang="ts">
defineOptions({
    name: 'BaseButton',
});

interface Props {
    variant?:
        | 'primary'
        | 'secondary'
        | 'filter-primary'
        | 'filter-secondary'
        | 'pagination'
        | 'apply'
        | 'submit'
        | 'link-button'
        | 'back-button'
        | 'user-menu-button'
        | 'mobile-menu-toggle'
        | 'mobile-filter-toggle'
        | 'details'
        | 'add-skill'
        | 'remove-skill'
        | 'save'
        | 'logout';
    text?: string;
    size?: 'small' | 'big' | 'medium';
    link?: string;
    active?: boolean;
    disabled?: boolean;
    type?: 'button' | 'submit' | 'reset';
}

withDefaults(defineProps<Props>(), {
    variant: 'primary',
    text: 'Button',
    size: 'small',
    active: false,
    disabled: false,
    type: 'button',
});
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
    display: inline-flex;
    align-items: center;
    justify-content: center;
    gap: 8px;
    padding: 16px 24px;
    border-radius: 6px;
    font-weight: 500;
    font-size: 16px;
    line-height: 1;
    transition: all 0.2s ease-in-out;
    cursor: pointer;
    border: 1px solid transparent;
    white-space: nowrap;
}

.button:disabled {
    opacity: 0.5;
    cursor: not-allowed;
}

/* Primary variant */
.button.primary {
    background-color: var(--color-primary);
    color: white;
    border-color: var(--color-primary);
}

.button.primary:hover:not(:disabled) {
    background-color: var(--color-primary-hover);
    border-color: var(--color-primary-hover);
}

/* Secondary variant */
.button.secondary {
    background-color: var(--color-secondary);
    color: var(--color-text-primary);
    border-color: var(--color-border);
}

.button.secondary:hover:not(:disabled) {
    background-color: var(--color-secondary-hover);
    border-color: var(--color-border);
}

/* Details variant */
.button.details {
    background-color: transparent;
    color: var(--color-text-primary);
    border: 1px solid var(--color-border);
}

.button.details:hover:not(:disabled) {
    background-color: var(--hover-color);
    border-color: var(--color-text-secondary);
}

/* Sizes */
.button.small {
    padding: 10px 16px;
    font-size: 14px;
}

.button.large {
    padding: 22px 40px;
    font-size: 18px;
}

/* Full width */
.button.full-width {
    width: 100%;
}

/* Icon only */
.button.icon-only {
    padding: 16px;
}

.button.icon-only.small {
    padding: 10px;
}

.button.icon-only.large {
    padding: 22px;
}

/* Loading state */
.button.loading {
    position: relative;
    color: transparent;
}

.button.loading::after {
    content: '';
    position: absolute;
    width: 16px;
    height: 16px;
    border: 2px solid;
    border-radius: 50%;
    border-color: currentColor transparent transparent;
    animation: spin 0.8s linear infinite;
}

@keyframes spin {
    to {
        transform: rotate(360deg);
    }
}
</style>
