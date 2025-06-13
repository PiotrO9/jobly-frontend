<template>
    <div class="job-board">
        <Button
            variant="mobile-filter-toggle"
            :class="{ 'toggle-behind': showMobileFilters }"
            @click="handleToggleMobileFilters"
            @keydown="handleKeyDown"
            tabindex="0"
            aria-label="Toggle filters menu"
        >
            <svg class="filter-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M3 4a1 1 0 011-1h16a1 1 0 011 1v2.586a1 1 0 01-.293.707l-6.414 6.414a1 1 0 00-.293.707V17l-4 4v-6.586a1 1 0 00-.293-.707L3.293 7.207A1 1 0 013 6.5V4z"
                />
            </svg>
            <span class="filter-text">Filters</span>
        </Button>

        <div
            v-if="showMobileFilters"
            class="mobile-overlay"
            @click="handleToggleMobileFilters"
        ></div>

        <JobFilters
            :filters="filters"
            :salary-range="SALARY_RANGE"
            :class="[
                'filters-container',
                showMobileFilters ? 'mobile-filters-open' : 'mobile-filters-closed',
            ]"
            @update:filters="handleFiltersUpdate"
            @apply-filters="handleApplyFilters"
            @reset-filters="handleResetFilters"
        />

        <main class="main-content">
            <div class="content-wrapper">
                <div v-if="jobsLoading" class="loading-state">
                    <div class="loading-spinner">
                        <svg class="spinner-icon" fill="none" viewBox="0 0 24 24">
                            <circle
                                class="spinner-circle"
                                cx="12"
                                cy="12"
                                r="10"
                                stroke="currentColor"
                                stroke-width="4"
                            ></circle>
                            <path
                                class="spinner-path"
                                fill="currentColor"
                                d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"
                            ></path>
                        </svg>
                    </div>
                    <p class="loading-text">Loading jobs...</p>
                </div>

                <div v-else-if="jobsError" class="error-state">
                    <div class="error-icon">
                        <svg
                            class="error-icon-svg"
                            fill="none"
                            stroke="currentColor"
                            viewBox="0 0 24 24"
                        >
                            <path
                                stroke-linecap="round"
                                stroke-linejoin="round"
                                stroke-width="2"
                                d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-2.5L13.732 4c-.77-.833-1.964-.833-2.732 0L4.082 16.5c-.77.833.192 2.5 1.732 2.5z"
                            ></path>
                        </svg>
                    </div>
                    <h3 class="error-title">Error loading jobs</h3>
                    <p class="error-message">{{ jobsError }}</p>
                    <Button
                        @click="loadJobs"
                        variant="primary"
                        text="Try Again"
                        class="error-retry-btn"
                    />
                </div>

                <div v-else class="job-list">
                    <JobCard v-for="job in paginatedJobs" :key="job.id" :job="job" />

                    <div v-if="filteredJobs.length === 0" class="no-jobs-placeholder">
                        <h3 class="no-jobs-title">No Jobs Found</h3>
                        <p class="no-jobs-description">
                            We couldn't find any jobs matching your search criteria.
                        </p>
                        <p class="no-jobs-suggestion">
                            Try adjusting your filters or broadening your search criteria.
                        </p>
                        <Button
                            @click="handleResetFilters"
                            @keydown="handleKeyDown"
                            tabindex="0"
                            aria-label="Clear all filters"
                            variant="filter-primary"
                            size="medium"
                            text="Clear Filters"
                            class="no-jobs-btn"
                        />
                    </div>
                </div>
            </div>

            <div class="pagination-wrapper">
                <BasePagination
                    :current-page="currentPage"
                    :total-pages="totalPages"
                    @page-change="handlePageChange"
                    @prev-page="handlePrevPage"
                    @next-page="handleNextPage"
                />
            </div>
        </main>
        <Chat />
    </div>
</template>

<script setup lang="ts">
import { ref, computed, watch, onMounted, onUnmounted } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import JobCard from '../components/JobCard.vue';
import Button from '../components/ui/Button.vue';
import BasePagination from '../components/ui/Pagination.vue';
import JobFilters from '../components/JobFilters.vue';
import Chat from '../components/Chat.vue';
import { useJobs } from '../composables/useJobs';
import type { Filters } from '../types/job';

const route = useRoute();
const router = useRouter();

const SALARY_RANGE = {
    min: 50,
    max: 200,
} as const;

const showMobileFilters = ref(false);

watch(showMobileFilters, (isOpen) => {
    if (isOpen) {
        document.body.classList.add('scroll-locked');
    } else {
        document.body.classList.remove('scroll-locked');
    }
});

function handleEscapeKey(event: KeyboardEvent) {
    if (event.key === 'Escape' && showMobileFilters.value) {
        showMobileFilters.value = false;
    }
}

watch(showMobileFilters, (isOpen) => {
    if (isOpen) {
        document.addEventListener('keydown', handleEscapeKey);
    } else {
        document.removeEventListener('keydown', handleEscapeKey);
    }
});

