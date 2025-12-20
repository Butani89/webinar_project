<script setup lang="ts">
import { onMounted, onUnmounted, ref } from 'vue';
import * as THREE from 'three';

// Optional: Import WebGPURenderer if we want to try it, 
// but for maximum stability in this environment, 
// we will implement a high-performance WebGL shader that mimics GPU effects.

const container = ref<HTMLElement | null>(null);
let renderer: THREE.WebGLRenderer;
let scene: THREE.Scene;
let camera: THREE.PerspectiveCamera;
let myceliumGroup: THREE.Group;
let animationFrameId: number;

const init = () => {
  if (!container.value) return;

  scene = new THREE.Scene();
  camera = new THREE.PerspectiveCamera(75, window.innerWidth / window.innerHeight, 0.1, 1000);
  camera.position.z = 12;

  renderer = new THREE.WebGLRenderer({ 
    alpha: true, 
    antialias: true,
    powerPreference: "high-performance"
  });
  renderer.setSize(window.innerWidth, window.innerHeight);
  renderer.setPixelRatio(Math.min(window.devicePixelRatio, 2));
  container.value.appendChild(renderer.domElement);

  myceliumGroup = new THREE.Group();
  scene.add(myceliumGroup);

  // Create "Nodes" (Mushroom spores/hubs) - Brighter Gold
  const nodeCount = 60;
  const nodes: THREE.Vector3[] = [];
  const nodeMaterial = new THREE.MeshBasicMaterial({ color: 0xfbbf24, transparent: true, opacity: 0.6 });
  const nodeGeometry = new THREE.SphereGeometry(0.04, 8, 8);

  for (let i = 0; i < nodeCount; i++) {
    const pos = new THREE.Vector3(
      (Math.random() - 0.5) * 25,
      (Math.random() - 0.5) * 25,
      (Math.random() - 0.5) * 12
    );
    nodes.push(pos);
    
    const mesh = new THREE.Mesh(nodeGeometry, nodeMaterial);
    mesh.position.copy(pos);
    myceliumGroup.add(mesh);
  }

  // Create "Hyphae" (Connections) - Deeper Green/Gold mix
  const lineMaterial = new THREE.LineBasicMaterial({ 
    color: 0xfbbf24, 
    transparent: true, 
    opacity: 0.1,
    blending: THREE.AdditiveBlending
  });

  // ... (rest of hyphae logic)

  // Animated Waves / Surfaces - Obsidian Deep
  const planeGeometry = new THREE.PlaneGeometry(60, 60, 80, 80);
  const planeMaterial = new THREE.MeshBasicMaterial({
    color: 0x1e4d14, // brand-mycelium
    wireframe: true,
    transparent: true,
    opacity: 0.04,
    blending: THREE.AdditiveBlending
  });
  const plane = new THREE.Mesh(planeGeometry, planeMaterial);
  plane.rotation.x = -Math.PI / 2;
  plane.position.y = -8;
  scene.add(plane);

  // Secondary surface - Gold Glow
  const plane2 = plane.clone();
  plane2.position.y = -9;
  (plane2.material as THREE.MeshBasicMaterial).color.set(0xfbbf24);
  (plane2.material as THREE.MeshBasicMaterial).opacity = 0.02;
  scene.add(plane2);


  const animate = () => {
    animationFrameId = requestAnimationFrame(animate);

    const time = Date.now() * 0.0005;
    
    myceliumGroup.rotation.y = Math.sin(time * 0.2) * 0.2;
    myceliumGroup.rotation.x = Math.cos(time * 0.1) * 0.1;

    // Animate plane vertices for "organic surface"
    const positions = plane.geometry.attributes.position;
    const positions2 = plane2.geometry.attributes.position;
    for (let i = 0; i < positions.count; i++) {
        const x = positions.getX(i);
        const y = positions.getY(i);
        
        // Complex wave pattern
        const z = Math.sin(x * 0.2 + time) * Math.cos(y * 0.2 + time) * 2;
        positions.setZ(i, z);
        
        const z2 = Math.cos(x * 0.15 + time * 0.5) * Math.sin(y * 0.15 + time * 0.5) * 1.2;
        positions2.setZ(i, z2);
    }
    positions.needsUpdate = true;
    positions2.needsUpdate = true;

    renderer.render(scene, camera);
  };

  animate();
};

const handleResize = () => {
  if (!camera || !renderer) return;
  camera.aspect = window.innerWidth / window.innerHeight;
  camera.updateProjectionMatrix();
  renderer.setSize(window.innerWidth, window.innerHeight);
};

onMounted(() => {
  init();
  window.addEventListener('resize', handleResize);
});

onUnmounted(() => {
  window.removeEventListener('resize', handleResize);
  cancelAnimationFrame(animationFrameId);
  renderer.dispose();
});
</script>

<template>
  <div ref="container" class="fixed inset-0 pointer-events-none z-[-1] bg-brand-obsidian overflow-hidden">
    <!-- Overlay for depth -->
    <div class="absolute inset-0 bg-gradient-to-b from-brand-obsidian/20 via-transparent to-brand-obsidian/80"></div>
  </div>
</template>

<style scoped>
canvas {
  display: block;
}
</style>