export interface Job {
	id: string; // Changed to string (UUID from database)
	title: string;
	company: string; // This will be populated from company relation
	location: string;
	postedDays: number; // Maps to posted_days_ago from database
	type: string; // Maps to employment_type from database
	experience: string; // Maps to experience_level from database
	salaryMin: number; // Maps to salary_min from database
	salaryMax: number; // Maps to salary_max from database
	description: string;
	skills: string[];
	// Additional fields for detailed view
	requirements?: string[];
	benefits?: string[];
	equity?: number;
	remoteAllowed?: boolean;
	currency?: string;
	// Company details (when joined)
	companyDetails?: {
		id: string;
		name: string;
		description?: string;
		logoUrl?: string;
	};
}

export interface Filters {
	keyword: string;
	location: string;
	types: string[];
	experience: string;
	posted: string;
	skills: string;
	salaryMin: number;
	salaryMax: number;
}

export interface JobCardProps {
	job: Job;
} 