const {
    jobs: jobsFromDB,
    loading: jobsLoading,
    error: jobsError,
    fetchJobs,
    filterJobs,
    getPaginatedJobs,
    getTotalPages,
} = useJobs();

const filters = ref<Filters>({
    keyword: '',
    location: '',
    types: [],
    experience: '',
    posted: '',
    skills: '',
    salaryMin: SALARY_RANGE.min,
    salaryMax: SALARY_RANGE.max,
    category: '',
});

const currentPage = ref(1);

const filteredJobs = computed(() => {
    if (!jobsFromDB.value.length) return [];
    return filterJobs(filters.value);
});

const totalPages = computed(() => getTotalPages(filteredJobs.value));

const paginatedJobs = computed(() => {
    return getPaginatedJobs(filteredJobs.value, currentPage.value);
});

async function loadJobs() {
    try {
        const result = await fetchJobs();
        if (!result.success) {
            console.error('Error loading jobs:', result.error);
        }
    } catch (error) {
        console.error('Error loading jobs:', error);
    }
}

function handleFiltersUpdate(newFilters: Filters) {
    filters.value = newFilters;
    currentPage.value = 1;
}

function handleApplyFilters() {
    console.log('Applied filters:', filters.value);
    showMobileFilters.value = false;
}

function handleResetFilters() {
    filters.value = {
        keyword: '',
        location: '',
        types: [],
        experience: '',
        posted: '',
        skills: '',
        salaryMin: SALARY_RANGE.min,
        salaryMax: SALARY_RANGE.max,
        category: '',
    };
    currentPage.value = 1;
    showMobileFilters.value = false;

    // Clear URL parameters
    router.push({ path: '/jobs', query: {} });
}

function handlePageChange(page: number) {
    currentPage.value = page;
    console.log('Navigate to page:', page);
}

function handlePrevPage() {
    console.log('Previous page');
}

function handleNextPage() {
    console.log('Next page');
}

function handleToggleMobileFilters() {
    showMobileFilters.value = !showMobileFilters.value;
}

function handleKeyDown(event: KeyboardEvent) {
    if (event.key === 'Enter' || event.key === ' ') {
        event.preventDefault();
        (event.target as HTMLElement).click();
    }
}

// Watch for route changes to handle category filtering
watch(
    () => route.query.category,
    (newCategory) => {
        if (newCategory && typeof newCategory === 'string') {
            filters.value.category = newCategory;
        } else {
            filters.value.category = '';
        }
        currentPage.value = 1;
    },
    { immediate: false },
);

onMounted(async () => {
    // Check for category parameter in URL
    const categoryParam = route.query.category as string;
    if (categoryParam) {
        filters.value.category = categoryParam;
    }

    await loadJobs();
});

onUnmounted(() => {
    document.body.classList.remove('scroll-locked');
    document.removeEventListener('keydown', handleEscapeKey);
});
</script>

<style scoped>
.job-board {
    display: flex;
    flex-direction: column;
    min-height: 100vh;
    background-color: var(--color-background-secondary);
    font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
}

.mobile-filter-toggle {
    display: flex;
    align-items: center;
    position: fixed;
    top: 5rem;
    left: 1rem;
    z-index: 109;
    padding: 0.5rem 1rem;
    background-color: var(--color-background);
    border: 1px solid var(--color-border-light);
    border-radius: 0.5rem;
    box-shadow:
        0 1px 3px 0 rgba(0, 0, 0, 0.1),
        0 1px 2px 0 rgba(0, 0, 0, 0.06);
    color: var(--color-text-secondary);
    cursor: pointer;
    transition: background-color 0.2s;
}

.mobile-filter-toggle:hover {
    background-color: var(--color-background-secondary);
}

.mobile-filter-toggle:focus {
    outline: none;
    box-shadow:
        0 0 0 2px var(--color-info),
        0 0 0 4px rgba(59, 130, 246, 0.1);
}

.mobile-filter-toggle.toggle-behind {
    z-index: 105;
}

.filter-icon {
    width: 1.25rem;
    height: 1.25rem;
}

.filter-text {
    margin-left: 0.5rem;
}

.mobile-overlay {
    position: fixed;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background-color: var(--color-overlay);
    z-index: 111;
}

.filters-container {
    width: 20rem;
    flex-shrink: 0;
}

.mobile-filters-closed {
    display: none;
}

.mobile-filters-open {
    position: fixed;
    top: 0;
    bottom: 0;
    left: 0;
    z-index: 112;
    width: 20rem;
    transform: translateX(0);
    padding-top: 1rem;
}

.main-content {
    flex: 1;
    display: flex;
    flex-direction: column;
    padding: 1rem;
    padding-top: 2rem;
    overflow-y: auto;
    min-height: 0;
}

.content-wrapper {
    flex: 1;
    overflow-y: auto;
}

.pagination-wrapper {
    flex-shrink: 0;
    padding-top: 1.5rem;
    margin-top: auto;
}

.job-list {
    display: flex;
    flex-direction: column;
    gap: 1rem;
}

.no-jobs-placeholder {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    padding: 1.5rem;
    text-align: center;
    background-color: var(--color-background);
    border-radius: 0.75rem;
    border: 1px solid var(--color-border);
}

