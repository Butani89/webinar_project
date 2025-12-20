<script setup lang="ts">
import { Clock, Zap } from 'lucide-vue-next'

const items = [
  { time: '10:00', title: 'THE GENESIS: THE INVISIBLE ARCHITECTURE', category: 'Phase I' },
  { time: '10:45', title: 'NEURAL HARVEST: QUANTUM BIOLOGY', category: 'Phase II', highlight: true },
  { time: '12:15', title: 'INTERMISSION: FREQUENCY ALIGNMENT', category: 'Pause' },
  { time: '13:15', title: 'SONIC AWAKENING: TRANSCENDENT WORKSHOP', category: 'Phase III', highlight: true },
  { time: '15:00', title: 'SYMPOSIUM: THE FUTURE OF CONSCIOUSNESS', category: 'Dialogue' },
  { time: '16:00', title: 'THE ASCENSION: CLOSING CEREMONY', category: 'Finale' }
]
</script>

<template>
  <section id="agenda" class="py-32 px-6 bg-brand-obsidian relative overflow-hidden">
    <!-- Premium Atmosphere -->
    <div class="absolute top-0 right-0 w-[600px] h-[600px] bg-brand-gold/5 rounded-full blur-[120px] -mr-64 -mt-64"></div>
    
    <div class="max-w-5xl mx-auto relative z-10">
      <div class="text-center mb-24">
        <div class="text-brand-gold font-black tracking-[0.5em] uppercase text-xs mb-4">The Schedule</div>
        <h2 class="text-5xl md:text-7xl font-black text-white mb-6 tracking-tighter">PHASE LOG</h2>
        <div class="w-24 h-1 bg-brand-gold mx-auto"></div>
      </div>

      <div class="space-y-4">
        <div v-for="item in items" :key="item.time" 
          :class="[
            'group flex flex-col md:flex-row items-start md:items-center gap-6 p-8 md:p-10 rounded-[2rem] transition-all border-2 backdrop-blur-2xl',
            item.highlight ? 'bg-white/5 border-brand-gold/30 shadow-[0_0_50px_rgba(251,191,36,0.05)]' : 'bg-transparent border-white/5 hover:border-white/10'
          ]">
          <div :class="['font-mono font-black text-3xl md:text-4xl tracking-tighter', item.highlight ? 'text-brand-gold' : 'text-white/20']">
            {{ item.time }}
          </div>
          <div class="flex-1">
            <div :class="['text-[10px] uppercase font-black tracking-[0.3em] mb-2', item.highlight ? 'text-brand-amber' : 'text-brand-gold/40']">
              {{ item.category }}
            </div>
            <div class="text-xl md:text-2xl font-black text-white tracking-tight group-hover:text-brand-gold transition-colors">
              {{ item.title }}
            </div>
          </div>
          <Zap v-if="item.highlight" class="w-8 h-8 text-brand-gold animate-pulse" />
          <Clock v-else class="w-6 h-6 text-white/10" />
        </div>
      </div>
    </div>
  </section>
</template>