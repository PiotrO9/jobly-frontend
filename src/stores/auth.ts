import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import { supabase, type User, type Session } from '@/lib/supabase'
import type { AuthError } from '@supabase/supabase-js'
import { useUserProfile } from '@/composables/useUserProfile'
import type { UserProfile } from '@/types/supabase'

export const useAuthStore = defineStore('auth', () => {
	const user = ref<User | null>(null)
	const session = ref<Session | null>(null)
	const loading = ref(true)
	const error = ref<AuthError | Error | null>(null)

	// User profile integration
	const {
		userProfile,
		profileLoading,
		fetchUserProfile,
		updateUserProfile,
		createUserProfile,
		clearProfile
	} = useUserProfile()

	const isAuthenticated = computed(() => !!user.value)
	const isLoading = computed(() => loading.value || profileLoading.value)
	const userEmail = computed(() => user.value?.email || null)
	const userId = computed(() => user.value?.id || null)
	const isRecruiter = computed(() => userProfile.value?.is_recruiter ?? false)
	const canPostJobs = computed(() => isRecruiter.value)
	const userCompanyId = computed(() => userProfile.value?.company_id)
	const fullUserProfile = computed(() => userProfile.value)

	async function signUp(email: string, password: string, userData?: object) {
		try {
			loading.value = true
			error.value = null

			const { data, error: signUpError } = await supabase.auth.signUp({
				email,
				password,
				options: {
					data: userData
				}
			})

			if (signUpError) {
				error.value = signUpError
				throw signUpError
			}

			// Create user profile after successful signup
			if (data.user) {
				const profileData: Partial<UserProfile> = {
					id: data.user.id,
					email: data.user.email || email,
					is_recruiter: false,
					...userData
				}

				await createUserProfile(profileData)
			}

			return data
		} catch (err) {
			error.value = err as Error
			throw err
		} finally {
			loading.value = false
		}
	}

	async function signIn(email: string, password: string) {
		try {
			loading.value = true
			error.value = null

			const { data, error: signInError } = await supabase.auth.signInWithPassword({
				email,
				password
			})

			if (signInError) {
				error.value = signInError
				throw signInError
			}

			// Fetch user profile after successful signin
			if (data.user) {
				await fetchUserProfile(data.user.id)
			}

			return data
		} catch (err) {
			error.value = err as Error
			throw err
		} finally {
			loading.value = false
		}
	}

	async function signOut() {
		try {
			loading.value = true
			error.value = null

			const { error: signOutError } = await supabase.auth.signOut()

			if (signOutError) {
				error.value = signOutError
				throw signOutError
			}

			// Clear user profile on signout
			clearProfile()
		} catch (err) {
			error.value = err as Error
			throw err
		} finally {
			loading.value = false
		}
	}

	async function resetPassword(email: string) {
		try {
			loading.value = true
			error.value = null

			const { error: resetError } = await supabase.auth.resetPasswordForEmail(email)

			if (resetError) {
				error.value = resetError
				throw resetError
			}
		} catch (err) {
			error.value = err as Error
			throw err
		} finally {
			loading.value = false
		}
	}

	async function updateProfile(profileData: Partial<UserProfile>) {
		if (!userId.value) {
			throw new Error('User not authenticated')
		}

		return await updateUserProfile(userId.value, profileData)
	}

	async function refreshProfile() {
		if (!userId.value) {
			return
		}

		await fetchUserProfile(userId.value)
	}

	function clearError() {
		error.value = null
	}

	function setUser(newUser: User | null) {
		user.value = newUser
	}

	function setSession(newSession: Session | null) {
		session.value = newSession
	}

	function setLoading(isLoading: boolean) {
		loading.value = isLoading
	}

	function initializeAuth() {
		supabase.auth.getSession().then(({ data: { session: currentSession } }) => {
			user.value = currentSession?.user ?? null
			session.value = currentSession
			loading.value = false

			// Fetch user profile if user is logged in
			if (currentSession?.user) {
				fetchUserProfile(currentSession.user.id)
			}
		})

		supabase.auth.onAuthStateChange((event, currentSession) => {
			user.value = currentSession?.user ?? null
			session.value = currentSession
			loading.value = false

			if (event === 'SIGNED_IN' || event === 'TOKEN_REFRESHED') {
				error.value = null
				// Fetch user profile on auth state change
				if (currentSession?.user) {
					fetchUserProfile(currentSession.user.id)
				}
			} else if (event === 'SIGNED_OUT') {
				clearProfile()
			}
		})
	}

	return {
		user,
		session,
		loading,
		error,
		userProfile,
		profileLoading,

		isAuthenticated,
		isLoading,
		userEmail,
		userId,
		isRecruiter,
		canPostJobs,
		userCompanyId,
		fullUserProfile,

		signUp,
		signIn,
		signOut,
		resetPassword,
		updateProfile,
		refreshProfile,
		clearError,
		setUser,
		setSession,
		setLoading,
		initializeAuth
	}
})
