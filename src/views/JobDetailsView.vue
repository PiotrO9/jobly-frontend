<template>
	<div class="job-details">
		<div class="job-details-container">
			<Button
				variant="back-button"
				@click="handleGoBack"
				@keydown="handleKeyDown"
				tabindex="0"
				aria-label="Go back to jobs list"
			>
				<svg class="back-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
					<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7" />
				</svg>
				<span>Back to Jobs</span>
			</Button>

			<div v-if="loading" class="loading-state">
				<div class="loading-spinner">
					<svg class="spinning-icon" fill="none" viewBox="0 0 24 24">
						<circle class="spinner-circle-bg" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
						<path class="spinner-path-fg" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
					</svg>
				</div>
				<p class="loading-text">Loading job details...</p>
			</div>

			<div v-else-if="notFound || error" class="error-state">
				<div class="error-icon">
					<svg fill="none" stroke="currentColor" viewBox="0 0 24 24">
						<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-2.5L13.732 4c-.77-.833-1.964-.833-2.732 0L4.082 16.5c-.77.833.192 2.5 1.732 2.5z"></path>
					</svg>
				</div>
				<h3 class="error-title">Job Not Found</h3>
				<p class="error-message">
					{{ notFound ? 'The job you are looking for does not exist.' : 'There was an error loading the job details.' }}
				</p>
				<Button 
					@click="handleGoBack" 
					variant="primary" 
					text="Back to Jobs"
					class="error-back-btn"
				/>
			</div>

			<div v-else-if="job" class="job-card">
				<div class="job-header">
					<div class="job-main-info">
						<h1 class="job-title">{{ job.title }}</h1>
						<div class="company-location">
							<h2 class="company-name">{{ job.company }}</h2>
							<div class="location-info">
								<svg class="location-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
									<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z" />
									<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 11a3 3 0 11-6 0 3 3 0 016 0z" />
								</svg>
								<span>{{ job.location }}</span>
							</div>
						</div>
					</div>
					
					<div class="job-meta">
						<div class="salary-range">
							<span class="salary-label">Salary</span>
							<span class="salary-value">${{ job.salaryMin }}k - ${{ job.salaryMax }}k</span>
						</div>
						<div class="job-tags">
							<span class="job-tag type-tag">{{ job.type }}</span>
							<span class="job-tag experience-tag">{{ job.experience }}</span>
							<span class="job-tag posted-tag">{{ job.postedDays }} days ago</span>
						</div>
					</div>
				</div>

				<div class="job-content">
					<section class="job-section">
						<h3 class="section-title">Job Description</h3>
						<p class="job-description">{{ job.description }}</p>
						<p class="job-description-extended">
							We are looking for a talented {{ job.title.toLowerCase() }} to join our dynamic team. 
							You will be responsible for developing high-quality software solutions, collaborating with 
							cross-functional teams, and contributing to our innovative projects. This is an excellent 
							opportunity to grow your career in a supportive environment.
						</p>
					</section>

					<section class="job-section">
						<h3 class="section-title">Required Skills</h3>
						<div class="skills-container">
							<span 
								v-for="skill in job.skills" 
								:key="skill" 
								class="skill-tag"
							>
								{{ skill }}
							</span>
						</div>
					</section>

					<section class="job-section">
						<h3 class="section-title">Requirements</h3>
						<ul class="requirements-list">
							<li 
								v-for="requirement in job.requirements" 
								:key="requirement" 
								class="requirement-item"
							>
								{{ requirement }}
							</li>
							<template v-if="!job.requirements || job.requirements.length === 0">
								<li class="requirement-item">
									{{ job.experience }} level experience in {{ job.skills[0] || 'relevant technology' }} development
								</li>
								<li class="requirement-item">
									Strong understanding of modern development practices
								</li>
								<li class="requirement-item">
									Experience with collaborative development workflows
								</li>
								<li class="requirement-item">
									Excellent communication and problem-solving skills
								</li>
								<li class="requirement-item">
									Bachelor's degree in Computer Science or related field (preferred)
								</li>
							</template>
						</ul>
					</section>

					<section class="job-section">
						<h3 class="section-title">What We Offer</h3>
						<ul class="benefits-list">
							<li 
								v-for="benefit in job.benefits" 
								:key="benefit" 
								class="benefit-item"
							>
								<svg class="benefit-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
									<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
								</svg>
								<span>{{ benefit }}</span>
							</li>
							<template v-if="!job.benefits || job.benefits.length === 0">
								<li class="benefit-item">
									<svg class="benefit-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
										<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1" />
									</svg>
									<span>Competitive salary and benefits package</span>
								</li>
								<li class="benefit-item">
									<svg class="benefit-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
										<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4" />
									</svg>
									<span>{{ job.remoteAllowed ? 'Remote work flexibility' : 'On-site collaboration' }}</span>
								</li>
								<li class="benefit-item">
									<svg class="benefit-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
										<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.746 0 3.332.477 4.5 1.253v13C19.832 18.477 18.246 18 16.5 18c-1.746 0-3.332.477-4.5 1.253" />
									</svg>
									<span>Professional development opportunities</span>
								</li>
								<li class="benefit-item">
									<svg class="benefit-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
										<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z" />
									</svg>
									<span>Collaborative team environment</span>
								</li>
								<li v-if="job.equity && job.equity > 0" class="benefit-item">
									<svg class="benefit-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
										<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 7h8m0 0v8m0-8l-8 8-4-4-6 6" />
									</svg>
									<span>Equity package ({{ (job.equity * 100).toFixed(3) }}%)</span>
								</li>
							</template>
						</ul>
					</section>
				</div>

				<div class="job-actions">
					<Button
						@click="handleApplyJob"
						@keydown="handleKeyDown"
						tabindex="0"
						aria-label="Apply for this job"
						variant="primary"
						size="medium"
						text="Apply for this Job"
						class="apply-button"
					/>
					<Button
						@click="handleSaveJob"
						@keydown="handleKeyDown"
						tabindex="0"
						aria-label="Save job for later"
						variant="secondary"
						size="medium"
						text="Save Job"
						class="save-button"
					/>
				</div>
			</div>
		</div>
	</div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue';
