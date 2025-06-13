<template>
    <aside class="sidebar">
        <h2 class="sidebar-title">Filter Jobs</h2>

        <div class="filters">
            <div class="filter-group">
                <label class="filter-label">Keywords</label>
                <input
                    v-model="localFilters.keyword"
                    type="text"
                    placeholder="e.g. Frontend"
                    class="filter-input"
                    @input="handleFilterChange"
                />
            </div>

            <div class="filter-group">
                <label class="filter-label">Location</label>
                <input
                    v-model="localFilters.location"
                    type="text"
                    placeholder="City or region"
                    class="filter-input"
                    @input="handleFilterChange"
                />
            </div>

            <div class="filter-group">
                <p class="filter-label">Contract Type</p>
                <div class="checkbox-group">
                    <label class="checkbox-label">
                        <input
                            type="checkbox"
                            value="Full-time"
                            v-model="localFilters.types"
                            class="checkbox-input"
                            @change="handleFilterChange"
                        />
                        <span class="checkbox-text">Full-time</span>
                    </label>
                    <label class="checkbox-label">
                        <input
                            type="checkbox"
                            value="Part-time"
                            v-model="localFilters.types"
                            class="checkbox-input"
                            @change="handleFilterChange"
                        />
                        <span class="checkbox-text">Part-time</span>
                    </label>
                    <label class="checkbox-label">
                        <input
                            type="checkbox"
                            value="Contract"
                            v-model="localFilters.types"
                            class="checkbox-input"
                            @change="handleFilterChange"
                        />
                        <span class="checkbox-text">Contract</span>
                    </label>
                </div>
            </div>

            <div class="filter-group">
                <label class="filter-label">Experience Level</label>
                <select
                    v-model="localFilters.experience"
                    class="filter-select"
                    @change="handleFilterChange"
                >
                    <option value="">Any</option>
                    <option>Junior</option>
                    <option>Mid</option>
                    <option>Senior</option>
                    <option>Lead</option>
                </select>
            </div>

            <div class="filter-group">
                <label class="filter-label">Posted Date</label>
                <select
                    v-model="localFilters.posted"
                    class="filter-select"
                    @change="handleFilterChange"
                >
                    <option value="">Anytime</option>
                    <option value="1">Last 24 hours</option>
                    <option value="7">Last 7 days</option>
                    <option value="30">Last 30 days</option>
                </select>
            </div>

            <div class="filter-group">
                <label class="filter-label">Skills</label>
                <input
                    v-model="localFilters.skills"
                    type="text"
                    placeholder="e.g. Vue, React"
                    class="filter-input"
                    @input="handleFilterChange"
                />
            </div>

            <div class="filter-group">
                <label class="filter-label">Salary (USD)</label>
                <div class="salary-inputs">
                    <div class="salary-input-group">
                        <input
                            type="number"
                            v-model.number="localFilters.salaryMin"
                            :min="salaryRange.min"
                            :max="localFilters.salaryMax"
                            class="salary-input"
                            @input="handleSalaryMinChange"
                            @blur="validateSalaryMin"
                        />
                        <span class="salary-suffix">k</span>
                    </div>
                    <span class="salary-separator">-</span>
                    <div class="salary-input-group">
                        <input
                            type="number"
                            v-model.number="localFilters.salaryMax"
                            :min="localFilters.salaryMin"
                            :max="salaryRange.max"
                            class="salary-input"
                            @input="handleSalaryMaxChange"
                            @blur="validateSalaryMax"
                        />
                        <span class="salary-suffix">k</span>
                    </div>
                </div>
                <div class="range-values">
                    <span>${{ salaryRange.min }}k</span>
                    <span class="current-values">${{ localFilters.salaryMin }}k - ${{ localFilters.salaryMax }}k</span>
                    <span>${{ salaryRange.max }}k</span>
                </div>
            </div>

            <div class="filter-group">
                <label class="filter-label">Category</label>
                <select
                    v-model="localFilters.category"
                    class="filter-select"
                    @change="handleFilterChange"
                >
                    <option value="">Any</option>
                    <option v-for="category in categories" :key="category.id" :value="category.id">
                        {{ category.name }}
                    </option>
                </select>
            </div>

            <div class="filter-buttons">
                <BaseButton
                    @click="handleApplyFilters"
                    @keydown="handleKeyDown"
                    tabindex="0"
                    aria-label="Apply filters"
                    variant="filter-primary"
                    size="medium"
                    text="Show Jobs"
                />
                <BaseButton
                    @click="handleResetFilters"
                    @keydown="handleKeyDown"
                    tabindex="0"
                    aria-label="Clear filters"
                    variant="filter-secondary"
                    size="medium"
                    text="Clear"
                />
            </div>
        </div>
    </aside>
</template>

<script setup lang="ts">
import { ref, watch, onMounted } from 'vue';
import BaseButton from './ui/Button.vue';
import type { Filters } from '../types/job';
import { useJobCategories } from '@/composables/useJobCategories';

interface Props {
    filters: Filters;
    salaryRange: {
        min: number;
        max: number;
    };
}

