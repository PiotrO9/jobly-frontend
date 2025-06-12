<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '@/stores/auth'
import { useJobManagement } from '@/composables/useJobManagement'
import { useApplications } from '@/composables/useApplications'
import Button from '@/components/ui/Button.vue'

const router = useRouter()
const authStore = useAuthStore()
const { jobs, fetchCompanyJobs, jobLoading } = useJobManagement()
const { applications, fetchCompanyApplications, applicationsLoading } = useApplications()

const statsLoading = ref(true)

const userCompanyId = computed(() => authStore.userCompanyId)
const isRecruiter = computed(() => authStore.isRecruiter)

const activeJobs = computed(() => jobs.value.filter(job => job.status === 'active'))
const draftJobs = computed(() => jobs.value.filter(job => job.status === 'draft'))
const totalApplications = computed(() => applications.value.length)
const pendingApplications = computed(() => 
	applications.value.filter(app => app.status === 'pending')
)

onMounted(async () => {
	if (!authStore.isAuthenticated || !isRecruiter.value) {
		router.push('/')
		return
	}

	if (!userCompanyId.value) {
		return
	}

	try {
		statsLoading.value = true
		await Promise.all([
			fetchCompanyJobs(userCompanyId.value),
			fetchCompanyApplications(userCompanyId.value)
		])
	} catch (error) {
		console.error('Error loading dashboard data:', error)
	} finally {
		statsLoading.value = false
	}
})

function handlePostJob() {
	router.push('/post-job')
}

function handleViewJobs() {
	router.push('/recruiter/jobs')
}

function handleViewApplications() {
	router.push('/recruiter/applications')
}
</script>

