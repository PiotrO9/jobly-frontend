<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '@/stores/auth'
import { useApplications } from '@/composables/useApplications'
import Button from '@/components/ui/Button.vue'

const router = useRouter()
const authStore = useAuthStore()
const { applications, fetchUserApplications, applicationsLoading } = useApplications()

const selectedStatus = ref<'all' | 'pending' | 'reviewed' | 'interview' | 'accepted' | 'rejected'>('all')

const userId = computed(() => authStore.userId)

const filteredApplications = computed(() => {
	if (selectedStatus.value === 'all') {
		return applications.value
	}
	return applications.value.filter(app => app.status === selectedStatus.value)
})

const applicationStats = computed(() => ({
	all: applications.value.length,
	pending: applications.value.filter(app => app.status === 'pending').length,
	reviewed: applications.value.filter(app => app.status === 'reviewed').length,
	interview: applications.value.filter(app => app.status === 'interview').length,
	accepted: applications.value.filter(app => app.status === 'accepted').length,
	rejected: applications.value.filter(app => app.status === 'rejected').length
}))

onMounted(async () => {
	if (!authStore.isAuthenticated) {
		router.push('/login')
		return
	}

	if (!userId.value) {
		return
	}

	await fetchUserApplications(userId.value)
})

function handleViewJob(jobId: string) {
	router.push(`/jobs/${jobId}`)
}

function handleApplyToJob() {
	router.push('/jobs')
}

function formatDate(dateString: string): string {
	return new Date(dateString).toLocaleDateString('en-US', {
		year: 'numeric',
		month: 'short',
		day: 'numeric'
	})
}

function getStatusColor(status: string): string {
	const colors: Record<string, string> = {
		pending: 'text-amber-600 bg-amber-50',
		reviewed: 'text-blue-600 bg-blue-50',
		interview: 'text-purple-600 bg-purple-50',
		accepted: 'text-green-600 bg-green-50',
		rejected: 'text-red-600 bg-red-50'
	}
	return colors[status] || 'text-gray-600 bg-gray-50'
}

function formatSalary(min?: number | null, max?: number | null, currency = 'PLN'): string {
	if (!min && !max) return 'Not specified'
	if (min && max) return `${min.toLocaleString()} - ${max.toLocaleString()} ${currency}`
	if (min) return `From ${min.toLocaleString()} ${currency}`
	if (max) return `Up to ${max.toLocaleString()} ${currency}`
	return 'Not specified'
}
</script>

