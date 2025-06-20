<script setup lang="ts">
import { ref, reactive, computed, onMounted } from 'vue';
import { useRouter } from 'vue-router';
import { useAuthStore } from '@/stores/auth';
import { useDatabase } from '@/composables/useDatabase';
import Button from '@/components/ui/Button.vue';

const router = useRouter();
const authStore = useAuthStore();
const { select, update } = useDatabase();

interface UserProfile {
    id: string;
    email: string;
    first_name: string;
    last_name: string;
    username: string;
    bio: string;
    location: string;
    website_url: string;
    linkedin_url: string;
    github_url: string;
    skills: string[];
    experience_years: number | null;
    is_recruiter: boolean;
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
    is_recruiter: false,
});

const isLoading = ref(false);
const isSaving = ref(false);
const successMessage = ref('');
const errorMessage = ref('');
const newSkill = ref('');

const isAuthenticated = computed(() => authStore.isAuthenticated);

onMounted(async () => {
    if (!isAuthenticated.value) {
        router.push('/login');
        return;
    }

    await loadUserProfile();
});

async function loadUserProfile() {
    if (!authStore.userId) return;

    isLoading.value = true;

    try {
        const { data, error } = await select('user_profiles', {
            filters: { id: authStore.userId },
        });

        if (error) {
            errorMessage.value = 'Failed to load user profile';
            return;
        }

        if (data && data.length > 0) {
            const userProfile = data[0] as unknown as UserProfile;
            Object.assign(profile, userProfile);
        }
    } catch (error) {
        console.error('Error loading user profile:', error);
        errorMessage.value = 'An error occurred while loading profile';
    } finally {
        isLoading.value = false;
    }
}

async function handleSaveProfile() {
    if (!authStore.userId) return;

    isSaving.value = true;
    successMessage.value = '';
    errorMessage.value = '';

    try {
        const { error } = await update('user_profiles', profile, { id: authStore.userId });

        if (error) {
            errorMessage.value = 'Failed to save changes';
            return;
        }

        successMessage.value = 'Profile updated successfully!';

        setTimeout(() => {
            successMessage.value = '';
        }, 3000);
    } catch (error) {
        console.error('Error saving profile:', error);
        errorMessage.value = 'An error occurred while saving';
    } finally {
        isSaving.value = false;
    }
}

function handleAddSkill() {
    if (newSkill.value.trim() && !profile.skills?.includes(newSkill.value.trim())) {
        if (!profile.skills) profile.skills = [];
        profile.skills.push(newSkill.value.trim());
        newSkill.value = '';
    }
}

function handleRemoveSkill(skillToRemove: string) {
    if (profile.skills) {
        profile.skills = profile.skills.filter((skill) => skill !== skillToRemove);
    }
}

async function handleSignOut() {
    try {
        await authStore.signOut();
        router.push('/');
    } catch (error) {
        console.error('Logout failed:', error);
    }
}
</script>