interface Emits {
    (e: 'update:filters', filters: Filters): void;
    (e: 'apply-filters'): void;
    (e: 'reset-filters'): void;
}

const props = defineProps<Props>();
const emit = defineEmits<Emits>();
const { categories, fetchCategories } = useJobCategories();

const localFilters = ref<Filters>({ ...props.filters });

watch(
    () => props.filters,
    (newFilters) => {
        // Popraw nieprawidłowe wartości zakresu
        if (newFilters.salaryMin > newFilters.salaryMax) {
            newFilters = {
                ...newFilters,
                salaryMin: Math.min(newFilters.salaryMin, newFilters.salaryMax),
                salaryMax: Math.max(newFilters.salaryMin, newFilters.salaryMax),
            };
        }
        localFilters.value = { ...newFilters };
    },
    { deep: true },
);
onMounted(async () => {
    await fetchCategories();
});

function handleFilterChange() {
    emit('update:filters', { ...localFilters.value });
}

function handleSalaryMinChange() {
    const value = Number(localFilters.value.salaryMin);
    if (isNaN(value)) return;

    if (value < props.salaryRange.min) {
        localFilters.value.salaryMin = props.salaryRange.min;
    } else if (value > localFilters.value.salaryMax) {
        localFilters.value.salaryMin = localFilters.value.salaryMax;
    }
    handleFilterChange();
}

function handleSalaryMaxChange() {
    const value = Number(localFilters.value.salaryMax);
    if (isNaN(value)) return;

    if (value > props.salaryRange.max) {
        localFilters.value.salaryMax = props.salaryRange.max;
    } else if (value < localFilters.value.salaryMin) {
        localFilters.value.salaryMax = localFilters.value.salaryMin;
    }
    handleFilterChange();
}

function validateSalaryMin() {
    const value = Number(localFilters.value.salaryMin);
    if (isNaN(value)) {
        localFilters.value.salaryMin = props.salaryRange.min;
    }
    handleFilterChange();
}

function validateSalaryMax() {
    const value = Number(localFilters.value.salaryMax);
    if (isNaN(value)) {
        localFilters.value.salaryMax = props.salaryRange.max;
    }
    handleFilterChange();
}

function handleApplyFilters() {
    emit('apply-filters');
}

function handleResetFilters() {
    emit('reset-filters');
}

function handleKeyDown(event: KeyboardEvent) {
    if (event.key === 'Enter' || event.key === ' ') {
        event.preventDefault();
        (event.target as HTMLElement).click();
    }
}
</script>

<style scoped>
.sidebar {
    width: 25%;
    padding: 20px;
    background-color: var(--color-background);
    overflow-y: auto;
    border-right: 1px solid var(--color-border);
}

.sidebar-title {
    font-size: 20px;
    font-weight: 600;
    margin: 0 0 16px 0;
    color: var(--color-text-primary);
}

.filters {
    display: flex;
    flex-direction: column;
    gap: 24px;
}

.filter-group {
    display: flex;
    flex-direction: column;
}

.filter-label {
    display: block;
    font-size: 14px;
    font-weight: 500;
    color: var(--color-text-secondary);
    margin-bottom: 8px;
}

.filter-input,
.filter-select {
    width: 100%;
    padding: 8px 12px;
    border: 1px solid var(--color-border-light);
    border-radius: 6px;
    font-size: 14px;
    transition:
        border-color 0.2s ease-in-out,
        box-shadow 0.2s ease-in-out;
}

.filter-input:focus,
.filter-select:focus {
    outline: none;
    border-color: var(--color-info);
    box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
}

.checkbox-group {
    display: flex;
    flex-direction: column;
    gap: 8px;
}

.checkbox-label {
    display: flex;
    align-items: center;
    cursor: pointer;
}

.checkbox-input {
    margin-right: 8px;
    accent-color: var(--color-info);
}

.checkbox-text {
    font-size: 14px;
    color: var(--color-text-secondary);
}

.salary-inputs {
    display: flex;
    align-items: center;
    gap: 8px;
    margin: 8px 0;
}

.salary-input-group {
    position: relative;
    flex: 1;
}

.salary-input {
    width: 100%;
    padding: 8px 24px 8px 12px;
    border: 1px solid var(--color-border-light);
    border-radius: 6px;
    font-size: 14px;
    transition: border-color 0.2s ease-in-out, box-shadow 0.2s ease-in-out;
}

.salary-input:focus {
    outline: none;
    border-color: var(--color-info);
    box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
}

.salary-suffix {
    position: absolute;
    right: 12px;
    top: 50%;
    transform: translateY(-50%);
    color: var(--color-text-secondary);
    font-size: 14px;
    pointer-events: none;
}

.salary-separator {
    color: var(--color-text-secondary);
    font-size: 14px;
}

.range-values {
    display: flex;
    justify-content: space-between;
    font-size: 12px;
    color: #6b7280;
    margin-top: 8px;
}

.current-values {
    font-weight: 500;
    color: #3b82f6;
}

.filter-buttons {
    display: flex;
    gap: 12px;
    padding-top: 16px;
}

.filter-buttons .button {
    flex: 1;
}
</style>