<template>
	<div class="applications-container">
		<div class="applications-wrapper">
			<div class="applications-header">
				<div class="header-content">
					<h1 class="applications-title">My Applications</h1>
					<p class="applications-subtitle">Track your job application status and progress</p>
				</div>
				<Button 
					variant="primary" 
					text="Browse Jobs"
					@click="handleApplyToJob"
				/>
			</div>

			<div class="applications-content">
				<!-- Statistics -->
				<section class="statistics">
					<h2 class="section-title">Application Overview</h2>
					<div class="stats-grid">
						<div class="stat-card">
							<div class="stat-icon all">
								<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
									<path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
									<polyline points="14,2 14,8 20,8"></polyline>
								</svg>
							</div>
							<div class="stat-content">
								<h3 class="stat-number">{{ applicationStats.all }}</h3>
								<p class="stat-label">Total Applications</p>
							</div>
						</div>

						<div class="stat-card">
							<div class="stat-icon pending">
								<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
									<circle cx="12" cy="12" r="10"></circle>
									<polyline points="12,6 12,12 16,14"></polyline>
								</svg>
							</div>
							<div class="stat-content">
								<h3 class="stat-number">{{ applicationStats.pending }}</h3>
								<p class="stat-label">Pending Review</p>
							</div>
						</div>

						<div class="stat-card">
							<div class="stat-icon interview">
								<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
									<path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"></path>
									<circle cx="9" cy="7" r="4"></circle>
									<path d="m22 21-3-3m0 0a6 6 0 0 0 0-12 6 6 0 0 0 0 12z"></path>
								</svg>
							</div>
							<div class="stat-content">
								<h3 class="stat-number">{{ applicationStats.interview }}</h3>
								<p class="stat-label">In Interview</p>
							</div>
						</div>

						<div class="stat-card">
							<div class="stat-icon accepted">
								<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
									<polyline points="20,6 9,17 4,12"></polyline>
								</svg>
							</div>
							<div class="stat-content">
								<h3 class="stat-number">{{ applicationStats.accepted }}</h3>
								<p class="stat-label">Accepted</p>
							</div>
						</div>
					</div>
				</section>

				<!-- Filters -->
				<section class="filters">
					<div class="filter-group">
						<label for="status-filter" class="filter-label">Filter by Status:</label>
						<select id="status-filter" v-model="selectedStatus" class="filter-select">
							<option value="all">All Statuses ({{ applicationStats.all }})</option>
							<option value="pending">Pending ({{ applicationStats.pending }})</option>
							<option value="reviewed">Reviewed ({{ applicationStats.reviewed }})</option>
							<option value="interview">Interview ({{ applicationStats.interview }})</option>
							<option value="accepted">Accepted ({{ applicationStats.accepted }})</option>
							<option value="rejected">Rejected ({{ applicationStats.rejected }})</option>
						</select>
					</div>
				</section>

				<!-- Loading State -->
				<div v-if="applicationsLoading" class="loading-state">
					<div class="loading-spinner"></div>
					<p>Loading your applications...</p>
				</div>

				<!-- Empty State -->
				<div v-else-if="filteredApplications.length === 0" class="empty-state">
					<div class="empty-icon">
						<svg xmlns="http://www.w3.org/2000/svg" width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1" stroke-linecap="round" stroke-linejoin="round">
							<path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
							<polyline points="14,2 14,8 20,8"></polyline>
						</svg>
					</div>
					<h3 class="empty-title">
						{{ selectedStatus === 'all' ? 'No Applications Yet' : `No ${selectedStatus} Applications` }}
					</h3>
					<p class="empty-description">
						{{ selectedStatus === 'all' 
							? 'Start applying to jobs that match your skills and interests.' 
							: `You don't have any ${selectedStatus} applications at the moment.` 
						}}
					</p>
					<Button 
						variant="primary" 
						text="Find Jobs to Apply" 
						@click="handleApplyToJob"
					/>
				</div>

				<!-- Applications List -->
				<div v-else class="applications-list">
					<div v-for="application in filteredApplications" :key="application.id" class="application-card">
						<div class="application-header">
							<div class="job-info">
								<h3 class="job-title">{{ application.job?.title }}</h3>
								<div class="job-meta">
									<span v-if="application.job?.company?.name" class="company-name">
										{{ application.job.company.name }}
									</span>
									<span v-if="application.job?.location" class="job-location">
										{{ application.job.location }}
									</span>
									<span v-if="application.job?.employment_type" class="job-type">
										{{ application.job.employment_type }}
									</span>
								</div>
							</div>
							<div class="application-status">
								<span :class="['status-badge', getStatusColor(application.status)]">
									{{ application.status }}
								</span>
							</div>
						</div>

						<div class="application-details">
							<div class="application-info">
								<div class="info-item">
									<span class="info-label">Applied:</span>
									<span class="info-value">{{ formatDate(application.applied_at) }}</span>
								</div>
								<div v-if="application.job?.salary_min || application.job?.salary_max" class="info-item">
									<span class="info-label">Salary:</span>
									<span class="info-value">
										{{ formatSalary(application.job.salary_min, application.job.salary_max, application.job.currency) }}
									</span>
								</div>
								<div v-if="application.job?.experience_level" class="info-item">
									<span class="info-label">Experience Level:</span>
									<span class="info-value">{{ application.job.experience_level }}</span>
								</div>
							</div>

							<div v-if="application.cover_letter" class="cover-letter">
								<h4 class="cover-letter-title">Your Cover Letter:</h4>
								<p class="cover-letter-text">{{ application.cover_letter }}</p>
							</div>
						</div>

						<div class="application-actions">
							<Button 
								variant="secondary" 
								text="View Job" 
								size="small"
								@click="handleViewJob(application.job_id)"
							/>
							<Button 
								v-if="application.resume_url"
								variant="secondary" 
								text="View Resume" 
								size="small"
								:link="application.resume_url"
								target="_blank"
							/>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</template>

<style scoped>
.applications-container {
	min-height: calc(100vh - var(--header-height, 80px));
	background-color: var(--color-background);
	padding: 2rem 0;
}

.applications-wrapper {
	max-width: 1200px;
	margin: 0 auto;
	padding: 0 1.5rem;
}

.applications-header {
	display: flex;
	justify-content: space-between;
	align-items: flex-start;
	margin-bottom: 3rem;
	gap: 2rem;
}

.header-content h1 {
	font-size: 2.5rem;
	font-weight: 700;
	color: var(--color-text-primary);
	margin-bottom: 0.5rem;
}

.applications-subtitle {
	font-size: 1.125rem;
	color: var(--color-text-secondary);
	margin: 0;
}

.applications-content {
	display: flex;
	flex-direction: column;
	gap: 2rem;
}

.section-title {
	font-size: 1.5rem;
	font-weight: 600;
	color: var(--color-text-primary);
	margin-bottom: 1.5rem;
}

.statistics {
	background: white;
	border-radius: 12px;
	border: 1px solid var(--color-border);
	padding: 2rem;
	box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
}

.stats-grid {
	display: grid;
	grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
	gap: 1.5rem;
}

.stat-card {
	background: var(--color-background);
	border: 1px solid var(--color-border);
	border-radius: 8px;
	padding: 1.5rem;
	display: flex;
	align-items: center;
	gap: 1rem;
}

.stat-icon {
	width: 48px;
	height: 48px;
	border-radius: 8px;
	display: flex;
	align-items: center;
	justify-content: center;
	flex-shrink: 0;
}

.stat-icon.all {
	background: rgba(59, 130, 246, 0.1);
	color: rgb(59, 130, 246);
}

.stat-icon.pending {
	background: rgba(251, 191, 36, 0.1);
	color: rgb(251, 191, 36);
}

