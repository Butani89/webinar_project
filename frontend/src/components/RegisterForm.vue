<script setup lang="ts">
import { useForm } from '@inertiajs/vue3'
import { ref, watch } from 'vue'
import { Calendar, Mail, User, Building, Send, CheckCircle2, AlertCircle, ShieldCheck } from 'lucide-vue-next'

const props = defineProps<{
  new_attendee?: any
}>()

const form = useForm({
  name: '',
  email: '',
  company: '',
  experience: 'nyborjare',
  date: '2025-12-24'
})

const feedback = ref({ message: '', isError: false, imageUrl: '' })

watch(() => props.new_attendee, (newVal) => {
  if (newVal) {
    feedback.value = {
      message: `PROTOCOL ACCEPTED. Welcome, ${newVal.name}.`,
      isError: false,
      imageUrl: newVal.image_url
    }
    form.reset()
  }
}, { immediate: true })

const register = () => {
  feedback.value = { message: '', isError: false, imageUrl: '' }
  
  form.post('/register/', {
    preserveScroll: true,
    onError: (errors) => {
      feedback.value = { 
        message: Object.values(errors).join(', ') || 'Protocol error. Re-validate entries.', 
        isError: true, 
        imageUrl: '' 
      }
    }
  })
}
</script>

<template>
  <section id="register" class="py-40 px-6 bg-brand-obsidian relative overflow-hidden">
    <!-- Divine Atmosphere -->
    <div class="absolute inset-0 bg-forest-pattern opacity-5 mix-blend-overlay"></div>
    <div class="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-[1200px] h-[1200px] bg-brand-gold/10 rounded-full blur-[200px] pointer-events-none animate-pulse-soft"></div>

    <div class="max-w-4xl mx-auto relative z-10">
      <div class="bg-black/40 backdrop-blur-3xl rounded-[4rem] border border-white/5 p-10 md:p-24 shadow-[0_0_100px_rgba(0,0,0,0.5)]">
        <div class="text-center mb-20">
          <div class="w-24 h-24 bg-brand-gold/10 rounded-[2rem] flex items-center justify-center mx-auto mb-10 border border-brand-gold/20">
            <ShieldCheck class="w-12 h-12 text-brand-gold" />
          </div>
          <h2 class="text-5xl md:text-7xl font-black text-white mb-6 tracking-tighter uppercase">JOIN THE CIRCLE</h2>
          <p class="text-brand-mist/40 text-xl font-light">Enter your coordinates to begin the ascension.</p>
        </div>

        <form @submit.prevent="register" class="space-y-12">
          <div class="grid grid-cols-1 md:grid-cols-2 gap-12">
            <div class="space-y-4">
              <label class="text-[10px] font-black text-brand-gold/60 tracking-[0.3em] uppercase flex items-center gap-3">
                <User class="w-3 h-3" /> NAME / IDENTIFIER
              </label>
              <input v-model="form.name" type="text" required class="w-full px-0 py-4 bg-transparent border-b-2 border-white/10 focus:border-brand-gold text-white text-2xl font-black focus:outline-none transition-all placeholder:text-white/5" placeholder="John Doe">
            </div>
            <div class="space-y-4">
              <label class="text-[10px] font-black text-brand-gold/60 tracking-[0.3em] uppercase flex items-center gap-3">
                <Mail class="w-3 h-3" /> DIGITAL FREQUENCY (EMAIL)
              </label>
              <input v-model="form.email" type="email" required class="w-full px-0 py-4 bg-transparent border-b-2 border-white/10 focus:border-brand-gold text-white text-2xl font-black focus:outline-none transition-all placeholder:text-white/5" placeholder="frequency@ether.com">
            </div>
          </div>

          <div class="space-y-4">
            <label class="text-[10px] font-black text-brand-gold/60 tracking-[0.3em] uppercase flex items-center gap-3">
              <Building class="w-3 h-3" /> AFFILIATION
            </label>
            <input v-model="form.company" type="text" class="w-full px-0 py-4 bg-transparent border-b-2 border-white/10 focus:border-brand-gold text-white text-2xl font-black focus:outline-none transition-all placeholder:text-white/5" placeholder="The Institute">
          </div>

          <div class="grid grid-cols-1 md:grid-cols-2 gap-12">
            <div class="space-y-4">
              <label class="text-[10px] font-black text-brand-gold/60 tracking-[0.3em] uppercase">EXPERIENCE LEVEL</label>
              <select v-model="form.experience" class="w-full px-0 py-4 bg-transparent border-b-2 border-white/10 focus:border-brand-gold text-white text-xl font-black focus:outline-none transition-all appearance-none cursor-pointer">
                <option value="nyborjare" class="bg-brand-obsidian">INITIATE</option>
                <option value="intresserad" class="bg-brand-obsidian">ADVENTURER</option>
                <option value="expert" class="bg-brand-obsidian">MASTERY</option>
              </select>
            </div>
            <div class="space-y-4">
              <label class="text-[10px] font-black text-brand-gold/60 tracking-[0.3em] uppercase flex items-center gap-3">
                <Calendar class="w-3 h-3" /> CHOSEN WINDOW
              </label>
              <select v-model="form.date" class="w-full px-0 py-4 bg-transparent border-b-2 border-white/10 focus:border-brand-gold text-white text-xl font-black focus:outline-none transition-all appearance-none cursor-pointer">
                <option value="2025-12-24" class="bg-brand-obsidian">24 DEC 2025 - THE UNVEILING</option>
              </select>
            </div>
          </div>

          <button :disabled="form.processing" type="submit" class="group relative w-full py-8 bg-brand-gold text-brand-obsidian font-black text-2xl rounded-3xl transition-all shadow-[0_30px_60px_rgba(251,191,36,0.2)] hover:shadow-brand-gold/40 overflow-hidden active:scale-95 disabled:opacity-50 tracking-widest uppercase">
            <span class="relative z-10 flex items-center justify-center gap-4">
              {{ form.processing ? 'Processing coordinates...' : 'TRANSMIT REGISTRATION' }}
              <Send class="w-6 h-6 group-hover:translate-x-2 group-hover:-translate-y-2 transition-transform" />
            </span>
            <div class="absolute inset-0 bg-white opacity-0 group-hover:opacity-20 transition-opacity"></div>
          </button>
        </form>

        <!-- Feedback UI -->
        <transition enter-active-class="animate-fade-in-up" leave-active-class="opacity-0">
          <div v-if="feedback.message" :class="[
            'mt-20 p-12 rounded-[3rem] text-center border-2 transition-all backdrop-blur-3xl',
            feedback.isError ? 'bg-red-500/10 border-red-500/20 text-red-400' : 'bg-brand-gold/5 border-brand-gold/20 text-brand-gold'
          ]">
            <div class="flex flex-col items-center gap-8">
              <component :is="feedback.isError ? AlertCircle : CheckCircle2" class="w-20 h-20 mb-4 animate-pulse" />
              <div class="text-4xl font-black tracking-tighter uppercase">{{ feedback.message }}</div>
              
              <div v-if="feedback.imageUrl" class="mt-8">
                <p class="text-xs font-black tracking-[0.5em] text-white/40 mb-10 uppercase">Your Unique Biological Avatar Assigned:</p>
                <div class="relative inline-block group">
                  <div class="absolute inset-0 bg-brand-gold/40 blur-[60px] rounded-full group-hover:blur-[80px] transition-all"></div>
                  <img :src="feedback.imageUrl" alt="Avatar" class="relative w-48 h-48 rounded-[3rem] shadow-2xl border-4 border-white/10 group-hover:scale-105 transition-transform duration-500">
                </div>
              </div>
            </div>
          </div>
        </transition>
      </div>
    </div>
  </section>
</template>