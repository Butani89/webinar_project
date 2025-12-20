<script setup lang="ts">
import { ref } from 'vue'
import { Calendar, Mail, User, Building, Send, CheckCircle2, AlertCircle } from 'lucide-vue-next'

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
        message: `Välkommen ombord, ${form.value.name}!`,
        isError: false,
        imageUrl: data.image_url
      }
      form.value = { name: '', email: '', company: '', experience: 'nyborjare', date: '2025-12-24' }
    } else {
      throw new Error(data.message || 'Ett fel uppstod vid registreringen.')
    }
  } catch (e: any) {
    feedback.value = { message: e.message, isError: true, imageUrl: '' }
  } finally {
    isSubmitting.value = false
  }
}
</script>

<template>

  <section id="register" class="py-24 px-4 bg-brand-forest relative overflow-hidden">

    <!-- Background Flare -->

    <div class="absolute inset-0 bg-forest-pattern opacity-10"></div>

    <div class="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-[800px] h-[800px] bg-brand-amber/20 rounded-full blur-[160px] pointer-events-none"></div>



    <div class="max-w-3xl mx-auto relative z-10">

      <div class="bg-white rounded-[40px] shadow-2xl p-8 md:p-16">

        <div class="text-center mb-12">

          <div class="w-16 h-16 bg-brand-mist rounded-2xl flex items-center justify-center mx-auto mb-6">

            <Send class="w-8 h-8 text-brand-forest" />

          </div>

          <h2 class="text-3xl md:text-4xl font-black text-brand-forest mb-4">Säkra Din Plats Idag</h2>

          <p class="text-gray-500">Antalet platser är begränsat för att säkerställa kvaliteten i den interaktiva sessionen.</p>

        </div>



        <form @submit.prevent="register" class="space-y-8">

          <div class="grid grid-cols-1 md:grid-cols-2 gap-8">

            <div class="space-y-3">

              <label class="text-sm font-bold text-brand-forest flex items-center gap-2">

                <User class="w-4 h-4" /> Namn

              </label>

              <input v-model="form.name" type="text" required class="w-full px-6 py-4 bg-brand-mist border-2 border-transparent focus:border-brand-mycelium/20 rounded-2xl focus:outline-none transition-all placeholder:opacity-30" placeholder="Ditt fullständiga namn">

            </div>

            <div class="space-y-3">

              <label class="text-sm font-bold text-brand-forest flex items-center gap-2">

                <Mail class="w-4 h-4" /> E-post

              </label>

              <input v-model="form.email" type="email" required class="w-full px-6 py-4 bg-brand-mist border-2 border-transparent focus:border-brand-mycelium/20 rounded-2xl focus:outline-none transition-all placeholder:opacity-30" placeholder="namn@exempel.se">

            </div>

          </div>



          <div class="space-y-3">

            <label class="text-sm font-bold text-brand-forest flex items-center gap-2">

              <Building class="w-4 h-4" /> Organisation (Valfritt)

            </label>

            <input v-model="form.company" type="text" class="w-full px-6 py-4 bg-brand-mist border-2 border-transparent focus:border-brand-mycelium/20 rounded-2xl focus:outline-none transition-all placeholder:opacity-30" placeholder="T.ex. Universitet eller Företag">

          </div>



          <div class="grid grid-cols-1 md:grid-cols-2 gap-8">

            <div class="space-y-3">

              <label class="text-sm font-bold text-brand-forest">Erfarenhetsnivå</label>

              <select v-model="form.experience" class="w-full px-6 py-4 bg-brand-mist border-2 border-transparent focus:border-brand-mycelium/20 rounded-2xl focus:outline-none transition-all appearance-none cursor-pointer">

                <option value="nyborjare">Nybörjare</option>

                <option value="intresserad">Intresserad amatör</option>

                <option value="expert">Expert/Yrkesverksam</option>

              </select>

            </div>

            <div class="space-y-3">

              <label class="text-sm font-bold text-brand-forest flex items-center gap-2">

                <Calendar class="w-4 h-4" /> Session

              </label>

              <select v-model="form.date" class="w-full px-6 py-4 bg-brand-mist border-2 border-transparent focus:border-brand-mycelium/20 rounded-2xl focus:outline-none transition-all appearance-none cursor-pointer">

                <option value="2025-12-24">Huvudsession - 24 dec 2025</option>

              </select>

            </div>

          </div>



          <button :disabled="isSubmitting" type="submit" class="group relative w-full py-5 bg-brand-forest hover:bg-black text-white font-black text-xl rounded-2xl transition-all shadow-xl hover:shadow-black/20 overflow-hidden active:scale-95 disabled:opacity-50">

            <span class="relative z-10 flex items-center justify-center gap-3">

              {{ isSubmitting ? 'Behandlar anmälan...' : 'Anmäl Mig Nu' }}

            </span>

            <div class="absolute inset-0 bg-gradient-to-r from-brand-mycelium to-brand-forest opacity-0 group-hover:opacity-100 transition-opacity"></div>

          </button>

        </form>



        <!-- Feedback UI -->

        <transition enter-active-class="animate-fade-in-up" leave-active-class="opacity-0">

          <div v-if="feedback.message" :class="[

            'mt-12 p-8 rounded-3xl text-center border-2 transition-all',

            feedback.isError ? 'bg-red-50 border-red-100 text-red-700' : 'bg-brand-mist border-brand-mycelium/10 text-brand-forest'

          ]">

            <div class="flex flex-col items-center gap-4">

              <component :is="feedback.isError ? AlertCircle : CheckCircle2" class="w-12 h-12 mb-2" />

              <div class="text-2xl font-black">{{ feedback.message }}</div>

              

              <div v-if="feedback.imageUrl" class="mt-4">

                <p class="text-sm opacity-60 mb-6">Din personliga bio-genererade svamp-avatar är redo:</p>

                <div class="relative inline-block">

                  <div class="absolute inset-0 bg-brand-amber/40 blur-2xl rounded-full"></div>

                  <img :src="feedback.imageUrl" alt="Avatar" class="relative w-32 h-32 rounded-3xl shadow-2xl border-4 border-white">

                </div>

              </div>

            </div>

          </div>

        </transition>

      </div>

    </div>

  </section>

</template>