<template>
    <div class="settings-container">
        <div class="settings-card">
            <div class="settings-header">
                <h1 class="settings-title">Account Settings</h1>
                <p class="settings-subtitle">Manage your profile and preferences</p>
            </div>

            <div v-if="isLoading" class="loading-state">
                <div class="loading-spinner"></div>
                <p>Loading profile...</p>
            </div>

            <form v-else @submit.prevent="handleSaveProfile" class="settings-form">
                <div v-if="successMessage" class="message success">
                    {{ successMessage }}
                </div>
                <div v-if="errorMessage" class="message error">
                    {{ errorMessage }}
                </div>

                <section class="form-section">
                    <h2 class="section-title">Basic Information</h2>

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
                            <small class="form-hint">Email address cannot be changed</small>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="first_name" class="form-label">First Name</label>
                            <input
                                id="first_name"
                                v-model="profile.first_name"
                                type="text"
                                class="form-input"
                                placeholder="Your first name"
                            />
                        </div>
                        <div class="form-group">
                            <label for="last_name" class="form-label">Last Name</label>
                            <input
                                id="last_name"
                                v-model="profile.last_name"
                                type="text"
                                class="form-input"
                                placeholder="Your last name"
                            />
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="username" class="form-label">Username</label>
                            <input
                                id="username"
                                v-model="profile.username"
                                type="text"
                                class="form-input"
                                placeholder="username"
                            />
                        </div>
                        <div class="form-group">
                            <label for="location" class="form-label">Location</label>
                            <input
                                id="location"
                                v-model="profile.location"
                                type="text"
                                class="form-input"
                                placeholder="Warsaw, Poland"
                            />
                        </div>
                    </div>
                </section>

                <section class="form-section">
                    <h2 class="section-title">About Me</h2>
                    <div class="form-group">
                        <label for="bio" class="form-label">Bio</label>
                        <textarea
                            id="bio"
                            v-model="profile.bio"
                            class="form-textarea"
                            placeholder="Tell us about yourself..."
                            rows="4"
                        ></textarea>
                    </div>
                </section>

                <section class="form-section">
                    <h2 class="section-title">Experience</h2>
                    <div class="form-row">
                        <div class="form-group">
                            <label for="experience_years" class="form-label"
                                >Years of Experience</label
                            >
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

                <section class="form-section">
                    <h2 class="section-title">Skills</h2>
                    <div class="skill-input-group">
                        <input
                            v-model="newSkill"
                            type="text"
                            class="form-input"
                            placeholder="Add skill (e.g. JavaScript)"
                            @keyup.enter="handleAddSkill"
                        />
                        <Button type="button" variant="add-skill" @click="handleAddSkill">
                            Add
                        </Button>
                    </div>
                    <div v-if="profile.skills && profile.skills.length > 0" class="skills-list">
                        <span v-for="skill in profile.skills" :key="skill" class="skill-tag">
                            {{ skill }}
                            <Button
                                type="button"
                                variant="remove-skill"
                                @click="handleRemoveSkill(skill)"
                                text="×"
                            />
                        </span>
                    </div>
                </section>

                <section class="form-section">
                    <h2 class="section-title">Social Links</h2>
                    <div class="form-group">
                        <label for="website_url" class="form-label">Website</label>
                        <input
                            id="website_url"
                            v-model="profile.website_url"
                            type="url"
                            class="form-input"
                            placeholder="https://your-website.com"
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
                                placeholder="https://linkedin.com/in/your-profile"
                            />
                        </div>
                        <div class="form-group">
                            <label for="github_url" class="form-label">GitHub</label>
                            <input
                                id="github_url"
                                v-model="profile.github_url"
                                type="url"
                                class="form-input"
                                placeholder="https://github.com/your-profile"
                            />
                        </div>
                    </div>
                </section>

                <section class="form-section">
                    <h2 class="section-title">Account Type</h2>
                    <div class="checkbox-group">
                        <label class="checkbox-label">
                            <input
                                v-model="profile.is_recruiter"
                                type="checkbox"
                                class="checkbox-input"
                            />
                            <span class="checkbox-text">I am a recruiter</span>
                        </label>
                        <small class="form-hint">
                            Recruiter accounts have access to additional job posting management
                            features
                        </small>
                    </div>
                </section>

                <div class="form-actions">
                    <Button type="submit" variant="save" :disabled="isSaving">
                        <span v-if="isSaving">Saving...</span>
                        <span v-else>Save Changes</span>
                    </Button>

                    <Button type="button" variant="logout" @click="handleSignOut" text="Sign Out" />
                </div>
            </form>
        </div>
    </div>
</template>

<style scoped>
.settings-container {
    min-height: 100vh;
    background-color: var(--color-background-tertiary);
    padding: 2rem 1rem;
}

.settings-card {
    max-width: 900px;
    margin: 0 auto;
    background: var(--color-background);
    border-radius: 12px;
    box-shadow:
        0 4px 6px -1px rgba(0, 0, 0, 0.1),
        0 2px 4px -1px rgba(0, 0, 0, 0.06);
    overflow: hidden;
}

.settings-header {
    background: linear-gradient(135deg, var(--color-primary) 0%, var(--color-primary-hover) 100%);
    color: var(--color-background);
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
    border: 3px solid var(--color-border);
    border-top: 3px solid var(--color-primary);
    border-radius: 50%;
    animation: spin 1s linear infinite;
    margin: 0 auto 1rem;
}

@keyframes spin {
    0% {
        transform: rotate(0deg);
    }
    100% {
        transform: rotate(360deg);
    }
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
    background-color: var(--color-success-bg);
    color: var(--color-success);
    border: 1px solid var(--color-success-border);
}

.message.error {
    background-color: var(--color-error-bg);
    color: var(--color-error);
    border: 1px solid var(--color-error-border);
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
    border-bottom: 2px solid var(--color-border);
}

.form-row {
    display: grid;
    grid-template-columns: 1fr;
    gap: 1rem;
}

@media (min-width: 768px) {
    .form-row {
        grid-template-columns: repeat(2, 1fr);
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
    margin-top: 1rem;
}

.form-input,
.form-textarea {
    padding: 0.75rem 1rem;
    border: 1px solid var(--color-border-light);
    border-radius: 6px;
    font-size: 1rem;
    transition: all 0.2s ease;
    background-color: var(--color-background);
}

.form-input:focus,
.form-textarea:focus {
    outline: none;
    border-color: var(--color-primary);
    box-shadow: 0 0 0 3px rgba(0, 96, 251, 0.1);
}

.form-input:disabled {
    background-color: var(--color-background-secondary);
    color: var(--color-text-tertiary);
    cursor: not-allowed;
}

.form-hint {
    font-size: 0.75rem;
    color: var(--gray-600);
    margin-bottom: 0.5rem;
}

.skill-input-group {
    display: flex;
    gap: 0.5rem;
    margin-bottom: 1rem;
}

.skill-input-group .form-input {
    flex: 1;
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
    background-color: var(--color-info-bg-cyan);
    color: var(--color-info-cyan);
    padding: 0.5rem 0.75rem;
    border-radius: 20px;
    font-size: 0.875rem;
    font-weight: 500;
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
    border: 2px solid var(--color-border-light);
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
    border-top: 1px solid var(--color-border);
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

    .skill-input-group {
        flex-direction: column;
    }
}
</style>
