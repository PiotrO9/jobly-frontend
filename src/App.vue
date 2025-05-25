<script setup lang="ts">
import { RouterView } from 'vue-router'
import AppHeader from '@/components/app/AppHeader.vue'
import AppFooter from '@/components/app/AppFooter.vue'
</script>

<template>
	<AppHeader />
	<main class="app">
		<RouterView />
	</main>
	<AppFooter />
</template>

<style scoped>
.app {
	width: 100%;
	height: 100%;
}
</style>