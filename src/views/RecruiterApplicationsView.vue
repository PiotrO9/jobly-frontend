<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '@/stores/auth'
import { useApplications } from '@/composables/useApplications'
import { useJobManagement } from '@/composables/useJobManagement'
import Button from '@/components/ui/Button.vue'

const router = useRouter()
const authStore = useAuthStore()
const { applications, fetchCompanyApplications, updateApplicationStatus, applicationsLoading } = useApplications()
const { jobs, fetchCompanyJobs } = useJobManagement()

const selectedStatus = ref<'all' | 'pending' | 'reviewed' | 'interview' | 'accepted' | 'rejected'>('all')
const selectedJob = ref<string>('all')
const statusUpdateLoading = ref<string | null>(null)

const userCompanyId = computed(() => authStore.userCompanyId)
const isRecruiter = computed(() => authStore.isRecruiter)

const filteredApplications = computed(() => {
	let filtered = applications.value

	if (selectedStatus.value !== 'all') {
		filtered = filtered.filter(app => app.status === selectedStatus.value)
	}

	if (selectedJob.value !== 'all') {
		filtered = filtered.filter(app => app.job_id === selectedJob.value)
	}

	return filtered.sort((a, b) => new Date(b.applied_at).getTime() - new Date(a.applied_at).getTime())
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
	if (!authStore.isAuthenticated || !isRecruiter.value) {
		router.push('/')
		return
	}

	if (!userCompanyId.value) {
		return
	}

	try {
		await Promise.all([
			fetchCompanyApplications(userCompanyId.value),
			fetchCompanyJobs(userCompanyId.value)
		])
	} catch (error) {
		console.error('Error loading applications:', error)
	}
})

async function handleUpdateStatus(
	applicationId: string, 
	status: 'pending' | 'reviewed' | 'interview' | 'accepted' | 'rejected'
) {
	try {
		statusUpdateLoading.value = applicationId
		const result = await updateApplicationStatus(applicationId, status)
		
		if (result.success) {
			// Application status updated successfully
		}
	} catch (error) {
		console.error('Failed to update application status:', error)
	} finally {
		statusUpdateLoading.value = null
	}
}