<template>
	<div class="dashboard-container">
		<div class="dashboard-wrapper">
			<div class="dashboard-header">
				<h1 class="dashboard-title">Recruiter Dashboard</h1>
				<p class="dashboard-subtitle">Manage your job postings and review applications</p>
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
						You need to be associated with a company to access recruiter features. Please update your profile to include your company information.
					</p>
					<Button 
						variant="primary" 
						text="Update Profile" 
						link="/account/settings"
					/>
				</div>
			</div>

			<div v-else class="dashboard-content">
				<!-- Quick Actions -->
				<section class="quick-actions">
					<h2 class="section-title">Quick Actions</h2>
					<div class="actions-grid">
						<button @click="handlePostJob" class="action-card">
							<div class="action-icon">
								<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
									<line x1="12" y1="5" x2="12" y2="19"></line>
									<line x1="5" y1="12" x2="19" y2="12"></line>
								</svg>
							</div>
							<h3 class="action-title">Post New Job</h3>
							<p class="action-description">Create a new job posting</p>
						</button>

						<button @click="handleViewJobs" class="action-card">
							<div class="action-icon">
								<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
									<rect width="18" height="11" x="3" y="11" rx="2" ry="2"></rect>
									<path d="m7 11V7a5 5 0 0 1 10 0v4"></path>
								</svg>
							</div>
							<h3 class="action-title">Manage Jobs</h3>
							<p class="action-description">View and edit your job postings</p>
						</button>

						<button @click="handleViewApplications" class="action-card">
							<div class="action-icon">
								<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
									<path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
									<polyline points="14,2 14,8 20,8"></polyline>
									<line x1="16" y1="13" x2="8" y2="13"></line>
									<line x1="16" y1="17" x2="8" y2="17"></line>
									<polyline points="10,9 9,9 8,9"></polyline>
								</svg>
							</div>
							<h3 class="action-title">Review Applications</h3>
							<p class="action-description">Manage candidate applications</p>
						</button>
					</div>
				</section>

				<!-- Statistics -->
				<section class="statistics">
					<h2 class="section-title">Overview</h2>
					<div v-if="statsLoading || jobLoading || applicationsLoading" class="loading-state">
						<div class="loading-spinner"></div>
						<p>Loading statistics...</p>
					</div>
					<div v-else class="stats-grid">
						<div class="stat-card">
							<div class="stat-icon active">
								<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
									<rect width="18" height="11" x="3" y="11" rx="2" ry="2"></rect>
									<path d="m7 11V7a5 5 0 0 1 10 0v4"></path>
								</svg>
							</div>
							<div class="stat-content">
								<h3 class="stat-number">{{ activeJobs.length }}</h3>
								<p class="stat-label">Active Jobs</p>
							</div>
						</div>

						<div class="stat-card">
							<div class="stat-icon draft">
								<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
									<path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path>
									<polyline points="14,2 14,8 20,8"></polyline>
								</svg>
							</div>
							<div class="stat-content">
								<h3 class="stat-number">{{ draftJobs.length }}</h3>
								<p class="stat-label">Draft Jobs</p>
							</div>
						</div>

						<div class="stat-card">
							<div class="stat-icon applications">
								<svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
									<path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"></path>
									<circle cx="9" cy="7" r="4"></circle>
									<path d="m22 21-3-3m0 0a6 6 0 0 0 0-12 6 6 0 0 0 0 12z"></path>
								</svg>
							</div>
							<div class="stat-content">
								<h3 class="stat-number">{{ totalApplications }}</h3>
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
								<h3 class="stat-number">{{ pendingApplications.length }}</h3>
								<p class="stat-label">Pending Review</p>
							</div>
						</div>
					</div>
				</section>

				<!-- Recent Activity -->
				<section class="recent-activity">
					<h2 class="section-title">Recent Activity</h2>
					<div class="activity-content">
						<div v-if="jobs.length === 0 && applications.length === 0" class="empty-state">
							<div class="empty-icon">
								<svg xmlns="http://www.w3.org/2000/svg" width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1" stroke-linecap="round" stroke-linejoin="round">
									<rect width="18" height="11" x="3" y="11" rx="2" ry="2"></rect>
									<path d="m7 11V7a5 5 0 0 1 10 0v4"></path>
								</svg>
							</div>
							<h3 class="empty-title">No Activity Yet</h3>
							<p class="empty-description">Start by posting your first job to see activity here.</p>
							<Button variant="primary" text="Post Your First Job" @click="handlePostJob" />
						</div>

						<div v-else class="activity-list">
							<div v-for="job in jobs.slice(0, 3)" :key="job.id" class="activity-item">
								<div class="activity-icon">
									<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
										<rect width="18" height="11" x="3" y="11" rx="2" ry="2"></rect>
										<path d="m7 11V7a5 5 0 0 1 10 0v4"></path>
									</svg>
								</div>
								<div class="activity-content">
									<h4 class="activity-title">{{ job.title }}</h4>
									<p class="activity-description">
										Job posted • {{ job.applications_count }} applications
									</p>
								</div>
								<div class="activity-status" :class="job.status">
									{{ job.status }}
								</div>
							</div>
						</div>
					</div>
				</section>
			</div>
		</div>
	</div>
</template>

<style scoped>
.dashboard-container {
	min-height: calc(100vh - var(--header-height, 80px));
	background-color: var(--color-background);
	padding: 2rem 0;
}

.dashboard-wrapper {
	max-width: 1200px;
	margin: 0 auto;
	padding: 0 1.5rem;
}

.dashboard-header {
	text-align: center;
	margin-bottom: 3rem;
}

.dashboard-title {
	font-size: 2.5rem;
	font-weight: 700;
	color: var(--color-text-primary);
	margin-bottom: 0.5rem;
}

