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
		component: () => import('../views/PostJobView.vue')
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

router.beforeEach((to, from, next) => {
	const authStore = useAuthStore()
	
	if (to.meta.requiresAuth && !authStore.isAuthenticated) {
		next('/login')
		return
	}
	
	if (to.meta.requiresGuest && authStore.isAuthenticated) {
		next('/')
		return
	}
	
	next()
})

export default router
