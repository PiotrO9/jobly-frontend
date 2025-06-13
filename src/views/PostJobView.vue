<script setup lang="ts">
import { ref, reactive, computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '@/stores/auth'
import { useJobManagement } from '@/composables/useJobManagement'
import Button from '@/components/ui/Button.vue'

const router = useRouter()
const authStore = useAuthStore()
const { createJob, jobLoading } = useJobManagement()

const isSubmitting = ref(false)
const successMessage = ref('')
const errorMessage = ref('')

const jobForm = reactive({
	title: '',
	location: '',
	employment_type: 'Full-time' as const,
	experience_level: 'Mid' as const,
	salary_min: null as number | null,
	salary_max: null as number | null,
	currency: 'PLN',
	description: '',
	skills: [] as string[],
	requirements: [] as string[],
	benefits: [] as string[],
	equity: null as number | null,
	remote_allowed: false,
	status: 'draft' as const
})

const newSkill = ref('')
const newRequirement = ref('')
const newBenefit = ref('')

const errors = reactive({
	title: [] as string[],
	location: [] as string[],
	description: [] as string[],
	salary: [] as string[]
})

const isRecruiter = computed(() => authStore.isRecruiter)
const userCompanyId = computed(() => authStore.userCompanyId)

onMounted(() => {
	if (!authStore.isAuthenticated) {
		router.push('/login')
		return
	}

	if (!isRecruiter.value) {
		// User is not a recruiter, stay on page but show message
		return
	}

	if (!userCompanyId.value) {
		errorMessage.value = 'You need to be associated with a company to post jobs. Please update your profile.'
	}
})

function validateForm(): boolean {
	errors.title = []
	errors.location = []
	errors.description = []
	errors.salary = []

	if (!jobForm.title.trim()) {
		errors.title.push('Job title is required')
	} else if (jobForm.title.length < 3) {
		errors.title.push('Job title must be at least 3 characters long')
	}

	if (!jobForm.location?.trim()) {
		errors.location.push('Location is required')
	}

	if (!jobForm.description.trim()) {
		errors.description.push('Job description is required')
	} else if (jobForm.description.length < 50) {
		errors.description.push('Job description must be at least 50 characters long')
	}

	if (jobForm.salary_min && jobForm.salary_max && jobForm.salary_min > jobForm.salary_max) {
		errors.salary.push('Minimum salary cannot be higher than maximum salary')
	}

	if (jobForm.equity && (jobForm.equity < 0 || jobForm.equity > 1)) {
		errors.salary.push('Equity must be between 0 and 1 (0% to 100%)')
	}

	return Object.values(errors).every(fieldErrors => fieldErrors.length === 0)
}

function handleAddSkill() {
	if (newSkill.value.trim() && !jobForm.skills.includes(newSkill.value.trim())) {
		jobForm.skills.push(newSkill.value.trim())
		newSkill.value = ''
	}
}

function handleRemoveSkill(skillToRemove: string) {
	jobForm.skills = jobForm.skills.filter(skill => skill !== skillToRemove)
}

function handleAddRequirement() {
	if (newRequirement.value.trim() && !jobForm.requirements.includes(newRequirement.value.trim())) {
		jobForm.requirements.push(newRequirement.value.trim())
		newRequirement.value = ''
	}
}

function handleRemoveRequirement(requirementToRemove: string) {
	jobForm.requirements = jobForm.requirements.filter(req => req !== requirementToRemove)
}

function handleAddBenefit() {
	if (newBenefit.value.trim() && !jobForm.benefits.includes(newBenefit.value.trim())) {
		jobForm.benefits.push(newBenefit.value.trim())
		newBenefit.value = ''
	}
}

function handleRemoveBenefit(benefitToRemove: string) {
	jobForm.benefits = jobForm.benefits.filter(benefit => benefit !== benefitToRemove)
}

async function handleSubmit(isDraft = false) {
	if (!userCompanyId.value) {
		errorMessage.value = 'Company information is required to post a job'
		return
	}

	if (!isDraft && !validateForm()) {
		return
	}

	isSubmitting.value = true
	successMessage.value = ''
	errorMessage.value = ''

	try {
		const jobData = {
			...jobForm,
			company_id: userCompanyId.value,
			status: isDraft ? 'draft' as const : 'active' as const
		}

		const result = await createJob(jobData)

		if (result.success) {
			successMessage.value = isDraft
				? 'Job saved as draft successfully!'
				: 'Job posted successfully!'

			setTimeout(() => {
				router.push('/recruiter/jobs')
			}, 2000)
		} else {
			errorMessage.value = 'Failed to create job. Please try again.'
		}
	} catch (error) {
		console.error('Error creating job:', error)
		errorMessage.value = 'An error occurred while creating the job'
	} finally {
		isSubmitting.value = false
	}
}

function handleSaveDraft() {
	handleSubmit(true)
}

function handlePublishJob() {
	handleSubmit(false)
}
</script>

<template>
	<div class="post-job-container">
		<div class="post-job-wrapper">
			<div class="post-job-header">
				<h1 class="post-job-title">Post a Job</h1>
				<p v-if="!isRecruiter" class="access-denied-message">
					Only recruiters can post jobs. If you're a recruiter, please update your profile to indicate your recruiter status.
				</p>
				<p v-else class="post-job-subtitle">
					Create a new job posting to attract top talent
				</p>
			</div>

			<div v-if="!isRecruiter" class="access-denied-content">
				<div class="access-denied-card">
					<div class="access-denied-icon">
						<svg xmlns="http://www.w3.org/2000/svg" width="48" height="48" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round">
							<circle cx="12" cy="12" r="10"></circle>
							<line x1="15" y1="9" x2="9" y2="15"></line>
							<line x1="9" y1="9" x2="15" y2="15"></line>
						</svg>
					</div>
					<h2 class="access-denied-title">Recruiter Access Required</h2>
					<p class="access-denied-description">
						This feature is only available to recruiters. If you are a recruiter and need access to this feature, please contact your administrator or update your account settings.
					</p>
					<div class="access-denied-actions">
						<Button
							variant="primary"
							text="Go to Settings"
							link="/account/settings"
						/>
						<Button
							variant="secondary"
							text="Browse Jobs"
							link="/jobs"
						/>
					</div>
				</div>
			</div>

			<form v-else @submit.prevent="handlePublishJob" class="post-job-form">
				<div v-if="successMessage" class="message success">
					{{ successMessage }}
				</div>
				<div v-if="errorMessage" class="message error">
					{{ errorMessage }}
				</div>

				<!-- Basic Information -->
				<section class="form-section">
					<h2 class="section-title">Basic Information</h2>

					<div class="form-group">
						<label for="title" class="form-label">Job Title*</label>
						<input
							id="title"
							v-model="jobForm.title"
							type="text"
							class="form-input"
							:class="{ error: errors.title.length > 0 }"
							placeholder="e.g., Senior Frontend Developer"
							required
						/>
						<div v-if="errors.title.length > 0" class="form-errors">
							<span v-for="error in errors.title" :key="error" class="form-error">
								{{ error }}
							</span>
						</div>
					</div>

					<div class="form-row">
						<div class="form-group">
							<label for="location" class="form-label">Location*</label>
							<input
								id="location"
								v-model="jobForm.location"
								type="text"
								class="form-input"
								:class="{ error: errors.location.length > 0 }"
								placeholder="e.g., Warsaw, Poland"
								required
							/>
							<div v-if="errors.location.length > 0" class="form-errors">
								<span v-for="error in errors.location" :key="error" class="form-error">
									{{ error }}
								</span>
							</div>
						</div>

						<div class="form-group">
							<label class="form-label">
								<input
									v-model="jobForm.remote_allowed"
									type="checkbox"
									class="form-checkbox"
								/>
								Remote work allowed
							</label>
						</div>
					</div>

					<div class="form-row">
						<div class="form-group">
							<label for="employment_type" class="form-label">Employment Type</label>
							<select
								id="employment_type"
								v-model="jobForm.employment_type"
								class="form-select"
							>
								<option value="Full-time">Full-time</option>
								<option value="Part-time">Part-time</option>
								<option value="Contract">Contract</option>
								<option value="Internship">Internship</option>
							</select>
						</div>

						<div class="form-group">
							<label for="experience_level" class="form-label">Experience Level</label>
							<select
								id="experience_level"
								v-model="jobForm.experience_level"
								class="form-select"
							>
								<option value="Junior">Junior</option>
								<option value="Mid">Mid</option>
								<option value="Senior">Senior</option>
								<option value="Lead">Lead</option>
							</select>
						</div>
					</div>
				</section>

				<!-- Compensation -->
				<section class="form-section">
					<h2 class="section-title">Compensation</h2>

					<div class="form-row">
						<div class="form-group">
							<label for="salary_min" class="form-label">Minimum Salary (PLN)</label>
							<input
								id="salary_min"
								v-model.number="jobForm.salary_min"
								type="number"
								class="form-input"
								placeholder="e.g., 8000"
								min="0"
								step="500"
							/>
						</div>

						<div class="form-group">
							<label for="salary_max" class="form-label">Maximum Salary (PLN)</label>
							<input
								id="salary_max"
								v-model.number="jobForm.salary_max"
								type="number"
								class="form-input"
								placeholder="e.g., 15000"
								min="0"
								step="500"
							/>
						</div>

						<div class="form-group">
							<label for="equity" class="form-label">Equity (%)</label>
							<input
								id="equity"
								v-model.number="jobForm.equity"
								type="number"
								class="form-input"
								placeholder="e.g., 0.5"
								min="0"
								max="1"
								step="0.001"
							/>
						</div>
					</div>

					<div v-if="errors.salary.length > 0" class="form-errors">
						<span v-for="error in errors.salary" :key="error" class="form-error">
							{{ error }}
						</span>
					</div>
				</section>

				<!-- Job Description -->
				<section class="form-section">
					<h2 class="section-title">Job Description</h2>

					<div class="form-group">
						<label for="description" class="form-label">Description*</label>
						<textarea
							id="description"
							v-model="jobForm.description"
							class="form-textarea"
							:class="{ error: errors.description.length > 0 }"
							placeholder="Describe the role, responsibilities, and what makes this opportunity exciting..."
							rows="8"
							required
						></textarea>
						<div v-if="errors.description.length > 0" class="form-errors">
							<span v-for="error in errors.description" :key="error" class="form-error">
								{{ error }}
							</span>
						</div>
					</div>
				</section>

				<!-- Skills & Requirements -->
				<section class="form-section">
					<h2 class="section-title">Skills & Requirements</h2>

					<div class="form-group">
						<label for="new-skill" class="form-label">Required Skills</label>
						<div class="input-with-button">
							<input
								id="new-skill"
								v-model="newSkill"
								type="text"
								class="form-input"
								placeholder="e.g., React, TypeScript"
								@keydown.enter.prevent="handleAddSkill"
							/>
							<button
								type="button"
								@click="handleAddSkill"
								class="add-button"
								:disabled="!newSkill.trim()"
							>
								Add
							</button>
						</div>
						<div v-if="jobForm.skills.length > 0" class="tags-list">
							<span
								v-for="skill in jobForm.skills"
								:key="skill"
								class="tag"
							>
								{{ skill }}
								<button
									type="button"
									@click="handleRemoveSkill(skill)"
									class="tag-remove"
									aria-label="Remove skill"
								>
									×
								</button>
							</span>
						</div>
					</div>

					<div class="form-group">
						<label for="new-requirement" class="form-label">Requirements</label>
						<div class="input-with-button">
							<input
								id="new-requirement"
								v-model="newRequirement"
								type="text"
								class="form-input"
								placeholder="e.g., 3+ years of experience"
								@keydown.enter.prevent="handleAddRequirement"
							/>
							<button
								type="button"
								@click="handleAddRequirement"
								class="add-button"
								:disabled="!newRequirement.trim()"
							>
								Add
							</button>
						</div>
						<div v-if="jobForm.requirements.length > 0" class="tags-list">
							<span
								v-for="requirement in jobForm.requirements"
								:key="requirement"
								class="tag"
							>
								{{ requirement }}
								<button
									type="button"
									@click="handleRemoveRequirement(requirement)"
									class="tag-remove"
									aria-label="Remove requirement"
								>
									×
								</button>
							</span>
						</div>
					</div>

					<div class="form-group">
						<label for="new-benefit" class="form-label">Benefits</label>
						<div class="input-with-button">
							<input
								id="new-benefit"
								v-model="newBenefit"
								type="text"
								class="form-input"
								placeholder="e.g., Health insurance, Flexible hours"
								@keydown.enter.prevent="handleAddBenefit"
							/>
							<button
								type="button"
								@click="handleAddBenefit"
								class="add-button"
								:disabled="!newBenefit.trim()"
							>
								Add
							</button>
						</div>
						<div v-if="jobForm.benefits.length > 0" class="tags-list">
							<span
								v-for="benefit in jobForm.benefits"
								:key="benefit"
								class="tag"
							>
								{{ benefit }}
								<button
									type="button"
									@click="handleRemoveBenefit(benefit)"
									class="tag-remove"
									aria-label="Remove benefit"
								>
									×
								</button>
							</span>
						</div>
					</div>
				</section>

				<!-- Form Actions -->
				<div class="form-actions">
					<Button
						type="button"
						variant="secondary"
						text="Save as Draft"
						@click="handleSaveDraft"
						:disabled="isSubmitting || jobLoading"
					/>
					<Button
						type="submit"
						variant="primary"
						text="Publish Job"
						:disabled="isSubmitting || jobLoading || !userCompanyId"
						:loading="isSubmitting || jobLoading"
					/>
					<Button
						type="button"
						variant="secondary"
						text="View Company Jobs"
						link="/recruiter/jobs"
					/>
				</div>
			</form>
		</div>
	</div>
</template>

<style scoped>
.post-job-container {
	min-height: calc(100vh - var(--header-height, 80px));
	background-color: var(--color-background);
	padding: 2rem 0;
}

.post-job-wrapper {
	max-width: 800px;
	margin: 0 auto;
	padding: 0 1.5rem;
}

.post-job-header {
	text-align: center;
	margin-bottom: 3rem;
}

.post-job-title {
	font-size: 2.5rem;
	font-weight: 700;
	color: var(--color-text-primary);
	margin-bottom: 0.5rem;
}

.post-job-subtitle {
	font-size: 1.125rem;
	color: var(--color-text-secondary);
	margin: 0;
}

.access-denied-message {
	color: var(--color-warning);
	font-weight: 500;
	margin: 0;
}

.access-denied-content {
	display: flex;
	justify-content: center;
	align-items: center;
	min-height: 400px;
}

.access-denied-card {
	background: white;
	border-radius: 12px;
	border: 1px solid var(--color-border);
	padding: 3rem;
	text-align: center;
	max-width: 500px;
	box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
}

.access-denied-icon {
	color: var(--color-warning);
	margin-bottom: 1.5rem;
}

.access-denied-title {
	font-size: 1.5rem;
	font-weight: 600;
	color: var(--color-text-primary);
	margin-bottom: 1rem;
}

.access-denied-description {
	color: var(--color-text-secondary);
	line-height: 1.6;
	margin-bottom: 2rem;
}

.access-denied-actions {
	display: flex;
	gap: 1rem;
	justify-content: center;
	flex-wrap: wrap;
}

.post-job-form {
	background: white;
	border-radius: 12px;
	border: 1px solid var(--color-border);
	padding: 2rem;
	box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
}

.form-section {
	margin-bottom: 2.5rem;
}

.form-section:last-of-type {
	margin-bottom: 1.5rem;
}

.section-title {
	font-size: 1.25rem;
	font-weight: 600;
	color: var(--color-text-primary);
	margin-bottom: 1.5rem;
	padding-bottom: 0.5rem;
	border-bottom: 1px solid var(--color-border);
}

.form-group {
	margin-bottom: 1.5rem;
}

.form-row {
	display: grid;
	grid-template-columns: 1fr 1fr;
	gap: 1.5rem;
	align-items: flex-end;
	margin-bottom: 1.5rem;
}

.form-row .form-group {
	margin-bottom: 0;
}

.form-label {
	display: block;
	font-weight: 500;
	color: var(--color-text-primary);
	margin-bottom: 0.5rem;
	font-size: 0.875rem;
}

.form-input,
.form-select,
.form-textarea {
	width: 100%;
	padding: 0.75rem;
	border: 1px solid var(--color-border);
	border-radius: 6px;
	font-size: 1rem;
	transition: border-color 0.2s;
}

.form-input:focus,
.form-select:focus,
.form-textarea:focus {
	outline: none;
	border-color: var(--color-primary);
	box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
}

.form-input.error,
.form-textarea.error {
	border-color: var(--color-error);
}

.form-checkbox {
	margin-right: 0.5rem;
}

.form-textarea {
	resize: vertical;
	min-height: 100px;
}

.input-with-button {
	display: flex;
	gap: 0.75rem;
	align-items: flex-start;
}

.input-with-button .form-input {
	flex: 1;
}

.add-button {
	padding: 0.75rem 1rem;
	background-color: var(--color-primary);
	color: white;
	border: none;
	border-radius: 6px;
	font-weight: 500;
	cursor: pointer;
	transition: background-color 0.2s;
	white-space: nowrap;
}

.add-button:hover:not(:disabled) {
	background-color: var(--color-primary-dark);
}

.add-button:disabled {
	opacity: 0.5;
	cursor: not-allowed;
}

.tags-list {
	display: flex;
	flex-wrap: wrap;
	gap: 0.5rem;
	margin-top: 0.75rem;
}

.tag {
	display: inline-flex;
	align-items: center;
	background-color: var(--color-primary-light);
	color: var(--color-primary-dark);
	padding: 0.375rem 0.75rem;
	border-radius: 20px;
	font-size: 0.875rem;
	font-weight: 500;
}

.tag-remove {
	background: none;
	border: none;
	color: var(--color-primary-dark);
	font-size: 1.125rem;
	line-height: 1;
	cursor: pointer;
	margin-left: 0.5rem;
	padding: 0;
	width: 16px;
	height: 16px;
	display: flex;
	align-items: center;
	justify-content: center;
}

.tag-remove:hover {
	color: var(--color-error);
}

.form-errors {
	margin-top: 0.5rem;
}

.form-error {
	display: block;
	color: var(--color-error);
	font-size: 0.875rem;
	margin-top: 0.25rem;
}

.form-actions {
	display: flex;
	justify-content: flex-end;
	gap: 1rem;
	padding-top: 1.5rem;
	border-top: 1px solid var(--color-border);
}

.message {
	padding: 1rem;
	border-radius: 6px;
	margin-bottom: 1.5rem;
	font-weight: 500;
}

.message.success {
	background-color: var(--color-success-light);
	color: var(--color-success-dark);
	border: 1px solid var(--color-success);
}

.message.error {
	background-color: var(--color-error-light);
	color: var(--color-error-dark);
	border: 1px solid var(--color-error);
}

@media (max-width: 768px) {
	.post-job-wrapper {
		padding: 0 1rem;
	}

	.post-job-form {
		padding: 1.5rem;
	}

	.form-row {
		grid-template-columns: 1fr;
		gap: 1rem;
	}

	.form-actions {
		flex-direction: column;
	}

	.access-denied-card {
		padding: 2rem;
		margin: 0 1rem;
	}

	.access-denied-actions {
		flex-direction: column;
	}
}
</style>
