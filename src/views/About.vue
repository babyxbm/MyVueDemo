<script setup>
import { ref, onMounted } from 'vue'
import api from '../api/index.js'
import Loading from '../components/Loading.vue'

const profile = ref(null)
const loading = ref(true)

const skills = [
  { name: 'Vue.js / Nuxt.js', level: 90 },
  { name: 'React', level: 75 },
  { name: 'Node.js / Express', level: 85 },
  { name: 'MySQL / MongoDB', level: 78 },
  { name: 'TypeScript', level: 80 },
  { name: 'Docker / Git', level: 72 },
  { name: 'Python', level: 60 },
  { name: 'CSS / Tailwind', level: 82 },
]

const experiences = [
  { period: '2024 - 至今', title: '前端开发工程师', company: '某科技公司', desc: '负责公司核心产品的前端架构设计与开发，使用 Vue 3 + TypeScript 技术栈，主导了组件库建设和性能优化。' },
  { period: '2023 - 2024', title: '初级前端开发', company: '某互联网公司', desc: '参与多个 Web 项目的开发，积累了丰富的实战经验，熟悉敏捷开发流程。' },
  { period: '2022 - 2023', title: '前端实习生', company: '某创业公司', desc: '学习并实践前端技术，参与公司官网和后台管理系统的开发。' },
]

const education = [
  { period: '2019 - 2023', school: '某大学', major: '计算机科学与技术', desc: '本科，GPA 3.6/4.0，获得校级奖学金' },
]

const certifications = [
  { name: 'Vue 3 认证开发者', issuer: 'Vue.js 官方', year: '2024' },
  { name: 'AWS 云从业者', issuer: 'Amazon Web Services', year: '2023' },
  { name: '软件设计师（中级）', issuer: '人社部', year: '2023' },
]

const stats = [
  { value: '3+', label: '年开发经验' },
  { value: '30+', label: '完成项目' },
  { value: '14', label: '博客文章' },
  { value: '8', label: '开源贡献' },
]

onMounted(async () => {
  try {
    const res = await api.get('/about')
    profile.value = res.data
  } catch (err) {
    console.error('获取个人信息失败')
  } finally {
    loading.value = false
  }
})
</script>

<template>
  <div class="about">
    <div class="profile-card" v-if="profile">
      <div class="avatar-ring">
        <div class="avatar">{{ (profile.username || 'U')[0].toUpperCase() }}</div>
      </div>
      <h1>{{ profile.username }}</h1>
      <p class="bio">{{ profile.bio }}</p>
    </div>

    <!-- Stats -->
    <div class="stats-row">
      <div class="stat-item" v-for="(s, i) in stats" :key="i">
        <span class="stat-value">{{ s.value }}</span>
        <span class="stat-label">{{ s.label }}</span>
      </div>
    </div>

    <!-- 技能 -->
    <section class="section">
      <h2 class="section-title">技术技能</h2>
      <div class="skills-grid">
        <div class="skill-item" v-for="skill in skills" :key="skill.name">
          <div class="skill-header">
            <span class="skill-name">{{ skill.name }}</span>
            <span class="skill-level">{{ skill.level }}%</span>
          </div>
          <div class="skill-bar">
            <div class="skill-fill" :style="{ width: skill.level + '%' }"></div>
          </div>
        </div>
      </div>
    </section>

    <!-- 工作经历 -->
    <section class="section">
      <h2 class="section-title">工作经历</h2>
      <div class="timeline">
        <div class="timeline-item" v-for="(exp, i) in experiences" :key="i">
          <div class="timeline-dot"></div>
          <div class="timeline-content">
            <span class="period">{{ exp.period }}</span>
            <h3>{{ exp.title }}</h3>
            <p class="company">{{ exp.company }}</p>
            <p class="desc">{{ exp.desc }}</p>
          </div>
        </div>
      </div>
    </section>

    <!-- 教育背景 -->
    <section class="section">
      <h2 class="section-title">教育背景</h2>
      <div class="timeline">
        <div class="timeline-item" v-for="(edu, i) in education" :key="i">
          <div class="timeline-dot"></div>
          <div class="timeline-content">
            <span class="period">{{ edu.period }}</span>
            <h3>{{ edu.school }}</h3>
            <p class="company">{{ edu.major }}</p>
            <p class="desc">{{ edu.desc }}</p>
          </div>
        </div>
      </div>
    </section>

    <!-- 证书 -->
    <section class="section">
      <h2 class="section-title">证书</h2>
      <div class="certs-grid">
        <div class="cert-card" v-for="(cert, i) in certifications" :key="i">
          <div class="cert-icon">🏅</div>
          <div class="cert-info">
            <h4>{{ cert.name }}</h4>
            <p>{{ cert.issuer }} · {{ cert.year }}</p>
          </div>
        </div>
      </div>
    </section>

    <Loading v-if="!profile && loading" />
  </div>
</template>

