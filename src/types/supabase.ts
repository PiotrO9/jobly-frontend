export interface DatabaseResponse<T> {
	data: T[] | null
	error: Error | null
}

export interface SingleResponse<T> {
	data: T | null
	error: Error | null
}

export interface Company {
	id: string
	handle: string
	name: string
	description?: string
	num_employees?: number
	logo_url?: string
	created_at: string
	updated_at: string
}

export interface Job {
	id: string
	title: string
	company_id: string
	location?: string
	posted_days_ago: number
	employment_type: 'Full-time' | 'Part-time' | 'Contract' | 'Internship'
	experience_level: 'Junior' | 'Mid' | 'Senior' | 'Lead'
	salary_min?: number
	salary_max?: number
	currency: string
	description?: string
	skills?: string[]
	requirements?: string[]
	benefits?: string[]
	equity?: number
	remote_allowed: boolean
	status: 'active' | 'closed' | 'draft'
	views_count: number
	applications_count: number
	created_at: string
	updated_at: string
	company?: Company
	categories?: JobCategory[]
}

export interface UserProfile {
	id: string
	email: string
	first_name?: string
	last_name?: string
	username?: string
	bio?: string
	avatar_url?: string
	location?: string
	website_url?: string
	linkedin_url?: string
	github_url?: string
	skills?: string[]
	experience_years?: number
	resume_url?: string
	is_recruiter: boolean
	company_id?: string
	created_at: string
	updated_at: string
	company?: Company
}

export interface Application {
	id: string
	user_id: string
	job_id: string
	status: 'pending' | 'reviewed' | 'interview' | 'accepted' | 'rejected'
	cover_letter?: string
	resume_url?: string
	applied_at: string
	updated_at: string
	job?: Job
	user?: UserProfile
}

export interface SavedJob {
	id: string
	user_id: string
	job_id: string
	created_at: string
	job?: Job
}

export interface JobCategory {
	id: string
	name: string
	description?: string
	color: string
	created_at: string
}

export interface DatabaseTable {
	id: string
	created_at: string
	updated_at: string
}

export interface QueryOptions {
	columns?: string
	filters?: Record<string, unknown>
	orderBy?: {
		column: string
		ascending?: boolean
	}
	limit?: number
	offset?: number
}

export interface SubscriptionOptions {
	event?: 'INSERT' | 'UPDATE' | 'DELETE' | '*'
	schema?: string
	filter?: string
}

export interface SignUpForm {
	email: string
	password: string
	confirmPassword?: string
	userData?: Record<string, unknown>
}

export interface SignInForm {
	email: string
	password: string
	rememberMe?: boolean
}

export interface ResetPasswordForm {
	email: string
}

export interface SupabaseError {
	message: string
	details?: string
	hint?: string
	code?: string
} 