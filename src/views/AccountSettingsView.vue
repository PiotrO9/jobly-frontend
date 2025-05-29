<script setup lang="ts">
import { ref, reactive, computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '@/stores/auth'
import { useDatabase } from '@/composables/useDatabase'

const router = useRouter()
const authStore = useAuthStore()
const { select, update } = useDatabase()

interface UserProfile {
	id: string
	email: string
	first_name: string
	last_name: string
	username: string
	bio: string
	location: string
	website_url: string
	linkedin_url: string
	github_url: string
	skills: string[]
	experience_years: number | null
	is_recruiter: boolean
}

const profile = reactive<Partial<UserProfile>>({
	email: '',
	first_name: '',
	last_name: '',
	username: '',
	bio: '',
	location: '',
	website_url: '',
	linkedin_url: '',
	github_url: '',
	skills: [],
	experience_years: null,
	is_recruiter: false
})

const isLoading = ref(false)
const isSaving = ref(false)
const successMessage = ref('')
const errorMessage = ref('')
const newSkill = ref('')

// Sprawdź czy użytkownik jest zalogowany
const isAuthenticated = computed(() => authStore.isAuthenticated)

onMounted(async () => {
	if (!isAuthenticated.value) {
		router.push('/login')
		return
	}
	
	await loadUserProfile()
})

async function loadUserProfile() {
	if (!authStore.userId) return
	
	isLoading.value = true
	
	try {
		const { data, error } = await select('user_profiles', {
			filters: { id: authStore.userId }
		})
		
		if (error) {
			errorMessage.value = 'Nie udało się załadować profilu użytkownika'
			return
		}
		
		if (data && data.length > 0) {
			const userProfile = data[0] as unknown as UserProfile
			Object.assign(profile, userProfile)
		}
	} catch (error) {
		console.error('Error loading user profile:', error)
		errorMessage.value = 'Wystąpił błąd podczas ładowania profilu'
	} finally {
		isLoading.value = false
	}
}

async function handleSaveProfile() {
	if (!authStore.userId) return
	
	isSaving.value = true
	successMessage.value = ''
	errorMessage.value = ''
	
	try {
		const { error } = await update('user_profiles', profile, { id: authStore.userId })
		
		if (error) {
			errorMessage.value = 'Nie udało się zapisać zmian'
			return
		}
		
		successMessage.value = 'Profil został zaktualizowany!'
		
		// Ukryj komunikat po 3 sekundach
		setTimeout(() => {
			successMessage.value = ''
		}, 3000)
	} catch (error) {
		console.error('Error saving profile:', error)
		errorMessage.value = 'Wystąpił błąd podczas zapisywania'
	} finally {
		isSaving.value = false
	}
}

function handleAddSkill() {
	if (newSkill.value.trim() && !profile.skills?.includes(newSkill.value.trim())) {
		if (!profile.skills) profile.skills = []
		profile.skills.push(newSkill.value.trim())
		newSkill.value = ''
	}
}

function handleRemoveSkill(skillToRemove: string) {
	if (profile.skills) {
		profile.skills = profile.skills.filter(skill => skill !== skillToRemove)
	}
}

async function handleSignOut() {
	try {
		await authStore.signOut()
		router.push('/')
	} catch (error) {
		console.error('Logout failed:', error)
	}
}
</script>

<template>
	<div class="settings-container">
		<div class="settings-card">
			<div class="settings-header">
				<h1 class="settings-title">Ustawienia konta</h1>
				<p class="settings-subtitle">Zarządzaj swoim profilem i preferencjami</p>
			</div>
			
			<!-- Loading State -->
			<div v-if="isLoading" class="loading-state">
				<div class="loading-spinner"></div>
				<p>Ładowanie profilu...</p>
			</div>
			
			<!-- Settings Form -->
			<form v-else @submit.prevent="handleSaveProfile" class="settings-form">
				<!-- Success/Error Messages -->
				<div v-if="successMessage" class="message success">
					{{ successMessage }}
				</div>
				<div v-if="errorMessage" class="message error">
					{{ errorMessage }}
				</div>
				
				<!-- User Info Section -->
				<section class="form-section">
					<h2 class="section-title">Informacje podstawowe</h2>
					
					<div class="form-row">
						<div class="form-group">
							<label for="email" class="form-label">Email</label>
							<input
								id="email"
								v-model="profile.email"
								type="email"
								class="form-input"
								readonly
								disabled
							/>
							<small class="form-hint">Adres email nie może być zmieniony</small>
						</div>
					</div>
					
					<div class="form-row">
						<div class="form-group">
							<label for="first_name" class="form-label">Imię</label>
							<input
								id="first_name"
								v-model="profile.first_name"
								type="text"
								class="form-input"
								placeholder="Twoje imię"
							/>
						</div>
						<div class="form-group">
							<label for="last_name" class="form-label">Nazwisko</label>
							<input
								id="last_name"
								v-model="profile.last_name"
								type="text"
								class="form-input"
								placeholder="Twoje nazwisko"
							/>
						</div>
					</div>
					
					<div class="form-row">
						<div class="form-group">
							<label for="username" class="form-label">Nazwa użytkownika</label>
							<input
								id="username"
								v-model="profile.username"
								type="text"
								class="form-input"
								placeholder="nazwa_uzytkownika"
							/>
						</div>
						<div class="form-group">
							<label for="location" class="form-label">Lokalizacja</label>
							<input
								id="location"
								v-model="profile.location"
								type="text"
								class="form-input"
								placeholder="Warszawa, Polska"
							/>
						</div>
					</div>
				</section>
				
				<!-- Bio Section -->
				<section class="form-section">
					<h2 class="section-title">O mnie</h2>
					<div class="form-group">
						<label for="bio" class="form-label">Biografia</label>
						<textarea
							id="bio"
							v-model="profile.bio"
							class="form-textarea"
							placeholder="Opowiedz coś o sobie..."
							rows="4"
						></textarea>
					</div>
				</section>
				
				<!-- Experience Section -->
				<section class="form-section">
					<h2 class="section-title">Doświadczenie</h2>
					<div class="form-row">
						<div class="form-group">
							<label for="experience_years" class="form-label">Lata doświadczenia</label>
							<input
								id="experience_years"
								v-model.number="profile.experience_years"
								type="number"
								class="form-input"
								placeholder="5"
								min="0"
								max="50"
							/>
						</div>
					</div>
				</section>
				
				<!-- Skills Section -->
				<section class="form-section">
					<h2 class="section-title">Umiejętności</h2>
					<div class="skills-input-group">
						<input
							v-model="newSkill"
							type="text"
							class="form-input"
							placeholder="Dodaj umiejętność (np. JavaScript)"
							@keyup.enter="handleAddSkill"
						/>
						<button type="button" class="add-skill-btn" @click="handleAddSkill">
							Dodaj
						</button>
					</div>
					<div v-if="profile.skills && profile.skills.length > 0" class="skills-list">
						<span
							v-for="skill in profile.skills"
							:key="skill"
							class="skill-tag"
						>
							{{ skill }}
							<button
								type="button"
								class="remove-skill-btn"
								@click="handleRemoveSkill(skill)"
							>
								×
							</button>
						</span>
					</div>
				</section>
				
				<!-- Links Section -->
				<section class="form-section">
					<h2 class="section-title">Linki społecznościowe</h2>
					<div class="form-group">
						<label for="website_url" class="form-label">Strona internetowa</label>
						<input
							id="website_url"
							v-model="profile.website_url"
							type="url"
							class="form-input"
							placeholder="https://twoja-strona.pl"
						/>
					</div>
					<div class="form-row">
						<div class="form-group">
							<label for="linkedin_url" class="form-label">LinkedIn</label>
							<input
								id="linkedin_url"
								v-model="profile.linkedin_url"
								type="url"
								class="form-input"
								placeholder="https://linkedin.com/in/twoj-profil"
							/>
						</div>
						<div class="form-group">
							<label for="github_url" class="form-label">GitHub</label>
							<input
								id="github_url"
								v-model="profile.github_url"
								type="url"
								class="form-input"
								placeholder="https://github.com/twoj-profil"
							/>
						</div>
					</div>
				</section>
				
				<!-- Account Type -->
				<section class="form-section">
					<h2 class="section-title">Typ konta</h2>
					<div class="checkbox-group">
						<label class="checkbox-label">
							<input
								v-model="profile.is_recruiter"
								type="checkbox"
								class="checkbox-input"
							/>
							<span class="checkbox-text">Jestem rekruterem</span>
						</label>
						<small class="form-hint">
							Konta rekruterów mają dostęp do dodatkowych funkcji zarządzania ofertami pracy
						</small>
					</div>
				</section>
				
				<!-- Action Buttons -->
				<div class="form-actions">
					<button
						type="submit"
						class="save-button"
						:disabled="isSaving"
					>
						<span v-if="isSaving">Zapisywanie...</span>
						<span v-else>Zapisz zmiany</span>
					</button>
					
					<button
						type="button"
						class="logout-button"
						@click="handleSignOut"
					>
						Wyloguj się
					</button>
				</div>
			</form>
		</div>
	</div>
</template>

<style scoped>
.settings-container {
	min-height: 100vh;
	background-color: #f8fafc;
	padding: 2rem 1rem;
}

.settings-card {
	max-width: 800px;
	margin: 0 auto;
	background: white;
	border-radius: 12px;
	box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
	overflow: hidden;
}

.settings-header {
	background: linear-gradient(135deg, var(--color-primary) 0%, var(--color-primary-hover) 100%);
	color: white;
	padding: 2rem;
	text-align: center;
}

.settings-title {
	font-size: 2rem;
	font-weight: 700;
	margin: 0 0 0.5rem 0;
}

.settings-subtitle {
	margin: 0;
	opacity: 0.9;
}

.loading-state {
	padding: 3rem;
	text-align: center;
	color: var(--gray-600);
}

.loading-spinner {
	width: 2rem;
	height: 2rem;
	border: 3px solid #e5e7eb;
	border-top: 3px solid var(--color-primary);
	border-radius: 50%;
	animation: spin 1s linear infinite;
	margin: 0 auto 1rem;
}

@keyframes spin {
	0% { transform: rotate(0deg); }
	100% { transform: rotate(360deg); }
}

.settings-form {
	padding: 2rem;
}

.message {
	padding: 1rem;
	border-radius: 6px;
	margin-bottom: 1.5rem;
	font-weight: 500;
}

.message.success {
	background-color: #f0fdf4;
	color: #16a34a;
	border: 1px solid #bbf7d0;
}

.message.error {
	background-color: #fef2f2;
	color: #dc2626;
	border: 1px solid #fecaca;
}

.form-section {
	margin-bottom: 2.5rem;
}

.section-title {
	font-size: 1.25rem;
	font-weight: 600;
	color: var(--text-color);
	margin: 0 0 1.5rem 0;
	padding-bottom: 0.5rem;
	border-bottom: 2px solid #e5e7eb;
}

.form-row {
	display: grid;
	grid-template-columns: 1fr;
	gap: 1rem;
}

@media (min-width: 640px) {
	.form-row {
		grid-template-columns: 1fr 1fr;
	}
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

.form-input,
.form-textarea {
	padding: 0.75rem 1rem;
	border: 1px solid #d1d5db;
	border-radius: 6px;
	font-size: 1rem;
	transition: all 0.2s ease;
	background-color: white;
}

.form-input:focus,
.form-textarea:focus {
	outline: none;
	border-color: var(--color-primary);
	box-shadow: 0 0 0 3px rgba(0, 96, 251, 0.1);
}

.form-input:disabled {
	background-color: #f9fafb;
	color: #6b7280;
	cursor: not-allowed;
}

.form-hint {
	font-size: 0.75rem;
	color: var(--gray-600);
}

.skills-input-group {
	display: flex;
	gap: 0.5rem;
	margin-bottom: 1rem;
}

.skills-input-group .form-input {
	flex: 1;
}

.add-skill-btn {
	padding: 0.75rem 1.5rem;
	background-color: var(--color-primary);
	color: white;
	border: none;
	border-radius: 6px;
	font-weight: 500;
	cursor: pointer;
	transition: background-color 0.2s ease;
}

.add-skill-btn:hover {
	background-color: var(--color-primary-hover);
}

.skills-list {
	display: flex;
	flex-wrap: wrap;
	gap: 0.5rem;
}

.skill-tag {
	display: inline-flex;
	align-items: center;
	gap: 0.5rem;
	background-color: #e0f2fe;
	color: #0369a1;
	padding: 0.5rem 0.75rem;
	border-radius: 20px;
	font-size: 0.875rem;
	font-weight: 500;
}

.remove-skill-btn {
	background: none;
	border: none;
	color: #0369a1;
	cursor: pointer;
	font-size: 1.25rem;
	line-height: 1;
	padding: 0;
	width: 1.5rem;
	height: 1.5rem;
	display: flex;
	align-items: center;
	justify-content: center;
	border-radius: 50%;
	transition: background-color 0.2s ease;
}

.remove-skill-btn:hover {
	background-color: rgba(3, 105, 161, 0.1);
}

.checkbox-group {
	display: flex;
	flex-direction: column;
	gap: 0.5rem;
}

.checkbox-label {
	display: flex;
	align-items: flex-start;
	gap: 0.75rem;
	cursor: pointer;
}

.checkbox-input {
	width: 1.25rem;
	height: 1.25rem;
	border: 2px solid #d1d5db;
	border-radius: 4px;
	cursor: pointer;
}

.checkbox-text {
	font-weight: 500;
	color: var(--text-color);
}

.form-actions {
	display: flex;
	gap: 1rem;
	justify-content: flex-end;
	margin-top: 2rem;
	padding-top: 2rem;
	border-top: 1px solid #e5e7eb;
}

.save-button {
	background-color: var(--color-primary);
	color: white;
	border: none;
	padding: 0.75rem 2rem;
	border-radius: 6px;
	font-size: 1rem;
	font-weight: 600;
	cursor: pointer;
	transition: background-color 0.2s ease;
}

.save-button:hover:not(:disabled) {
	background-color: var(--color-primary-hover);
}

.save-button:disabled {
	background-color: #9ca3af;
	cursor: not-allowed;
}

.logout-button {
	background-color: #dc2626;
	color: white;
	border: none;
	padding: 0.75rem 1.5rem;
	border-radius: 6px;
	font-size: 1rem;
	font-weight: 600;
	cursor: pointer;
	transition: background-color 0.2s ease;
}

.logout-button:hover {
	background-color: #b91c1c;
}

@media (max-width: 640px) {
	.settings-container {
		padding: 1rem;
	}
	
	.settings-card {
		border-radius: 8px;
	}
	
	.settings-header {
		padding: 1.5rem;
	}
	
	.settings-title {
		font-size: 1.5rem;
	}
	
	.settings-form {
		padding: 1.5rem;
	}
	
	.form-actions {
		flex-direction: column;
	}
	
	.skills-input-group {
		flex-direction: column;
	}
}
</style> 