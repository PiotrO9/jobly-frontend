<template>
	<div class="job-details">
		<div class="job-details-container">
			<button
				class="back-button"
				@click="handleGoBack"
				@keydown="handleKeyDown"
				tabindex="0"
				aria-label="Go back to jobs list"
			>
				<svg class="back-icon" fill="none" stroke="currentColor" viewBox="0 0 24 24">
					<path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7" />
				</svg>
				<span>Back to Jobs</span>
			</button>

			<div class="job-card">
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
							<li class="requirement-item">
								{{ job.experience }} level experience in {{ job.skills[0] }} development
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
						</ul>
					</section>

					<section class="job-section">
						<h3 class="section-title">What We Offer</h3>
						<ul class="benefits-list">
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
								<span>Remote work flexibility</span>
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
						</ul>
					</section>
				</div>

				<div class="job-actions">
					<BaseButton
						@click="handleApplyJob"
						@keydown="handleKeyDown"
						tabindex="0"
						aria-label="Apply for this job"
						variant="primary"
						size="medium"
						text="Apply for this Job"
						class="apply-button"
					/>
					<BaseButton
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
import BaseButton from '../components/ui/Button.vue';
import type { Job } from '../types/job';

const router = useRouter();
const route = useRoute();

// Mock job data - in real app this would come from API or store
const job = ref<Job>({
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
});

function handleGoBack() {
	router.push('/jobs');
}

function handleApplyJob() {
	console.log('Applying for job:', job.value.id);
	// Here you would typically navigate to application form or open modal
}

function handleSaveJob() {
	console.log('Saving job:', job.value.id);
	// Here you would typically save job to user's saved jobs
}

function handleKeyDown(event: KeyboardEvent) {
	if (event.key === 'Enter' || event.key === ' ') {
		event.preventDefault();
		(event.target as HTMLElement).click();
	}
}

onMounted(() => {
	// In real app, fetch job details based on route.params.id
	const jobId = route.params.id;
	console.log('Loading job details for ID:', jobId);
	
	// Mock data loading - replace with actual API call
	// fetchJobDetails(jobId);
});
</script>

<style scoped>
.job-details {
	min-height: 100vh;
	background-color: #f9fafb;
	font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
}

.job-details-container {
	max-width: 64rem;
	margin: 0 auto;
	padding: 2rem 1rem;
}

.back-button {
	display: flex;
	align-items: center;
	margin-bottom: 1.5rem;
	padding: 0.5rem 1rem;
	background-color: white;
	border: 1px solid #d1d5db;
	border-radius: 0.5rem;
	color: #374151;
	cursor: pointer;
	transition: all 0.2s;
	font-size: 0.875rem;
	font-weight: 500;
}

.back-button:hover {
	background-color: #f9fafb;
	border-color: #9ca3af;
}

.back-button:focus {
	outline: none;
	box-shadow: 0 0 0 2px #3b82f6, 0 0 0 4px rgba(59, 130, 246, 0.1);
}

.back-icon {
	width: 1rem;
	height: 1rem;
	margin-right: 0.5rem;
}

.job-card {
	background-color: white;
	border-radius: 1rem;
	padding: 2rem;
	box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.1), 0 1px 2px 0 rgba(0, 0, 0, 0.06);
	border: 1px solid #e5e7eb;
}

.job-header {
	border-bottom: 1px solid #e5e7eb;
	padding-bottom: 1.5rem;
	margin-bottom: 2rem;
}

.job-main-info {
	margin-bottom: 1rem;
}

.job-title {
	font-size: 1.875rem;
	font-weight: 700;
	color: #111827;
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
	color: #374151;
	margin: 0;
}

.location-info {
	display: flex;
	align-items: center;
	color: #6b7280;
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
	color: #6b7280;
	text-transform: uppercase;
	letter-spacing: 0.05em;
}

.salary-value {
	font-size: 1.125rem;
	font-weight: 600;
	color: #059669;
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
	background-color: #dbeafe;
	color: #1e40af;
}

.experience-tag {
	background-color: #f3e8ff;
	color: #7c3aed;
}

.posted-tag {
	background-color: #f0f9ff;
	color: #0369a1;
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
	color: #111827;
	margin: 0;
}

.job-description,
.job-description-extended {
	font-size: 0.875rem;
	color: #374151;
	line-height: 1.6;
	margin: 0;
}

.job-description-extended {
	color: #6b7280;
}

.skills-container {
	display: flex;
	flex-wrap: wrap;
	gap: 0.5rem;
}

.skill-tag {
	padding: 0.5rem 1rem;
	background-color: #f9fafb;
	border: 1px solid #e5e7eb;
	border-radius: 0.5rem;
	font-size: 0.875rem;
	font-weight: 500;
	color: #374151;
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
	color: #374151;
	line-height: 1.5;
}

.requirement-item::before {
	content: '•';
	position: absolute;
	left: 0;
	color: #3b82f6;
	font-weight: bold;
}

.benefit-item {
	display: flex;
	align-items: flex-start;
	gap: 0.75rem;
	font-size: 0.875rem;
	color: #374151;
	line-height: 1.5;
}

.benefit-icon {
	width: 1.25rem;
	height: 1.25rem;
	color: #059669;
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
		color: #d1d5db;
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