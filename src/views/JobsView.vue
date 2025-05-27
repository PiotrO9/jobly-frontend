<template>
	<div class="job-board">
		<button
			class="mobile-filter-toggle"
			:class="{ 'toggle-behind': showMobileFilters }"
			@click="handleToggleMobileFilters"
			@keydown="handleKeyDown"
			tabindex="0"
			aria-label="Toggle filters menu"
		>
			<svg class="filter-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
				<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 4a1 1 0 011-1h16a1 1 0 011 1v2.586a1 1 0 01-.293.707l-6.414 6.414a1 1 0 00-.293.707V17l-4 4v-6.586a1 1 0 00-.293-.707L3.293 7.207A1 1 0 013 6.5V4z" />
			</svg>
			<span class="filter-text">Filters</span>
		</button>

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
				showMobileFilters ? 'mobile-filters-open' : 'mobile-filters-closed'
			]"
			@update:filters="handleFiltersUpdate"
			@apply-filters="handleApplyFilters"
			@reset-filters="handleResetFilters"
		/>

		<main class="main-content">
			<div class="content-wrapper">
				<div class="job-list">
					<JobCard v-for="job in paginatedJobs" :key="job.id" :job="job" />
					
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
	</div>
</template>

<script setup lang="ts">
import { ref, computed, watch, onUnmounted } from 'vue';
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

const showMobileFilters = ref(false);

// Watch for mobile filters changes to control body scroll
watch(showMobileFilters, (isOpen) => {
	if (isOpen) {
		document.body.classList.add('scroll-locked');
	} else {
		document.body.classList.remove('scroll-locked');
	}
});

// Handle escape key to close mobile filters
function handleEscapeKey(event: KeyboardEvent) {
	if (event.key === 'Escape' && showMobileFilters.value) {
		showMobileFilters.value = false;
	}
}

