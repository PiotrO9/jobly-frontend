<template>
	<div class="job-board">
		<!-- Sidebar Filters -->
		<aside class="sidebar">
			<h2 class="sidebar-title">Filtruj oferty</h2>
			
			<div class="filters">
				<div class="filter-group">
					<label class="filter-label">Słowa kluczowe</label>
					<input 
						v-model="filters.keyword" 
						type="text" 
						placeholder="np. Frontend" 
						class="filter-input"
					/>
				</div>
				
				<div class="filter-group">
					<label class="filter-label">Lokalizacja</label>
					<input 
						v-model="filters.location" 
						type="text" 
						placeholder="Miasto lub region" 
						class="filter-input"
					/>
				</div>
				
				<div class="filter-group">
					<p class="filter-label">Typ umowy</p>
					<div class="checkbox-group">
						<label class="checkbox-label">
							<input type="checkbox" value="Full-time" v-model="filters.types" class="checkbox-input" />
							<span class="checkbox-text">Pełny etat</span>
						</label>
						<label class="checkbox-label">
							<input type="checkbox" value="Part-time" v-model="filters.types" class="checkbox-input" />
							<span class="checkbox-text">Część etatu</span>
						</label>
						<label class="checkbox-label">
							<input type="checkbox" value="Contract" v-model="filters.types" class="checkbox-input" />
							<span class="checkbox-text">Umowa zlecenie</span>
						</label>
					</div>
				</div>
				
				<div class="filter-group">
					<label class="filter-label">Poziom doświadczenia</label>
					<select 
						v-model="filters.experience" 
						class="filter-select"
					>
						<option value="">Dowolny</option>
						<option>Junior</option>
						<option>Mid</option>
						<option>Senior</option>
						<option>Lead</option>
					</select>
				</div>
				
				<div class="filter-group">
					<label class="filter-label">Data publikacji</label>
					<select 
						v-model="filters.posted" 
						class="filter-select"
					>
						<option value="">Dowolnie</option>
						<option value="1">Ostatnie 24h</option>
						<option value="7">Ostatnie 7 dni</option>
						<option value="30">Ostatnie 30 dni</option>
					</select>
				</div>
				
				<div class="filter-group">
					<label class="filter-label">Umiejętności</label>
					<input 
						v-model="filters.skills" 
						type="text" 
						placeholder="np. Vue, React" 
						class="filter-input"
					/>
				</div>
				
				<div class="filter-group">
					<label class="filter-label">Wynagrodzenie (PLN)</label>
					<div class="dual-range-container">
						<input 
							type="range" 
							v-model="filters.salaryMin" 
							:min="minSalary" 
							:max="maxSalary" 
							class="filter-range range-min"
							@input="handleSalaryMinChange"
						/>
						<input 
							type="range" 
							v-model="filters.salaryMax" 
							:min="minSalary" 
							:max="maxSalary" 
							class="filter-range range-max"
							@input="handleSalaryMaxChange"
						/>
					</div>
					<div class="range-values">
						<span>{{ minSalary }}k</span>
						<span class="current-values">{{ filters.salaryMin }}k - {{ filters.salaryMax }}k</span>
						<span>{{ maxSalary }}k</span>
					</div>
				</div>
				
				<div class="filter-buttons">
					<button 
						@click="handleApplyFilters" 
						@keydown="handleKeyDown"
						tabindex="0"
						aria-label="Zastosuj filtry"
						class="btn btn-primary"
					>
						Pokaż
					</button>
					<button 
						@click="handleResetFilters" 
						@keydown="handleKeyDown"
						tabindex="0"
						aria-label="Wyczyść filtry"
						class="btn btn-secondary"
					>
						Wyczyść
					</button>
				</div>
			</div>
		</aside>

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
					<h3 class="no-jobs-title">Brak ofert pracy</h3>
					<p class="no-jobs-description">
						Nie znaleźliśmy żadnych ofert pasujących do Twoich kryteriów wyszukiwania.
					</p>
					<p class="no-jobs-suggestion">
						Spróbuj zmienić filtry lub rozszerzyć kryteria wyszukiwania.
					</p>
					<button 
						@click="handleResetFilters"
						@keydown="handleKeyDown"
						tabindex="0"
						aria-label="Wyczyść wszystkie filtry"
						class="btn btn-primary no-jobs-btn"
					>
						Wyczyść filtry
					</button>
				</div>
			</div>
			
			<div class="pagination">
				<button 
					@click="handlePrevPage"
					@keydown="handleKeyDown"
					tabindex="0"
					aria-label="Poprzednia strona"
					class="pagination-btn"
				>
					&laquo;
				</button>
				<button 
					@click="handlePageClick(1)"
					@keydown="handleKeyDown"
					tabindex="0"
					aria-label="Strona 1"
					class="pagination-btn active"
				>
					1
				</button>
				<button 
					@click="handlePageClick(2)"
					@keydown="handleKeyDown"
					tabindex="0"
					aria-label="Strona 2"
					class="pagination-btn"
				>
					2
				</button>
				<button 
					@click="handleNextPage"
					@keydown="handleKeyDown"
					tabindex="0"
					aria-label="Następna strona"
					class="pagination-btn"
				>
					&raquo;
				</button>
			</div>
		</main>
	</div>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue';
