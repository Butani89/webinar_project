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
    'fixed top-0 left-0 right-0 z-50 transition-all duration-500 px-8 py-6 flex items-center justify-between',
    isScrolled ? 'bg-black/80 backdrop-blur-2xl border-b border-white/5 py-4' : 'bg-transparent'
  ]">
    <div class="flex items-center gap-4 group cursor-pointer">
      <div class="w-10 h-10 bg-brand-gold/10 rounded-xl flex items-center justify-center border border-brand-gold/20 group-hover:rotate-12 transition-transform">
        <img src="/img/logo.png" alt="Logo" class="w-6 h-6">
      </div>
      <span class="text-2xl font-black text-white tracking-tighter uppercase">SVAMPARNAS <span class="text-brand-gold">VÄRLD</span></span>
    </div>
    
    <div class="hidden md:flex items-center gap-12">
      <a href="#speakers" class="text-[10px] font-black text-white/40 hover:text-brand-gold tracking-[0.3em] uppercase transition-all">Visionaries</a>
      <a href="#agenda" class="text-[10px] font-black text-white/40 hover:text-brand-gold tracking-[0.3em] uppercase transition-all">The Map</a>
      <a href="#register" class="group relative px-8 py-3 bg-brand-gold text-brand-obsidian text-[10px] font-black tracking-[0.3em] uppercase rounded-full transition-all hover:shadow-[0_0_30px_rgba(251,191,36,0.3)] overflow-hidden">
        <span class="relative z-10">Entry Protocol</span>
        <div class="absolute inset-0 bg-white opacity-0 group-hover:opacity-20 transition-opacity"></div>
      </a>
    </div>
  </nav>
</template>