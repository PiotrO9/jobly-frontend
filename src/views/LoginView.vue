<script setup lang="ts">
import { ref, reactive, computed } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '@/stores/auth'
import type { AuthError } from '@supabase/supabase-js'
import Button from '@/components/ui/Button.vue'

const router = useRouter()
const authStore = useAuthStore()

interface LoginForm {
	email: string
	password: string
}

interface ValidationErrors {
	email: string[]
	password: string[]
	api: string[]
}

const form = reactive<LoginForm>({
	email: '',
	password: ''
})

const errors = reactive<ValidationErrors>({
	email: [],
	password: [],
	api: []
})

const isLoading = ref(false)

function validateEmail(email: string): string[] {
	const validationErrors: string[] = []
	
	if (!email) {
		validationErrors.push('Email is required')
	} else if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
		validationErrors.push('Invalid email format')
	}
	
	return validationErrors
}

function validatePassword(password: string): string[] {
	const validationErrors: string[] = []
	
	if (!password) {
		validationErrors.push('Password is required')
	} else if (password.length < 6) {
		validationErrors.push('Password must be at least 6 characters long')
	}
	
	return validationErrors
}

function validateForm(): boolean {
	errors.email = validateEmail(form.email)
	errors.password = validatePassword(form.password)
	errors.api = []
	
	return errors.email.length === 0 && errors.password.length === 0
}

const isFormValid = computed(() => {
	return form.email && form.password && errors.email.length === 0 && errors.password.length === 0
})

function handleEmailBlur(): void {
	errors.email = validateEmail(form.email)
}

function handlePasswordBlur(): void {
	errors.password = validatePassword(form.password)
}

async function handleSubmit(): Promise<void> {
	if (!validateForm()) {
		return
	}
	
	isLoading.value = true
	errors.api = []
	
	try {
		await authStore.signIn(form.email, form.password)
		
		console.log('Login successful:', { user: authStore.userEmail })
		router.push('/')
	} catch (error) {
		const errorMessage = (error as AuthError | Error).message || 'An error occurred during login'
		
		switch (errorMessage) {
			case 'Invalid login credentials':
			case 'Invalid email or password':
				errors.api.push('Invalid email or password')
				break
			case 'Email not confirmed':
				errors.api.push('Account has not been activated. Check your email inbox.')
				break
			case 'Too many requests':
				errors.api.push('Too many login attempts. Please try again in a moment.')
				break
			default:
				errors.api.push(errorMessage)
		}
	} finally {
		isLoading.value = false
	}
}

function handleRegisterClick(): void {
	router.push('/register')
}
</script>

<template>
	<div class="login-container">
		<div class="login-card">
			<h1 class="login-title">Sign In</h1>
			<p class="login-subtitle">Enter your credentials to sign in</p>
			
			<form @submit.prevent="handleSubmit" class="login-form">
				<div v-if="errors.api.length > 0" class="api-errors">
					<span v-for="error in errors.api" :key="error" class="api-error">
						{{ error }}
					</span>
				</div>
				
				<div class="form-group">
					<label for="email" class="form-label">Email</label>
					<input
						id="email"
						v-model="form.email"
						type="email"
						class="form-input"
						:class="{ 'form-input--error': errors.email.length > 0 }"
						placeholder="your@email.com"
						@blur="handleEmailBlur"
						autocomplete="email"
					/>
					<div v-if="errors.email.length > 0" class="form-errors">
						<span v-for="error in errors.email" :key="error" class="form-error">
							{{ error }}
						</span>
					</div>
				</div>
				
				<div class="form-group">
					<label for="password" class="form-label">Password</label>
					<input
						id="password"
						v-model="form.password"
						type="password"
						class="form-input"
						:class="{ 'form-input--error': errors.password.length > 0 }"
						placeholder="Your password"
						@blur="handlePasswordBlur"
						autocomplete="current-password"
					/>
					<div v-if="errors.password.length > 0" class="form-errors">
						<span v-for="error in errors.password" :key="error" class="form-error">
							{{ error }}
						</span>
					</div>
				</div>
				
				<Button
					type="submit"
					variant="submit"
					:disabled="!isFormValid || isLoading"
					@click="handleSubmit"
				>
					<span v-if="isLoading">Signing in...</span>
					<span v-else>Sign In</span>
				</Button>
			</form>
			
			<div class="login-footer">
				<p class="login-footer-text">
					Don't have an account yet?
					<Button
						type="button"
						variant="link-button"
						@click="handleRegisterClick"
						text="Sign Up"
					/>
				</p>
			</div>
		</div>
	</div>
</template>

<style scoped>
.login-container {
	min-height: 100vh;
	display: flex;
	align-items: center;
	justify-content: center;
	padding: 1rem;
	background-color: #f8fafc;
}

.login-card {
	background: white;
	border-radius: 12px;
	box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
	padding: 2rem;
	width: 100%;
	max-width: 400px;
}

.login-title {
	font-size: 1.875rem;
	font-weight: 700;
	color: var(--text-color);
	text-align: center;
	margin: 0 0 0.5rem 0;
}

.login-subtitle {
	color: var(--gray-600);
	text-align: center;
	margin: 0 0 2rem 0;
	font-size: 0.875rem;
}

.login-form {
	display: flex;
	flex-direction: column;
	gap: 1.5rem;
}

.api-errors {
	padding: 1rem;
	background-color: #fef2f2;
	border-radius: 6px;
	border: 1px solid #fecaca;
	display: flex;
	flex-direction: column;
	gap: 0.25rem;
}

.api-error {
	color: #dc2626;
	font-size: 0.875rem;
	font-weight: 500;
}

.form-group {
	display: flex;
	flex-direction: column;
	gap: 0.5rem;
}

.form-label {
	font-weight: 500;
	color: var(--text-color);
	font-size: 0.875rem;
}

.form-input {
	padding: 0.75rem 1rem;
	border: 1px solid #d1d5db;
	border-radius: 6px;
	font-size: 1rem;
	transition: all 0.2s ease;
	background-color: white;
}

.form-input:focus {
	outline: none;
	border-color: var(--color-primary);
	box-shadow: 0 0 0 3px rgba(0, 96, 251, 0.1);
}

.form-input--error {
	border-color: #ef4444;
}

.form-input--error:focus {
	border-color: #ef4444;
	box-shadow: 0 0 0 3px rgba(239, 68, 68, 0.1);
}

.form-errors {
	display: flex;
	flex-direction: column;
	gap: 0.25rem;
}

.form-error {
	color: #ef4444;
	font-size: 0.75rem;
	font-weight: 500;
}

.login-footer {
	margin-top: 2rem;
	text-align: center;
}

.login-footer-text {
	color: var(--gray-600);
	font-size: 0.875rem;
	margin: 0;
}

@media (max-width: 480px) {
	.login-card {
		padding: 1.5rem;
		margin: 0;
	}
	
	.login-title {
		font-size: 1.5rem;
	}
}
</style> 