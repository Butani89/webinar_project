<script setup lang="ts">
import { ref } from 'vue'
import { Calendar, Mail, User, Building } from 'lucide-vue-next'

const form = ref({
  name: '',
  email: '',
  company: '',
  experience: 'nyborjare',
  date: '2025-12-24'
})

const feedback = ref({ message: '', isError: false, imageUrl: '' })
const isSubmitting = ref(false)

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
</template>
