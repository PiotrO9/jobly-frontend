<template>
	<div class="job-board">
		<JobFilters 
			:filters="filters"
			:salary-range="SALARY_RANGE"
			@update:filters="handleFiltersUpdate"
			@apply-filters="handleApplyFilters"
			@reset-filters="handleResetFilters"
		/>

		<!-- Job List -->
		<main class="main-content">
			<div class="job-list">
				<JobCard v-for="job in filteredJobs" :key="job.id" :job="job" />
				
				<!-- Placeholder when no jobs found -->
				<div v-if="filteredJobs.length === 0" class="no-jobs-placeholder">
					<div class="no-jobs-icon">
						<svg width="64" height="64" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
							<path d="M20 6H16V4C16 2.89 15.11 2 14 2H10C8.89 2 8 2.89 8 4V6H4C3.45 6 3 6.45 3 7S3.45 8 4 8H5V19C5 20.1 5.9 21 7 21H17C18.1 21 19 20.1 19 19V8H20C20.55 8 21 7.55 21 7S20.55 6 20 6ZM10 4H14V6H10V4Z" fill="#9CA3AF"/>
						</svg>
					</div>
					<h3 class="no-jobs-title">No Jobs Found</h3>
					<p class="no-jobs-description">
						We couldn't find any jobs matching your search criteria.
					</p>
					<p class="no-jobs-suggestion">
						Try adjusting your filters or broadening your search criteria.
					</p>
					<BaseButton 
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
			
			<BasePagination 
				:current-page="currentPage"
				:total-pages="totalPages"
				@page-change="handlePageChange"
				@prev-page="handlePrevPage"
				@next-page="handleNextPage"
			/>
		</main>
	</div>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue';
import JobCard from '../components/JobCard.vue';
import BaseButton from '../components/ui/Button.vue';
import BasePagination from '../components/ui/Pagination.vue';
import JobFilters from '../components/JobFilters.vue';
import type { Job, Filters } from '../types/job';

const SALARY_RANGE = {
	min: 50,
	max: 200
} as const;

const ITEMS_PER_PAGE = 10;

const jobs = ref<Job[]>([
	{ 
		id: 1, 
		title: 'Frontend Developer', 
		company: 'Acme Corp', 
		location: 'New York', 
		postedDays: 2, 
		type: 'Full-time', 
		experience: 'Mid', 
		salaryMin: 100, 
		salaryMax: 140, 
		description: 'Join our front-end team and build modern web applications using the latest technologies.', 
		skills: ['Vue', 'JavaScript', 'TypeScript'] 
	},
	{ 
		id: 2, 
		title: 'Backend Engineer', 
		company: 'Tech Solutions', 
		location: 'San Francisco', 
		postedDays: 5, 
		type: 'Contract', 
		experience: 'Senior', 
		salaryMin: 120, 
		salaryMax: 160, 
		description: 'Design and implement scalable APIs and backend systems.', 
		skills: ['Node.js', 'Express', 'MongoDB'] 
	},
	{ 
		id: 3, 
		title: 'Full Stack Developer', 
		company: 'StartupXYZ', 
		location: 'Austin', 
		postedDays: 1, 
		type: 'Full-time', 
		experience: 'Junior', 
		salaryMin: 80, 
		salaryMax: 110, 
		description: 'Work on the complete technology stack in a dynamic startup environment.', 
		skills: ['React', 'Node.js', 'PostgreSQL'] 
	}
]);

const filters = ref<Filters>({ 
	keyword: '', 
	location: '', 
	types: [], 
	experience: '', 
	posted: '', 
	skills: '', 
	salaryMin: SALARY_RANGE.min,
	salaryMax: SALARY_RANGE.max 
});

const currentPage = ref(1);

const filteredJobs = computed(() => {
	return jobs.value.filter(job => {
		const matchesKeyword = !filters.value.keyword || 
			job.title.toLowerCase().includes(filters.value.keyword.toLowerCase());
		
		const matchesLocation = !filters.value.location || 
			job.location.toLowerCase().includes(filters.value.location.toLowerCase());
		
		const matchesType = !filters.value.types.length || 
			filters.value.types.includes(job.type);
		
		const matchesExperience = !filters.value.experience || 
			job.experience === filters.value.experience;
		
		const matchesPosted = !filters.value.posted || 
			job.postedDays <= Number(filters.value.posted);
		
		const matchesSkills = !filters.value.skills || 
			filters.value.skills.split(',')
				.map(s => s.trim().toLowerCase())
				.every(s => job.skills.map(js => js.toLowerCase()).includes(s));
		
		const matchesSalary = job.salaryMax >= filters.value.salaryMin && 
			job.salaryMin <= filters.value.salaryMax;
		
		return matchesKeyword && matchesLocation && matchesType && 
			matchesExperience && matchesPosted && matchesSkills && matchesSalary;
	});
});

const totalPages = computed(() => Math.ceil(filteredJobs.value.length / ITEMS_PER_PAGE));

function handleFiltersUpdate(newFilters: Filters) {
	filters.value = newFilters;
	currentPage.value = 1;
}

function handleApplyFilters() {
	console.log('Applied filters:', filters.value);
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
		salaryMax: SALARY_RANGE.max 
	};
	currentPage.value = 1;
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

function handleKeyDown(event: KeyboardEvent) {
	if (event.key === 'Enter' || event.key === ' ') {
		event.preventDefault();
		(event.target as HTMLElement).click();
	}
}
</script>

<style scoped>
.job-board {
	display: flex;
	height: 100vh;
	background-color: #f9fafb;
	font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
}

.main-content {
	flex: 1;
	padding: 20px;
	overflow-y: auto;
}

.job-list {
	display: flex;
	flex-direction: column;
	gap: 16px;
	margin-bottom: 24px;
}

.no-jobs-placeholder {
	display: flex;
	flex-direction: column;
	align-items: center;
	justify-content: center;
	padding: 48px 24px;
	text-align: center;
	background-color: #ffffff;
	border-radius: 12px;
	border: 1px solid #e5e7eb;
	margin-top: 24px;
}

.no-jobs-icon {
	margin-bottom: 16px;
	opacity: 0.6;
}

.no-jobs-title {
	font-size: 20px;
	font-weight: 600;
	color: #111827;
	margin: 0 0 8px 0;
}

.no-jobs-description {
	font-size: 16px;
	color: #6b7280;
	margin: 0 0 8px 0;
	max-width: 400px;
	line-height: 1.5;
}

.no-jobs-suggestion {
	font-size: 14px;
	color: #9ca3af;
	margin: 0 0 24px 0;
	max-width: 350px;
	line-height: 1.4;
}

.no-jobs-btn {
	min-width: 140px;
}
</style>
  