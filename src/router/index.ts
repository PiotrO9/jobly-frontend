import { createRouter, createWebHistory } from 'vue-router'

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
	}
  ],
})

export default router
