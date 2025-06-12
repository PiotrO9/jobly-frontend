import { ref, computed } from 'vue'
import { useDatabase } from './useDatabase'
import type { Application } from '@/types/supabase'

export function useApplications() {
	const { select, insert, update } = useDatabase<Application>()
	
	const applications = ref<Application[]>([])
	const applicationsLoading = ref(false)
	const applicationsError = ref<Error | null>(null)

	async function fetchUserApplications(userId: string) {
		try {
			applicationsLoading.value = true
			applicationsError.value = null

			const { data, error: fetchError } = await select('applications', {
				columns: `
					id,
					user_id,
					job_id,
					status,
					cover_letter,
					resume_url,
					applied_at,
					updated_at,
					job:jobs (
						id,
						title,
						location,
						employment_type,
						experience_level,
						salary_min,
						salary_max,
						company:companies (
							id,
							name,
							logo_url
						)
					)
				`,
				filters: { user_id: userId },
				orderBy: { column: 'applied_at', ascending: false }
			})

			if (fetchError) {
				applicationsError.value = fetchError as Error
				return { success: false, error: fetchError }
			}

			applications.value = data || []
			return { success: true, data: data || [] }
		} catch (err) {
			applicationsError.value = err as Error
			return { success: false, error: err }
		} finally {
			applicationsLoading.value = false
		}
	}

	async function fetchJobApplications(jobId: string) {
		try {
			applicationsLoading.value = true
			applicationsError.value = null

			const { data, error: fetchError } = await select('applications', {
				columns: `
					id,
					user_id,
					job_id,
					status,
					cover_letter,
					resume_url,
					applied_at,
					updated_at,
					user:user_profiles (
						id,
						email,
						first_name,
						last_name,
						avatar_url,
						location,
						skills,
						experience_years,
						resume_url,
						linkedin_url,
						github_url
					)
				`,
				filters: { job_id: jobId },
				orderBy: { column: 'applied_at', ascending: false }
			})

			if (fetchError) {
				applicationsError.value = fetchError as Error
				return { success: false, error: fetchError }
			}

			applications.value = data || []
			return { success: true, data: data || [] }
		} catch (err) {
			applicationsError.value = err as Error
			return { success: false, error: err }
		} finally {
			applicationsLoading.value = false
		}
	}

	async function fetchCompanyApplications(companyId: string) {
		try {
			applicationsLoading.value = true
			applicationsError.value = null

			const { data, error: fetchError } = await select('applications', {
				columns: `
					id,
					user_id,
					job_id,
					status,
					cover_letter,
					resume_url,
					applied_at,
					updated_at,
					job:jobs!inner (
						id,
						title,
						location,
						employment_type,
						experience_level,
						company_id
					),
					user:user_profiles (
						id,
						email,
						first_name,
						last_name,
						avatar_url,
						location,
						skills,
						experience_years,
						resume_url,
						linkedin_url,
						github_url
					)
				`,
				orderBy: { column: 'applied_at', ascending: false }
			})

			if (fetchError) {
				applicationsError.value = fetchError as Error
				return { success: false, error: fetchError }
			}

			// Filter applications for jobs from this company
			const companyApplications = data?.filter(app => 
				app.job && 'company_id' in app.job && app.job.company_id === companyId
			) || []

			applications.value = companyApplications
			return { success: true, data: companyApplications }
		} catch (err) {
			applicationsError.value = err as Error
			return { success: false, error: err }
		} finally {
			applicationsLoading.value = false
		}
	}

	async function createApplication(applicationData: {
		user_id: string
		job_id: string
		cover_letter?: string
		resume_url?: string
	}) {
		try {
			applicationsLoading.value = true
			applicationsError.value = null

			const { data, error: insertError } = await insert('applications', {
				...applicationData,
				status: 'pending'
			})

			if (insertError) {
				applicationsError.value = insertError as Error
				return { success: false, error: insertError }
			}

			return { success: true, data: data?.[0] }
		} catch (err) {
			applicationsError.value = err as Error
			return { success: false, error: err }
		} finally {
			applicationsLoading.value = false
		}
	}

	async function updateApplicationStatus(
		applicationId: string, 
		status: 'pending' | 'reviewed' | 'interview' | 'accepted' | 'rejected'
	) {
		try {
			applicationsLoading.value = true
			applicationsError.value = null

			const { data, error: updateError } = await update('applications', 
				{ status, updated_at: new Date().toISOString() },
				{ id: applicationId }
			)

			if (updateError) {
				applicationsError.value = updateError as Error
				return { success: false, error: updateError }
			}

			// Update local applications array
			const applicationIndex = applications.value.findIndex(app => app.id === applicationId)
			if (applicationIndex !== -1 && data?.[0]) {
				applications.value[applicationIndex] = data[0]
			}

			return { success: true, data: data?.[0] }
		} catch (err) {
			applicationsError.value = err as Error
			return { success: false, error: err }
		} finally {
			applicationsLoading.value = false
		}
	}

	async function checkExistingApplication(userId: string, jobId: string) {
		try {
			const { data, error: fetchError } = await select('applications', {
				columns: 'id, status',
				filters: { user_id: userId, job_id: jobId }
			})

			if (fetchError) {
				return { exists: false, error: fetchError }
			}

			return { 
				exists: data && data.length > 0, 
				application: data?.[0] || null 
			}
		} catch (err) {
			return { exists: false, error: err }
		}
	}

	const pendingApplications = computed(() => 
		applications.value.filter(app => app.status === 'pending')
	)

	const reviewedApplications = computed(() => 
		applications.value.filter(app => app.status === 'reviewed')
	)

	const interviewApplications = computed(() => 
		applications.value.filter(app => app.status === 'interview')
	)

	const acceptedApplications = computed(() => 
		applications.value.filter(app => app.status === 'accepted')
	)

	const rejectedApplications = computed(() => 
		applications.value.filter(app => app.status === 'rejected')
	)

	function clearApplications() {
		applications.value = []
		applicationsError.value = null
	}

	function clearError() {
		applicationsError.value = null
	}

	return {
		applications,
		applicationsLoading,
		applicationsError,
		pendingApplications,
		reviewedApplications,
		interviewApplications,
		acceptedApplications,
		rejectedApplications,
		
		fetchUserApplications,
		fetchJobApplications,
		fetchCompanyApplications,
		createApplication,
		updateApplicationStatus,
		checkExistingApplication,
		clearApplications,
		clearError
	}
} 