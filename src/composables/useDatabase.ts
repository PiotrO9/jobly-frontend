import { ref, type Ref } from 'vue'
import { supabase } from '@/lib/supabase'
import type { PostgrestError } from '@supabase/supabase-js'

export function useDatabase<T = Record<string, unknown>>() {
	// Reactive state
	const data: Ref<T[] | null> = ref(null)
	const loading = ref(false)
	const error: Ref<PostgrestError | Error | null> = ref(null)

	// Generic CRUD operations
	async function select(
		table: string,
		options?: {
			columns?: string
			filters?: Record<string, unknown>
			orderBy?: { column: string; ascending?: boolean }
			limit?: number
			offset?: number
		}
	) {
		try {
			loading.value = true
			error.value = null

			let query = supabase.from(table).select(options?.columns || '*')

			// Apply filters
			if (options?.filters) {
				Object.entries(options.filters).forEach(([key, value]) => {
					query = query.eq(key, value)
				})
			}

			// Apply ordering
			if (options?.orderBy) {
				query = query.order(options.orderBy.column, { 
					ascending: options.orderBy.ascending ?? true 
				})
			}

			// Apply pagination
			if (options?.limit) {
				query = query.limit(options.limit)
			}

			if (options?.offset) {
				query = query.range(options.offset, options.offset + (options.limit || 10) - 1)
			}

			const { data: result, error: selectError } = await query

			if (selectError) {
				error.value = selectError
				return { data: null, error: selectError }
			}

			data.value = result as T[]
			return { data: result as T[], error: null }
		} catch (err) {
			error.value = err as Error
			return { data: null, error: err }
		} finally {
			loading.value = false
		}
	}

	async function insert(table: string, values: Partial<T> | Partial<T>[]) {
		try {
			loading.value = true
			error.value = null

			const { data: result, error: insertError } = await supabase
				.from(table)
				.insert(values)
				.select()

			if (insertError) {
				error.value = insertError
				return { data: null, error: insertError }
			}

			return { data: result as T[], error: null }
		} catch (err) {
			error.value = err as Error
			return { data: null, error: err }
		} finally {
			loading.value = false
		}
	}

	async function update(
		table: string,
		values: Partial<T>,
		filters: Record<string, unknown>
	) {
		try {
			loading.value = true
			error.value = null

			let query = supabase.from(table).update(values)

			// Apply filters
			Object.entries(filters).forEach(([key, value]) => {
				query = query.eq(key, value)
			})

			const { data: result, error: updateError } = await query.select()

			if (updateError) {
				error.value = updateError
				return { data: null, error: updateError }
			}

			return { data: result as T[], error: null }
		} catch (err) {
			error.value = err as Error
			return { data: null, error: err }
		} finally {
			loading.value = false
		}
	}

	async function remove(table: string, filters: Record<string, unknown>) {
		try {
			loading.value = true
			error.value = null

			let query = supabase.from(table).delete()

			// Apply filters
			Object.entries(filters).forEach(([key, value]) => {
				query = query.eq(key, value)
			})

			const { data: result, error: deleteError } = await query.select()

			if (deleteError) {
				error.value = deleteError
				return { data: null, error: deleteError }
			}

			return { data: result as T[], error: null }
		} catch (err) {
			error.value = err as Error
			return { data: null, error: err }
		} finally {
			loading.value = false
		}
	}

	async function upsert(table: string, values: Partial<T> | Partial<T>[]) {
		try {
			loading.value = true
			error.value = null

			const { data: result, error: upsertError } = await supabase
				.from(table)
				.upsert(values)
				.select()

			if (upsertError) {
				error.value = upsertError
				return { data: null, error: upsertError }
			}

			return { data: result as T[], error: null }
		} catch (err) {
			error.value = err as Error
			return { data: null, error: err }
		} finally {
			loading.value = false
		}
	}

	// Real-time subscriptions - basic implementation
	function subscribe(table: string) {
		// This is a simplified version - can be extended with callbacks based on specific Supabase version
		return supabase
			.channel(`${table}_changes`)
			.subscribe()
	}

	function clearError() {
		error.value = null
	}

	return {
		// State
		data,
		loading,
		error,

		// Methods
		select,
		insert,
		update,
		remove,
		upsert,
		subscribe,
		clearError,

		// Direct access to supabase client
		supabase
	}
} 