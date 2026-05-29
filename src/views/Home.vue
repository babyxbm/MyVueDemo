<script setup>
import { ref, onMounted } from 'vue'
import api from '../api/index.js'
import PostCard from '../components/PostCard.vue'
import Loading from '../components/Loading.vue'

const posts = ref([])
const featured = ref([])
const categories = ref([])
const loading = ref(true)
const page = ref(1)
const totalPages = ref(1)
const activeCategory = ref('')
const searchQuery = ref('')

async function fetchCategories() {
  try {
    const res = await api.get('/categories')
    categories.value = res.data
  } catch (err) {
    console.error('获取分类失败:', err)
  }
}

async function fetchFeatured() {
  try {
    const res = await api.get('/posts/featured')
    featured.value = res.data
  } catch (err) {
    console.error('获取推荐文章失败:', err)
  }
}

async function fetchPosts() {
  loading.value = true
  try {
    const params = { page: page.value, limit: 10 }
    if (activeCategory.value) {
      params.category = activeCategory.value
    }
    const res = await api.get('/posts', { params })
    posts.value = res.data.posts
    totalPages.value = res.data.totalPages
  } catch (err) {
    console.error('获取文章失败:', err)
  } finally {
    loading.value = false
  }
}

function filterByCategory(categoryId) {
  activeCategory.value = categoryId
  page.value = 1
  fetchPosts()
}

function prevPage() {
  if (page.value > 1) { page.value--; fetchPosts() }
}
function nextPage() {
  if (page.value < totalPages.value) { page.value++; fetchPosts() }
}

onMounted(() => {
  fetchFeatured()
  fetchCategories()
  fetchPosts()
})
</script>

<template>
  <div class="home">
    <!-- Hero -->
    <section class="hero">
      <div class="hero-bg"></div>
      <div class="hero-content">
        <h1>个人博客</h1>
        <p>分享技术、记录成长，用代码探索世界</p>
      </div>
    </section>

    <!-- Featured Posts -->
    <section class="featured-section" v-if="featured.length > 0">
      <h2 class="section-title">推荐文章</h2>
      <div class="featured-grid">
        <router-link
          v-for="post in featured"
          :key="post.id"
          :to="`/post/${post.id}`"
          class="featured-card"
        >
          <div class="featured-body">
            <span class="featured-category">{{ post.category_name }}</span>
            <h3>{{ post.title }}</h3>
            <p>{{ post.summary }}</p>
            <div class="featured-meta">
              <span>{{ new Date(post.created_at).toLocaleDateString('zh-CN') }}</span>
              <span class="views">{{ post.view_count }} 次阅读</span>
            </div>
          </div>
        </router-link>
      </div>
    </section>

    <!-- Category Filter + Search -->
    <div class="toolbar">
      <div class="category-tabs">
        <button
          :class="['tab', { active: activeCategory === '' }]"
          @click="filterByCategory('')"
        >全部</button>
        <button
          v-for="cat in categories"
          :key="cat.id"
          :class="['tab', { active: activeCategory === String(cat.id) }]"
          @click="filterByCategory(String(cat.id))"
        >{{ cat.name }}</button>
      </div>
    </div>

    <!-- Posts -->
    <Loading v-if="loading" text="正在加载文章..." />

    <div v-else class="post-grid">
      <PostCard v-for="post in posts" :key="post.id" :post="post" />
    </div>

    <!-- Pagination -->
    <div class="pagination" v-if="totalPages > 1">
      <button :disabled="page <= 1" @click="prevPage">上一页</button>
      <span class="page-info">{{ page }} / {{ totalPages }}</span>
      <button :disabled="page >= totalPages" @click="nextPage">下一页</button>
    </div>

    <div v-if="!loading && posts.length === 0" class="empty">
      <p>暂无文章</p>
    </div>
  </div>
</template>

