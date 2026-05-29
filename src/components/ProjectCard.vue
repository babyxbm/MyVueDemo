<script setup>
defineProps({
  project: { type: Object, required: true },
})
</script>

<template>
  <div class="project-card">
    <div class="project-header">
      <div class="project-icon">{{ (project.title || 'P')[0] }}</div>
      <div class="project-header-info">
        <h3 class="project-title">{{ project.title }}</h3>
        <span class="featured-badge" v-if="project.featured">精选</span>
      </div>
    </div>
    <p class="project-desc">{{ project.description }}</p>
    <div class="tech-stack" v-if="project.tech_stack">
      <span class="tech-tag" v-for="tech in project.tech_stack.split(',')" :key="tech">{{ tech.trim() }}</span>
    </div>
    <div class="project-links">
      <a v-if="project.demo_url" :href="project.demo_url" target="_blank" class="link-btn demo">在线演示</a>
      <a v-if="project.github_url" :href="project.github_url" target="_blank" class="link-btn github">GitHub</a>
    </div>
  </div>
</template>

<style scoped>
.project-card {
  background: #fff;
  border-radius: 14px;
  padding: 24px;
  box-shadow: 0 1px 4px rgba(0,0,0,0.04);
  transition: all 0.3s;
  border: 1px solid #f0f0f0;
  display: flex;
  flex-direction: column;
}
.project-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 12px 28px rgba(0,0,0,0.08);
  border-color: #e0e0e0;
}
.project-header {
  display: flex;
  align-items: center;
  gap: 14px;
  margin-bottom: 14px;
}
.project-icon {
  width: 44px;
  height: 44px;
  border-radius: 12px;
  background: linear-gradient(135deg, #1a73e8, #66b1ff);
  color: #fff;
  font-size: 20px;
  font-weight: 700;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}
.project-header-info {
  display: flex;
  align-items: center;
  gap: 8px;
  flex-wrap: wrap;
}
.project-title {
  font-size: 17px;
  font-weight: 700;
  color: #1a1a2e;
}
.featured-badge {
  background: #fff8e1;
  color: #f59e0b;
  padding: 2px 10px;
  border-radius: 10px;
  font-size: 11px;
  font-weight: 600;
}
.project-desc {
  color: #777;
  font-size: 14px;
  line-height: 1.6;
  flex: 1;
  margin-bottom: 16px;
}
.tech-stack {
  display: flex;
  gap: 6px;
  flex-wrap: wrap;
  margin-bottom: 18px;
}
.tech-tag {
  background: #e8f0fe;
  color: #1a73e8;
  padding: 3px 10px;
  border-radius: 6px;
  font-size: 12px;
  font-weight: 500;
}
.project-links {
  display: flex;
  gap: 10px;
  margin-top: auto;
}
.link-btn {
  padding: 8px 18px;
  border-radius: 8px;
  font-size: 13px;
  text-decoration: none;
  transition: all 0.2s;
  font-weight: 500;
}
.link-btn.demo {
  background: #1a73e8;
  color: #fff;
}
.link-btn.demo:hover {
  background: #1557b0;
  text-decoration: none;
}
.link-btn.github {
  background: #24292e;
  color: #fff;
}
.link-btn.github:hover {
  background: #000;
  text-decoration: none;
}
</style>
