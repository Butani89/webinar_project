<script setup lang="ts">
import { ref, onMounted } from 'vue'
import Header from './components/Header.vue'
import Hero from './components/Hero.vue'
import RegisterForm from './components/RegisterForm.vue'

const countdown = ref('')

const updateCountdown = () => {
  const eventDate = new Date("December 24, 2025 10:00:00").getTime()
  const now = new Date().getTime()
  const distance = eventDate - now

  if (distance < 0) {
    countdown.value = "Webinariet har startat!"
  } else {
    const days = Math.floor(distance / (1000 * 60 * 60 * 24))
    const hours = Math.floor((distance % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60))
    const minutes = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60))
    countdown.value = `Sändningen startar om: ${days}d ${hours}t ${minutes}m`
  }
}

onMounted(() => {
  updateCountdown()
  setInterval(updateCountdown, 60000)
})
</script>

<template>
  <div class="min-h-screen font-sans text-gray-900 bg-gradient-to-br from-gray-50 to-blue-50">
    <Header />

    <main class="max-w-4xl px-4 mx-auto mt-12 mb-20">
      <Hero :countdown="countdown" />
      <RegisterForm />
    </main>

    <footer class="py-12 text-center text-gray-500">
      <p>&copy; 2025 Svamparnas Värld | Scaffolding with Vue & Tailwind</p>
    </footer>
  </div>
</template>