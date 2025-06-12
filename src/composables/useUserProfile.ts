import { ref, computed } from 'vue'
import { useDatabase } from './useDatabase'
import type { UserProfile } from '@/types/supabase'

export function useUserProfile() {
	const { select, update, insert } = useDatabase<UserProfile>()
	
	const userProfile = ref<UserProfile | null>(null)
	const profileLoading = ref(false)
	const profileError = ref<Error | null>(null)

	const isRecruiter = computed(() => userProfile.value?.is_recruiter ?? false)
	const canPostJobs = computed(() => isRecruiter.value)
	const userCompanyId = computed(() => userProfile.value?.company_id)

	async function fetchUserProfile(userId: string) {
		try {
			profileLoading.value = true
			profileError.value = null

			const { data, error: fetchError } = await select('user_profiles', {
				columns: `
					id,
					email,
					first_name,
					last_name,
					username,
					bio,
					avatar_url,
					location,
					website_url,
					linkedin_url,
					github_url,
					skills,
					experience_years,
					resume_url,
					is_recruiter,
					company_id,
					created_at,
					updated_at,
					companies (
						id,
						handle,
						name,
						description,
						logo_url
					)
				`,
				filters: { id: userId }
			})

			if (fetchError) {
				profileError.value = fetchError as Error
				return { success: false, error: fetchError }
			}

			if (data && data.length > 0) {
				userProfile.value = data[0]
				return { success: true, data: data[0] }
			}

			return { success: false, error: new Error('Profile not found') }
		} catch (err) {
			profileError.value = err as Error
			return { success: false, error: err }
		} finally {
			profileLoading.value = false
		}
	}

	async function updateUserProfile(userId: string, profileData: Partial<UserProfile>) {
		try {
			profileLoading.value = true
			profileError.value = null

			const { data, error: updateError } = await update('user_profiles', profileData, { id: userId })

			if (updateError) {
				profileError.value = updateError as Error
				return { success: false, error: updateError }
			}

			if (data && data.length > 0) {
				userProfile.value = data[0]
				return { success: true, data: data[0] }
			}

			return { success: false, error: new Error('Profile update failed') }
		} catch (err) {
			profileError.value = err as Error
			return { success: false, error: err }
		} finally {
			profileLoading.value = false
		}
	}

	async function createUserProfile(profileData: Partial<UserProfile>) {
		try {
			profileLoading.value = true
			profileError.value = null

			const { data, error: insertError } = await insert('user_profiles', profileData)

			if (insertError) {
				profileError.value = insertError as Error
				return { success: false, error: insertError }
			}

			if (data && data.length > 0) {
				userProfile.value = data[0]
				return { success: true, data: data[0] }
			}

			return { success: false, error: new Error('Profile creation failed') }
		} catch (err) {
			profileError.value = err as Error
			return { success: false, error: err }
		} finally {
			profileLoading.value = false
		}
	}

	function clearProfile() {
		userProfile.value = null
		profileError.value = null
	}

	function clearError() {
		profileError.value = null
	}

	return {
		userProfile,
		profileLoading,
		profileError,
		isRecruiter,
		canPostJobs,
		userCompanyId,
		
		fetchUserProfile,
		updateUserProfile,
		createUserProfile,
		clearProfile,
		clearError
	}
} 