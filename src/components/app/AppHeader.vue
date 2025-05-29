<script setup lang="ts">
import { ref, watch, onMounted, onUnmounted } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '@/stores/auth'
import Button from '@/components/ui/Button.vue'
import MenuItem from '@/components/ui/MenuItem.vue'
import { useJobCategories } from '@/composables/useJobCategories'

const router = useRouter()
const authStore = useAuthStore()
const { categories, fetchCategories } = useJobCategories()

const isMobileMenuOpen = ref(false)
const isUserMenuOpen = ref(false)
const showMobileCategories = ref(false)

watch(isMobileMenuOpen, (isOpen) => {
	if (isOpen) {
		document.body.classList.add('scroll-locked')
	} else {
		document.body.classList.remove('scroll-locked')
	}
})

function handleEscapeKey(event: KeyboardEvent) {
	if (event.key === 'Escape' && isMobileMenuOpen.value) {
		isMobileMenuOpen.value = false
	}
	if (event.key === 'Escape' && isUserMenuOpen.value) {
		isUserMenuOpen.value = false
	}
}

watch([isMobileMenuOpen, isUserMenuOpen], ([mobileOpen, userMenuOpen]) => {
	if (mobileOpen || userMenuOpen) {
		document.addEventListener('keydown', handleEscapeKey)
	} else {
		document.removeEventListener('keydown', handleEscapeKey)
	}
})

function handleToggleMobileMenu() {
	isMobileMenuOpen.value = !isMobileMenuOpen.value
	isUserMenuOpen.value = false
}

function handleCloseMobileMenu() {
	isMobileMenuOpen.value = false
}

function handleToggleUserMenu() {
	isUserMenuOpen.value = !isUserMenuOpen.value
}

function handleCloseUserMenu() {
	isUserMenuOpen.value = false
}

function handleKeyDown(event: KeyboardEvent) {
	if (event.key === 'Enter' || event.key === ' ') {
		event.preventDefault()
		;(event.target as HTMLElement).click()
	}
}

function handleNavigateToSettings() {
	router.push('/account/settings')
	handleCloseUserMenu()
	handleCloseMobileMenu()
}

async function handleSignOut() {
	try {
		await authStore.signOut()
		router.push('/')
		handleCloseUserMenu()
		handleCloseMobileMenu()
	} catch (error) {
		console.error('Logout failed:', error)
	}
}

function handleClickOutside(event: Event) {
	const target = event.target as HTMLElement
	const userMenu = document.querySelector('.user-menu')
	const userButton = document.querySelector('.user-menu-button')
	
	if (userMenu && !userMenu.contains(target) && !userButton?.contains(target)) {
		isUserMenuOpen.value = false
	}
}

watch(isUserMenuOpen, (isOpen) => {
	if (isOpen) {
		document.addEventListener('click', handleClickOutside)
	} else {
		document.removeEventListener('click', handleClickOutside)
	}
})

function handleNavigateToCategory(categoryId: string) {
	router.push({ path: '/jobs', query: { category: categoryId } })
}

function toggleMobileCategories() {
	showMobileCategories.value = !showMobileCategories.value
}

function handleMobileCategoryClick(categoryId: string) {
	router.push({ path: '/jobs', query: { category: categoryId } })
	showMobileCategories.value = false
	handleCloseMobileMenu()
}

function handleViewAllJobs() {
	router.push({ path: '/jobs' })
}

onMounted(async () => {
	await fetchCategories()
})

onUnmounted(() => {
	document.body.classList.remove('scroll-locked')
	document.removeEventListener('keydown', handleEscapeKey)
	document.removeEventListener('click', handleClickOutside)
})
</script>

