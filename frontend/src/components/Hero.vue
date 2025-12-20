<script setup lang="ts">
import { Trees, Music, Sparkles, ChevronDown } from 'lucide-vue-next'

defineProps<{
  countdown: string
}>()
</script>

<template>
  <section class="relative min-h-[90vh] flex flex-col items-center justify-center text-center px-4 overflow-hidden bg-mushroom-dark pt-20">
    <!-- Background Decor -->
    <div class="absolute inset-0 opacity-20 pointer-events-none bg-forest-pattern"></div>
    <div class="absolute -top-24 -left-24 w-96 h-96 bg-mushroom-medium rounded-full blur-[120px] opacity-30"></div>
    <div class="absolute -bottom-24 -right-24 w-96 h-96 bg-mushroom-accent rounded-full blur-[120px] opacity-20"></div>

    <div class="relative z-10 max-w-4xl mx-auto animate-fade-in-up">
      <div class="inline-flex items-center gap-2 px-4 py-2 mb-8 text-xs font-bold tracking-widest text-white uppercase rounded-full bg-white/10 backdrop-blur-sm border border-white/20">
        <Sparkles class="w-3 h-3 text-mushroom-gold" />
        Digitalt Event 2025
      </div>

      <h1 class="mb-6 text-5xl md:text-7xl font-extrabold text-white leading-tight">
        Myceliets <span class="text-mushroom-gold">Psykologi</span> <br>& <span class="text-mushroom-accent">Musik</span>
      </h1>
      
      <p class="mb-10 text-xl md:text-2xl text-white/80 leading-relaxed max-w-2xl mx-auto">
        Upptäck det underjordiska nätverket som binder samman naturen i en unik symbios av vetenskap och konst.
      </p>

      <div class="flex flex-col md:flex-row items-center justify-center gap-4 mb-16">
        <a href="#register" class="w-full md:w-auto px-10 py-4 bg-mushroom-accent hover:bg-mushroom-gold text-white font-black text-lg rounded-2xl transition-all transform hover:-translate-y-1 shadow-xl hover:shadow-mushroom-accent/40">
          Säkra Din Plats
        </a>
        <div class="px-6 py-4 rounded-2xl bg-white/5 backdrop-blur-md border border-white/10 text-white min-w-[280px]">
          <div class="text-xs uppercase tracking-tighter opacity-60 mb-1">Startar om</div>
          <div class="text-xl font-mono font-bold">{{ countdown }}</div>
        </div>
      </div>

      <div class="grid grid-cols-1 md:grid-cols-2 gap-6 max-w-3xl mx-auto text-left">
        <div class="p-6 rounded-3xl bg-white/5 backdrop-blur-md border border-white/10 hover:bg-white/10 transition-colors group">
          <div class="w-12 h-12 rounded-2xl bg-mushroom-medium flex items-center justify-center mb-4 group-hover:scale-110 transition-transform">
            <Trees class="w-6 h-6 text-white" />
          </div>
          <h3 class="text-xl font-bold text-white mb-2">Banbrytande Forskning</h3>
          <p class="text-white/60 text-sm">Djupdyk i mykologisk neurobiologi och hur svampar bearbetar information.</p>
        </div>
        <div class="p-6 rounded-3xl bg-white/5 backdrop-blur-md border border-white/10 hover:bg-white/10 transition-colors group">
          <div class="w-12 h-12 rounded-2xl bg-mushroom-accent flex items-center justify-center mb-4 group-hover:scale-110 transition-transform">
            <Music class="w-6 h-6 text-white" />
          </div>
          <h3 class="text-xl font-bold text-white mb-2">Live Myko-Melodier</h3>
          <p class="text-white/60 text-sm">Upplev musiken skapad av levande svampar genom sofistikerad biosensor-teknik.</p>
        </div>
      </div>
    </div>

    <!-- Scroll Indicator -->
    <a href="#speakers" class="absolute bottom-8 left-1/2 -translate-x-1/2 text-white/40 hover:text-white transition-colors animate-bounce">
      <ChevronDown class="w-8 h-8" />
    </a>
  </section>
</template>