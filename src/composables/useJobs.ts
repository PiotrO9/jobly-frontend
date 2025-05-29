import { ref, type Ref } from 'vue'
import { useDatabase } from './useDatabase'
import type { Job as DatabaseJob } from '@/types/supabase'
import type { Job as ComponentJob, Filters } from '@/types/job'

interface QueryOptions {
	columns: string
	filters: Record<string, unknown>
	orderBy: { column: string; ascending: boolean }
}

export function useJobs() {
	const { select, loading, error } = useDatabase<DatabaseJob>()
	
	const jobs: Ref<ComponentJob[]> = ref([])
	const currentPage = ref(1)
	const itemsPerPage = 10
	
	function transformDatabaseJobToComponent(dbJob: DatabaseJob & { 
		company?: { id: string; name: string; description?: string; logo_url?: string }
		job_category_relations?: Array<{ job_categories: { id: string; name: string } }>
	}): ComponentJob {
		const categories = dbJob.job_category_relations?.map(relation => relation.job_categories) || []
		const primaryCategory = categories.length > 0 ? categories[0].id : undefined

		return {
			id: dbJob.id,
			title: dbJob.title,
			company: dbJob.company?.name || 'Unknown Company',
			location: dbJob.location || 'Remote',
			postedDays: dbJob.posted_days_ago,
			type: dbJob.employment_type,
			experience: dbJob.experience_level,
			salaryMin: dbJob.salary_min || 0,
			salaryMax: dbJob.salary_max || 0,
			description: dbJob.description || '',
			skills: dbJob.skills || [],
			requirements: dbJob.requirements || [],
			benefits: dbJob.benefits || [],
			equity: dbJob.equity || 0,
			remoteAllowed: dbJob.remote_allowed || false,
			currency: dbJob.currency || 'PLN',
			category: primaryCategory,
			companyDetails: dbJob.company ? {
				id: dbJob.company.id,
				name: dbJob.company.name,
				description: dbJob.company.description,
				logoUrl: dbJob.company.logo_url
			} : undefined
		}
	}
	
	async function fetchJobs(filters?: Partial<Filters>) {
		try {
			const queryOptions: QueryOptions = {
				columns: `
					id,
					title,
					location,
					posted_days_ago,
					employment_type,
					experience_level,
					salary_min,
					salary_max,
					description,
					skills,
					companies (
						name
					),
					job_category_relations (
						job_categories (
							id,
							name
						)
					)
				`,
				filters: { status: 'active' },
				orderBy: { column: 'created_at', ascending: false }
			}
			
			if (filters) {
				if (filters.location) {
					queryOptions.filters.location = `ilike.%${filters.location}%`
				}
				if (filters.experience) {
					queryOptions.filters.experience_level = filters.experience
				}
				if (filters.types && filters.types.length > 0) {
					queryOptions.filters.employment_type = `in.(${filters.types.join(',')})`
				}
			}
			
			const { data: jobsData, error: fetchError } = await select('jobs', queryOptions)
			
			if (fetchError) {
				console.error('Error fetching jobs:', fetchError)
				return { success: false, error: fetchError }
			}
			
			if (jobsData) {
				jobs.value = jobsData.map(transformDatabaseJobToComponent)
			}
			
			return { success: true, data: jobs.value }
		} catch (err) {
			console.error('Error in fetchJobs:', err)
			return { success: false, error: err }
		}
	}
	
	function filterJobs(filters: Filters): ComponentJob[] {
		return jobs.value.filter(job => {
			const matchesKeyword = !filters.keyword || 
				job.title.toLowerCase().includes(filters.keyword.toLowerCase())
			
			const matchesLocation = !filters.location || 
				job.location.toLowerCase().includes(filters.location.toLowerCase())
			
			const matchesType = !filters.types.length || 
				filters.types.includes(job.type)
			
			const matchesExperience = !filters.experience || 
				job.experience === filters.experience
			
			const matchesPosted = !filters.posted || 
				job.postedDays <= Number(filters.posted)
			
			const matchesSkills = !filters.skills || 
				filters.skills.split(',')
					.map(s => s.trim().toLowerCase())
					.every(s => job.skills.map(js => js.toLowerCase()).includes(s))
			
			const matchesSalary = job.salaryMax >= filters.salaryMin && 
				job.salaryMin <= filters.salaryMax
			
			const matchesCategory = !filters.category || 
				job.category === filters.category
			
			return matchesKeyword && matchesLocation && matchesType && 
				matchesExperience && matchesPosted && matchesSkills && matchesSalary && matchesCategory
		})
	}
	
	function getPaginatedJobs(filteredJobs: ComponentJob[], page: number = currentPage.value): ComponentJob[] {
		const start = (page - 1) * itemsPerPage
		const end = start + itemsPerPage
		return filteredJobs.slice(start, end)
	}
	
	function getTotalPages(filteredJobs: ComponentJob[]): number {
		return Math.ceil(filteredJobs.length / itemsPerPage)
	}
	
	async function searchJobs(searchTerm: string, filters?: Partial<Filters>) {
		try {
			const queryOptions: QueryOptions & { filters: Record<string, unknown> } = {
				columns: `
					id,
					title,
					location,
					posted_days_ago,
					employment_type,
					experience_level,
					salary_min,
					salary_max,
					description,
					skills,
					companies (
						name
					),
					job_category_relations (
						job_categories (
							id,
							name
						)
					)
				`,
				filters: { 
					status: 'active',
					or: `title.ilike.%${searchTerm}%,description.ilike.%${searchTerm}%,companies.name.ilike.%${searchTerm}%`
				},
				orderBy: { column: 'created_at', ascending: false }
			}
			
			const { data: jobsData, error: searchError } = await select('jobs', queryOptions)
			
			if (searchError) {
				console.error('Error searching jobs:', searchError)
				return { success: false, error: searchError }
			}
			
			if (jobsData) {
				const searchResults = jobsData.map(transformDatabaseJobToComponent)
				const filtered = filters ? searchResults.filter(job => {
					return filterJobs(filters as Filters).includes(job)
				}) : searchResults
				
				return { success: true, data: filtered }
			}
			
			return { success: true, data: [] }
		} catch (err) {
			console.error('Error in searchJobs:', err)
			return { success: false, error: err }
		}
	}
	
	async function getJobById(jobId: string) {
		try {
			const { data: jobsData, error: fetchError } = await select('jobs', {
				columns: `
					id,
					title,
					location,
					posted_days_ago,
					employment_type,
					experience_level,
					salary_min,
					salary_max,
					description,
					skills,
					requirements,
					benefits,
					equity,
					remote_allowed,
					companies (
						id,
						name,
						description,
						logo_url
					),
					job_category_relations (
						job_categories (
							id,
							name
						)
					)
				`,
				filters: { id: jobId, status: 'active' }
			})
			
			if (fetchError) {
				console.error('Error fetching job:', fetchError)
				return { success: false, error: fetchError }
			}
			
			if (jobsData && jobsData.length > 0) {
				const job = transformDatabaseJobToComponent(jobsData[0])
				return { success: true, data: job }
			}
			
			return { success: false, error: new Error('Job not found') }
		} catch (err) {
			console.error('Error in getJobById:', err)
			return { success: false, error: err }
		}
	}
	
	return {
		jobs,
		loading,
		error,
		currentPage,
		itemsPerPage,
		
		fetchJobs,
		filterJobs,
		getPaginatedJobs,
		getTotalPages,
		searchJobs,
		getJobById,
		
		transformDatabaseJobToComponent
	}
} 