<template>
	<header class="header">
		<div class="header-wrapper container">
			<div class="logo-wrapper">
				<router-link to="/" class="logo-text">
					Job board
				</router-link>
			</div>

			<nav class="desktop-nav">
				<ul class="menu-list">
					<li class="menu-item">
						<router-link to="/" class="menu-link">
							Home
						</router-link>
					</li>
					<li class="menu-item">
						<router-link to="/jobs" class="menu-link">
							Jobs
						</router-link>
					</li>
					<MenuItem label="Find a job" hasArrow>
						<template #content>
							<div class="dropdown-content">
								<h3 class="dropdown-title">Job Categories</h3>
								<ul class="categories-list">
									<li 
										v-for="category in categories" 
										:key="category.id"
										class="category-item"
									>
										<button
											@click="handleNavigateToCategory(category.id)"
											@keydown="handleKeyDown"
											tabindex="0"
											:aria-label="`Browse ${category.name} jobs`"
											class="category-link"
										>
											<span class="category-name">{{ category.name }}</span>
											<span v-if="category.description" class="category-description">
												{{ category.description }}
											</span>
										</button>
									</li>
								</ul>
								<div class="dropdown-footer">
									<Button 
										variant="details" 
										text="View All Jobs" 
										@click="handleViewAllJobs" 
										@keydown="handleKeyDown" 
										tabindex="0" 
										class="view-all-link"
										aria-label="View all jobs" 
									/>
								</div>
							</div>
						</template>
					</MenuItem>
				</ul>
			</nav>

			<div class="desktop-actions">
				<div v-if="!authStore.isAuthenticated" class="auth-buttons">
					<Button variant="secondary" text="Login" link="/login" />
					<Button variant="primary" text="Sign Up" link="/register" />
				</div>
				
				<div v-else class="user-menu-wrapper">
					<button 
						class="user-menu-button"
						@click="handleToggleUserMenu"
						@keydown="handleKeyDown"
						tabindex="0"
						aria-label="User menu"
						:aria-expanded="isUserMenuOpen"
					>
						<div class="user-avatar">
							{{ authStore.userEmail?.charAt(0).toUpperCase() }}
						</div>
						<span class="user-email">{{ authStore.userEmail }}</span>
						<svg class="chevron-icon" :class="{ 'rotated': isUserMenuOpen }" xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
							<polyline points="6,9 12,15 18,9"></polyline>
						</svg>
					</button>
					
					<div v-if="isUserMenuOpen" class="user-menu">
						<div class="user-menu-header">
							<div class="user-info">
								<div class="user-name">{{ authStore.userEmail }}</div>
							</div>
						</div>
						<div class="user-menu-divider"></div>
						<div class="user-menu-items">
							<button class="user-menu-item" @click="handleNavigateToSettings">
								<svg class="menu-icon" xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
									<circle cx="12" cy="12" r="3"></circle>
									<path d="m12 1 1.27 2.76 2.76 1.27-2.76 1.27L12 9l-1.27-2.76-2.76-1.27 2.76-1.27L12 1"></path>
									<path d="m19 12 1.27 2.76 2.76 1.27-2.76 1.27L19 21l-1.27-2.76-2.76-1.27 2.76-1.27L19 12"></path>
								</svg>
								Account Settings
							</button>
							<button class="user-menu-item logout" @click="handleSignOut">
								<svg class="menu-icon" xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
									<path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"></path>
									<polyline points="16,17 21,12 16,7"></polyline>
									<line x1="21" y1="12" x2="9" y2="12"></line>
								</svg>
								Sign Out
							</button>
						</div>
					</div>
				</div>
			</div>

			<button 
				class="mobile-menu-toggle"
				@click="handleToggleMobileMenu"
				@keydown="handleKeyDown"
				tabindex="0"
				aria-label="Toggle mobile menu"
				:aria-expanded="isMobileMenuOpen"
			>
				<span class="hamburger-line" :class="{ 'active': isMobileMenuOpen }"></span>
				<span class="hamburger-line" :class="{ 'active': isMobileMenuOpen }"></span>
				<span class="hamburger-line" :class="{ 'active': isMobileMenuOpen }"></span>
			</button>
		</div>

		<div 
			v-if="isMobileMenuOpen"
			class="mobile-overlay"
			@click="handleCloseMobileMenu"
		></div>

		<nav class="mobile-nav" :class="{ 'mobile-nav-open': isMobileMenuOpen }">
			<div class="mobile-nav-header">
				<div class="mobile-nav-title">Menu</div>
				<button 
					class="mobile-nav-close"
					@click="handleCloseMobileMenu"
					@keydown="handleKeyDown"
					tabindex="0"
					aria-label="Close menu"
				>
				</button>
			</div>
			
			<div class="mobile-nav-content">
				<ul class="mobile-menu-list">
					<li class="mobile-menu-item">
						<router-link to="/" class="mobile-menu-link" @click="handleCloseMobileMenu">
							<svg class="mobile-menu-icon" xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
								<path d="m3 9 9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"></path>
								<polyline points="9,22 9,12 15,12 15,22"></polyline>
							</svg>
							Home
						</router-link>
					</li>
					<li class="mobile-menu-item">
						<router-link to="/jobs" class="mobile-menu-link" @click="handleCloseMobileMenu">
							<svg class="mobile-menu-icon" xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
								<rect x="2" y="3" width="20" height="14" rx="2" ry="2"></rect>
								<line x1="8" y1="21" x2="16" y2="21"></line>
								<line x1="12" y1="17" x2="12" y2="21"></line>
							</svg>
							Jobs
						</router-link>
					</li>
					
					<li class="mobile-menu-item mobile-categories-item">
						<button 
							class="mobile-categories-toggle"
							@click="toggleMobileCategories"
							@keydown="handleKeyDown"
							tabindex="0"
							aria-label="Toggle job categories"
							:aria-expanded="showMobileCategories"
						>
							<div class="mobile-categories-toggle-content">
								<span>Job Categories</span>
							</div>
							<svg 
								class="mobile-categories-arrow" 
								:class="{ 'rotated': showMobileCategories }"
								xmlns="http://www.w3.org/2000/svg" 
								width="16" 
								height="16" 
								viewBox="0 0 24 24" 
								fill="none" 
								stroke="currentColor" 
								stroke-width="2" 
								stroke-linecap="round" 
								stroke-linejoin="round"
							>
								<polyline points="6,9 12,15 18,9"></polyline>
							</svg>
						</button>
						
						<div v-if="showMobileCategories" class="mobile-categories-list">
							<button
								v-for="category in categories"
								:key="category.id"
								@click="handleMobileCategoryClick(category.id)"
								@keydown="handleKeyDown"
								tabindex="0"
								:aria-label="`Browse ${category.name} jobs`"
								class="mobile-category-link"
							>
								<span class="mobile-category-name">{{ category.name }}</span>
								<span v-if="category.description" class="mobile-category-description">
									{{ category.description }}
								</span>
							</button>
						</div>
					</li>
				</ul>
				
				<div v-if="!authStore.isAuthenticated" class="mobile-auth-section">
					<div class="mobile-auth-buttons">
						<router-link to="/login" class="mobile-auth-link mobile-login" @click="handleCloseMobileMenu">
							Login
						</router-link>
						<router-link to="/register" class="mobile-auth-link mobile-signup" @click="handleCloseMobileMenu">
							Sign Up
						</router-link>
					</div>
				</div>
				
				<div v-else class="mobile-user-section">
					<div class="mobile-user-info">
						<div class="mobile-user-avatar">
							{{ authStore.userEmail?.charAt(0).toUpperCase() }}
						</div>
						<div class="mobile-user-details">
							<div class="mobile-user-email">{{ authStore.userEmail }}</div>
							<div class="mobile-user-status">Logged in</div>
						</div>
					</div>
					
					<div class="mobile-user-actions">
						<button class="mobile-user-action" @click="handleNavigateToSettings">
							<svg class="mobile-menu-icon" xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
								<circle cx="12" cy="12" r="3"></circle>
								<path d="m12 1 1.27 2.76 2.76 1.27-2.76 1.27L12 9l-1.27-2.76-2.76-1.27 2.76-1.27L12 1"></path>
								<path d="m19 12 1.27 2.76 2.76 1.27-2.76 1.27L19 21l-1.27-2.76-2.76-1.27 2.76-1.27L19 12"></path>
							</svg>
							Account Settings
						</button>
						<button class="mobile-user-action mobile-logout" @click="handleSignOut">
							<svg class="mobile-menu-icon" xmlns="http://www.w3.org/2000/svg" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
								<path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"></path>
								<polyline points="16,17 21,12 16,7"></polyline>
								<line x1="21" y1="12" x2="9" y2="12"></line>
							</svg>
							Sign Out
						</button>
					</div>
				</div>
			</div>
		</nav>
	</header>
