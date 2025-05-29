import { ref, type Ref } from 'vue'
import { useDatabase } from './useDatabase'
import type { JobCategory } from '@/types/job'

interface DatabaseJobCategory {
	id: string
	name: string
	description?: string
	created_at: string
}

export function useJobCategories() {
	const { select, loading, error } = useDatabase<DatabaseJobCategory>()
	
	const categories: Ref<JobCategory[]> = ref([])
	
	function transformDatabaseCategoryToComponent(dbCategory: DatabaseJobCategory): JobCategory {
		return {
			id: dbCategory.id,
			name: dbCategory.name,
			description: dbCategory.description
		}
	}
	
	async function fetchCategories() {
		try {
			const { data: categoriesData, error: fetchError } = await select('job_categories', {
				columns: 'id, name, description',
				orderBy: { column: 'name', ascending: true }
			})
			
			if (fetchError) {
				console.error('Error fetching job categories:', fetchError)
				return { success: false, error: fetchError }
			}
			
			if (categoriesData) {
				categories.value = categoriesData.map(transformDatabaseCategoryToComponent)
			}
			
			return { success: true, data: categories.value }
		} catch (err) {
			console.error('Error in fetchCategories:', err)
			return { success: false, error: err }
		}
	}
	
	async function getCategoryById(categoryId: string) {
		try {
			const { data: categoryData, error: fetchError } = await select('job_categories', {
				columns: 'id, name, description',
				filters: { id: categoryId }
			})
			
			if (fetchError) {
				console.error('Error fetching category by ID:', fetchError)
				return { success: false, error: fetchError }
			}
			
			if (categoryData && categoryData.length > 0) {
				const category = transformDatabaseCategoryToComponent(categoryData[0])
				return { success: true, data: category }
			}
			
			return { success: false, error: 'Category not found' }
		} catch (err) {
			console.error('Error in getCategoryById:', err)
			return { success: false, error: err }
		}
	}
	
	return {
		categories,
		loading,
		error,
		fetchCategories,
		getCategoryById
	}
} 