<script setup>
defineProps({
  post: { type: Object, required: true },
})
</script>

<template>
  <router-link :to="`/post/${post.id}`" class="post-card">
    <div class="post-cover-placeholder" v-if="!post.cover_image">
      <span class="placeholder-icon">&lt;/&gt;</span>
    </div>
    <div class="post-cover" v-else>
      <img :src="post.cover_image" :alt="post.title">
    </div>
    <div class="post-body">
      <div class="post-meta">
        <span class="category" v-if="post.category_name">{{ post.category_name }}</span>
        <span class="date">{{ new Date(post.created_at).toLocaleDateString('zh-CN') }}</span>
      </div>
      <h3 class="post-title">{{ post.title }}</h3>
      <p class="post-summary">{{ post.summary }}</p>
      <div class="post-footer">
        <div class="tags" v-if="post.tags">
          <span class="tag" v-for="tag in post.tags.split(',')" :key="tag">{{ tag.trim() }}</span>
        </div>
        <span class="views">{{ post.view_count }} 阅读</span>
      </div>
    </div>
  </router-link>
</template>

<style scoped>
.post-card {
  display: flex;
  flex-direction: column;
  background: #fff;
  border-radius: 14px;
  overflow: hidden;
  text-decoration: none;
  color: inherit;
  box-shadow: 0 1px 4px rgba(0,0,0,0.04);
  transition: all 0.3s;
  border: 1px solid #f0f0f0;
}
.post-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 12px 28px rgba(0,0,0,0.08);
  border-color: #e0e0e0;
}

.post-cover-placeholder {
  height: 160px;
  background: linear-gradient(135deg, #e8f0fe, #f0f4ff);
  display: flex;
  align-items: center;
  justify-content: center;
}
.placeholder-icon {
  font-size: 32px;
  font-weight: 800;
  color: #1a73e8;
  opacity: 0.3;
}

.post-cover img {
  width: 100%;
  height: 180px;
  object-fit: cover;
}

.post-body {
  padding: 20px;
  flex: 1;
  display: flex;
  flex-direction: column;
}
.post-meta {
  display: flex;
  gap: 12px;
  align-items: center;
  margin-bottom: 10px;
}
.category {
  background: #e8f0fe;
  color: #1a73e8;
  padding: 2px 10px;
  border-radius: 10px;
  font-size: 12px;
  font-weight: 500;
}
.date {
  color: #aaa;
  font-size: 13px;
}
.post-title {
  font-size: 18px;
  font-weight: 700;
  margin-bottom: 8px;
  color: #1a1a2e;
  line-height: 1.4;
  transition: color 0.2s;
}
.post-card:hover .post-title {
  color: #1a73e8;
}
.post-summary {
  color: #777;
  font-size: 14px;
  line-height: 1.6;
  flex: 1;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}
.post-footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-top: 14px;
  padding-top: 14px;
  border-top: 1px solid #f5f5f5;
}
.tags {
  display: flex;
  gap: 6px;
  flex-wrap: wrap;
}
.tag {
  background: #f5f5f5;
  color: #888;
  padding: 2px 8px;
  border-radius: 4px;
  font-size: 11px;
}
.views {
  font-size: 12px;
  color: #bbb;
  white-space: nowrap;
}
</style>
