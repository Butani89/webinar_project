<script setup lang="ts">
import { ref, onMounted, onUnmounted } from 'vue'

const isScrolled = ref(false)

const handleScroll = () => {
  isScrolled.value = window.scrollY > 50
}

onMounted(() => {
  window.addEventListener('scroll', handleScroll)
})

onUnmounted(() => {
  window.removeEventListener('scroll', handleScroll)
})
</script>

<template>
  <nav :class="[
    'fixed top-0 left-0 right-0 z-50 transition-all duration-300 px-6 py-4 flex items-center justify-between',
    isScrolled ? 'bg-mushroom-dark/90 backdrop-blur-md shadow-lg py-3' : 'bg-transparent'
  ]">
    <div class="flex items-center gap-3 group cursor-pointer">
      <img src="/img/logo.png" alt="Logo" class="w-10 h-10 transition-transform group-hover:rotate-12">
      <span class="text-xl font-bold text-white tracking-tight">Svamparnas Värld</span>
    </div>
    
    <div class="hidden md:flex items-center gap-8">
      <a href="#about" class="text-sm font-medium text-white/80 hover:text-white transition-colors">Om Eventet</a>
      <a href="#speakers" class="text-sm font-medium text-white/80 hover:text-white transition-colors">Föreläsare</a>
      <a href="#agenda" class="text-sm font-medium text-white/80 hover:text-white transition-colors">Agenda</a>
      <a href="#register" class="bg-mushroom-accent hover:bg-mushroom-gold text-white px-5 py-2 rounded-full text-sm font-bold transition-all transform hover:scale-105 shadow-md">
        Anmäl Dig
      </a>
    </div>
  </nav>
</template>