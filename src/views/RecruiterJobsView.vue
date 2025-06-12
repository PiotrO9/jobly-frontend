<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '@/stores/auth'
import { useJobManagement } from '@/composables/useJobManagement'
import Button from '@/components/ui/Button.vue'

const router = useRouter()
const authStore = useAuthStore()
const { jobs, fetchCompanyJobs, updateJobStatus, deleteJob, jobLoading } = useJobManagement()

const selectedTab = ref<'all' | 'active' | 'draft' | 'closed'>('all')
const showDeleteModal = ref(false)
const jobToDelete = ref<string | null>(null)
const deleteLoading = ref(false)

const userCompanyId = computed(() => authStore.userCompanyId)
const isRecruiter = computed(() => authStore.isRecruiter)

const filteredJobs = computed(() => {
	if (selectedTab.value === 'all') {
		return jobs.value
	}
	return jobs.value.filter(job => job.status === selectedTab.value)
})

const jobStats = computed(() => ({
	all: jobs.value.length,
	active: jobs.value.filter(job => job.status === 'active').length,
	draft: jobs.value.filter(job => job.status === 'draft').length,
	closed: jobs.value.filter(job => job.status === 'closed').length
}))

onMounted(async () => {
	if (!authStore.isAuthenticated || !isRecruiter.value) {
		router.push('/')
		return
	}

	if (!userCompanyId.value) {
		return
	}

	await fetchCompanyJobs(userCompanyId.value)
})

function handlePostJob() {
	router.push('/post-job')
}

function handleEditJob(jobId: string) {
	router.push(`/post-job?edit=${jobId}`)
}

function handleViewJob(jobId: string) {
	router.push(`/jobs/${jobId}`)
}

async function handleUpdateStatus(jobId: string, status: 'active' | 'closed' | 'draft') {
	try {
		const result = await updateJobStatus(jobId, status)
		if (result.success) {
			// Job status updated successfully
		}
	} catch (error) {
		console.error('Failed to update job status:', error)
	}
}

function handleDeleteClick(jobId: string) {
	jobToDelete.value = jobId
	showDeleteModal.value = true
}

async function handleConfirmDelete() {
	if (!jobToDelete.value) return

	try {
		deleteLoading.value = true
		const result = await deleteJob(jobToDelete.value)
		
		if (result.success) {
			// Remove job from local array
			const jobIndex = jobs.value.findIndex(job => job.id === jobToDelete.value)
			if (jobIndex !== -1) {
				jobs.value.splice(jobIndex, 1)
			}
			handleCloseDeleteModal()
		}
	} catch (error) {
		console.error('Failed to delete job:', error)
	} finally {
		deleteLoading.value = false
	}
}

function handleCloseDeleteModal() {
	showDeleteModal.value = false
	jobToDelete.value = null
}

function formatSalary(min?: number | null, max?: number | null, currency = 'PLN'): string {
	if (!min && !max) return 'Not specified'
	if (min && max) return `${min.toLocaleString()} - ${max.toLocaleString()} ${currency}`
	if (min) return `From ${min.toLocaleString()} ${currency}`
	if (max) return `Up to ${max.toLocaleString()} ${currency}`
	return 'Not specified'
}

function formatDate(dateString: string): string {
	return new Date(dateString).toLocaleDateString('en-US', {
		year: 'numeric',
		month: 'short',
		day: 'numeric'
	})
}
</script>