import { useRouter, useRoute } from 'vue-router';
import Button from '../components/ui/Button.vue';
import { useJobs } from '../composables/useJobs';
import type { Job } from '../types/job';

const router = useRouter();
const route = useRoute();

const { getJobById, loading, error } = useJobs();

const job = ref<Job | null>(null);
const notFound = ref(false);

async function loadJobDetails() {
	const jobId = route.params.id as string;
	
	if (!jobId) {
		notFound.value = true;
		return;
	}
	
	try {
		const result = await getJobById(jobId);
		
		if (result.success && result.data) {
			job.value = result.data;
		} else {
			console.error('Error loading job details:', result.error);
			notFound.value = true;
		}
	} catch (err) {
		console.error('Error loading job details:', err);
		notFound.value = true;
	}
}

function handleGoBack() {
	router.push('/jobs');
}

function handleApplyJob() {
	if (job.value) {
		console.log('Applying for job:', job.value.id);
	}
}

function handleSaveJob() {
	if (job.value) {
		console.log('Saving job:', job.value.id);
	}
}

function handleKeyDown(event: KeyboardEvent) {
	if (event.key === 'Enter' || event.key === ' ') {
		event.preventDefault();
		(event.target as HTMLElement).click();
	}
}

onMounted(() => {
	loadJobDetails();
});
</script>

<style scoped>
.job-details {
	min-height: 100vh;
	background-color: var(--color-background-secondary);
	font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
}

.job-details-container {
	max-width: 64rem;
	margin: 0 auto;
	padding: 2rem 1rem;
}

.job-card {
	background-color: var(--color-background);
	border-radius: 1rem;
	padding: 2rem;
	box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.1), 0 1px 2px 0 rgba(0, 0, 0, 0.06);
	border: 1px solid var(--color-border);
}

.job-header {
	border-bottom: 1px solid var(--color-border);
	padding-bottom: 1.5rem;
	margin-bottom: 2rem;
}

.job-main-info {
	margin-bottom: 1rem;
}

.job-title {
	font-size: 1.875rem;
	font-weight: 700;
	color: var(--color-text-primary);
	margin: 0 0 0.5rem 0;
	line-height: 1.2;
}

.company-location {
	display: flex;
	flex-direction: column;
	gap: 0.5rem;
}

.company-name {
	font-size: 1.25rem;
	font-weight: 600;
	color: var(--color-text-secondary);
	margin: 0;
}

.location-info {
	display: flex;
	align-items: center;
	color: var(--color-text-tertiary);
	font-size: 0.875rem;
}

.location-icon {
	width: 1rem;
	height: 1rem;
	margin-right: 0.25rem;
}

.job-meta {
	display: flex;
	flex-direction: column;
	gap: 1rem;
}

.salary-range {
	display: flex;
	flex-direction: column;
	gap: 0.25rem;
}

.salary-label {
	font-size: 0.75rem;
	font-weight: 500;
	color: var(--color-text-tertiary);
	text-transform: uppercase;
	letter-spacing: 0.05em;
}

.salary-value {
	font-size: 1.125rem;
	font-weight: 600;
	color: var(--color-success-emerald);
}

.job-tags {
	display: flex;
	flex-wrap: wrap;
	gap: 0.5rem;
}

.job-tag {
	padding: 0.375rem 0.75rem;
	border-radius: 9999px;
	font-size: 0.75rem;
	font-weight: 500;
	white-space: nowrap;
}

.type-tag {
	background-color: var(--color-info-bg-light);
	color: var(--color-info-dark);
}

.experience-tag {
	background-color: var(--color-purple-bg);
	color: var(--color-purple);
}

.posted-tag {
	background-color: var(--color-info-bg-sky);
	color: var(--color-info-cyan);
}

.job-content {
	display: flex;
	flex-direction: column;
	gap: 2rem;
}