.no-jobs-icon {
    margin-bottom: 1rem;
    opacity: 0.6;
}

.no-jobs-icon svg {
    width: 3rem;
    height: 3rem;
}

.no-jobs-title {
    font-size: 1.125rem;
    font-weight: 600;
    color: var(--color-text-primary);
    margin: 0 0 0.5rem 0;
}

.no-jobs-description {
    font-size: 0.875rem;
    color: var(--color-text-tertiary);
    margin: 0 0 0.5rem 0;
    max-width: 28rem;
    line-height: 1.5;
}

.no-jobs-suggestion {
    font-size: 0.75rem;
    color: var(--color-text-quaternary);
    margin: 0 0 1.5rem 0;
    max-width: 20rem;
    line-height: 1.4;
}

.no-jobs-btn {
    min-width: 9rem;
}

.loading-state {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    padding: 3rem 1.5rem;
    text-align: center;
    background-color: var(--color-background);
    border-radius: 0.75rem;
    border: 1px solid var(--color-border);
}

.loading-spinner {
    margin-bottom: 1rem;
}

.spinner-icon {
    width: 2rem;
    height: 2rem;
    color: var(--color-info);
    animation: spin 1s linear infinite;
}

.spinner-circle {
    opacity: 0.25;
}

.spinner-path {
    opacity: 0.75;
}

@keyframes spin {
    from {
        transform: rotate(0deg);
    }
    to {
        transform: rotate(360deg);
    }
}

.loading-text {
    color: var(--color-text-tertiary);
    font-size: 0.875rem;
    margin: 0;
}

.error-state {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    padding: 3rem 1.5rem;
    text-align: center;
    background-color: var(--color-background);
    border-radius: 0.75rem;
    border: 1px solid var(--color-border);
}

.error-icon {
    margin-bottom: 1rem;
}

.error-icon-svg {
    width: 2rem;
    height: 2rem;
    color: var(--color-error-light);
}

.error-title {
    font-size: 1.125rem;
    font-weight: 600;
    color: var(--color-text-primary);
    margin: 0 0 0.5rem 0;
}

.error-message {
    color: var(--color-text-tertiary);
    font-size: 0.875rem;
    margin: 0 0 1.5rem 0;
}

.error-retry-btn {
    margin-top: 1rem;
}

@media (max-width: 640px) {
    .mobile-filter-toggle {
        display: flex;
        top: 4.5rem;
    }

    .mobile-overlay {
        display: block;
    }

    .main-content {
        padding: 0.75rem;
        padding-top: 1.5rem;
    }

    .pagination-wrapper {
        padding-top: 1rem;
    }

    .job-list {
        gap: 0.75rem;
    }

    .no-jobs-placeholder {
        padding: 1.5rem;
        margin-left: 0.5rem;
        margin-right: 0.5rem;
    }

    .no-jobs-icon svg {
        width: 3rem;
        height: 3rem;
    }

    .no-jobs-title {
        font-size: 1.125rem;
    }

    .no-jobs-description {
        font-size: 0.875rem;
    }

    .no-jobs-suggestion {
        font-size: 0.75rem;
    }
}

@media (min-width: 641px) and (max-width: 1023px) {
    .mobile-filter-toggle {
        display: flex;
        top: 5.5rem;
    }

    .mobile-overlay {
        display: block;
    }

    .main-content {
        padding: 1.25rem;
        padding-top: 1.5rem;
    }

    .pagination-wrapper {
        padding-top: 1.25rem;
    }

    .no-jobs-icon svg {
        width: 4rem;
        height: 4rem;
    }

    .no-jobs-title {
        font-size: 1.25rem;
    }

    .no-jobs-description {
        font-size: 1rem;
    }

    .no-jobs-suggestion {
        font-size: 0.875rem;
    }
}

@media (min-width: 1024px) {
    .job-board {
        flex-direction: row;
    }

    .mobile-filter-toggle {
        display: none;
    }

    .mobile-overlay {
        display: none;
    }

    .mobile-filters-closed {
        display: block;
    }

    .mobile-filters-open {
        position: relative;
        transform: none;
        z-index: auto;
        padding-top: 0;
    }

    .main-content {
        padding: 2rem;
        padding-top: 1rem;
    }

    .pagination-wrapper {
        padding-top: 2rem;
    }

    .no-jobs-placeholder {
        padding: 3rem 1.5rem;
        grid-column: 1/3;
    }

    .no-jobs-icon svg {
        width: 4rem;
        height: 4rem;
    }

    .no-jobs-title {
        font-size: 1.25rem;
    }

    .no-jobs-description {
        font-size: 1rem;
    }

    .no-jobs-suggestion {
        font-size: 0.875rem;
    }
}

@media (min-width: 1280px) {
    .job-list {
        display: grid;
        grid-template-columns: repeat(2, 1fr);
        gap: 1.5rem;
    }
}

@media (min-width: 1536px) {
    .main-content {
        padding: 2.5rem;
    }

    .job-list {
        gap: 2rem;
    }
}
</style>
