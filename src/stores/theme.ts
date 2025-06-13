import { defineStore } from 'pinia'
import { ref, watch } from 'vue'

export const useThemeStore = defineStore('theme', () => {
  const isDarkMode = ref(localStorage.getItem('theme') === 'dark')

  watch(isDarkMode, (newValue) => {
    localStorage.setItem('theme', newValue ? 'dark' : 'light')
    document.documentElement.classList.toggle('dark', newValue)
  }, { immediate: true })

  function toggleTheme() {
    isDarkMode.value = !isDarkMode.value
  }

  return {
    isDarkMode,
    toggleTheme
  }
})
