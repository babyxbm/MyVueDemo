<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import api from '../../api/index.js'

const router = useRouter()
const posts = ref([])
const username = ref(localStorage.getItem('username') || '')

const isLoggedIn = computed(() => !!localStorage.getItem('token'))

function logout() {
  localStorage.removeItem('token')
  localStorage.removeItem('username')
  router.push('/')
}

async function loadPosts() {
  try {
    const res = await api.get('/posts?limit=100')
    posts.value = res.data.posts
  } catch (err) {
    console.error(err)
  }
}

async function deletePost(id) {
  if (!confirm('确定删除这篇文章？')) return
  try {
    await api.delete(`/posts/${id}`)
    posts.value = posts.value.filter(p => p.id !== id)
  } catch (err) {
    alert('删除失败')
  }
}

onMounted(() => {
  if (!isLoggedIn.value) {
    const pwd = prompt('请输入管理员密码（默认 admin123）：')
    if (pwd) {
      api.post('/auth/login', { username: 'admin', password: pwd })
        .then(res => {
          localStorage.setItem('token', res.data.token)
          localStorage.setItem('username', res.data.username)
          username.value = res.data.username
          loadPosts()
        })
        .catch(() => {
          alert('登录失败')
          router.push('/')
        })
    } else {
      router.push('/')
    }
  } else {
    loadPosts()
  }
})
</script>

<template>
  <div class="dashboard" v-if="isLoggedIn">
    <div class="dash-header">
      <div>
        <h1>后台管理</h1>
        <p class="welcome">欢迎回来，{{ username }}</p>
      </div>
      <div class="dash-actions">
        <router-link to="/admin/post" class="btn primary">写文章</router-link>
        <router-link to="/admin/messages" class="btn">留言管理</router-link>
        <a href="#" class="btn logout" @click.prevent="logout">退出</a>
      </div>
    </div>

    <section class="section">
      <h2>文章列表</h2>
      <div class="post-list">
        <div class="post-row" v-for="post in posts" :key="post.id">
          <div class="post-info">
            <span class="post-title">{{ post.title }}</span>
            <span class="post-meta">{{ post.category_name || '未分类' }} · {{ new Date(post.created_at).toLocaleDateString('zh-CN') }}</span>
          </div>
          <div class="post-actions">
            <router-link :to="`/admin/post/${post.id}`" class="action edit">编辑</router-link>
            <a href="#" class="action delete" @click.prevent="deletePost(post.id)">删除</a>
          </div>
        </div>
        <div v-if="posts.length === 0" class="empty">暂无文章</div>
      </div>
    </section>
  </div>
</template>

<style scoped>
.dashboard {
  max-width: 900px;
  margin: 0 auto;
  padding: 40px 0;
}
.dash-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  margin-bottom: 32px;
}
.dash-header h1 {
  font-size: 24px;
  color: #1a1a2e;
}
.welcome {
  color: #888;
  font-size: 14px;
  margin-top: 4px;
}
.dash-actions {
  display: flex;
  gap: 8px;
}
.btn {
  padding: 8px 16px;
  border-radius: 6px;
  font-size: 14px;
  text-decoration: none;
  border: 1px solid #ddd;
  color: #555;
  cursor: pointer;
  transition: all 0.2s;
}
.btn.primary {
  background: #1a73e8;
  color: #fff;
  border-color: #1a73e8;
}
.btn.primary:hover { background: #1557b0; }
.btn:hover:not(.primary) { background: #f5f5f5; }
.btn.logout { color: #d32f2f; border-color: #ffcdd2; }

.section {
  background: #fff;
  border-radius: 12px;
  padding: 24px;
  box-shadow: 0 2px 8px rgba(0,0,0,0.06);
}
.section h2 {
  font-size: 18px;
  color: #222;
  margin-bottom: 16px;
}

.post-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 14px 0;
  border-bottom: 1px solid #f0f0f0;
}
.post-row:last-child { border-bottom: none; }
.post-info {
  display: flex;
  flex-direction: column;
  gap: 4px;
}
.post-title { font-size: 15px; color: #333; }
.post-meta { font-size: 13px; color: #999; }
.post-actions { display: flex; gap: 8px; }
.action {
  padding: 4px 12px;
  border-radius: 4px;
  font-size: 13px;
  text-decoration: none;
  cursor: pointer;
}
.action.edit { color: #1a73e8; background: #e8f0fe; }
.action.delete { color: #d32f2f; background: #ffebee; }
.empty { color: #999; padding: 24px; text-align: center; }

@media (max-width: 640px) {
  .dash-header { flex-direction: column; gap: 12px; }
}
</style>