.dashboard-subtitle {
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

.dashboard-content {
	display: flex;
	flex-direction: column;
	gap: 3rem;
}

.section-title {
	font-size: 1.5rem;
	font-weight: 600;
	color: var(--color-text-primary);
	margin-bottom: 1.5rem;
}

.quick-actions {
	background: white;
	border-radius: 12px;
	border: 1px solid var(--color-border);
	padding: 2rem;
	box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
}

.actions-grid {
	display: grid;
	grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
	gap: 1.5rem;
}

.action-card {
	background: var(--color-background);
	border: 1px solid var(--color-border);
	border-radius: 8px;
	padding: 1.5rem;
	text-align: center;
	cursor: pointer;
	transition: all 0.2s;
	text-decoration: none;
	color: inherit;
}

.action-card:hover {
	border-color: var(--color-primary);
	transform: translateY(-2px);
	box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
}

.action-icon {
	width: 48px;
	height: 48px;
	background: var(--color-primary-light);
	color: var(--color-primary);
	border-radius: 8px;
	display: flex;
	align-items: center;
	justify-content: center;
	margin: 0 auto 1rem;
}

.action-title {
	font-size: 1.125rem;
	font-weight: 600;
	color: var(--color-text-primary);
	margin-bottom: 0.5rem;
}

.action-description {
	color: var(--color-text-secondary);
	font-size: 0.875rem;
	margin: 0;
}

.statistics {
	background: white;
	border-radius: 12px;
	border: 1px solid var(--color-border);
	padding: 2rem;
	box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
}

.loading-state {
	display: flex;
	flex-direction: column;
	align-items: center;
	justify-content: center;
	padding: 3rem;
	color: var(--color-text-secondary);
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

.stat-icon.active {
	background: rgba(34, 197, 94, 0.1);
	color: rgb(34, 197, 94);
}

.stat-icon.draft {
	background: rgba(251, 191, 36, 0.1);
	color: rgb(251, 191, 36);
}

.stat-icon.applications {
	background: rgba(59, 130, 246, 0.1);
	color: rgb(59, 130, 246);
}

.stat-icon.pending {
	background: rgba(249, 115, 22, 0.1);
	color: rgb(249, 115, 22);
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

.recent-activity {
	background: white;
	border-radius: 12px;
	border: 1px solid var(--color-border);
	padding: 2rem;
	box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
}

.activity-content {
	min-height: 200px;
}

.empty-state {
	display: flex;
	flex-direction: column;
	align-items: center;
	justify-content: center;
	padding: 3rem;
	text-align: center;
}

.empty-icon {
	color: var(--color-text-secondary);
	margin-bottom: 1.5rem;
}

.empty-title {
	font-size: 1.25rem;
	font-weight: 600;
	color: var(--color-text-primary);
	margin-bottom: 0.5rem;
}

.empty-description {
	color: var(--color-text-secondary);
	margin-bottom: 2rem;
}

.activity-list {
	display: flex;
	flex-direction: column;
	gap: 1rem;
}

.activity-item {
	display: flex;
	align-items: center;
	gap: 1rem;
	padding: 1rem;
	background: var(--color-background);
	border: 1px solid var(--color-border);
	border-radius: 8px;
}

.activity-item .activity-icon {
	width: 32px;
	height: 32px;
	background: var(--color-primary-light);
	color: var(--color-primary);
	border-radius: 6px;
	display: flex;
	align-items: center;
	justify-content: center;
	flex-shrink: 0;
}

.activity-item .activity-content {
	flex: 1;
}

.activity-title {
	font-weight: 600;
	color: var(--color-text-primary);
	margin-bottom: 0.25rem;
	font-size: 0.875rem;
}

.activity-description {
	color: var(--color-text-secondary);
	font-size: 0.75rem;
	margin: 0;
}

.activity-status {
	padding: 0.25rem 0.75rem;
	border-radius: 20px;
	font-size: 0.75rem;
	font-weight: 500;
	text-transform: capitalize;
}

.activity-status.active {
	background: rgba(34, 197, 94, 0.1);
	color: rgb(34, 197, 94);
}

.activity-status.draft {
	background: rgba(251, 191, 36, 0.1);
	color: rgb(251, 191, 36);
}

.activity-status.closed {
	background: rgba(107, 114, 128, 0.1);
	color: rgb(107, 114, 128);
}

@media (max-width: 768px) {
	.dashboard-wrapper {
		padding: 0 1rem;
	}
	
	.actions-grid {
		grid-template-columns: 1fr;
	}
	
	.stats-grid {
		grid-template-columns: repeat(2, 1fr);
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
}
</style> 