function handleViewJob(jobId: string) {
	router.push(`/jobs/${jobId}`)
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
</script>

<template>
	<div class="applications-container">
		<div class="applications-wrapper">
			<div class="applications-header">
				<div class="header-content">
					<h1 class="applications-title">Application Management</h1>
					<p class="applications-subtitle">Review and manage candidate applications</p>
				</div>
			</div>

			<div v-if="!userCompanyId" class="no-company-message">
				<div class="message-card">
					<div class="message-icon">
						<svg xmlns="http://www.w3.org/2000/svg" width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round">
							<path d="M12 9v4m0 4h.01M21 12a9 9 0 1 1-18 0 9 9 0 0 1 18 0Z"/>
						</svg>
					</div>
					<h2 class="message-title">Company Association Required</h2>
					<p class="message-description">
						You need to be associated with a company to view applications.
					</p>
					<Button 
						variant="primary" 
						text="Update Profile" 
						link="/account/settings"
					/>
				</div>
			</div>

			<div v-else class="applications-content">
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
					<div class="filters-row">
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

						<div class="filter-group">
							<label for="job-filter" class="filter-label">Filter by Job:</label>
							<select id="job-filter" v-model="selectedJob" class="filter-select">
								<option value="all">All Jobs</option>
								<option v-for="job in jobs" :key="job.id" :value="job.id">
									{{ job.title }}
								</option>
							</select>
						</div>
					</div>
				</section>

				<!-- Loading State -->
				<div v-if="applicationsLoading" class="loading-state">
					<div class="loading-spinner"></div>
					<p>Loading applications...</p>
				</div>

				<!-- Empty State -->
				<div v-else-if="filteredApplications.length === 0" class="empty-state">
					<div class="empty-icon">
						<svg xmlns="http://www.w3.org/2000/svg" width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1" stroke-linecap="round" stroke-linejoin="round">
							<path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
							<polyline points="14,2 14,8 20,8"></polyline>
						</svg>
					</div>
					<h3 class="empty-title">No Applications Found</h3>
					<p class="empty-description">
						{{ selectedStatus === 'all' && selectedJob === 'all'
							? 'No applications have been submitted yet.' 
							: 'No applications match your current filters.' 
						}}
					</p>
					<Button 
						variant="primary" 
						text="Post a Job" 
						link="/post-job"
					/>
				</div>

				<!-- Applications List -->
				<div v-else class="applications-list">
					<div v-for="application in filteredApplications" :key="application.id" class="application-card">
						<div class="application-header">
							<div class="applicant-info">
								<div class="applicant-avatar">
									<img 
										v-if="application.user?.avatar_url" 
										:src="application.user.avatar_url" 
										:alt="`${application.user.first_name} ${application.user.last_name}`"
										class="avatar-image"
									/>
									<div v-else class="avatar-placeholder">
										{{ (application.user?.first_name?.[0] || '') + (application.user?.last_name?.[0] || '') }}
									</div>
								</div>
								<div class="applicant-details">
									<h3 class="applicant-name">
										{{ application.user?.first_name }} {{ application.user?.last_name }}
									</h3>
									<p class="applicant-email">{{ application.user?.email }}</p>
									<p v-if="application.user?.location" class="applicant-location">
										{{ application.user.location }}
									</p>
								</div>
							</div>
							<div class="application-status">
								<span :class="['status-badge', getStatusColor(application.status)]">
									{{ application.status }}
								</span>
							</div>
						</div>

						<div class="application-details">
							<div class="job-info">
								<h4 class="job-title">{{ application.job?.title }}</h4>
								<p class="application-date">Applied on {{ formatDate(application.applied_at) }}</p>
							</div>

							<div v-if="application.cover_letter" class="cover-letter">
								<h5 class="cover-letter-title">Cover Letter:</h5>
								<p class="cover-letter-text">{{ application.cover_letter }}</p>
							</div>

							<div v-if="application.user?.skills?.length" class="skills">
								<h5 class="skills-title">Skills:</h5>
								<div class="skills-list">
									<span 
										v-for="skill in application.user.skills" 
										:key="skill" 
										class="skill-tag"
									>
										{{ skill }}
									</span>
								</div>
							</div>

							<div v-if="application.user?.experience_years" class="experience">
								<span class="experience-label">Experience:</span>
								<span class="experience-value">{{ application.user.experience_years }} years</span>
							</div>
						</div>

						<div class="application-actions">
							<div class="action-buttons">
								<Button 
									v-if="application.user?.resume_url"
									variant="secondary" 
									text="View Resume" 
									size="small"
									:link="application.user.resume_url"
									target="_blank"
								/>
								<Button 
									v-if="application.user?.linkedin_url"
									variant="secondary" 
									text="LinkedIn" 
									size="small"
									:link="application.user.linkedin_url"
									target="_blank"
								/>
								<Button 
									variant="secondary" 
									text="View Job" 
									size="small"
									@click="handleViewJob(application.job_id)"
								/>
							</div>

							<div class="status-actions">
								<select 
									:value="application.status"
									@change="handleUpdateStatus(application.id, ($event.target as HTMLSelectElement).value as any)"
									:disabled="statusUpdateLoading === application.id"
									class="status-select"
								>
									<option value="pending">Pending</option>
									<option value="reviewed">Reviewed</option>
									<option value="interview">Interview</option>
									<option value="accepted">Accepted</option>
									<option value="rejected">Rejected</option>
								</select>
								
								<div v-if="statusUpdateLoading === application.id" class="status-loading">
									<div class="mini-spinner"></div>
								</div>
							</div>
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
	text-align: center;
	margin-bottom: 3rem;
}