import JobCard from '../components/JobCard.vue';
import type { Job, Filters } from '../types/job';

const jobs = ref<Job[]>([
	{ 
		id: 1, 
		title: 'Frontend Developer', 
		company: 'Acme Corp', 
		location: 'Warszawa', 
		postedDays: 2, 
		type: 'Full-time', 
		experience: 'Mid', 
		salaryMin: 100, 
		salaryMax: 140, 
		description: 'Dołącz do zespołu front-end i twórz nowoczesne aplikacje webowe używając najnowszych technologii.', 
		skills: ['Vue', 'JavaScript', 'TypeScript'] 
	},
	{ 
		id: 2, 
		title: 'Backend Engineer', 
		company: 'Tech Solutions', 
		location: 'Kraków', 
		postedDays: 5, 
		type: 'Contract', 
		experience: 'Senior', 
		salaryMin: 120, 
		salaryMax: 160, 
		description: 'Projektowanie i implementacja skalowalnych API oraz systemów backendowych.', 
		skills: ['Node.js', 'Express', 'MongoDB'] 
	},
	{ 
		id: 3, 
		title: 'Full Stack Developer', 
		company: 'StartupXYZ', 
		location: 'Gdańsk', 
		postedDays: 1, 
		type: 'Full-time', 
		experience: 'Junior', 
		salaryMin: 80, 
		salaryMax: 110, 
		description: 'Praca nad kompletnym stosem technologicznym w dynamicznym środowisku startupowym.', 
		skills: ['React', 'Node.js', 'PostgreSQL'] 
	}
]);

const minSalary = 50;
const maxSalary = 200;

const filters = ref<Filters>({ 
	keyword: '', 
	location: '', 
	types: [], 
	experience: '', 
	posted: '', 
	skills: '', 
	salaryMin: minSalary,
	salaryMax: maxSalary 
});

const filteredJobs = computed(() => {
	return jobs.value.filter(job => {
		if (filters.value.keyword && !job.title.toLowerCase().includes(filters.value.keyword.toLowerCase())) {
			return false;
		}
		if (filters.value.location && !job.location.toLowerCase().includes(filters.value.location.toLowerCase())) {
			return false;
		}
		if (filters.value.types.length && !filters.value.types.includes(job.type)) {
			return false;
		}
		if (filters.value.experience && job.experience !== filters.value.experience) {
			return false;
		}
		if (filters.value.posted && job.postedDays > Number(filters.value.posted)) {
			return false;
		}
		if (filters.value.skills) {
			const searchSkills = filters.value.skills.split(',').map(s => s.trim().toLowerCase());
			if (!searchSkills.every(s => job.skills.map(js => js.toLowerCase()).includes(s))) {
				return false;
			}
		}
		if (job.salaryMax < filters.value.salaryMin || job.salaryMin > filters.value.salaryMax) {
			return false;
		}
		return true;
	});
});

function handleApplyFilters() {
	console.log('Zastosowano filtry:', filters.value);
}

