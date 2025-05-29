<script setup lang="ts">
import { ref, reactive, computed } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '@/stores/auth'
import type { AuthError } from '@supabase/supabase-js'

const router = useRouter()
const authStore = useAuthStore()

interface RegisterForm {
	email: string
	password: string
	confirmPassword: string
}

interface ValidationErrors {
	email: string[]
	password: string[]
	confirmPassword: string[]
	api: string[]
}

const form = reactive<RegisterForm>({
	email: '',
	password: '',
	confirmPassword: ''
})

const errors = reactive<ValidationErrors>({
	email: [],
	password: [],
	confirmPassword: [],
	api: []
})

const isLoading = ref(false)
const registrationSuccess = ref(false)

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
	} else {
		if (password.length < 8) {
			validationErrors.push('Password must be at least 8 characters long')
		}
		if (!/(?=.*[a-z])/.test(password)) {
			validationErrors.push('Password must contain at least one lowercase letter')
		}
		if (!/(?=.*[A-Z])/.test(password)) {
			validationErrors.push('Password must contain at least one uppercase letter')
		}
		if (!/(?=.*\d)/.test(password)) {
			validationErrors.push('Password must contain at least one digit')
		}
	}
	
	return validationErrors
}

function validateConfirmPassword(password: string, confirmPassword: string): string[] {
	const validationErrors: string[] = []
	
	if (!confirmPassword) {
		validationErrors.push('Password confirmation is required')
	} else if (password !== confirmPassword) {
		validationErrors.push('Passwords must match')
	}
	
	return validationErrors
}

function validateForm(): boolean {
	errors.email = validateEmail(form.email)
	errors.password = validatePassword(form.password)
	errors.confirmPassword = validateConfirmPassword(form.password, form.confirmPassword)
	errors.api = []
	
	return errors.email.length === 0 && 
	       errors.password.length === 0 && 
	       errors.confirmPassword.length === 0
}

const isFormValid = computed(() => {
	return form.email && 
	       form.password && 
	       form.confirmPassword && 
	       errors.email.length === 0 && 
	       errors.password.length === 0 && 
	       errors.confirmPassword.length === 0
})

function handleEmailBlur(): void {
	errors.email = validateEmail(form.email)
}

function handlePasswordBlur(): void {
	errors.password = validatePassword(form.password)
	// Revalidate password confirmation if it has been entered
	if (form.confirmPassword) {
		errors.confirmPassword = validateConfirmPassword(form.password, form.confirmPassword)
	}
}

function handleConfirmPasswordBlur(): void {
	errors.confirmPassword = validateConfirmPassword(form.password, form.confirmPassword)
}

async function handleSubmit(): Promise<void> {
	if (!validateForm()) {
		return
	}
	
	isLoading.value = true
	errors.api = []
	
	try {
		await authStore.signUp(form.email, form.password)
		
		registrationSuccess.value = true
		console.log('Registration successful - email confirmation required')
		
		// Redirect to login after 3 seconds
		setTimeout(() => {
			router.push('/login')
		}, 3000)
	} catch (error) {
		// Map Supabase errors to user-friendly messages
		const errorMessage = (error as AuthError | Error).message || 'An error occurred during registration'
		
		switch (errorMessage) {
			case 'User already registered':
				errors.api.push('User with this email address already exists')
				break
			case 'Password should be at least 6 characters':
				errors.api.push('Password must be at least 6 characters long')
				break
			case 'Signup requires a valid password':
				errors.api.push('Password is invalid')
				break
			case 'Invalid email':
				errors.api.push('Invalid email address')
				break
			case 'Database error saving new user':
				errors.api.push('Database configuration error. Please contact administrator.')
				break
			default:
				errors.api.push(errorMessage)
		}
	} finally {
		isLoading.value = false
	}
}

function handleLoginClick(): void {
	router.push('/login')
}
</script>

