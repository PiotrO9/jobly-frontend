import { ref } from 'vue'
import { useDatabase } from './useDatabase'
import type { Job } from '@/types/supabase'

interface JobFormData {
	title: string
	company_id: string
	location?: string
	employment_type: 'Full-time' | 'Part-time' | 'Contract' | 'Internship'
	experience_level: 'Junior' | 'Mid' | 'Senior' | 'Lead'
	salary_min?: number | null
	salary_max?: number | null
	currency: string
	description?: string
	skills?: string[]
	requirements?: string[]
	benefits?: string[]
	equity?: number | null
	remote_allowed: boolean
	status: 'active' | 'closed' | 'draft'
}

export function useJobManagement() {
	const { select, insert, update, remove } = useDatabase<Job>()
	
	const jobs = ref<Job[]>([])
	const jobLoading = ref(false)
	const jobError = ref<Error | null>(null)

	async function createJob(jobData: JobFormData) {
		try {
			jobLoading.value = true
			jobError.value = null

			const { data, error: insertError } = await insert('jobs', {
				...jobData,
				posted_days_ago: 0,
				views_count: 0,
				applications_count: 0
			})

			if (insertError) {
				jobError.value = insertError as Error
				return { success: false, error: insertError }
			}

			return { success: true, data: data?.[0] }
		} catch (err) {
			jobError.value = err as Error
			return { success: false, error: err }
		} finally {
			jobLoading.value = false
		}
	}

	async function updateJob(jobId: string, jobData: Partial<JobFormData>) {
		try {
			jobLoading.value = true
			jobError.value = null

			const { data, error: updateError } = await update('jobs', jobData, { id: jobId })

			if (updateError) {
				jobError.value = updateError as Error
				return { success: false, error: updateError }
			}

			return { success: true, data: data?.[0] }
		} catch (err) {
			jobError.value = err as Error
			return { success: false, error: err }
		} finally {
			jobLoading.value = false
		}
	}

	async function deleteJob(jobId: string) {
		try {
			jobLoading.value = true
			jobError.value = null

			const { data, error: deleteError } = await remove('jobs', { id: jobId })

			if (deleteError) {
				jobError.value = deleteError as Error
				return { success: false, error: deleteError }
			}

			return { success: true, data: data }
		} catch (err) {
			jobError.value = err as Error
			return { success: false, error: err }
		} finally {
			jobLoading.value = false
		}
	}

	async function fetchCompanyJobs(companyId: string) {
		try {
			jobLoading.value = true
			jobError.value = null

			const { data, error: fetchError } = await select('jobs', {
				columns: `
					id,
					title,
					location,
					posted_days_ago,
					employment_type,
					experience_level,
					salary_min,
					salary_max,
					currency,
					status,
					views_count,
					applications_count,
					created_at,
					updated_at,
					companies (
						id,
						name,
						logo_url
					)
				`,
				filters: { company_id: companyId },
				orderBy: { column: 'created_at', ascending: false }
			})

			if (fetchError) {
				jobError.value = fetchError as Error
				return { success: false, error: fetchError }
			}

			jobs.value = data || []
			return { success: true, data: data || [] }
		} catch (err) {
			jobError.value = err as Error
			return { success: false, error: err }
		} finally {
			jobLoading.value = false
		}
	}

	async function getJobById(jobId: string) {
		try {
			jobLoading.value = true
			jobError.value = null

			const { data, error: fetchError } = await select('jobs', {
				columns: `
					id,
					title,
					company_id,
					location,
					posted_days_ago,
					employment_type,
					experience_level,
					salary_min,
					salary_max,
					currency,
					description,
					skills,
					requirements,
					benefits,
					equity,
					remote_allowed,
					status,
					views_count,
					applications_count,
					created_at,
					updated_at,
					companies (
						id,
						name,
						description,
						logo_url
					)
				`,
				filters: { id: jobId }
			})

			if (fetchError) {
				jobError.value = fetchError as Error
				return { success: false, error: fetchError }
			}

			if (data && data.length > 0) {
				return { success: true, data: data[0] }
			}

			return { success: false, error: new Error('Job not found') }
		} catch (err) {
			jobError.value = err as Error
			return { success: false, error: err }
		} finally {
			jobLoading.value = false
		}
	}

	async function updateJobStatus(jobId: string, status: 'active' | 'closed' | 'draft') {
		try {
			jobLoading.value = true
			jobError.value = null

			const { data, error: updateError } = await update('jobs', 
				{ status },
				{ id: jobId }
			)

			if (updateError) {
				jobError.value = updateError as Error
				return { success: false, error: updateError }
			}

			// Update local jobs array if exists
			const jobIndex = jobs.value.findIndex(job => job.id === jobId)
			if (jobIndex !== -1 && data?.[0]) {
				jobs.value[jobIndex] = data[0]
			}

			return { success: true, data: data?.[0] }
		} catch (err) {
			jobError.value = err as Error
			return { success: false, error: err }
		} finally {
			jobLoading.value = false
		}
	}

	function clearJobs() {
		jobs.value = []
		jobError.value = null
	}

	function clearError() {
		jobError.value = null
	}

	return {
		jobs,
		jobLoading,
		jobError,
		
		createJob,
		updateJob,
		deleteJob,
		fetchCompanyJobs,
		getJobById,
		updateJobStatus,
		clearJobs,
		clearError
	}
} 