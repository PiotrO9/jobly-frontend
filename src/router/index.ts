import { createRouter, createWebHistory } from 'vue-router'
import { useAuthStore } from '@/stores/auth'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      name: 'home',
	  component: () => import('../views/HomeView.vue')
    },
	{
		path: '/design-system',
		name: 'design-system',
		component: () => import('../views/DesignSystemView.vue')
	},
	{
		path: '/jobs',
		name: 'jobs',
		component: () => import('../views/JobsView.vue')
	},
	{
		path: '/jobs/:id',
		name: 'job-details',
		component: () => import('../views/JobDetailsView.vue')
	},
	{
		path: '/post-job',
		name: 'post-job',
		component: () => import('../views/PostJobView.vue'),
		meta: { requiresAuth: true }
	},
	{
		path: '/recruiter',
		name: 'recruiter-dashboard',
		component: () => import('../views/RecruiterDashboardView.vue'),
		meta: { requiresAuth: true, requiresRecruiter: true }
	},
	{
		path: '/recruiter/jobs',
		name: 'recruiter-jobs',
		component: () => import('../views/RecruiterJobsView.vue'),
		meta: { requiresAuth: true, requiresRecruiter: true }
	},
	{
		path: '/recruiter/applications',
		name: 'recruiter-applications',
		component: () => import('../views/RecruiterApplicationsView.vue'),
		meta: { requiresAuth: true, requiresRecruiter: true }
	},
	{
		path: '/applications',
		name: 'user-applications',
		component: () => import('../views/UserApplicationsView.vue'),
		meta: { requiresAuth: true }
	},
	{
		path: '/login',
		name: 'login',
		component: () => import('../views/LoginView.vue'),
		meta: { requiresGuest: true }
	},
	{
		path: '/register',
		name: 'register',
		component: () => import('../views/RegisterView.vue'),
		meta: { requiresGuest: true }
	},
	{
		path: '/account/settings',
		name: 'account-settings',
		component: () => import('../views/AccountSettingsView.vue'),
		meta: { requiresAuth: true }
	}
  ],
})

router.beforeEach(async (to, from, next) => {
	const authStore = useAuthStore()

	// Wait for auth to initialize if it's still loading
	if (authStore.isLoading) {
		await new Promise((resolve) => {
			const unwatch = authStore.$subscribe(() => {
				if (!authStore.isLoading) {
					unwatch()
					resolve(undefined)
				}
			})
		})
	}

	// Check if route requires authentication
	if (to.meta.requiresAuth && !authStore.isAuthenticated) {
		next('/login')
		return
	}

	// Check if route requires guest (not authenticated)
	if (to.meta.requiresGuest && authStore.isAuthenticated) {
		next('/')
		return
	}

	// Check if route requires recruiter role
	if (to.meta.requiresRecruiter && !authStore.isRecruiter) {
		// If user is authenticated but not a recruiter, redirect to home
		if (authStore.isAuthenticated) {
			next('/')
		} else {
			next('/login')
		}
		return
	}

	next()
})

export default router
