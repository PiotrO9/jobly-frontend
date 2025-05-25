<script setup lang="ts">
import Button from '@/components/ui/Button.vue'
import MenuItem from '@/components/ui/MenuItem.vue'
</script>

<template>
	<header>
		<div class="header-wrapper container">
			<div class="logo-wrapper">
				<span>
					Job board
				</span>
			</div>
			<nav>
				<ul class="menu-list">
					<li class="menu-item">
						<a href="/">
							Home
						</a>
					</li>
					<li class="menu-item">
						<a href="/">
							About
						</a>
					</li>
					<MenuItem label="Find a job" link="/find-a-job" hasArrow>
						<template #content>
							<div class="dropdown-content">
								<h2>tes2t</h2>
							</div>
						</template>
					</MenuItem>
				</ul>
			</nav>
			<Button variant="primary" text="Post a job" />
		</div>
	</header>
</template>

<style scoped>
.dropdown-content {
	border: 2px solid var(--gray-600);
	border-radius: 16px;
	background-color: var(--color-background);
	position: absolute;
	top: 30px;
	left: 0;
	padding: 40px 60px;
}

header {
	width: 100%;
	display: flex;
	justify-content: center;
	align-items: center;
}

.header-wrapper {
	background-color: var(--color-background);
	display: flex;
	align-items: center;
	justify-content: space-between;
	padding: 20px;

	.menu-list {
		display: flex;
		align-items: center;		
		gap: 20px;

		.menu-item,
		:deep(.menu-item) {
			font-weight: 600;
		}
	}
}
</style>