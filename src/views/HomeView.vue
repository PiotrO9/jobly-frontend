<script setup lang="ts">
import Button from '@/components/ui/Button.vue';
</script>

<template>
    <div class="home-layout">
        <h1 class="home-layout-title">Jobly – Career Opportunities Marketplace</h1>
        <p class="home-layout-description">Jobly – Connecting employers with top talent</p>
        <div class="button-wrapper">
            <Button variant="primary" text="Find a job" size="big" link="/jobs" />
            <Button variant="secondary" text="Post a job" size="big" link="/post-job" />
        </div>
    </div>
</template>

<style scoped>
.home-layout {
	background-color: var(--color-info-bg);
	width: 100%;
	height: 100dvh;
	display: flex;
	flex-direction: column;
	align-items: center;
	justify-content: center;
	gap: 40px;

    .home-layout-title {
        font-size: 80px;
        font-weight: 500;
        color: var(--color-text-primary);
        text-align: center;
        transition: color 0.3s ease;
    }

    .home-layout-description {
        font-size: 20px;
        font-weight: 400;
        color: var(--color-text-secondary);
        transition: color 0.3s ease;
    }
}

.button-wrapper {
    display: flex;
    gap: 20px;
}
</style>