.job-section {
	display: flex;
	flex-direction: column;
	gap: 1rem;
}

.section-title {
	font-size: 1.125rem;
	font-weight: 600;
	color: var(--color-text-primary);
	margin: 0;
}

.job-description,
.job-description-extended {
	font-size: 0.875rem;
	color: var(--color-text-secondary);
	line-height: 1.6;
	margin: 0;
}

.job-description-extended {
	color: var(--color-text-tertiary);
}

.skills-container {
	display: flex;
	flex-wrap: wrap;
	gap: 0.5rem;
}

.skill-tag {
	padding: 0.5rem 1rem;
	background-color: var(--color-background-secondary);
	border: 1px solid var(--color-border);
	border-radius: 0.5rem;
	font-size: 0.875rem;
	font-weight: 500;
	color: var(--color-text-secondary);
}

.requirements-list,
.benefits-list {
	list-style: none;
	padding: 0;
	margin: 0;
	display: flex;
	flex-direction: column;
	gap: 0.75rem;
}

.requirement-item {
	position: relative;
	padding-left: 1.5rem;
	font-size: 0.875rem;
	color: var(--color-text-secondary);
	line-height: 1.5;
}

.requirement-item::before {
	content: '•';
	position: absolute;
	left: 0;
	color: var(--color-info);
	font-weight: bold;
}

.benefit-item {
	display: flex;
	align-items: flex-start;
	gap: 0.75rem;
	font-size: 0.875rem;
	color: var(--color-text-secondary);
	line-height: 1.5;
}

.benefit-icon {
	width: 1.25rem;
	height: 1.25rem;
	color: var(--color-success-emerald);
	flex-shrink: 0;
	margin-top: 0.125rem;
}

.job-actions {
	display: flex;
	flex-direction: column;
	gap: 1rem;
	margin-top: 2rem;
	padding-top: 2rem;
}

.apply-button,
.save-button {
	width: 100%;
}

/* Loading State */
.loading-state {
	display: flex;
	flex-direction: column;
	align-items: center;
	justify-content: center;
	padding: 4rem 2rem;
	text-align: center;
}

.loading-spinner {
	margin-bottom: 1rem;
}

.spinning-icon {
	width: 3rem;
	height: 3rem;
	color: var(--color-info);
	animation: spin-animation 1s linear infinite;
}

.spinner-circle-bg {
	opacity: 0.2;
}

.spinner-path-fg {
	opacity: 1;
}

@keyframes spin-animation {
	from {
		transform: rotate(0deg);
	}
	to {
		transform: rotate(360deg);
	}
}

.loading-text {
	font-size: 1.125rem;
	color: var(--color-text-tertiary);
	margin: 0;
}

/* Error State */
.error-state {
	display: flex;
	flex-direction: column;
	align-items: center;
	justify-content: center;
	padding: 4rem 2rem;
	text-align: center;
}

.error-icon {
	margin-bottom: 1rem;
}

.error-icon svg {
	width: 4rem;
	height: 4rem;
	color: var(--color-error);
}

.error-title {
	font-size: 1.5rem;
	font-weight: 600;
	color: var(--color-text-primary);
	margin: 0 0 0.5rem 0;
}

.error-message {
	font-size: 1rem;
	color: var(--color-text-tertiary);
	margin: 0 0 2rem 0;
	max-width: 28rem;
}

.error-back-btn {
	width: auto;
}

@media (min-width: 640px) {
	.job-details-container {
		padding: 2.5rem 1.5rem;
	}

	.job-card {
		padding: 2.5rem;
	}

	.job-title {
		font-size: 2.25rem;
	}

	.company-location {
		flex-direction: row;
		align-items: center;
		gap: 1rem;
	}

	.company-name::after {
		content: '•';
		margin: 0 0.75rem;
		color: var(--color-text-disabled);
	}

	.job-meta {
		flex-direction: row;
		justify-content: space-between;
		align-items: flex-end;
	}

	.job-actions {
		flex-direction: row;
		gap: 1rem;
	}

	.apply-button,
	.save-button {
		width: auto;
		flex: 1;
	}
}

@media (min-width: 768px) {
	.job-details-container {
		padding: 3rem 2rem;
	}

	.job-card {
		padding: 3rem;
	}

	.job-header {
		display: flex;
		justify-content: space-between;
		align-items: flex-start;
		gap: 2rem;
	}

	.job-main-info {
		flex: 1;
		margin-bottom: 0;
	}

	.job-meta {
		flex-direction: column;
		align-items: flex-end;
		text-align: right;
		flex-shrink: 0;
	}

	.job-tags {
		justify-content: flex-end;
	}
}

@media (min-width: 1024px) {
	.job-details-container {
		padding: 4rem 2rem;
	}

	.job-card {
		padding: 4rem;
	}

	.job-content {
		gap: 2.5rem;
	}

	.job-actions {
		max-width: 24rem;
		margin-left: auto;
		margin-right: auto;
	}
}
</style> 