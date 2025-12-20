<script setup lang="ts">
import { Trees, Music } from 'lucide-vue-next'

defineProps<{
  countdown: string
}>()
</script>

<template>
  <section class="mb-12 glass-card p-8 md:p-12">
    <div class="flex flex-col items-center justify-between gap-8 md:flex-row">
      <div class="md:w-1/2">
        <h2 class="mb-6 text-3xl font-bold text-mushroom-dark border-b-4 border-mushroom-accent inline-block">Webinar: Myceliets Psykologi</h2>
        <p class="mb-6 text-lg leading-relaxed">Välkommen till en unik session där vi dyker djupt ner i hur mycelium kommunicerar och hur vi kan översätta deras bio-elektriska signaler till ljudlandskap.</p>
        <div class="p-4 rounded-xl bg-green-50 border-l-4 border-mushroom-dark">
          <p class="font-bold text-mushroom-dark">Datum: 24 dec 2025 | 10:00 - 16:00</p>
          <p class="text-sm text-gray-600 mt-1">{{ countdown }}</p>
        </div>
      </div>
      <div class="grid grid-cols-2 gap-4 md:w-1/2">
        <div class="p-6 text-center bg-white shadow-sm rounded-2xl">
          <Trees class="w-10 h-10 mx-auto mb-3 text-mushroom-dark" />
          <h4 class="font-bold">Forskning</h4>
          <p class="text-xs text-gray-500">Bio-neurobiologi</p>
        </div>
        <div class="p-6 text-center bg-white shadow-sm rounded-2xl">
          <Music class="w-10 h-10 mx-auto mb-3 text-mushroom-accent" />
          <h4 class="font-bold">Musik</h4>
          <p class="text-xs text-gray-500">Myko-melodier</p>
        </div>
      </div>
    </div>
  </section>
</template>
