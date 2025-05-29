export interface Job {
	id: string;
	title: string;
	company: string;
	location: string;
	postedDays: number;
	type: string;
	experience: string;
	salaryMin: number;
	salaryMax: number;
	description: string;
	skills: string[];
	requirements?: string[];
	benefits?: string[];
	equity?: number;
	remoteAllowed?: boolean;
	currency?: string;
	category?: string;
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
	category?: string;
}

export interface JobCardProps {
	job: Job;
}

export interface JobCategory {
	id: string;
	name: string;
	description?: string;
} 