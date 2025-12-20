<script setup lang="ts">
import { Clock } from 'lucide-vue-next'

const items = [
  { time: '10:00', title: 'Introduktion: Det osynliga nätverket', category: 'Intro' },
  { time: '10:45', title: 'Bio-elektrisk kommunikation i skogen', category: 'Vetenskap', highlight: true },
  { time: '12:15', title: 'Lunchpaus & Nätverkande', category: 'Paus' },
  { time: '13:15', title: 'Att översätta mycelium till melodi', category: 'Workshop', highlight: true },
  { time: '15:00', title: 'Paneldiskussion: Framtidens mykologi', category: 'Debatt' },
  { time: '16:00', title: 'Avslutning', category: 'Slut' }
]
</script>

<template>
  <section id="agenda" class="py-24 px-4 bg-white relative overflow-hidden">
    <!-- Decor -->
    <div class="absolute top-0 right-0 w-64 h-64 bg-brand-mist rounded-full -mr-32 -mt-32 opacity-50"></div>
    
    <div class="max-w-4xl mx-auto relative z-10">
      <div class="text-center mb-16">
        <h2 class="text-4xl md:text-5xl font-black text-brand-forest mb-4">Programöversikt</h2>
        <p class="text-gray-600">En dag fylld av insikter och auditiva upplevelser.</p>
      </div>

      <div class="space-y-6">
        <div v-for="item in items" :key="item.time" 
          :class="[
            'flex items-center gap-6 p-6 rounded-3xl transition-all border-2',
            item.highlight ? 'bg-brand-forest text-white border-brand-forest shadow-xl scale-[1.02]' : 'bg-brand-mist border-transparent hover:border-brand-mycelium/20'
          ]">
          <div :class="['w-20 font-mono font-bold text-xl', item.highlight ? 'text-brand-gold' : 'text-brand-forest']">
            {{ item.time }}
          </div>
          <div class="flex-1">
            <div :class="['text-xs uppercase font-black tracking-widest mb-1 opacity-60']">{{ item.category }}</div>
            <div class="text-lg font-bold leading-tight">{{ item.title }}</div>
          </div>
          <Clock :class="['w-6 h-6 opacity-30', item.highlight ? 'text-white' : 'text-brand-forest']" />
        </div>
      </div>
    </div>
  </section>
</template>
