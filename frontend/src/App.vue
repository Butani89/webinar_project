<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { Calendar, Mail, User, Building, Trees, Music } from 'lucide-vue-next'

const form = ref({
  name: '',
  email: '',
  company: '',
  experience: 'nyborjare',
  date: '2025-12-24'
})

const feedback = ref({ message: '', isError: false, imageUrl: '' })
const isSubmitting = ref(false)
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

const register = async () => {
  isSubmitting.value = true
  feedback.value = { message: '', isError: false, imageUrl: '' }
  
  try {
    const response = await fetch('/api/register/', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(form.value)
    })
    
    const data = await response.json()
    if (response.status === 201) {
      feedback.value = {
        message: `Tack ${form.value.name}! Din plats är reserverad.`,
        isError: false,
        imageUrl: data.image_url
      }
      form.value = { name: '', email: '', company: '', experience: 'nyborjare', date: '2025-12-24' }
    } else {
      throw new Error(data.message || 'Registreringen misslyckades')
    }
  } catch (e: any) {
    feedback.value = { message: e.message, isError: true, imageUrl: '' }
  } finally {
    isSubmitting.value = false
  }
}
</script>

<template>
  <div class="min-h-screen font-sans text-gray-900 bg-gradient-to-br from-gray-50 to-blue-50">
    <!-- Header -->
    <header class="py-12 text-center text-white shadow-lg bg-mushroom-dark animate-fade-in-down">
      <img src="/img/logo.png" alt="Logo" class="w-32 mx-auto mb-6 drop-shadow-lg">
      <h1 class="mb-4 text-5xl font-bold">Svamparnas Fascinerande Värld</h1>
      <p class="text-xl opacity-90">Utforska det underjordiska nätverket som binder samman naturen.</p>
    </header>

    <main class="max-w-4xl px-4 mx-auto mt-12 mb-20">
      <!-- Hero Section -->
      <section class="mb-12 glass-card p-8 md:p-12">
        <div class="flex flex-col items-center justify-between gap-8 md:flex-row">
          <div class="md:w-1/2">
            <h2 class="mb-6 text-3xl font-bold text-mushroom-dark border-b-4 border-mushroom-accent inline-block">Webinar: Myceliets Psykologi</h2>
            <p class="mb-6 text-lg leading-relaxed">Välkommen till en unik session där vi dyker djupt ner i hur mycelium kommunicerar och hur vi kan översätta deras bio-elektriska signaler till ljudlandskap.</p>
            <div class="p-4 rounded-xl bg-green-50 border-l-4 border-mushroom-dark">
              <p class="font-bold text-mushroom-dark">Datum: 24 dec 2025 | 10:00 - 16:00</p>
              <p class="text-sm text-gray-600 mt-1">{{ countdown }}</p>
            </div>
          </div>
          <div class="grid grid-cols-2 gap-4 md:w-1/2">
            <div class="p-6 text-center bg-white shadow-sm rounded-2xl">
              <Trees class="w-10 h-10 mx-auto mb-3 text-mushroom-dark" />
              <h4 class="font-bold">Forskning</h4>
              <p class="text-xs text-gray-500">Bio-neurobiologi</p>
            </div>
            <div class="p-6 text-center bg-white shadow-sm rounded-2xl">
              <Music class="w-10 h-10 mx-auto mb-3 text-mushroom-accent" />
              <h4 class="font-bold">Musik</h4>
              <p class="text-xs text-gray-500">Myko-melodier</p>
            </div>
          </div>
        </div>
      </section>

      <!-- Registration Form -->
      <section id="register" class="glass-card p-8 md:p-12">
        <h3 class="mb-8 text-2xl font-bold text-center text-mushroom-dark">Registrera din plats</h3>
        <form @submit.prevent="register" class="grid gap-6">
          <div class="grid gap-6 md:grid-cols-2">
            <div class="space-y-2">
              <label class="block text-sm font-semibold text-gray-700">Namn</label>
              <div class="relative">
                <User class="absolute left-3 top-3 w-5 h-5 text-gray-400" />
                <input v-model="form.name" type="text" required class="w-full pl-10 pr-4 py-3 border border-gray-200 rounded-xl focus:ring-2 focus:ring-mushroom-dark focus:outline-none transition-all" placeholder="Ditt fullständiga namn">
              </div>
            </div>
            <div class="space-y-2">
              <label class="block text-sm font-semibold text-gray-700">E-post</label>
              <div class="relative">
                <Mail class="absolute left-3 top-3 w-5 h-5 text-gray-400" />
                <input v-model="form.email" type="email" required class="w-full pl-10 pr-4 py-3 border border-gray-200 rounded-xl focus:ring-2 focus:ring-mushroom-dark focus:outline-none transition-all" placeholder="namn@exempel.se">
              </div>
            </div>
          </div>

          <div class="space-y-2">
            <label class="block text-sm font-semibold text-gray-700">Organisation (Valfritt)</label>
            <div class="relative">
              <Building class="absolute left-3 top-3 w-5 h-5 text-gray-400" />
              <input v-model="form.company" type="text" class="w-full pl-10 pr-4 py-3 border border-gray-200 rounded-xl focus:ring-2 focus:ring-mushroom-dark focus:outline-none transition-all" placeholder="Universitet eller Företag">
            </div>
          </div>

          <div class="grid gap-6 md:grid-cols-2">
            <div class="space-y-2">
              <label class="block text-sm font-semibold text-gray-700">Erfarenhetsnivå</label>
              <select v-model="form.experience" class="w-full px-4 py-3 border border-gray-200 rounded-xl focus:ring-2 focus:ring-mushroom-dark focus:outline-none bg-white">
                <option value="nyborjare">Nybörjare</option>
                <option value="intresserad">Intresserad amatör</option>
                <option value="expert">Expert/Yrkesverksam</option>
              </select>
            </div>
            <div class="space-y-2">
              <label class="block text-sm font-semibold text-gray-700">Session</label>
              <div class="relative">
                <Calendar class="absolute left-3 top-3 w-5 h-5 text-gray-400" />
                <select v-model="form.date" class="w-full pl-10 pr-4 py-3 border border-gray-200 rounded-xl focus:ring-2 focus:ring-mushroom-dark focus:outline-none bg-white">
                  <option value="2025-12-24">Huvudsession - 24 dec 2025</option>
                </select>
              </div>
            </div>
          </div>

          <button :disabled="isSubmitting" type="submit" class="w-full py-4 mt-4 text-xl font-bold text-white transition-all transform bg-mushroom-dark rounded-xl hover:bg-opacity-90 active:scale-95 disabled:opacity-50 shadow-lg">
            {{ isSubmitting ? 'Bearbetar...' : 'Anmäl mig till webinaret' }}
          </button>

          <div v-if="feedback.message" :class="['p-6 mt-6 rounded-2xl text-center', feedback.isError ? 'bg-red-50 text-red-700 border border-red-100' : 'bg-green-50 text-mushroom-dark border border-green-100 shadow-inner']">
            <p class="font-bold">{{ feedback.message }}</p>
            <div v-if="feedback.imageUrl" class="mt-4">
              <p class="text-sm mb-3">Din unika bio-genererade svamp-avatar:</p>
              <img :src="feedback.imageUrl" alt="Avatar" class="w-24 h-24 mx-auto rounded-xl shadow-md border-2 border-white">
            </div>
          </div>
        </form>
      </section>
    </main>

    <footer class="py-12 text-center text-gray-500">
      <p>&copy; 2025 Svamparnas Värld | Scaffolding with Vue & Tailwind</p>
    </footer>
  </div>
</template>
