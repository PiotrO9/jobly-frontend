export interface Job {
	id: number;
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