</template>

<style scoped>
.header {
	width: 100%;
	background-color: var(--color-background, #ffffff);
	border-bottom: 1px solid #e5e7eb;
	position: sticky;
	top: 0;
	z-index: 110;
}

.header-wrapper {
	display: flex;
	align-items: center;
	justify-content: space-between;
	padding: 1rem 1.25rem;
	max-width: 1200px;
	margin: 0 auto;
}

.logo-wrapper {
	flex-shrink: 0;
}

.logo-text {
	font-size: 1.5rem;
	font-weight: 700;
	color: #111827;
	text-decoration: none;
}

.desktop-nav {
	display: none;
}

.menu-list {
	display: flex;
	align-items: center;
	gap: 2rem;
	list-style: none;
	margin: 0;
	padding: 0;
}

.menu-item {
	font-weight: 600;
}

.menu-link {
	color: #374151;
	text-decoration: none;
	font-size: 0.875rem;
	font-weight: 500;
	padding: 0.5rem 0;
	transition: color 0.2s;
}

.menu-link:hover {
	color: #111827;
}

.desktop-actions {
	display: none;
}

.dropdown-content {
	border: 2px solid var(--gray-600, #4b5563);
	border-radius: 1rem;
	background-color: var(--color-background, #ffffff);
	position: absolute;
	top: 30px;
	left: 0;
	padding: 1.5rem;
	box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
	min-width: 320px;
	max-width: 400px;
}

.dropdown-title {
	margin: 0 0 1rem 0;
	font-size: 1.125rem;
	font-weight: 600;
	color: #111827;
}

.categories-list {
	list-style: none;
	margin: 0;
	padding: 0;
	display: flex;
	flex-direction: column;
	gap: 0.5rem;
}

.category-item {
	margin: 0;
}

.category-link {
	display: flex;
	align-items: center;
	justify-content: space-between;
	width: 100%;
	padding: 0.75rem;
	background: none;
	border: none;
	border-radius: 0.5rem;
	text-align: left;
	cursor: pointer;
	transition: background-color 0.2s ease;
}

.category-link:hover {
	background-color: #f9fafb;
}

.category-link:focus {
	outline: none;
	box-shadow: 0 0 0 2px #3b82f6;
	background-color: #f9fafb;
}

.category-name {
	font-weight: 500;
	font-size: 0.875rem;
	color: #111827;
}

.category-description {
	font-size: 0.75rem;
	color: #6b7280;
	margin-left: auto;
	text-align: end;
}

.dropdown-footer {
	margin-top: 1rem;
	padding-top: 1rem;
	border-top: 1px solid #e5e7eb;

	.view-all-link {
		width: 100%;
	}
}

.mobile-menu-toggle {
	display: flex;
	flex-direction: column;
	justify-content: space-around;
	width: 2rem;
	height: 2rem;
	background: transparent;
	border: none;
	cursor: pointer;
	padding: 0;
	z-index: 121;
}

.mobile-menu-toggle:focus {
	outline: none;
	border-radius: 0.25rem;
}

.hamburger-line {
	width: 2rem;
	height: 0.25rem;
	background-color: #374151;
	border-radius: 0.125rem;
	transition: all 0.3s linear;
	position: relative;
	transform-origin: 1px;
}

.hamburger-line.active:nth-child(1) {
	transform: rotate(45deg);
}

.hamburger-line.active:nth-child(2) {
	opacity: 0;
	transform: translateX(20px);
}

.hamburger-line.active:nth-child(3) {
	transform: rotate(-45deg);
}

.mobile-overlay {
	position: fixed;
	top: 0;
	left: 0;
	right: 0;
	bottom: 0;
	background-color: rgba(0, 0, 0, 0.5);
	z-index: 118;
}

.mobile-nav {
	position: fixed;
	top: 0;
	right: -100%;
	height: 100vh;
	width: 320px;
	background-color: var(--color-background, #ffffff);
	box-shadow: -2px 0 20px rgba(0, 0, 0, 0.15);
	transition: right 0.3s ease-in-out;
	z-index: 120;
	display: flex;
	flex-direction: column;
}

.mobile-nav-open {
	right: 0;
}

.mobile-nav-header {
	display: flex;
	align-items: center;
	justify-content: space-between;
	padding: 1.5rem;
	border-bottom: 1px solid #e5e7eb;
	background-color: #f9fafb;
}

.mobile-nav-title {
	font-size: 1.125rem;
	font-weight: 700;
	color: #111827;
}

.mobile-nav-close {
	display: flex;
	align-items: center;
	justify-content: center;
	width: 2rem;
	height: 2rem;
	background: none;
	border: none;
	border-radius: 0.375rem;
	color: #6b7280;
	cursor: pointer;
	transition: all 0.2s ease;
}

.mobile-nav-close:hover {
	background-color: #e5e7eb;
	color: #111827;
}

.mobile-nav-content {
	flex: 1;
	display: flex;
	flex-direction: column;
	overflow-y: auto;
}

.mobile-menu-list {
	list-style: none;
	margin: 0;
	padding: 1rem 0;
	flex: 1;
}

.mobile-menu-item {
	margin: 0;
}

.mobile-menu-link {
	display: flex;
	align-items: center;
	gap: 0.75rem;
	padding: 1rem 1.5rem;
	color: #374151;
	text-decoration: none;
	font-size: 1rem;
	font-weight: 500;
	transition: all 0.2s ease;
	border-left: 3px solid transparent;
}

.mobile-menu-link:hover {
	background-color: #f9fafb;
	color: #111827;
	border-left-color: var(--color-primary, #3b82f6);
}

.mobile-menu-link.router-link-active {
	background-color: #eff6ff;
	color: var(--color-primary, #3b82f6);
	border-left-color: var(--color-primary, #3b82f6);
}

.mobile-menu-icon {
	flex-shrink: 0;
	color: currentColor;
}

.mobile-categories {
	border-bottom: 1px solid #f3f4f6;
}

.mobile-categories-toggle {
	display: flex;
	align-items: center;
	justify-content: space-between;
	width: 100%;
	padding: 1rem 1.5rem;
	background: none;
	border: none;
	color: #374151;
	text-decoration: none;
	font-size: 1rem;
	font-weight: 500;
	cursor: pointer;
	transition: background-color 0.2s;
}

.mobile-categories-toggle:hover {
	background-color: #f9fafb;
	color: #111827;
}

.mobile-categories-arrow {
	transition: transform 0.2s ease;
	color: #6b7280;
}

.mobile-categories-arrow.rotated {
	transform: rotate(180deg);
}

.mobile-categories-list {
	background-color: #f9fafb;
	border-top: 1px solid #e5e7eb;
}

.mobile-category-link {
	display: flex;
	align-items: center;
	width: 100%;
	padding: 0.75rem 2rem;
	background: none;
	border: none;
	color: #374151;
	font-size: 0.875rem;
	font-weight: 500;
	text-align: left;
	cursor: pointer;
	transition: background-color 0.2s;
	gap: 0.75rem;
	justify-content: space-between;
}

.mobile-category-link:hover {
	background-color: #f3f4f6;
	color: #111827;
}

.mobile-category-name {
	font-weight: 500;
}

.mobile-category-description {
	font-size: 0.75rem;
	color: #6b7280;
	margin-left: auto;
	text-align: end;
}

.mobile-auth-section {
	padding: 1.5rem;
	border-top: 1px solid #e5e7eb;
	background-color: #f9fafb;
}

.mobile-auth-buttons {
	display: flex;
	flex-direction: column;
	gap: 0.75rem;
}

.mobile-auth-link {
	display: flex;
	align-items: center;
	justify-content: center;
	padding: 0.875rem 1.5rem;
	border-radius: 0.5rem;
	text-decoration: none;
	font-weight: 600;
	font-size: 0.875rem;
	transition: all 0.2s ease;
}

.mobile-login {
	background-color: #ffffff;
	color: #374151;
	border: 1px solid #d1d5db;
}

.mobile-login:hover {
	background-color: #f9fafb;
	border-color: #9ca3af;
}

.mobile-signup {
	background-color: var(--color-primary, #3b82f6);
	color: #ffffff;
	border: 1px solid var(--color-primary, #3b82f6);
}

.mobile-signup:hover {
	background-color: #2563eb;
	border-color: #2563eb;
}

.mobile-user-section {
	border-top: 1px solid #e5e7eb;
	background-color: #f9fafb;
}

.mobile-user-info {
	display: flex;
	align-items: center;
	gap: 1rem;
	padding: 1.5rem;
	border-bottom: 1px solid #e5e7eb;
}

.mobile-user-avatar {
	width: 3rem;
	height: 3rem;
	background-color: var(--color-primary, #3b82f6);
	color: white;
	border-radius: 50%;
	display: flex;
	align-items: center;
	justify-content: center;
	font-weight: 700;
	font-size: 1.125rem;
	flex-shrink: 0;
}

.mobile-user-details {
	flex: 1;
	min-width: 0;
}

.mobile-user-email {
	font-weight: 600;
	color: #111827;
	font-size: 0.875rem;
	overflow: hidden;
	text-overflow: ellipsis;
	white-space: nowrap;
}

.mobile-user-status {
	font-size: 0.75rem;
	color: #6b7280;
	margin-top: 0.125rem;
}

.mobile-user-actions {
	padding: 0.5rem 0;
}

.mobile-user-action {
	display: flex;
	align-items: center;
	gap: 0.75rem;
	width: 100%;
	padding: 1rem 1.5rem;
	background: none;
	border: none;
	color: #374151;
	font-size: 0.875rem;
	font-weight: 500;
	text-align: left;
	cursor: pointer;
	transition: all 0.2s ease;
}

.mobile-user-action:hover {
	background-color: #f3f4f6;
	color: #111827;
}

.mobile-user-action.mobile-logout {
	color: #dc2626;
}

.mobile-user-action.mobile-logout:hover {
	background-color: #fef2f2;
	color: #b91c1c;
}

@media (min-width: 768px) {
	.header-wrapper {
		padding: 1.25rem 2rem;
	}

	.logo-text {
		font-size: 1.75rem;
	}

	.mobile-nav {
		width: 320px;
	}

	.mobile-menu-link {
		font-size: 1.125rem;
		padding: 1.25rem 2rem;
	}

	.mobile-login {
		padding: 2rem;
	}
}

@media (min-width: 1024px) {
	.header-wrapper {
		padding: 1.5rem 2rem;
	}

	.desktop-nav {
		display: block;
	}

	.desktop-actions {
		display: block;
	}

	.mobile-menu-toggle {
		display: none;
	}

	.mobile-nav {
		display: none;
	}

	.mobile-overlay {
		display: none;
	}

	.menu-list {
		gap: 2.5rem;
	}

	.menu-link {
		font-size: 1rem;
		padding: 0.75rem 0;
	}
}

@media (min-width: 1280px) {
	.header-wrapper {
		max-width: 1280px;
		padding: 1.5rem 2.5rem;
	}

	.logo-text {
		font-size: 2rem;
	}

	.menu-list {
		gap: 3rem;
	}

	.menu-link {
		font-size: 1.125rem;
	}
}

@media (min-width: 1536px) {
	.header-wrapper {
		max-width: 1536px;
		padding: 2rem 3rem;
	}
}

.menu-link:focus,
.mobile-menu-link:focus {
	outline: none;
	box-shadow: 0 0 0 2px #3b82f6;
	border-radius: 0.25rem;
}

@media (prefers-reduced-motion: no-preference) {
	.mobile-nav {
		transition: right 0.3s ease-in-out;
	}

	.hamburger-line {
		transition: all 0.3s linear;
	}

	.menu-link,
	.mobile-menu-link {
		transition: all 0.2s ease;
	}
}

.auth-buttons {
	display: flex;
	align-items: center;
	gap: 0.75rem;
}

.user-menu-wrapper {
	position: relative;
}

.user-menu-button {
	display: flex;
	align-items: center;
	gap: 0.5rem;
	padding: 0.5rem 0.75rem;
	background: white;
	border: 1px solid #e5e7eb;
	border-radius: 8px;
	cursor: pointer;
	transition: all 0.2s ease;
	font-size: 0.875rem;
}

.user-menu-button:hover {
	border-color: var(--color-primary);
	box-shadow: 0 0 0 3px rgba(0, 96, 251, 0.1);
}

.user-avatar {
	width: 2rem;
	height: 2rem;
	background-color: var(--color-primary);
	color: white;
	border-radius: 50%;
	display: flex;
	align-items: center;
	justify-content: center;
	font-weight: 600;
	font-size: 0.875rem;
}

.user-email {
	max-width: 150px;
	overflow: hidden;
	text-overflow: ellipsis;
	white-space: nowrap;
	color: var(--text-color);
	font-weight: 500;
}

.chevron-icon {
	transition: transform 0.2s ease;
	color: #6b7280;
}

.chevron-icon.rotated {
	transform: rotate(180deg);
}

.user-menu {
	position: absolute;
	top: calc(100% + 0.5rem);
	right: 0;
	background: white;
	border: 1px solid #e5e7eb;
	border-radius: 8px;
	box-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
	width: 280px;
	z-index: 50;
}

.user-menu-header {
	padding: 1rem;
}

.user-info {
	display: flex;
	flex-direction: column;
	gap: 0.25rem;
}

.user-name {
	font-weight: 600;
	color: var(--text-color);
	font-size: 0.875rem;
}

.user-status {
	font-size: 0.75rem;
	color: var(--gray-600);
}

.user-menu-divider {
	height: 1px;
	background-color: #e5e7eb;
}

.user-menu-items {
	padding: 0.5rem 0;
}

.user-menu-item {
	display: flex;
	align-items: center;
	gap: 0.75rem;
	width: 100%;
	padding: 0.75rem 1rem;
	background: none;
	border: none;
	text-align: left;
	font-size: 0.875rem;
	color: var(--text-color);
	cursor: pointer;
	transition: background-color 0.2s ease;
}

.user-menu-item:hover {
	background-color: #f9fafb;
}

.user-menu-item.logout {
	color: #dc2626;
}

.user-menu-item.logout:hover {
	background-color: #fef2f2;
}

.menu-icon {
	flex-shrink: 0;
	color: var(--gray-600);
}

.user-menu-item.logout .menu-icon {
	color: #dc2626;
}

.mobile-auth {
	border-top: 1px solid #f3f4f6;
	margin-top: 1rem;
	padding-top: 1rem;
}

.mobile-signup {
	padding: 1.5rem;
	border-bottom: none;
}

.mobile-user-section {
	border-top: 1px solid #f3f4f6;
	margin-top: 1rem;
	padding-top: 1rem;
}

.mobile-user-info {
	display: flex;
	align-items: center;
	gap: 1rem;
	padding: 1rem 1.5rem;
	border-bottom: 1px solid #f3f4f6;
}

.mobile-user-avatar {
	width: 2.5rem;
	height: 2.5rem;
	background-color: var(--color-primary);
	color: white;
	border-radius: 50%;
	display: flex;
	align-items: center;
	justify-content: center;
	font-weight: 600;
	font-size: 1rem;
}

.mobile-user-details {
	display: flex;
	flex-direction: column;
	gap: 0.25rem;
}

.mobile-user-email {
	font-weight: 600;
	color: var(--text-color);
	font-size: 0.875rem;
}

.mobile-user-status {
	font-size: 0.75rem;
	color: var(--gray-600);
}

.mobile-menu-link.logout {
	color: #dc2626;
}

@media (max-width: 640px) {
	.user-email {
		display: none;
	}
	
	.user-menu {
		width: 260px;
	}
}
</style>