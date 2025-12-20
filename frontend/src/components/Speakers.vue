<script setup lang="ts">
const speakers = [
  {
    name: 'Dr. M. Myceliaceae',
    title: 'Professor i Mykologisk Neurobiologi',
    desc: 'Ledande expert på svampnätverkens bio-elektriska kommunikation.',
    image: '/img/m.myceliaceae.jpg'
  },
  {
    name: 'A. Amanita',
    title: 'Ljuddesigner & Myko-musiker',
    desc: 'Pionjär inom översättning av biologiska signaler till auditiv konst.',
    image: '/img/a.amanita.jpg'
  }
]
</script>

<template>
  <section id="speakers" class="py-24 px-4 bg-mushroom-light">
    <div class="max-w-6xl mx-auto">
      <div class="text-center mb-16">
        <h2 class="text-4xl md:text-5xl font-black text-mushroom-dark mb-4">Möt Våra Föreläsare</h2>
        <p class="text-gray-600 max-w-2xl mx-auto">Världsledande experter som förenar vetenskaplig precision med konstnärlig vision.</p>
      </div>

      <div class="grid grid-cols-1 md:grid-cols-2 gap-12">
        <div v-for="speaker in speakers" :key="speaker.name" class="group relative flex flex-col md:flex-row items-center gap-8 p-8 rounded-3xl bg-white shadow-xl hover:shadow-2xl transition-all hover:-translate-y-2">
          <div class="relative w-48 h-48 shrink-0 overflow-hidden rounded-2xl border-4 border-mushroom-accent/20">
            <img :src="speaker.image" :alt="speaker.name" class="w-full h-full object-cover transition-transform duration-500 group-hover:scale-110">
          </div>
          <div class="text-center md:text-left">
            <h3 class="text-2xl font-bold text-mushroom-dark mb-1">{{ speaker.name }}</h3>
            <p class="text-mushroom-accent font-bold text-sm uppercase tracking-wider mb-4">{{ speaker.title }}</p>
            <p class="text-gray-600 leading-relaxed">{{ speaker.desc }}</p>
          </div>
        </div>
      </div>
    </div>
  </section>
</template>