<template>
	<div class="jobs-container">
		<div class="jobs-wrapper">
			<div class="jobs-header">
				<div class="header-content">
					<h1 class="jobs-title">Job Management</h1>
					<p class="jobs-subtitle">Manage your job postings and track applications</p>
				</div>
				<Button 
					variant="primary" 
					text="Post New Job"
					@click="handlePostJob"
				/>
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
						You need to be associated with a company to manage job postings.
					</p>
					<Button 
						variant="primary" 
						text="Update Profile" 
						link="/account/settings"
					/>
				</div>
			</div>

			<div v-else class="jobs-content">
				<!-- Tabs -->
				<div class="tabs-container">
					<nav class="tabs-nav">
						<button 
							@click="selectedTab = 'all'"
							:class="['tab-button', { active: selectedTab === 'all' }]"
						>
							All Jobs ({{ jobStats.all }})
						</button>
						<button 
							@click="selectedTab = 'active'"
							:class="['tab-button', { active: selectedTab === 'active' }]"
						>
							Active ({{ jobStats.active }})
						</button>
						<button 
							@click="selectedTab = 'draft'"
							:class="['tab-button', { active: selectedTab === 'draft' }]"
						>
							Drafts ({{ jobStats.draft }})
						</button>
						<button 
							@click="selectedTab = 'closed'"
							:class="['tab-button', { active: selectedTab === 'closed' }]"
						>
							Closed ({{ jobStats.closed }})
						</button>
					</nav>
				</div>

				<!-- Loading State -->
				<div v-if="jobLoading" class="loading-state">
					<div class="loading-spinner"></div>
					<p>Loading jobs...</p>
				</div>

				<!-- Empty State -->
				<div v-else-if="filteredJobs.length === 0" class="empty-state">
					<div class="empty-icon">
						<svg xmlns="http://www.w3.org/2000/svg" width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1" stroke-linecap="round" stroke-linejoin="round">
							<rect width="18" height="11" x="3" y="11" rx="2" ry="2"></rect>
							<path d="m7 11V7a5 5 0 0 1 10 0v4"></path>
						</svg>
					</div>
					<h3 class="empty-title">
						{{ selectedTab === 'all' ? 'No Jobs Yet' : `No ${selectedTab} Jobs` }}
					</h3>
					<p class="empty-description">
						{{ selectedTab === 'all' 
							? 'Start by posting your first job to attract candidates.' 
							: `You don't have any ${selectedTab} jobs at the moment.` 
						}}
					</p>
					<Button 
						v-if="selectedTab === 'all' || selectedTab === 'active'"
						variant="primary" 
						text="Post Your First Job" 
						@click="handlePostJob" 
					/>
				</div>

				<!-- Jobs List -->
				<div v-else class="jobs-list">
					<div v-for="job in filteredJobs" :key="job.id" class="job-card">
						<div class="job-header">
							<div class="job-main-info">
								<h3 class="job-title">{{ job.title }}</h3>
								<div class="job-meta">
									<span class="job-location">{{ job.location }}</span>
									<span class="job-type">{{ job.employment_type }}</span>
									<span class="job-level">{{ job.experience_level }}</span>
								</div>
							</div>
							<div class="job-status">
								<span :class="['status-badge', job.status]">
									{{ job.status }}
								</span>
							</div>
						</div>

						<div class="job-details">
							<div class="job-stats">
								<div class="stat-item">
									<span class="stat-label">Posted:</span>
									<span class="stat-value">{{ formatDate(job.created_at) }}</span>
								</div>
								<div class="stat-item">
									<span class="stat-label">Views:</span>
									<span class="stat-value">{{ job.views_count }}</span>
								</div>
								<div class="stat-item">
									<span class="stat-label">Applications:</span>
									<span class="stat-value">{{ job.applications_count }}</span>
								</div>
								<div class="stat-item">
									<span class="stat-label">Salary:</span>
									<span class="stat-value">{{ formatSalary(job.salary_min, job.salary_max, job.currency) }}</span>
								</div>
							</div>
						</div>

						<div class="job-actions">
							<Button 
								variant="secondary" 
								text="View" 
								size="small"
								@click="handleViewJob(job.id)"
							/>
							<Button 
								variant="secondary" 
								text="Edit" 
								size="small"
								@click="handleEditJob(job.id)"
							/>
							
							<!-- Status Actions -->
							<div class="status-actions">
								<Button 
									v-if="job.status === 'draft'"
									variant="primary" 
									text="Publish" 
									size="small"
									@click="handleUpdateStatus(job.id, 'active')"
								/>
								<Button 
									v-if="job.status === 'active'"
									variant="secondary" 
									text="Close" 
									size="small"
									@click="handleUpdateStatus(job.id, 'closed')"
								/>
								<Button 
									v-if="job.status === 'closed'"
									variant="primary" 
									text="Reopen" 
									size="small"
									@click="handleUpdateStatus(job.id, 'active')"
								/>
							</div>

							<button 
								@click="handleDeleteClick(job.id)"
								class="delete-button"
								title="Delete job"
							>
								<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
									<polyline points="3,6 5,6 21,6"></polyline>
									<path d="m19,6v14a2,2 0 0,1 -2,2H7a2,2 0 0,1 -2,-2V6m3,0V4a2,2 0 0,1 2,-2h4a2,2 0 0,1 2,2v2"></path>
								</svg>
							</button>
						</div>
					</div>
				</div>
			</div>
		</div>

		<!-- Delete Confirmation Modal -->
		<div v-if="showDeleteModal" class="modal-overlay" @click="handleCloseDeleteModal">
			<div class="modal-content" @click.stop>
				<div class="modal-header">
					<h3 class="modal-title">Delete Job</h3>
					<button @click="handleCloseDeleteModal" class="modal-close">
						<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
							<line x1="18" y1="6" x2="6" y2="18"></line>
							<line x1="6" y1="6" x2="18" y2="18"></line>
						</svg>
					</button>
				</div>
				<div class="modal-body">
					<p>Are you sure you want to delete this job posting? This action cannot be undone and all associated applications will also be removed.</p>
				</div>
				<div class="modal-actions">
					<Button 
						variant="secondary" 
						text="Cancel" 
						@click="handleCloseDeleteModal"
						:disabled="deleteLoading"
					/>
					<Button 
						variant="danger" 
						text="Delete Job" 
						@click="handleConfirmDelete"
						:disabled="deleteLoading"
						:loading="deleteLoading"
					/>
				</div>
			</div>
		</div>
	</div>
