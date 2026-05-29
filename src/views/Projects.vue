<script setup>
import { ref, computed, onMounted } from 'vue'
import api from '../api/index.js'
import ProjectCard from '../components/ProjectCard.vue'
import Loading from '../components/Loading.vue'

const projects = ref([])
const loading = ref(true)
const activeTech = ref('')

const allTechs = computed(() => {
  const techSet = new Set()
  projects.value.forEach(p => {
    (p.tech_stack || '').split(',').forEach(t => {
      const trimmed = t.trim()
      if (trimmed) techSet.add(trimmed)
    })
  })
  return [...techSet].sort()
})

const filteredProjects = computed(() => {
  if (!activeTech.value) return projects.value
  return projects.value.filter(p =>
    (p.tech_stack || '').includes(activeTech.value)
  )
})

onMounted(async () => {
  try {
    const res = await api.get('/projects')
    projects.value = res.data
  } catch (err) {
    console.error('获取项目失败:', err)
  } finally {
    loading.value = false
  }
})
</script>

<template>
  <div class="projects-page">
    <div class="page-header">
      <h1>项目作品</h1>
      <p>一些我参与开发的项目</p>
    </div>

    <!-- Tech Filter -->
    <div class="tech-filter" v-if="allTechs.length > 0">
      <button
        :class="['tech-filter-btn', { active: activeTech === '' }]"
        @click="activeTech = ''"
      >全部</button>
      <button
        v-for="tech in allTechs"
        :key="tech"
        :class="['tech-filter-btn', { active: activeTech === tech }]"
        @click="activeTech = tech"
      >{{ tech }}</button>
    </div>

    <Loading v-if="loading" />

    <div v-else class="projects-grid">
      <ProjectCard v-for="project in filteredProjects" :key="project.id" :project="project" />
    </div>

    <div v-if="!loading && filteredProjects.length === 0" class="empty">
      <p>暂无项目展示</p>
    </div>
  </div>
</template>

<style scoped>
.projects-page {
  max-width: 900px;
  margin: 0 auto;
  padding: 40px 0;
}
.page-header {
  text-align: center;
  margin-bottom: 28px;
}
.page-header h1 {
  font-size: 28px;
  color: #1a1a2e;
  margin-bottom: 8px;
}
.page-header p {
  color: #888;
  font-size: 15px;
}

.tech-filter {
  display: flex;
  gap: 6px;
  flex-wrap: wrap;
  justify-content: center;
  margin-bottom: 28px;
}
.tech-filter-btn {
  padding: 5px 14px;
  border: 1px solid #e0e0e0;
  background: #fff;
  border-radius: 16px;
  font-size: 13px;
  cursor: pointer;
  transition: all 0.2s;
  color: #666;
}
.tech-filter-btn:hover {
  border-color: #1a73e8;
  color: #1a73e8;
}
.tech-filter-btn.active {
  background: #1a73e8;
  color: #fff;
  border-color: #1a73e8;
}

.projects-grid {
  display: grid;
  gap: 20px;
  grid-template-columns: repeat(auto-fill, minmax(340px, 1fr));
}
.empty {
  text-align: center;
  color: #999;
  padding: 60px 0;
}

@media (max-width: 640px) {
  .projects-grid { grid-template-columns: 1fr; }
}
</style>
