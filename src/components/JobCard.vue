<template>
	<div class="job-card">
		<div class="job-header">
			<div class="job-info">
				<h3 
					class="job-title"
					@click="handleViewDetails"
					@keydown="handleTitleKeyDown"
					tabindex="0"
					role="button"
					aria-label="View job details"
				>
					{{ job.title }}
				</h3>
				<p class="job-company">{{ job.company }} • {{ job.location }}</p>
			</div>
			<div class="job-meta">
				<span class="job-salary">{{ job.salaryMin }}k - {{ job.salaryMax }}k PLN</span>
				<p class="job-posted">{{ job.postedDays }} dni temu</p>
			</div>
		</div>
		
		<p class="job-description">{{ job.description }}</p>
		
		<div class="job-footer">
			<div class="job-tags">
				<span class="tag tag-type">{{ job.type }}</span>
				<span class="tag tag-experience">{{ job.experience }}</span>
				<span 
					v-for="skill in job.skills" 
					:key="skill"
					class="tag tag-skill"
				>
					{{ skill }}
				</span>
			</div>
			<Button 
				@click="handleViewDetails"
				@keydown="handleDetailsKeyDown"
				tabindex="0"
				aria-label="See job details"
				variant="details"
				text="Details"
			/>
		</div>
	</div>
</template>

<script setup lang="ts">
import { useRouter } from 'vue-router';
import Button from '@/components/ui/Button.vue';
import type { JobCardProps } from '@/types/job';

const props = defineProps<JobCardProps>();
const router = useRouter();

function handleViewDetails() {
	router.push(`/jobs/${props.job.id}`);
}

function handleTitleKeyDown(event: KeyboardEvent) {
	if (event.key === 'Enter' || event.key === ' ') {
		event.preventDefault();
		handleViewDetails();
	}
}

function handleDetailsKeyDown(event: KeyboardEvent) {
	if (event.key === 'Enter' || event.key === ' ') {
		event.preventDefault();
		handleViewDetails();
	}
}
</script>

<style scoped>
.job-card {
	background: #ffffff;
	padding: 16px;
	border: 1px solid #e5e7eb;
	border-radius: 8px;
	display: flex;
	flex-direction: column;
	box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.1);
	transition: box-shadow 0.2s ease-in-out;
	font-family: 'Roboto', sans-serif;
}

.job-card:hover {
	box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
}

.job-header {
	display: flex;
	justify-content: space-between;
	align-items: flex-start;
	margin-bottom: 12px;
}

.job-info {
	flex: 1;
}

.job-title {
	display: inline-block;
	font-size: 18px;
	font-weight: 600;
	color: #2563eb;
	margin: 0 0 4px 0;
	font-family: 'Roboto', sans-serif;
	cursor: pointer;
	transition: color 0.2s ease-in-out;
	border: none;
	background: none;
	padding: 0;
	text-align: left;
	line-height: 1.2;
}

.job-title:hover {
	color: #1d4ed8;
	text-decoration: underline;
}

.job-title:focus {
	outline: none;
	box-shadow: 0 0 0 2px #3b82f6, 0 0 0 4px rgba(59, 130, 246, 0.1);
	border-radius: 2px;
}

.job-company {
	font-size: 14px;
	color: #6b7280;
	margin: 0;
	font-family: 'Roboto', sans-serif;
}

.job-meta {
	text-align: right;
}

.job-salary {
	font-size: 14px;
	font-weight: 500;
	color: #059669;
	font-family: 'Roboto', sans-serif;
}

.job-posted {
	font-size: 12px;
	color: #9ca3af;
	margin: 4px 0 0 0;
	font-family: 'Roboto', sans-serif;
}

.job-description {
	font-size: 14px;
	color: #374151;
	margin: 0 0 16px 0;
	flex: 1;
	line-height: 1.5;
	font-family: 'Roboto', sans-serif;
}

.job-footer {
	display: flex;
	justify-content: space-between;
	align-items: center;
}

.job-tags {
	display: flex;
	gap: 8px;
	flex-wrap: wrap;
}

.tag {
	padding: 4px 8px;
	font-size: 12px;
	border-radius: 6px;
	font-weight: 500;
	font-family: 'Roboto', sans-serif;
}

.tag-type {
	background-color: #dbeafe;
	color: #1e40af;
}

.tag-experience {
	background-color: #ede9fe;
	color: #7c3aed;
}

.tag-skill {
	background-color: #f3f4f6;
	color: #374151;
}
</style>


