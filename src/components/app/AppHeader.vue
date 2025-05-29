<script setup lang="ts">
import { ref, watch, onUnmounted } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '@/stores/auth'
import Button from '@/components/ui/Button.vue'
import MenuItem from '@/components/ui/MenuItem.vue'

const router = useRouter()
const authStore = useAuthStore()

const isMobileMenuOpen = ref(false)
const isUserMenuOpen = ref(false)

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
					<MenuItem label="Find a job" link="/find-a-job" hasArrow>
						<template #content>
							<div class="dropdown-content">
								<h2>Job Categories</h2>
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
			<ul class="mobile-menu-list">
				<li class="mobile-menu-item">
					<router-link to="/" class="mobile-menu-link" @click="handleCloseMobileMenu">
						Home
					</router-link>
				</li>
				<li class="mobile-menu-item">
					<router-link to="/jobs" class="mobile-menu-link" @click="handleCloseMobileMenu">
						Jobs
					</router-link>
				</li>
				<li class="mobile-menu-item">
					<router-link to="/find-a-job" class="mobile-menu-link" @click="handleCloseMobileMenu">
						Find a job
					</router-link>
				</li>
				
				<div v-if="!authStore.isAuthenticated" class="mobile-auth">
					<li class="mobile-menu-item">
						<router-link to="/login" class="mobile-menu-link" @click="handleCloseMobileMenu">
							Login
						</router-link>
					</li>
					<li class="mobile-menu-item mobile-signup">
						<Button variant="primary" text="Sign Up" link="/register" @click="handleCloseMobileMenu" />
					</li>
				</div>
				
				<div v-else class="mobile-user-section">
					<li class="mobile-menu-item mobile-user-info">
						<div class="mobile-user-avatar">
							{{ authStore.userEmail?.charAt(0).toUpperCase() }}
						</div>
						<div class="mobile-user-details">
							<div class="mobile-user-email">{{ authStore.userEmail }}</div>
						</div>
					</li>
					<li class="mobile-menu-item">
						<button class="mobile-menu-link" @click="handleNavigateToSettings">
							Account Settings
						</button>
					</li>
					<li class="mobile-menu-item">
						<button class="mobile-menu-link logout" @click="handleSignOut">
							Sign Out
						</button>
					</li>
				</div>
			</ul>
		</nav>
	</header>
</template>

<style scoped>
/* Base Header Styles */
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

/* Logo */
.logo-wrapper {
	flex-shrink: 0;
}

.logo-text {
	font-size: 1.5rem;
	font-weight: 700;
	color: #111827;
	text-decoration: none;
}

/* Desktop Navigation */
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

/* Desktop Actions */
.desktop-actions {
	display: none;
}

/* Mobile Menu Toggle */
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

/* Mobile Overlay */
.mobile-overlay {
	position: fixed;
	top: 0;
	left: 0;
	right: 0;
	bottom: 0;
	background-color: rgba(0, 0, 0, 0.5);
	z-index: 118;
}

/* Mobile Navigation */
.mobile-nav {
	position: fixed;
	top: 0;
	right: -100%;
	height: 100vh;
	width: 280px;
	background-color: var(--color-background, #ffffff);
	box-shadow: -2px 0 10px rgba(0, 0, 0, 0.1);
	transition: right 0.3s ease-in-out;
	z-index: 120;
	padding-top: 5rem;
}

.mobile-nav-open {
	right: 0;
}

.mobile-menu-list {
	list-style: none;
	margin: 0;
	padding: 0;
	display: flex;
	flex-direction: column;
}

.mobile-menu-item {
	border-bottom: 1px solid #f3f4f6;
}

.mobile-menu-link {
	display: block;
	padding: 1rem 1.5rem;
	color: #374151;
	text-decoration: none;
	font-size: 1rem;
	font-weight: 500;
	transition: background-color 0.2s;
}

.mobile-menu-link:hover {
	background-color: #f9fafb;
	color: #111827;
}

.mobile-login {
	padding: 1.5rem;
	border-bottom: none;
}

/* Dropdown Content */
.dropdown-content {
	border: 2px solid var(--gray-600, #4b5563);
	border-radius: 1rem;
	background-color: var(--color-background, #ffffff);
	position: absolute;
	top: 30px;
	left: 0;
	padding: 2.5rem 3.75rem;
	box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
}

.dropdown-content h2 {
	margin: 0;
	font-size: 1.125rem;
	color: #111827;
}

/* Tablet Styles (768px+) */
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

/* Desktop Styles (1024px+) */
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

/* Large Desktop (1280px+) */
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

/* Extra Large Desktop (1536px+) */
@media (min-width: 1536px) {
	.header-wrapper {
		max-width: 1536px;
		padding: 2rem 3rem;
	}
}

/* Focus and Accessibility */
.menu-link:focus,
.mobile-menu-link:focus {
	outline: none;
	box-shadow: 0 0 0 2px #3b82f6;
	border-radius: 0.25rem;
}

/* Animations */
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

/* Auth Buttons */
.auth-buttons {
	display: flex;
	align-items: center;
	gap: 0.75rem;
}

/* User Menu Styles */
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

/* Mobile User Styles */
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