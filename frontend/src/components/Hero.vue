<script setup lang="ts">
import { Trees, Music, Sparkles, ChevronDown, Award } from 'lucide-vue-next'

defineProps<{
  countdown: string
  event_date: string
}>()
</script>

<template>
  <section class="relative min-h-screen flex flex-col items-center justify-center text-center px-6 overflow-hidden bg-transparent pt-32">
    <!-- Premium Atmosphere -->
    <div class="absolute inset-0 bg-cinematic-gradient pointer-events-none"></div>
    <div class="absolute top-0 left-0 w-full h-full opacity-10 bg-forest-pattern mix-blend-overlay"></div>

    <div class="relative z-10 max-w-5xl mx-auto animate-fade-in-up">
      <div class="inline-flex items-center gap-3 px-6 py-2.5 mb-10 text-sm font-black tracking-[0.3em] text-brand-gold uppercase rounded-full bg-brand-gold/10 backdrop-blur-xl border border-brand-gold/20 shadow-[0_0_30px_rgba(251,191,36,0.1)]">
        <Award class="w-4 h-4" />
        Experience of a Lifetime
      </div>

      <h1 class="mb-8 text-6xl md:text-9xl font-black text-white leading-[0.9] tracking-tighter">
        DEEP <span class="text-transparent bg-clip-text bg-gradient-to-r from-brand-gold via-brand-amber to-brand-gold animate-shimmer">MYCELIUM</span> <br>SECRET
      </h1>
      
      <p class="mb-14 text-2xl md:text-3xl text-brand-mist/70 leading-relaxed max-w-3xl mx-auto font-light tracking-wide">
        Transcend the ordinary. Join the global elite in an immersive journey through the bio-electrical whispers of the earth.
      </p>

      <div class="flex flex-col md:flex-row items-center justify-center gap-6 mb-24">
        <a href="#register" class="group relative w-full md:w-auto px-12 py-6 bg-brand-gold text-brand-obsidian font-black text-xl rounded-full transition-all transform hover:-translate-y-2 shadow-[0_20px_50px_rgba(251,191,36,0.3)] hover:shadow-brand-gold/50 overflow-hidden">
          <span class="relative z-10">CLAIM YOUR TICKET</span>
          <div class="absolute inset-0 bg-white opacity-0 group-hover:opacity-20 transition-opacity"></div>
        </a>
        
        <div class="flex flex-col items-center px-8 py-4 rounded-3xl bg-white/5 backdrop-blur-2xl border border-white/10 text-white min-w-[320px]">
          <div class="text-[10px] font-black uppercase tracking-[0.4em] text-brand-gold/60 mb-2">The Unveiling Starts In</div>
          <div class="text-3xl font-mono font-black tracking-widest">{{ countdown }}</div>
        </div>
      </div>

      <!-- Feature Grid - More Minimal & Sharp -->
      <div class="grid grid-cols-1 md:grid-cols-3 gap-8 max-w-5xl mx-auto text-left opacity-80">
        <div class="p-8 rounded-[40px] bg-white/5 backdrop-blur-3xl border border-white/10 hover:bg-white/10 transition-all group">
          <Trees class="w-8 h-8 text-brand-gold mb-6 group-hover:scale-110 transition-transform" />
          <h3 class="text-xl font-black text-white mb-3 tracking-tight">BIO-NEURAL MAPS</h3>
          <p class="text-brand-mist/40 text-sm leading-relaxed">Access classified data on mushroom network intelligence.</p>
        </div>
        <div class="p-8 rounded-[40px] bg-white/5 backdrop-blur-3xl border border-white/10 hover:bg-white/10 transition-all group">
          <Music class="w-8 h-8 text-brand-amber mb-6 group-hover:scale-110 transition-transform" />
          <h3 class="text-xl font-black text-white mb-3 tracking-tight">SONIC SYMBIOSIS</h3>
          <p class="text-brand-mist/40 text-sm leading-relaxed">Live spatial audio translation of mycelium frequencies.</p>
        </div>
        <div class="p-8 rounded-[40px] bg-white/5 backdrop-blur-3xl border border-white/10 hover:bg-white/10 transition-all group">
          <Sparkles class="w-8 h-8 text-brand-gold mb-6 group-hover:scale-110 transition-transform" />
          <h3 class="text-xl font-black text-white mb-3 tracking-tight">ELITE NETWORK</h3>
          <p class="text-brand-mist/40 text-sm leading-relaxed">Connect with 50 world-leading pioneers in biological art.</p>
        </div>
      </div>
    </div>

    <a href="#speakers" class="absolute bottom-12 left-1/2 -translate-x-1/2 text-brand-gold/30 hover:text-brand-gold transition-colors animate-bounce">
      <ChevronDown class="w-10 h-10" />
    </a>
  </section>
</template>
