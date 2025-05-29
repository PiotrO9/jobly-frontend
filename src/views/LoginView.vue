<script setup lang="ts">
import { ref, reactive, computed } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '@/stores/auth'
import type { AuthError } from '@supabase/supabase-js'

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
		validationErrors.push('Email jest wymagany')
	} else if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
		validationErrors.push('Nieprawidłowy format email')
	}
	
	return validationErrors
}

function validatePassword(password: string): string[] {
	const validationErrors: string[] = []
	
	if (!password) {
		validationErrors.push('Hasło jest wymagane')
	} else if (password.length < 6) {
		validationErrors.push('Hasło musi mieć co najmniej 6 znaków')
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
		
		// Jeśli dotarliśmy tutaj, logowanie się powiodło
		console.log('Login successful:', { user: authStore.userEmail })
		router.push('/')
	} catch (error) {
		// Mapowanie błędów Supabase na przyjazne komunikaty
		const errorMessage = (error as AuthError | Error).message || 'Wystąpił błąd podczas logowania'
		
		switch (errorMessage) {
			case 'Invalid login credentials':
			case 'Invalid email or password':
				errors.api.push('Nieprawidłowy email lub hasło')
				break
			case 'Email not confirmed':
				errors.api.push('Konto nie zostało aktywowane. Sprawdź swoją skrzynkę email.')
				break
			case 'Too many requests':
				errors.api.push('Zbyt wiele prób logowania. Spróbuj ponownie za chwilę.')
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
			<h1 class="login-title">Zaloguj się</h1>
			<p class="login-subtitle">Wprowadź swoje dane aby się zalogować</p>
			
			<form @submit.prevent="handleSubmit" class="login-form">
				<!-- Błędy API -->
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
						placeholder="twoj@email.com"
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
					<label for="password" class="form-label">Hasło</label>
					<input
						id="password"
						v-model="form.password"
						type="password"
						class="form-input"
						:class="{ 'form-input--error': errors.password.length > 0 }"
						placeholder="Twoje hasło"
						@blur="handlePasswordBlur"
						autocomplete="current-password"
					/>
					<div v-if="errors.password.length > 0" class="form-errors">
						<span v-for="error in errors.password" :key="error" class="form-error">
							{{ error }}
						</span>
					</div>
				</div>
				
				<button
					type="submit"
					class="submit-button"
					:class="{ 'submit-button--loading': isLoading }"
					:disabled="!isFormValid || isLoading"
				>
					<span v-if="isLoading">Logowanie...</span>
					<span v-else>Zaloguj się</span>
				</button>
			</form>
			
			<div class="login-footer">
				<p class="login-footer-text">
					Nie masz jeszcze konta?
					<button
						type="button"
						class="link-button"
						@click="handleRegisterClick"
					>
						Zarejestruj się
					</button>
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

.login-footer {
	margin-top: 2rem;
	text-align: center;
}

.login-footer-text {
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
	.login-card {
		padding: 1.5rem;
		margin: 0;
	}
	
	.login-title {
		font-size: 1.5rem;
	}
}
</style> 