<script setup lang="ts">
import { ref, onMounted } from 'vue'
import Header from './components/Header.vue'
import Hero from './components/Hero.vue'
import Speakers from './components/Speakers.vue'
import Agenda from './components/Agenda.vue'
import RegisterForm from './components/RegisterForm.vue'
import { Github, Twitter, Linkedin, Mail } from 'lucide-vue-next'

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
    countdown.value = `${days}d ${hours}t ${minutes}m`
  }
}

onMounted(() => {
  updateCountdown()
  setInterval(updateCountdown, 60000)
})
</script>

<template>
  <div class="min-h-screen selection:bg-mushroom-accent selection:text-white">
    <Header />

    <main>
      <Hero :countdown="countdown" />
      <Speakers />
      <Agenda />
      <RegisterForm />
    </main>

    <footer class="bg-mushroom-dark text-white pt-24 pb-12 px-6">
      <div class="max-w-6xl mx-auto">
        <div class="grid grid-cols-1 md:grid-cols-4 gap-12 mb-16">
          <div class="col-span-1 md:col-span-2">
            <div class="flex items-center gap-3 mb-6">
              <img src="/img/logo.png" alt="Logo" class="w-12 h-12">
              <span class="text-2xl font-black tracking-tight">Svamparnas Värld</span>
            </div>
            <p class="text-white/60 leading-relaxed max-w-sm mb-8">
              En djupdykning i myceliets psykologi och hur vi kan skapa musik tillsammans. Följ med oss på en resa bortom det synliga.
            </p>
            <div class="flex gap-4">
              <a href="#" class="p-3 rounded-xl bg-white/5 hover:bg-white/10 transition-colors"><Twitter class="w-5 h-5" /></a>
              <a href="#" class="p-3 rounded-xl bg-white/5 hover:bg-white/10 transition-colors"><Linkedin class="w-5 h-5" /></a>
              <a href="#" class="p-3 rounded-xl bg-white/5 hover:bg-white/10 transition-colors"><Github class="w-5 h-5" /></a>
            </div>
          </div>
          
          <div>
            <h4 class="font-bold mb-6 text-mushroom-gold">Länkar</h4>
            <ul class="space-y-4 text-white/60">
              <li><a href="#about" class="hover:text-white transition-colors">Om Eventet</a></li>
              <li><a href="#speakers" class="hover:text-white transition-colors">Föreläsare</a></li>
              <li><a href="#agenda" class="hover:text-white transition-colors">Agenda</a></li>
              <li><a href="#register" class="hover:text-white transition-colors">Registrering</a></li>
            </ul>
          </div>

          <div>
            <h4 class="font-bold mb-6 text-mushroom-gold">Kontakt</h4>
            <ul class="space-y-4 text-white/60">
              <li class="flex items-center gap-3"><Mail class="w-4 h-4" /> event@svampar.se</li>
              <li class="text-sm">Loopaware AB<br>Mushroom Street 42<br>Stockholm, Sweden</li>
            </ul>
          </div>
        </div>
        
        <div class="pt-8 border-t border-white/10 flex flex-col md:flex-row justify-between items-center gap-4 text-sm text-white/40">
          <p>&copy; 2025 Svamparnas Värld. Alla rättigheter förbehållna.</p>
          <div class="flex gap-6">
            <a href="#" class="hover:text-white transition-colors">Integritetspolicy</a>
            <a href="#" class="hover:text-white transition-colors">Användarvillkor</a>
          </div>
        </div>
      </div>
    </footer>
  </div>
</template>

<style>
html {
  scroll-behavior: smooth;
}
</style>
