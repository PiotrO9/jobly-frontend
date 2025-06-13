<script setup lang="ts">
import { ref, onMounted, onUnmounted } from 'vue';

interface Props {
    label: string;
    link?: string;
    hasArrow?: boolean;
}

const props = withDefaults(defineProps<Props>(), {
    label: 'Menu item',
    link: undefined,
    hasArrow: false,
});

const emit = defineEmits(['category-selected']);
const isOpen = ref(false);
const menuItemRef = ref<HTMLLIElement | null>(null);

function toggleDropdown() {
    if (props.hasArrow) {
        isOpen.value = !isOpen.value;
    }
}

function handleClickOutside(event: MouseEvent) {
    if (menuItemRef.value && !menuItemRef.value.contains(event.target as Node)) {
        isOpen.value = false;
    }
}

function handleDropdownClick() {
    isOpen.value = false;
    emit('category-selected');
}

onMounted(() => {
    document.addEventListener('click', handleClickOutside);
});

onUnmounted(() => {
    document.removeEventListener('click', handleClickOutside);
});
</script>

<template>
    <li class="menu-item" ref="menuItemRef">
        <a v-if="link" :href="link" class="menu-item-text">
            {{ label }}
        </a>
        <button v-else class="menu-item-text" @click="toggleDropdown">
            {{ label }}
        </button>

        <button
            v-if="hasArrow"
            class="arrow-button"
            @click="toggleDropdown"
            :class="{ rotated: isOpen }"
        >
            <img src="@/assets/icons/arrow.svg" alt="arrow" />
        </button>

        <div
            class="menu-item-dropdown-content"
            :class="{ 'is-open': isOpen }"
            @click="handleDropdownClick"
        >
            <slot name="content" />
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
    color: var(--color-text-primary);
}

.menu-item-text {
    color: var(--color-text-primary);
    text-decoration: none;
    font-size: 16px;
    font-weight: 500;
    transition: color 0.2s;
    background: none;
    border: none;
    padding: 0;
    cursor: pointer;
}

.arrow-button {
    background: none;
    border: none;
    padding: 0;
    cursor: pointer;
    height: 24px;
    width: 24px;
    display: flex;
    align-items: center;
    justify-content: center;
    transition:
        transform 0.3s ease-in-out,
        color 0.3s ease-in-out;
    color: var(--color-text-primary);
}

.arrow-button img {
    width: 100%;
    height: 100%;
    color: inherit;
    filter: brightness(0) saturate(100%) invert(var(--icon-invert));
}

.menu-item:hover {
    color: var(--color-primary);
    cursor: pointer;
}

.menu-item:hover .menu-item-text {
    color: var(--color-primary);
}

.menu-item:hover .arrow-button {
    color: var(--color-primary);
}

.menu-item:hover .arrow-button img {
    filter: brightness(0) saturate(100%) invert(45%) sepia(99%) saturate(1234%) hue-rotate(176deg)
        brightness(101%) contrast(101%);
}

.arrow-button.rotated {
    transform: rotate(180deg);
}

.menu-item-dropdown-content {
    transition:
        opacity 0.2s ease-in-out,
        transform 0.2s ease-in-out,
        visibility 0.2s ease-in-out;
    opacity: 0;
    transform: translateY(-10px);
    left: 0;
    position: absolute;
    top: 100%;
    visibility: hidden;
    margin-top: 8px;
    z-index: 50;
}

.menu-item-dropdown-content.is-open {
    opacity: 1;
    transform: translateY(0);
    visibility: visible;
}
</style>
