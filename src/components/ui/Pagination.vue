<template>
	<div v-if="totalPages > 0" class="pagination">
		<BaseButton 
			@click="handlePrevPage"
			@keydown="handleKeyDown"
			tabindex="0"
			aria-label="Previous page"
			variant="pagination"
			size="medium"
			text="&laquo;"
			:disabled="currentPage === 1"
		/>
		
		<BaseButton 
			v-for="page in visiblePages"
			:key="page"
			@click="handlePageClick(page)"
			@keydown="handleKeyDown"
			tabindex="0"
			:aria-label="`Page ${page}`"
			variant="pagination"
			size="medium"
			:text="page.toString()"
			:active="page === currentPage"
		/>
		
		<BaseButton 
			@click="handleNextPage"
			@keydown="handleKeyDown"
			tabindex="0"
			aria-label="Next page"
			variant="pagination"
			size="medium"
			text="&raquo;"
			:disabled="currentPage === totalPages"
		/>
	</div>
</template>

<script setup lang="ts">
defineOptions({
	name: 'BasePagination'
})

import { computed } from 'vue';
import BaseButton from './Button.vue';

interface Props {
	currentPage: number
	totalPages: number
	maxVisiblePages?: number
}

interface Emits {
	(e: 'page-change', page: number): void
	(e: 'prev-page'): void
	(e: 'next-page'): void
}

const props = withDefaults(defineProps<Props>(), {
	maxVisiblePages: 5
});

const emit = defineEmits<Emits>();

const visiblePages = computed(() => {
	const pages: number[] = [];
	const { currentPage, totalPages, maxVisiblePages } = props;
	
	if (totalPages <= maxVisiblePages) {
		for (let i = 1; i <= totalPages; i++) {
			pages.push(i);
		}
		return pages;
	}
	
	let startPage = Math.max(1, currentPage - Math.floor(maxVisiblePages / 2));
	const endPage = Math.min(totalPages, startPage + maxVisiblePages - 1);
	
	if (endPage - startPage + 1 < maxVisiblePages) {
		startPage = Math.max(1, endPage - maxVisiblePages + 1);
	}
	
	for (let i = startPage; i <= endPage; i++) {
		pages.push(i);
	}
	
	return pages;
});

function handlePageClick(page: number) {
	if (page !== props.currentPage) {
		emit('page-change', page);
	}
}

function handlePrevPage() {
	if (props.currentPage > 1) {
		emit('prev-page');
		emit('page-change', props.currentPage - 1);
	}
}

function handleNextPage() {
	if (props.currentPage < props.totalPages) {
		emit('next-page');
		emit('page-change', props.currentPage + 1);
	}
}

function handleKeyDown(event: KeyboardEvent) {
	if (event.key === 'Enter' || event.key === ' ') {
		event.preventDefault();
		(event.target as HTMLElement).click();
	}
}
</script>

<style scoped>
.pagination {
	display: flex;
	justify-content: center;
	align-items: center;
	gap: 8px;
}
</style> 