.applications-title {
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

.no-company-message {
	display: flex;
	justify-content: center;
	align-items: center;
	min-height: 400px;
}

.message-card {
	background: white;
	border-radius: 12px;
	border: 1px solid var(--color-border);
	padding: 3rem;
	text-align: center;
	max-width: 500px;
	box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
}

.message-icon {
	color: var(--color-warning);
	margin-bottom: 1.5rem;
}

.message-title {
	font-size: 1.5rem;
	font-weight: 600;
	color: var(--color-text-primary);
	margin-bottom: 1rem;
}

.message-description {
	color: var(--color-text-secondary);
	line-height: 1.6;
	margin-bottom: 2rem;
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

.filters-row {
	display: grid;
	grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
	gap: 1.5rem;
}

.filter-group {
	display: flex;
	flex-direction: column;
	gap: 0.5rem;
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

.applicant-info {
	display: flex;
	gap: 1rem;
	flex: 1;
}

.applicant-avatar {
	flex-shrink: 0;
}

.avatar-image {
	width: 48px;
	height: 48px;
	border-radius: 50%;
	object-fit: cover;
}

.avatar-placeholder {
	width: 48px;
	height: 48px;
	border-radius: 50%;
	background: var(--color-primary-light);
	color: var(--color-primary);
	display: flex;
	align-items: center;
	justify-content: center;
	font-weight: 600;
	font-size: 1rem;
}

.applicant-details {
	flex: 1;
}

.applicant-name {
	font-size: 1.125rem;
	font-weight: 600;
	color: var(--color-text-primary);
	margin-bottom: 0.25rem;
}

.applicant-email {
	color: var(--color-text-secondary);
	font-size: 0.875rem;
	margin-bottom: 0.25rem;
}

.applicant-location {
	color: var(--color-text-secondary);
	font-size: 0.875rem;
	margin: 0;
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

.job-info {
	background: var(--color-background);
	padding: 1rem;
	border-radius: 8px;
}

.job-title {
	font-weight: 600;
	color: var(--color-text-primary);
	margin-bottom: 0.25rem;
}

.application-date {
	color: var(--color-text-secondary);
	font-size: 0.875rem;
	margin: 0;
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

.skills {
	background: var(--color-background);
	padding: 1rem;
	border-radius: 8px;
}

.skills-title {
	font-weight: 600;
	color: var(--color-text-primary);
	margin-bottom: 0.75rem;
	font-size: 0.875rem;
}

.skills-list {
	display: flex;
	flex-wrap: wrap;
	gap: 0.5rem;
}

.skill-tag {
	background: var(--color-primary-light);
	color: var(--color-primary-dark);
	padding: 0.25rem 0.75rem;
	border-radius: 20px;
	font-size: 0.75rem;
	font-weight: 500;
}

.experience {
	display: flex;
	gap: 0.5rem;
	align-items: center;
}

.experience-label {
	font-weight: 500;
	color: var(--color-text-primary);
	font-size: 0.875rem;
}

.experience-value {
	color: var(--color-text-secondary);
	font-size: 0.875rem;
}

.application-actions {
	display: flex;
	justify-content: space-between;
	align-items: center;
	gap: 1rem;
	flex-wrap: wrap;
}

.action-buttons {
	display: flex;
	gap: 0.75rem;
	flex-wrap: wrap;
}

.status-actions {
	display: flex;
	align-items: center;
	gap: 0.5rem;
}

.status-select {
	padding: 0.5rem 0.75rem;
	border: 1px solid var(--color-border);
	border-radius: 6px;
	font-size: 0.875rem;
	background: white;
}

.status-select:focus {
	outline: none;
	border-color: var(--color-primary);
}

.status-loading {
	display: flex;
	align-items: center;
}

.mini-spinner {
	width: 16px;
	height: 16px;
	border: 2px solid var(--color-border);
	border-top: 2px solid var(--color-primary);
	border-radius: 50%;
	animation: spin 1s linear infinite;
}

@media (max-width: 768px) {
	.applications-wrapper {
		padding: 0 1rem;
	}
	
	.stats-grid {
		grid-template-columns: repeat(2, 1fr);
	}
	
	.filters-row {
		grid-template-columns: 1fr;
	}
	
	.application-header {
		flex-direction: column;
		gap: 0.75rem;
	}
	
	.application-actions {
		flex-direction: column;
		align-items: stretch;
		gap: 1rem;
	}
	
	.action-buttons {
		justify-content: center;
	}
	
	.status-actions {
		justify-content: center;
	}
	
	.message-card {
		padding: 2rem;
		margin: 0 1rem;
	}
}

@media (max-width: 480px) {
	.stats-grid {
		grid-template-columns: 1fr;
	}
	
	.applicant-info {
		flex-direction: column;
		align-items: center;
		text-align: center;
	}
	
	.action-buttons {
		flex-direction: column;
		width: 100%;
	}
}
</style> 