.stat-icon.interview {
	background: rgba(147, 51, 234, 0.1);
	color: rgb(147, 51, 234);
}

.stat-icon.accepted {
	background: rgba(34, 197, 94, 0.1);
	color: rgb(34, 197, 94);
}

.stat-content {
	flex: 1;
}

.stat-number {
	font-size: 2rem;
	font-weight: 700;
	color: var(--color-text-primary);
	line-height: 1;
	margin-bottom: 0.25rem;
}

.stat-label {
	font-size: 0.875rem;
	color: var(--color-text-secondary);
	margin: 0;
}

.filters {
	background: white;
	border-radius: 12px;
	border: 1px solid var(--color-border);
	padding: 1.5rem;
}

.filter-group {
	display: flex;
	flex-direction: column;
	gap: 0.5rem;
	max-width: 300px;
}

.filter-label {
	font-weight: 500;
	color: var(--color-text-primary);
	font-size: 0.875rem;
}

.filter-select {
	padding: 0.75rem;
	border: 1px solid var(--color-border);
	border-radius: 6px;
	font-size: 0.875rem;
	background: white;
}

.filter-select:focus {
	outline: none;
	border-color: var(--color-primary);
	box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
}

.loading-state,
.empty-state {
	display: flex;
	flex-direction: column;
	align-items: center;
	justify-content: center;
	padding: 4rem 2rem;
	text-align: center;
	background: white;
	border-radius: 12px;
	border: 1px solid var(--color-border);
}

.loading-spinner {
	width: 32px;
	height: 32px;
	border: 3px solid var(--color-border);
	border-top: 3px solid var(--color-primary);
	border-radius: 50%;
	animation: spin 1s linear infinite;
	margin-bottom: 1rem;
}

@keyframes spin {
	0% { transform: rotate(0deg); }
	100% { transform: rotate(360deg); }
}

.empty-icon {
	color: var(--color-text-secondary);
	margin-bottom: 1.5rem;
}

.empty-title {
	font-size: 1.5rem;
	font-weight: 600;
	color: var(--color-text-primary);
	margin-bottom: 0.5rem;
}

.empty-description {
	color: var(--color-text-secondary);
	margin-bottom: 2rem;
	max-width: 400px;
}

.applications-list {
	display: flex;
	flex-direction: column;
	gap: 1rem;
}

.application-card {
	background: white;
	border: 1px solid var(--color-border);
	border-radius: 12px;
	padding: 1.5rem;
	transition: box-shadow 0.2s;
}

.application-card:hover {
	box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
}

.application-header {
	display: flex;
	justify-content: space-between;
	align-items: flex-start;
	margin-bottom: 1rem;
	gap: 1rem;
}

.job-info {
	flex: 1;
}

.job-title {
	font-size: 1.25rem;
	font-weight: 600;
	color: var(--color-text-primary);
	margin-bottom: 0.5rem;
	line-height: 1.3;
}

.job-meta {
	display: flex;
	gap: 1rem;
	font-size: 0.875rem;
	color: var(--color-text-secondary);
	flex-wrap: wrap;
}

.company-name {
	font-weight: 500;
	color: var(--color-primary);
}

.application-status {
	flex-shrink: 0;
}

.status-badge {
	padding: 0.375rem 0.75rem;
	border-radius: 20px;
	font-size: 0.75rem;
	font-weight: 500;
	text-transform: capitalize;
}

.application-details {
	margin-bottom: 1.5rem;
	display: flex;
	flex-direction: column;
	gap: 1rem;
}

.application-info {
	display: grid;
	grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
	gap: 1rem;
	padding: 1rem;
	background: var(--color-background);
	border-radius: 8px;
}

.info-item {
	display: flex;
	flex-direction: column;
	gap: 0.25rem;
}

.info-label {
	font-size: 0.75rem;
	color: var(--color-text-secondary);
	font-weight: 500;
}

.info-value {
	font-size: 0.875rem;
	color: var(--color-text-primary);
	font-weight: 600;
}

.cover-letter {
	background: var(--color-background);
	padding: 1rem;
	border-radius: 8px;
}

.cover-letter-title {
	font-weight: 600;
	color: var(--color-text-primary);
	margin-bottom: 0.5rem;
	font-size: 0.875rem;
}

.cover-letter-text {
	color: var(--color-text-secondary);
	line-height: 1.6;
	margin: 0;
}

.application-actions {
	display: flex;
	gap: 0.75rem;
	flex-wrap: wrap;
}

@media (max-width: 768px) {
	.applications-wrapper {
		padding: 0 1rem;
	}
	
	.applications-header {
		flex-direction: column;
		gap: 1rem;
	}
	
	.stats-grid {
		grid-template-columns: repeat(2, 1fr);
	}
	
	.application-header {
		flex-direction: column;
		gap: 0.75rem;
	}
	
	.job-meta {
		gap: 0.75rem;
	}
	
	.application-info {
		grid-template-columns: 1fr;
	}
}

@media (max-width: 480px) {
	.stats-grid {
		grid-template-columns: 1fr;
	}
	
	.application-actions {
		flex-direction: column;
	}
}
</style> 