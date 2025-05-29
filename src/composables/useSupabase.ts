import { ref, onMounted, onUnmounted, type Ref } from 'vue'
import { supabase, type User, type Session } from '@/lib/supabase'
import type { AuthError } from '@supabase/supabase-js'

export function useSupabase() {
	const user: Ref<User | null> = ref(null)
	const session: Ref<Session | null> = ref(null)
	const loading = ref(true)
	const error: Ref<AuthError | Error | null> = ref(null)

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
				return { user: null, session: null, error: signUpError }
			}
			
			return { user: data.user, session: data.session, error: null }
		} catch (err) {
			error.value = err as Error
			return { user: null, session: null, error: err }
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
				return { user: null, session: null, error: signInError }
			}
			
			return { user: data.user, session: data.session, error: null }
		} catch (err) {
			error.value = err as Error
			return { user: null, session: null, error: err }
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
				return { error: signOutError }
			}
			
			return { error: null }
		} catch (err) {
			error.value = err as Error
			return { error: err }
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
				return { error: resetError }
			}
			
			return { error: null }
		} catch (err) {
			error.value = err as Error
			return { error: err }
		} finally {
			loading.value = false
		}
	}

	function from(table: string) {
		return supabase.from(table)
	}

	function storage() {
		return supabase.storage
	}

	let authListener: { data: { subscription: { unsubscribe: () => void } } } | null = null

	function initializeAuth() {
		supabase.auth.getSession().then(({ data: { session: currentSession } }) => {
			user.value = currentSession?.user ?? null
			session.value = currentSession
			loading.value = false
		})

		authListener = supabase.auth.onAuthStateChange((event, currentSession) => {
			user.value = currentSession?.user ?? null
			session.value = currentSession
			loading.value = false
			
			if (event === 'SIGNED_IN' || event === 'TOKEN_REFRESHED') {
				error.value = null
			}
		})
	}

	function cleanup() {
		if (authListener) {
			authListener.data.subscription.unsubscribe()
		}
	}

	onMounted(() => {
		initializeAuth()
	})

	onUnmounted(() => {
		cleanup()
	})

	return {
		user,
		session,
		loading,
		error,
		
		signUp,
		signIn,
		signOut,
		resetPassword,
		
		from,
		storage,
		
		supabase
	}
} 