<template>
	<div class="register-container">
		<div class="register-card">
			<h1 class="register-title">Sign Up</h1>
			<p class="register-subtitle">Create a new account to get started</p>
			
			<!-- Success message -->
			<div v-if="registrationSuccess" class="success-message">
				<h3 class="success-title">Registration successful! 🎉</h3>
				<p class="success-text">
					Check your email inbox and click the activation link to complete your registration.
				</p>
			</div>
			
			<form v-else @submit.prevent="handleSubmit" class="register-form">
				<!-- API errors -->
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
						autocomplete="new-password"
					/>
					<div v-if="errors.password.length > 0" class="form-errors">
						<span v-for="error in errors.password" :key="error" class="form-error">
							{{ error }}
						</span>
					</div>
				</div>
				
				<div class="form-group">
					<label for="confirmPassword" class="form-label">Confirm Password</label>
					<input
						id="confirmPassword"
						v-model="form.confirmPassword"
						type="password"
						class="form-input"
						:class="{ 'form-input--error': errors.confirmPassword.length > 0 }"
						placeholder="Confirm your password"
						@blur="handleConfirmPasswordBlur"
						autocomplete="new-password"
					/>
					<div v-if="errors.confirmPassword.length > 0" class="form-errors">
						<span v-for="error in errors.confirmPassword" :key="error" class="form-error">
							{{ error }}
						</span>
					</div>
				</div>
				
				<div class="password-requirements">
					<h4 class="password-requirements-title">Password requirements:</h4>
					<ul class="password-requirements-list">
						<li 
							class="password-requirement"
							:class="{ 'password-requirement--valid': form.password.length >= 8 }"
						>
							At least 8 characters
						</li>
						<li 
							class="password-requirement"
							:class="{ 'password-requirement--valid': /(?=.*[a-z])/.test(form.password) }"
						>
							At least one lowercase letter
						</li>
						<li 
							class="password-requirement"
							:class="{ 'password-requirement--valid': /(?=.*[A-Z])/.test(form.password) }"
						>
							At least one uppercase letter
						</li>
						<li 
							class="password-requirement"
							:class="{ 'password-requirement--valid': /(?=.*\d)/.test(form.password) }"
						>
							At least one digit
						</li>
					</ul>
				</div>
				
				<button
					type="submit"
					class="submit-button"
					:class="{ 'submit-button--loading': isLoading }"
					:disabled="!isFormValid || isLoading"
				>
					<span v-if="isLoading">Signing up...</span>
					<span v-else>Sign Up</span>
				</button>
			</form>
			
			<div class="register-footer">
				<p class="register-footer-text">
					Already have an account?
					<button
						type="button"
						class="link-button"
						@click="handleLoginClick"
					>
						Sign In
					</button>
				</p>
			</div>
		</div>
	</div>
</template>

<style scoped>
.register-container {
	min-height: 100vh;
	display: flex;
	align-items: center;
	justify-content: center;
	padding: 1rem;
	background-color: #f8fafc;
}

.register-card {
	background: white;
	border-radius: 12px;
	box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
	padding: 2rem;
	width: 100%;
	max-width: 480px;
}

.register-title {
	font-size: 1.875rem;
	font-weight: 700;
	color: var(--text-color);
	text-align: center;
	margin: 0 0 0.5rem 0;
}

.register-subtitle {
	color: var(--gray-600);
	text-align: center;
	margin: 0 0 2rem 0;
	font-size: 0.875rem;
}

.success-message {
	text-align: center;
	padding: 2rem 1rem;
	background-color: #f0fdf4;
	border-radius: 8px;
	border: 1px solid #bbf7d0;
	margin-bottom: 2rem;
}

.success-title {
	color: #16a34a;
	font-size: 1.25rem;
	font-weight: 600;
	margin: 0 0 1rem 0;
}

.success-text {
	color: #15803d;
	margin: 0;
	line-height: 1.5;
}

.register-form {
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

.password-requirements {
	padding: 1rem;
	background-color: #f8fafc;
	border-radius: 6px;
	border: 1px solid #e5e7eb;
}

.password-requirements-title {
	font-size: 0.875rem;
	font-weight: 600;
	color: var(--text-color);
	margin: 0 0 0.75rem 0;
}

.password-requirements-list {
	list-style: none;
	padding: 0;
	margin: 0;
	display: flex;
	flex-direction: column;
	gap: 0.5rem;
}

.password-requirement {
	font-size: 0.75rem;
	color: var(--gray-600);
	position: relative;
	padding-left: 1.5rem;
}

.password-requirement::before {
	content: '✗';
	position: absolute;
	left: 0;
	color: #ef4444;
	font-weight: 600;
}

.password-requirement--valid {
	color: #16a34a;
}

.password-requirement--valid::before {
	content: '✓';
	color: #16a34a;
}

.submit-button {
	background-color: var(--color-primary);
	color: white;
	border: none;
	padding: 0.75rem 1rem;
	border-radius: 6px;
	font-size: 1rem;
	font-weight: 600;
	cursor: pointer;
	transition: all 0.2s ease;
	margin-top: 0.5rem;
}

.submit-button:hover:not(:disabled) {
	background-color: var(--color-primary-hover);
}

.submit-button:disabled {
	background-color: #9ca3af;
	cursor: not-allowed;
}

.submit-button--loading {
	background-color: #9ca3af;
}

.register-footer {
	margin-top: 2rem;
	text-align: center;
}

.register-footer-text {
	color: var(--gray-600);
	font-size: 0.875rem;
	margin: 0;
}

.link-button {
	background: none;
	border: none;
	color: var(--color-primary);
	cursor: pointer;
	font-weight: 600;
	text-decoration: underline;
	font-size: inherit;
}

.link-button:hover {
	color: var(--color-primary-hover);
}

@media (max-width: 480px) {
	.register-card {
		padding: 1.5rem;
		margin: 0;
	}
	
	.register-title {
		font-size: 1.5rem;
	}
	
	.password-requirements {
		padding: 0.75rem;
	}
}
</style> 