<style scoped>
.about {
  max-width: 720px;
  margin: 0 auto;
  padding: 40px 0;
}

/* Profile Card */
.profile-card {
  text-align: center;
  padding: 48px 20px 36px;
  background: #fff;
  border-radius: 16px;
  box-shadow: 0 2px 12px rgba(0,0,0,0.06);
  margin-bottom: 28px;
}
.avatar-ring {
  width: 96px;
  height: 96px;
  border-radius: 50%;
  padding: 4px;
  background: linear-gradient(135deg, #1a73e8, #66b1ff);
  margin: 0 auto 16px;
}
.avatar {
  width: 100%;
  height: 100%;
  border-radius: 50%;
  background: #fff;
  color: #1a73e8;
  font-size: 36px;
  font-weight: 700;
  display: flex;
  align-items: center;
  justify-content: center;
}
.profile-card h1 {
  font-size: 26px;
  color: #1a1a2e;
  margin-bottom: 10px;
}
.bio {
  color: #666;
  font-size: 15px;
  line-height: 1.6;
  max-width: 480px;
  margin: 0 auto;
}

/* Stats */
.stats-row {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 12px;
  margin-bottom: 36px;
}
.stat-item {
  background: #fff;
  border-radius: 12px;
  padding: 20px 12px;
  text-align: center;
  box-shadow: 0 1px 4px rgba(0,0,0,0.04);
}
.stat-value {
  display: block;
  font-size: 26px;
  font-weight: 800;
  color: #1a73e8;
  margin-bottom: 4px;
}
.stat-label {
  font-size: 13px;
  color: #888;
}

.section {
  margin-bottom: 40px;
}
.section-title {
  font-size: 20px;
  color: #1a1a2e;
  margin-bottom: 20px;
  padding-bottom: 10px;
  border-bottom: 2px solid #1a73e8;
  display: inline-block;
}

/* Skills */
.skills-grid {
  display: grid;
  gap: 14px;
}
.skill-item {
  background: #fff;
  padding: 16px 20px;
  border-radius: 10px;
  box-shadow: 0 1px 4px rgba(0,0,0,0.04);
  transition: transform 0.2s;
}
.skill-item:hover {
  transform: translateX(4px);
}
.skill-header {
  display: flex;
  justify-content: space-between;
  margin-bottom: 8px;
}
.skill-name { font-size: 14px; color: #333; font-weight: 500; }
.skill-level { font-size: 13px; color: #999; }
.skill-bar {
  height: 8px;
  background: #eef0f4;
  border-radius: 4px;
  overflow: hidden;
}
.skill-fill {
  height: 100%;
  background: linear-gradient(90deg, #1a73e8, #66b1ff);
  border-radius: 4px;
  transition: width 1s ease;
}

/* Timeline */
.timeline {
  position: relative;
  padding-left: 24px;
}
.timeline::before {
  content: '';
  position: absolute;
  left: 6px;
  top: 8px;
  bottom: 8px;
  width: 2px;
  background: #e0e0e0;
}
.timeline-item {
  position: relative;
  padding-bottom: 28px;
}
.timeline-item:last-child { padding-bottom: 0; }
.timeline-dot {
  position: absolute;
  left: -24px;
  top: 6px;
  width: 14px;
  height: 14px;
  border-radius: 50%;
  background: #1a73e8;
  border: 3px solid #fff;
  box-shadow: 0 0 0 2px #1a73e8;
}
.timeline-content {
  background: #fff;
  padding: 16px 20px;
  border-radius: 10px;
  box-shadow: 0 1px 4px rgba(0,0,0,0.04);
  transition: transform 0.2s;
}
.timeline-content:hover {
  transform: translateX(4px);
}
.period {
  font-size: 13px;
  color: #1a73e8;
  font-weight: 600;
}
.timeline-content h3 {
  font-size: 16px;
  color: #222;
  margin: 4px 0;
}
.company {
  font-size: 14px;
  color: #666;
  margin-bottom: 6px;
}
.desc {
  font-size: 14px;
  color: #888;
  line-height: 1.5;
}

/* Certifications */
.certs-grid {
  display: grid;
  gap: 12px;
}
.cert-card {
  display: flex;
  align-items: center;
  gap: 16px;
  background: #fff;
  padding: 16px 20px;
  border-radius: 10px;
  box-shadow: 0 1px 4px rgba(0,0,0,0.04);
  transition: transform 0.2s;
}
.cert-card:hover {
  transform: translateX(4px);
}
.cert-icon {
  font-size: 28px;
  width: 48px;
  height: 48px;
  background: #fff8e1;
  border-radius: 10px;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}
.cert-info h4 {
  font-size: 15px;
  color: #333;
  margin-bottom: 2px;
}
.cert-info p {
  font-size: 13px;
  color: #888;
}

@media (max-width: 640px) {
  .stats-row { grid-template-columns: repeat(2, 1fr); }
}
</style>