function handleResetFilters() {
	filters.value = { 
		keyword: '', 
		location: '', 
		types: [], 
		experience: '', 
		posted: '', 
		skills: '', 
		salaryMin: minSalary,
		salaryMax: maxSalary 
	};
}

function handleSalaryMinChange() {
	if (filters.value.salaryMin > filters.value.salaryMax) {
		filters.value.salaryMax = filters.value.salaryMin;
	}
}

function handleSalaryMaxChange() {
	if (filters.value.salaryMax < filters.value.salaryMin) {
		filters.value.salaryMin = filters.value.salaryMax;
	}
}

function handlePageClick(page: number) {
	console.log('Przejście do strony:', page);
}

function handlePrevPage() {
	console.log('Poprzednia strona');
}

function handleNextPage() {
	console.log('Następna strona');
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

.sidebar {
	width: 25%;
	padding: 20px;
	background-color: #ffffff;
	overflow-y: auto;
	border-right: 1px solid #e5e7eb;
}

.sidebar-title {
	font-size: 20px;
	font-weight: 600;
	margin: 0 0 16px 0;
	color: #111827;
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
	color: #374151;
	margin-bottom: 8px;
}

.filter-input,
.filter-select {
	width: 100%;
	padding: 8px 12px;
	border: 1px solid #d1d5db;
	border-radius: 6px;
	font-size: 14px;
	transition: border-color 0.2s ease-in-out, box-shadow 0.2s ease-in-out;
}

.filter-input:focus,
.filter-select:focus {
	outline: none;
	border-color: #3b82f6;
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
	accent-color: #3b82f6;
}

.checkbox-text {
	font-size: 14px;
	color: #374151;
}

.dual-range-container {
	position: relative;
	height: 8px;
	margin: 8px 0;
}

.filter-range {
	position: absolute;
	width: 100%;
	height: 8px;
	background: transparent;
	border-radius: 4px;
	outline: none;
	cursor: pointer;
	appearance: none;
	pointer-events: none;
}

.filter-range::-webkit-slider-thumb {
	appearance: none;
	width: 20px;
	height: 20px;
	background: #3b82f6;
	border-radius: 50%;
	cursor: pointer;
	pointer-events: all;
	position: relative;
	z-index: 2;
}

.filter-range::-moz-range-thumb {
	width: 20px;
	height: 20px;
	background: #3b82f6;
	border-radius: 50%;
	cursor: pointer;
	border: none;
	pointer-events: all;
	position: relative;
	z-index: 2;
}

.range-min {
	z-index: 1;
}

.range-max {
	z-index: 2;
}

.dual-range-container::before {
	content: '';
	position: absolute;
	top: 0;
	left: 0;
	right: 0;
	height: 8px;
	background: #e5e7eb;
	border-radius: 4px;
	z-index: 0;
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

.btn {
	flex: 1;
	padding: 10px 16px;
	font-size: 14px;
	font-weight: 500;
	border: none;
	border-radius: 6px;
	cursor: pointer;
	transition: all 0.2s ease-in-out;
}

.btn-primary {
	background-color: #3b82f6;
	color: #ffffff;
}

.btn-primary:hover {
	background-color: #2563eb;
}

.btn-primary:focus {
	outline: none;
	box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.3);
}

.btn-secondary {
	background-color: #ffffff;
	color: #374151;
	border: 1px solid #d1d5db;
}

.btn-secondary:hover {
	background-color: #f9fafb;
}

.btn-secondary:focus {
	outline: none;
	box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.3);
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

.pagination {
	display: flex;
	justify-content: center;
	align-items: center;
	gap: 8px;
}

.pagination-btn {
	padding: 8px 12px;
	border: 1px solid #d1d5db;
	background-color: #ffffff;
	border-radius: 6px;
	cursor: pointer;
	font-size: 14px;
	transition: all 0.2s ease-in-out;
}

.pagination-btn:hover {
	background-color: #f9fafb;
}

.pagination-btn:focus {
	outline: none;
	box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.3);
}

.pagination-btn.active {
	background-color: #3b82f6;
	color: #ffffff;
	border-color: #3b82f6;
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
  