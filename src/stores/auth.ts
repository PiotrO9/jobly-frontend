import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import { supabase, type User, type Session } from '@/lib/supabase'
import type { AuthError } from '@supabase/supabase-js'

export const useAuthStore = defineStore('auth', () => {
	// State
	const user = ref<User | null>(null)
	const session = ref<Session | null>(null)
	const loading = ref(true)
	const error = ref<AuthError | Error | null>(null)

	// Getters
	const isAuthenticated = computed(() => !!user.value)
	const isLoading = computed(() => loading.value)
	const userEmail = computed(() => user.value?.email || null)
	const userId = computed(() => user.value?.id || null)

	// Actions
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

	// Initialize auth listener
	function initializeAuth() {
		// Get initial session
		supabase.auth.getSession().then(({ data: { session: currentSession } }) => {
			user.value = currentSession?.user ?? null
			session.value = currentSession
			loading.value = false
		})

		// Listen for auth changes
		supabase.auth.onAuthStateChange((event, currentSession) => {
			user.value = currentSession?.user ?? null
			session.value = currentSession
			loading.value = false
			
			// Clear error on successful auth change
			if (event === 'SIGNED_IN' || event === 'TOKEN_REFRESHED') {
				error.value = null
			}
		})
	}

	return {
		// State
		user,
		session,
		loading,
		error,
		
		// Getters
		isAuthenticated,
		isLoading,
		userEmail,
		userId,
		
		// Actions
		signUp,
		signIn,
		signOut,
		resetPassword,
		clearError,
		setUser,
		setSession,
		setLoading,
		initializeAuth
	}
}) 