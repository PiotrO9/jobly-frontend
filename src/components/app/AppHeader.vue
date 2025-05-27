<script setup lang="ts">
import { ref, watch, onUnmounted } from 'vue'
import Button from '@/components/ui/Button.vue'
import MenuItem from '@/components/ui/MenuItem.vue'

const isMobileMenuOpen = ref(false)

// Watch for mobile menu changes to control body scroll
watch(isMobileMenuOpen, (isOpen) => {
	if (isOpen) {
		document.body.classList.add('scroll-locked')
	} else {
		document.body.classList.remove('scroll-locked')
	}
})

// Handle escape key to close mobile menu
function handleEscapeKey(event: KeyboardEvent) {
	if (event.key === 'Escape' && isMobileMenuOpen.value) {
		isMobileMenuOpen.value = false
	}
}

// Add/remove escape key listener
watch(isMobileMenuOpen, (isOpen) => {
	if (isOpen) {
		document.addEventListener('keydown', handleEscapeKey)
	} else {
		document.removeEventListener('keydown', handleEscapeKey)
	}
})

function handleToggleMobileMenu() {
	isMobileMenuOpen.value = !isMobileMenuOpen.value
}

function handleCloseMobileMenu() {
	isMobileMenuOpen.value = false
}

function handleKeyDown(event: KeyboardEvent) {
	if (event.key === 'Enter' || event.key === ' ') {
		event.preventDefault()
		;(event.target as HTMLElement).click()
	}
}

// Cleanup scroll lock and event listeners when component unmounts
onUnmounted(() => {
	document.body.classList.remove('scroll-locked')
	document.removeEventListener('keydown', handleEscapeKey)
})
</script>

<template>
	<header class="header">
		<div class="header-wrapper container">
			<div class="logo-wrapper">
				<span class="logo-text">
					Job board
				</span>
			</div>

			<!-- Desktop Navigation -->
			<nav class="desktop-nav">
				<ul class="menu-list">
					<li class="menu-item">
						<a href="/" class="menu-link">
							Home
						</a>
					</li>
					<li class="menu-item">
						<a href="/" class="menu-link">
							About
						</a>
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

			<!-- Desktop Login Button -->
			<div class="desktop-actions">
				<Button variant="primary" text="Login" />
			</div>

			<!-- Mobile Menu Toggle -->
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

		<!-- Mobile Navigation Overlay -->
		<div 
			v-if="isMobileMenuOpen"
			class="mobile-overlay"
			@click="handleCloseMobileMenu"
		></div>

		<!-- Mobile Navigation Menu -->
		<nav class="mobile-nav" :class="{ 'mobile-nav-open': isMobileMenuOpen }">
			<ul class="mobile-menu-list">
				<li class="mobile-menu-item">
					<a href="/" class="mobile-menu-link" @click="handleCloseMobileMenu">
						Home
					</a>
				</li>
				<li class="mobile-menu-item">
					<a href="/" class="mobile-menu-link" @click="handleCloseMobileMenu">
						About
					</a>
				</li>
				<li class="mobile-menu-item">
					<a href="/find-a-job" class="mobile-menu-link" @click="handleCloseMobileMenu">
						Find a job
					</a>
				</li>
				<li class="mobile-menu-item mobile-login">
					<Button variant="primary" text="Login" @click="handleCloseMobileMenu" />
				</li>
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
</style>