// Add/remove escape key listener
watch(showMobileFilters, (isOpen) => {
	if (isOpen) {
		document.addEventListener('keydown', handleEscapeKey);
	} else {
		document.removeEventListener('keydown', handleEscapeKey);
	}
});

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
	},
	{ 
		id: 4, 
		title: 'DevOps Engineer', 
		company: 'CloudTech Inc', 
		location: 'Seattle', 
		postedDays: 3, 
		type: 'Full-time', 
		experience: 'Senior', 
		salaryMin: 130, 
		salaryMax: 170, 
		description: 'Manage cloud infrastructure and automate deployment processes.', 
		skills: ['AWS', 'Docker', 'Kubernetes'] 
	},
	{ 
		id: 5, 
		title: 'UX Designer', 
		company: 'Design Studio', 
		location: 'Los Angeles', 
		postedDays: 4, 
		type: 'Full-time', 
		experience: 'Mid', 
		salaryMin: 90, 
		salaryMax: 120, 
		description: 'Create intuitive user experiences for web and mobile applications.', 
		skills: ['Figma', 'Adobe XD', 'Prototyping'] 
	},
	{ 
		id: 6, 
		title: 'Data Scientist', 
		company: 'Analytics Pro', 
		location: 'Chicago', 
		postedDays: 2, 
		type: 'Contract', 
		experience: 'Senior', 
		salaryMin: 140, 
		salaryMax: 180, 
		description: 'Analyze complex datasets and build predictive models.', 
		skills: ['Python', 'Machine Learning', 'SQL'] 
	},
	{ 
		id: 7, 
		title: 'Mobile Developer', 
		company: 'AppWorks', 
		location: 'Miami', 
		postedDays: 6, 
		type: 'Full-time', 
		experience: 'Mid', 
		salaryMin: 95, 
		salaryMax: 125, 
		description: 'Develop native mobile applications for iOS and Android.', 
		skills: ['React Native', 'Swift', 'Kotlin'] 
	},
	{ 
		id: 8, 
		title: 'Product Manager', 
		company: 'Innovation Labs', 
		location: 'Boston', 
		postedDays: 1, 
		type: 'Full-time', 
		experience: 'Senior', 
		salaryMin: 110, 
		salaryMax: 150, 
		description: 'Lead product strategy and coordinate cross-functional teams.', 
		skills: ['Product Strategy', 'Agile', 'Data Analysis'] 
	},
	{ 
		id: 9, 
		title: 'QA Engineer', 
		company: 'Quality First', 
		location: 'Denver', 
		postedDays: 7, 
		type: 'Full-time', 
		experience: 'Junior', 
		salaryMin: 70, 
		salaryMax: 95, 
		description: 'Ensure software quality through comprehensive testing.', 
		skills: ['Selenium', 'Jest', 'Cypress'] 
	},
	{ 
		id: 10, 
		title: 'Security Engineer', 
		company: 'SecureNet', 
		location: 'Washington DC', 
		postedDays: 3, 
		type: 'Full-time', 
		experience: 'Senior', 
		salaryMin: 135, 
		salaryMax: 175, 
		description: 'Implement security measures and conduct vulnerability assessments.', 
		skills: ['Cybersecurity', 'Penetration Testing', 'CISSP'] 
	},
	{ 
		id: 11, 
		title: 'UI Developer', 
		company: 'Creative Agency', 
		location: 'Portland', 
		postedDays: 2, 
		type: 'Contract', 
		experience: 'Mid', 
		salaryMin: 85, 
		salaryMax: 115, 
		description: 'Build responsive user interfaces with modern frameworks.', 
		skills: ['HTML', 'CSS', 'JavaScript'] 
	},
	{ 
		id: 12, 
		title: 'Machine Learning Engineer', 
		company: 'AI Innovations', 
		location: 'San Francisco', 
		postedDays: 4, 
		type: 'Full-time', 
		experience: 'Senior', 
		salaryMin: 150, 
		salaryMax: 190, 
		description: 'Deploy machine learning models in production environments.', 
		skills: ['TensorFlow', 'PyTorch', 'MLOps'] 
	},
	{ 
		id: 13, 
		title: 'Database Administrator', 
		company: 'DataCorp', 
		location: 'Phoenix', 
		postedDays: 5, 
		type: 'Full-time', 
		experience: 'Mid', 
		salaryMin: 90, 
		salaryMax: 120, 
		description: 'Manage and optimize database performance and security.', 
		skills: ['MySQL', 'PostgreSQL', 'Oracle'] 
	},
	{ 
		id: 14, 
		title: 'Software Architect', 
		company: 'Enterprise Solutions', 
		location: 'Dallas', 
		postedDays: 1, 
		type: 'Full-time', 
		experience: 'Senior', 
		salaryMin: 140, 
		salaryMax: 180, 
		description: 'Design scalable software architecture for enterprise applications.', 
		skills: ['System Design', 'Microservices', 'Cloud Architecture'] 
	},
	{ 
		id: 15, 
		title: 'Frontend Intern', 
		company: 'Tech Startup', 
		location: 'San Francisco', 
		postedDays: 3, 
		type: 'Internship', 
		experience: 'Junior', 
		salaryMin: 50, 
		salaryMax: 70, 
		description: 'Learn frontend development in a fast-paced startup environment.', 
		skills: ['HTML', 'CSS', 'React'] 
	},
	{ 
		id: 16, 
		title: 'Systems Engineer', 
		company: 'Infrastructure Co', 
		location: 'Atlanta', 
		postedDays: 6, 
		type: 'Full-time', 
		experience: 'Mid', 
		salaryMin: 100, 
		salaryMax: 130, 
		description: 'Maintain and optimize system infrastructure and networks.', 
		skills: ['Linux', 'Networking', 'Scripting'] 
	},
	{ 
		id: 17, 
		title: 'Technical Writer', 
		company: 'Documentation Inc', 
		location: 'Remote', 
		postedDays: 4, 
		type: 'Contract', 
		experience: 'Mid', 
		salaryMin: 75, 
		salaryMax: 100, 
		description: 'Create technical documentation and user guides.', 
		skills: ['Technical Writing', 'Markdown', 'API Documentation'] 
	},
	{ 
		id: 18, 
		title: 'Game Developer', 
		company: 'Gaming Studio', 
		location: 'Los Angeles', 
		postedDays: 2, 
		type: 'Full-time', 
		experience: 'Mid', 
		salaryMin: 95, 
		salaryMax: 125, 
		description: 'Develop engaging games for multiple platforms.', 
		skills: ['Unity', 'C#', 'Game Design'] 
	},
	{ 
		id: 19, 
		title: 'Blockchain Developer', 
		company: 'CryptoTech', 
		location: 'New York', 
		postedDays: 1, 
		type: 'Full-time', 
		experience: 'Senior', 
		salaryMin: 130, 
		salaryMax: 170, 
		description: 'Build decentralized applications and smart contracts.', 
		skills: ['Solidity', 'Web3', 'Ethereum'] 
	},
	{ 
		id: 20, 
		title: 'Site Reliability Engineer', 
		company: 'Scale Systems', 
		location: 'Seattle', 
		postedDays: 5, 
		type: 'Full-time', 
		experience: 'Senior', 
		salaryMin: 125, 
		salaryMax: 165, 
		description: 'Ensure system reliability and performance at scale.', 
		skills: ['Monitoring', 'Automation', 'Incident Response'] 
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

const paginatedJobs = computed(() => {
	const start = (currentPage.value - 1) * ITEMS_PER_PAGE;
	const end = start + ITEMS_PER_PAGE;
	return filteredJobs.value.slice(start, end);
});

function handleFiltersUpdate(newFilters: Filters) {
	filters.value = newFilters;
	currentPage.value = 1;
}

function handleApplyFilters() {
	console.log('Applied filters:', filters.value);
	showMobileFilters.value = false; // Close mobile filters after applying
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
	showMobileFilters.value = false;
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

// Cleanup scroll lock and event listeners when component unmounts
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
	background-color: #f9fafb;
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
	background-color: white;
	border: 1px solid #d1d5db;
	border-radius: 0.5rem;
	box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.1), 0 1px 2px 0 rgba(0, 0, 0, 0.06);
	color: #374151;
	cursor: pointer;
	transition: background-color 0.2s;
}

.mobile-filter-toggle:hover {
	background-color: #f9fafb;
}

.mobile-filter-toggle:focus {
	outline: none;
	box-shadow: 0 0 0 2px #3b82f6, 0 0 0 4px rgba(59, 130, 246, 0.1);
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
	background-color: rgba(0, 0, 0, 0.5);
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
	padding-top: 6rem;
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
	background-color: white;
	border-radius: 0.75rem;
	border: 1px solid #e5e7eb;
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
	color: #111827;
	margin: 0 0 0.5rem 0;
}

.no-jobs-description {
	font-size: 0.875rem;
	color: #6b7280;
	margin: 0 0 0.5rem 0;
	max-width: 28rem;
	line-height: 1.5;
}

.no-jobs-suggestion {
	font-size: 0.75rem;
	color: #9ca3af;
	margin: 0 0 1.5rem 0;
	max-width: 20rem;
	line-height: 1.4;
}

.no-jobs-btn {
	min-width: 9rem;
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
		padding-top: 3.5rem;
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
		padding-top: 6.5rem;
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
		padding-top: 2rem;
	}

	.pagination-wrapper {
		padding-top: 2rem;
	}

	.no-jobs-placeholder {
		padding: 3rem 1.5rem;
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
  