<style scoped>
/* Hero */
.hero {
  position: relative;
  text-align: center;
  padding: 64px 20px 56px;
  margin-bottom: 32px;
  overflow: hidden;
}
.hero-bg {
  position: absolute;
  inset: 0;
  background: linear-gradient(135deg, #1a1a2e 0%, #16213e 50%, #0f3460 100%);
  border-radius: 16px;
  opacity: 0.05;
}
.hero-content {
  position: relative;
}
.hero h1 {
  font-size: 36px;
  color: #1a1a2e;
  margin-bottom: 10px;
  font-weight: 800;
  letter-spacing: -1px;
}
.hero p {
  color: #888;
  font-size: 17px;
}

/* Section Title */
.section-title {
  font-size: 20px;
  color: #1a1a2e;
  margin-bottom: 20px;
  display: flex;
  align-items: center;
  gap: 10px;
}
.section-title::before {
  content: '';
  width: 4px;
  height: 22px;
  background: #1a73e8;
  border-radius: 2px;
}

/* Featured */
.featured-section {
  margin-bottom: 32px;
}
.featured-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
  gap: 16px;
}
.featured-card {
  display: block;
  background: linear-gradient(135deg, #1a1a2e, #16213e);
  border-radius: 12px;
  padding: 24px;
  text-decoration: none;
  color: #fff;
  transition: transform 0.3s, box-shadow 0.3s;
}
.featured-card:nth-child(2) {
  background: linear-gradient(135deg, #0f3460, #1a73e8);
}
.featured-card:nth-child(3) {
  background: linear-gradient(135deg, #1a1a2e, #533483);
}
.featured-card:nth-child(4) {
  background: linear-gradient(135deg, #16213e, #0f3460);
}
.featured-card:nth-child(5) {
  background: linear-gradient(135deg, #533483, #e94560);
}
.featured-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 12px 28px rgba(0,0,0,0.2);
}
.featured-category {
  display: inline-block;
  background: rgba(255,255,255,0.15);
  color: #fff;
  padding: 2px 10px;
  border-radius: 8px;
  font-size: 12px;
  margin-bottom: 12px;
}
.featured-body h3 {
  font-size: 17px;
  margin-bottom: 8px;
  line-height: 1.4;
}
.featured-body p {
  font-size: 13px;
  color: rgba(255,255,255,0.7);
  line-height: 1.5;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
  margin-bottom: 14px;
}
.featured-meta {
  display: flex;
  gap: 14px;
  font-size: 12px;
  color: rgba(255,255,255,0.5);
}
.views {
  color: rgba(255,255,255,0.5);
}

/* Toolbar */
.toolbar {
  display: flex;
  gap: 12px;
  margin-bottom: 24px;
  flex-wrap: wrap;
  align-items: center;
  justify-content: space-between;
}
.category-tabs {
  display: flex;
  gap: 6px;
  flex-wrap: wrap;
}
.tab {
  padding: 6px 16px;
  border: 1px solid #e0e0e0;
  background: #fff;
  border-radius: 20px;
  font-size: 13px;
  cursor: pointer;
  transition: all 0.2s;
  color: #666;
}
.tab:hover {
  border-color: #1a73e8;
  color: #1a73e8;
}
.tab.active {
  background: #1a73e8;
  color: #fff;
  border-color: #1a73e8;
}

/* Posts */
.post-grid {
  display: grid;
  gap: 20px;
  grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
}

/* Pagination */
.pagination {
  display: flex;
  justify-content: center;
  align-items: center;
  gap: 16px;
  padding: 32px 0;
}
.pagination button {
  padding: 8px 20px;
  border: 1px solid #ddd;
  background: #fff;
  border-radius: 8px;
  cursor: pointer;
  font-size: 14px;
  transition: all 0.2s;
}
.pagination button:hover:not(:disabled) {
  background: #1a73e8;
  color: #fff;
  border-color: #1a73e8;
}
.pagination button:disabled {
  opacity: 0.4;
  cursor: not-allowed;
}
.page-info {
  font-size: 14px;
  color: #666;
}
.empty {
  text-align: center;
  color: #999;
  padding: 60px 0;
}

@media (max-width: 640px) {
  .hero { padding: 40px 16px; }
  .hero h1 { font-size: 28px; }
  .post-grid { grid-template-columns: 1fr; }
  .featured-grid { grid-template-columns: 1fr; }
  .toolbar { flex-direction: column; align-items: stretch; }
}
</style>
