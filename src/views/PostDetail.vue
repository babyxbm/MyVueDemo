<script setup>
import { ref, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import api from '../api/index.js'
import Loading from '../components/Loading.vue'

const route = useRoute()
const router = useRouter()
const post = ref(null)
const loading = ref(true)
const related = ref([])

onMounted(async () => {
  try {
    const res = await api.get(`/posts/${route.params.id}`)
    post.value = res.data
    related.value = res.data.related || []
  } catch (err) {
    post.value = null
  } finally {
    loading.value = false
  }
})
</script>

<template>
  <div class="post-detail">
    <Loading v-if="loading" />

    <div v-else-if="post" class="detail-content">
      <div class="post-header">
        <div class="breadcrumb">
          <router-link to="/">首页</router-link>
          <span class="sep">/</span>
          <span class="current">{{ post.title }}</span>
        </div>
        <h1>{{ post.title }}</h1>
        <div class="meta">
          <span v-if="post.category_name" class="category">{{ post.category_name }}</span>
          <span class="date">{{ new Date(post.created_at).toLocaleDateString('zh-CN') }}</span>
          <span class="views">{{ post.view_count }} 次阅读</span>
        </div>
      </div>

      <div class="post-body" v-html="post.content?.replace(/\n/g, '<br>')"></div>

      <div class="tags" v-if="post.tags">
        <span class="tag" v-for="tag in post.tags.split(',')" :key="tag">{{ tag.trim() }}</span>
      </div>

      <!-- Related Posts -->
      <div class="related-section" v-if="related.length > 0">
        <h2 class="related-title">相关文章</h2>
        <div class="related-grid">
          <router-link
            v-for="r in related"
            :key="r.id"
            :to="`/post/${r.id}`"
            class="related-card"
          >
            <h4>{{ r.title }}</h4>
            <span class="related-date">{{ new Date(r.created_at).toLocaleDateString('zh-CN') }}</span>
          </router-link>
        </div>
      </div>

      <div class="post-nav">
        <router-link to="/" class="back-link">← 返回首页</router-link>
      </div>
    </div>

    <div v-else class="error">
      <div class="error-icon">!</div>
      <p>文章不存在或已删除</p>
      <router-link to="/" class="back-link">← 返回首页</router-link>
    </div>
  </div>
</template>

<style scoped>
.post-detail {
  max-width: 720px;
  margin: 0 auto;
  padding: 40px 0;
}
.post-header {
  margin-bottom: 32px;
}
.breadcrumb {
  font-size: 13px;
  color: #999;
  margin-bottom: 12px;
  display: flex;
  gap: 6px;
  align-items: center;
}
.breadcrumb a {
  color: #1a73e8;
  text-decoration: none;
}
.breadcrumb a:hover { text-decoration: underline; }
.breadcrumb .sep { color: #ccc; }
.breadcrumb .current {
  color: #999;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
  max-width: 200px;
}
.post-header h1 {
  font-size: 30px;
  color: #1a1a2e;
  line-height: 1.35;
  margin-bottom: 16px;
  font-weight: 800;
}
.meta {
  display: flex;
  gap: 14px;
  align-items: center;
  flex-wrap: wrap;
  color: #888;
  font-size: 14px;
}
.category {
  background: #e8f0fe;
  color: #1a73e8;
  padding: 3px 12px;
  border-radius: 10px;
  font-size: 13px;
}
.post-body {
  font-size: 16px;
  line-height: 1.9;
  color: #333;
}
.post-body :deep(pre) {
  background: #1a1a2e;
  color: #e0e0e0;
  padding: 20px;
  border-radius: 10px;
  overflow-x: auto;
  font-size: 14px;
  margin: 20px 0;
  line-height: 1.6;
}
.post-body :deep(code) {
  background: #f0f0f0;
  color: #d63384;
  padding: 2px 8px;
  border-radius: 4px;
  font-size: 14px;
}
.post-body :deep(pre code) {
  background: none;
  color: inherit;
  padding: 0;
}
.post-body :deep(h2) {
  font-size: 24px;
  margin: 36px 0 14px;
  color: #1a1a2e;
  padding-bottom: 8px;
  border-bottom: 2px solid #f0f0f0;
}
.post-body :deep(h3) {
  font-size: 19px;
  margin: 28px 0 10px;
  color: #1a1a2e;
}
.post-body :deep(p) {
  margin-bottom: 16px;
}
.post-body :deep(ul), .post-body :deep(ol) {
  padding-left: 24px;
  margin-bottom: 16px;
}
.post-body :deep(li) {
  margin-bottom: 6px;
}
.post-body :deep(blockquote) {
  border-left: 4px solid #1a73e8;
  margin: 20px 0;
  padding: 12px 20px;
  background: #f8f9ff;
  border-radius: 0 8px 8px 0;
  color: #555;
}
.post-body :deep(table) {
  width: 100%;
  border-collapse: collapse;
  margin: 20px 0;
}
.post-body :deep(th), .post-body :deep(td) {
  border: 1px solid #e0e0e0;
  padding: 10px 14px;
  text-align: left;
  font-size: 14px;
}
.post-body :deep(th) {
  background: #f5f5f5;
  font-weight: 600;
}
.tags {
  display: flex;
  gap: 8px;
  flex-wrap: wrap;
  margin-top: 40px;
  padding-top: 24px;
  border-top: 1px solid #eee;
}
.tag {
  background: #f5f5f5;
  color: #666;
  padding: 4px 14px;
  border-radius: 6px;
  font-size: 13px;
  transition: all 0.2s;
}
.tag:hover {
  background: #e8f0fe;
  color: #1a73e8;
}

/* Related */
.related-section {
  margin-top: 48px;
}
.related-title {
  font-size: 20px;
  color: #1a1a2e;
  margin-bottom: 16px;
  padding-bottom: 10px;
  border-bottom: 2px solid #1a73e8;
  display: inline-block;
}
.related-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 12px;
}
.related-card {
  display: block;
  background: #fff;
  border: 1px solid #eee;
  border-radius: 10px;
  padding: 16px 18px;
  text-decoration: none;
  transition: all 0.25s;
}
.related-card:hover {
  border-color: #1a73e8;
  box-shadow: 0 4px 12px rgba(26,115,232,0.1);
  transform: translateY(-2px);
}
.related-card h4 {
  font-size: 14px;
  color: #333;
  margin-bottom: 6px;
  line-height: 1.4;
}
.related-date {
  font-size: 12px;
  color: #999;
}

.post-nav {
  margin-top: 40px;
}
.back-link {
  color: #1a73e8;
  text-decoration: none;
  font-size: 15px;
  font-weight: 500;
}
.back-link:hover { text-decoration: underline; }

.error {
  text-align: center;
  padding: 80px 20px;
  color: #999;
}
.error-icon {
  width: 56px;
  height: 56px;
  border-radius: 50%;
  background: #ffebee;
  color: #d32f2f;
  font-size: 28px;
  font-weight: 700;
  display: flex;
  align-items: center;
  justify-content: center;
  margin: 0 auto 16px;
}

@media (max-width: 640px) {
  .related-grid { grid-template-columns: 1fr; }
  .post-header h1 { font-size: 24px; }
}
</style>