</template>

<style scoped>
.jobs-container {
	min-height: calc(100vh - var(--header-height, 80px));
	background-color: var(--color-background);
	padding: 2rem 0;
}

.jobs-wrapper {
	max-width: 1200px;
	margin: 0 auto;
	padding: 0 1.5rem;
}

.jobs-header {
	display: flex;
	justify-content: space-between;
	align-items: flex-start;
	margin-bottom: 2rem;
	gap: 2rem;
}

.header-content h1 {
	font-size: 2.5rem;
	font-weight: 700;
	color: var(--color-text-primary);
	margin-bottom: 0.5rem;
}

.jobs-subtitle {
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

.jobs-content {
	display: flex;
	flex-direction: column;
	gap: 2rem;
}

.tabs-container {
	background: white;
	border-radius: 12px;
	border: 1px solid var(--color-border);
	overflow: hidden;
}

.tabs-nav {
	display: flex;
	border-bottom: 1px solid var(--color-border);
}

.tab-button {
	flex: 1;
	padding: 1rem 1.5rem;
	background: transparent;
	border: none;
	font-weight: 500;
	color: var(--color-text-secondary);
	cursor: pointer;
	transition: all 0.2s;
	border-bottom: 3px solid transparent;
}

.tab-button:hover {
	background: var(--color-background);
	color: var(--color-text-primary);
}

.tab-button.active {
	color: var(--color-primary);
	border-bottom-color: var(--color-primary);
	background: var(--color-background);
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

.jobs-list {
	display: flex;
	flex-direction: column;
	gap: 1rem;
}

.job-card {
	background: white;
	border: 1px solid var(--color-border);
	border-radius: 12px;
	padding: 1.5rem;
	transition: box-shadow 0.2s;
}

.job-card:hover {
	box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
}

.job-header {
	display: flex;
	justify-content: space-between;
	align-items: flex-start;
	margin-bottom: 1rem;
	gap: 1rem;
}

.job-main-info {
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

.job-status {
	flex-shrink: 0;
}

.status-badge {
	padding: 0.375rem 0.75rem;
	border-radius: 20px;
	font-size: 0.75rem;
	font-weight: 500;
	text-transform: capitalize;
}

.status-badge.active {
	background: rgba(34, 197, 94, 0.1);
	color: rgb(34, 197, 94);
}

.status-badge.draft {
	background: rgba(251, 191, 36, 0.1);
	color: rgb(251, 191, 36);
}

.status-badge.closed {
	background: rgba(107, 114, 128, 0.1);
	color: rgb(107, 114, 128);
}

.job-details {
	margin-bottom: 1.5rem;
}

.job-stats {
	display: grid;
	grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
	gap: 1rem;
	padding: 1rem;
	background: var(--color-background);
	border-radius: 8px;
}

.stat-item {
	display: flex;
	flex-direction: column;
	gap: 0.25rem;
}

.stat-label {
	font-size: 0.75rem;
	color: var(--color-text-secondary);
	font-weight: 500;
}

.stat-value {
	font-size: 0.875rem;
	color: var(--color-text-primary);
	font-weight: 600;
}

.job-actions {
	display: flex;
	gap: 0.75rem;
	align-items: center;
	flex-wrap: wrap;
}

.status-actions {
	display: flex;
	gap: 0.5rem;
}

.delete-button {
	background: none;
	border: none;
	color: var(--color-error);
	cursor: pointer;
	padding: 0.5rem;
	border-radius: 4px;
	transition: background-color 0.2s;
	margin-left: auto;
}

.delete-button:hover {
	background: rgba(239, 68, 68, 0.1);
}

.modal-overlay {
	position: fixed;
	top: 0;
	left: 0;
	right: 0;
	bottom: 0;
	background: rgba(0, 0, 0, 0.5);
	display: flex;
	align-items: center;
	justify-content: center;
	z-index: 1000;
	padding: 1rem;
}

.modal-content {
	background: white;
	border-radius: 12px;
	max-width: 400px;
	width: 100%;
	box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1);
}

.modal-header {
	display: flex;
	justify-content: space-between;
	align-items: center;
	padding: 1.5rem 1.5rem 0;
}

.modal-title {
	font-size: 1.25rem;
	font-weight: 600;
	color: var(--color-text-primary);
}

.modal-close {
	background: none;
	border: none;
	color: var(--color-text-secondary);
	cursor: pointer;
	padding: 0.25rem;
	border-radius: 4px;
	transition: color 0.2s;
}

.modal-close:hover {
	color: var(--color-text-primary);
}

.modal-body {
	padding: 1.5rem;
	color: var(--color-text-secondary);
	line-height: 1.6;
}

.modal-actions {
	display: flex;
	justify-content: flex-end;
	gap: 0.75rem;
	padding: 0 1.5rem 1.5rem;
}

@media (max-width: 768px) {
	.jobs-wrapper {
		padding: 0 1rem;
	}
	
	.jobs-header {
		flex-direction: column;
		align-items: stretch;
		gap: 1rem;
	}
	
	.tabs-nav {
		flex-direction: column;
	}
	
	.tab-button {
		border-bottom: none;
		border-right: 3px solid transparent;
	}
	
	.tab-button.active {
		border-bottom: none;
		border-right-color: var(--color-primary);
	}
	
	.job-header {
		flex-direction: column;
		gap: 0.75rem;
	}
	
	.job-meta {
		gap: 0.75rem;
	}
	
	.job-stats {
		grid-template-columns: repeat(2, 1fr);
	}
	
	.job-actions {
		justify-content: flex-start;
	}
	
	.delete-button {
		margin-left: 0;
	}
	
	.message-card {
		padding: 2rem;
		margin: 0 1rem;
	}
}

@media (max-width: 480px) {
	.job-stats {
		grid-template-columns: 1fr;
	}
	
	.modal-overlay {
		padding: 0.5rem;
	}
}
</style> 