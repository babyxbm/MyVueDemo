<script setup>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import api from '../../api/index.js'

const router = useRouter()
const messages = ref([])
const loading = ref(true)

async function loadMessages() {
  try {
    const res = await api.get('/messages')
    messages.value = res.data
  } catch (err) {
    console.error(err)
  } finally {
    loading.value = false
  }
}

async function markRead(id) {
  try {
    await api.put(`/messages/${id}/read`)
    const msg = messages.value.find(m => m.id === id)
    if (msg) msg.read = 1
  } catch (err) {
    console.error(err)
  }
}

onMounted(async () => {
  if (!localStorage.getItem('token')) {
    router.push('/admin')
    return
  }
  loadMessages()
})
</script>

<template>
  <div class="msg-page">
    <div class="page-header">
      <h1>留言管理</h1>
      <router-link to="/admin" class="back-link">← 返回后台</router-link>
    </div>

    <div class="msg-list" v-if="!loading">
      <div class="msg-card" v-for="msg in messages" :key="msg.id" :class="{ unread: !msg.read }">
        <div class="msg-header">
          <div class="msg-author">
            <strong>{{ msg.name }}</strong>
            <span class="msg-email">{{ msg.email }}</span>
          </div>
          <div class="msg-meta">
            <span class="msg-date">{{ new Date(msg.created_at).toLocaleString('zh-CN') }}</span>
            <button v-if="!msg.read" class="read-btn" @click="markRead(msg.id)">标为已读</button>
          </div>
        </div>
        <p class="msg-content">{{ msg.content }}</p>
      </div>
      <div v-if="messages.length === 0" class="empty">暂无留言</div>
    </div>
    <div v-else class="empty">加载中...</div>
  </div>
</template>

<style scoped>
.msg-page {
  max-width: 720px;
  margin: 0 auto;
  padding: 40px 0;
}
.page-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 24px;
}
.page-header h1 { font-size: 24px; color: #1a1a2e; }
.back-link { color: #1a73e8; text-decoration: none; font-size: 14px; }
.msg-card {
  background: #fff;
  padding: 20px;
  border-radius: 10px;
  margin-bottom: 12px;
  box-shadow: 0 1px 4px rgba(0,0,0,0.04);
}
.msg-card.unread {
  border-left: 3px solid #1a73e8;
  background: #f8faff;
}
.msg-header {
  display: flex;
  justify-content: space-between;
  margin-bottom: 10px;
  flex-wrap: wrap;
  gap: 8px;
}
.msg-author { display: flex; gap: 10px; align-items: center; }
.msg-author strong { font-size: 15px; color: #333; }
.msg-email { font-size: 13px; color: #999; }
.msg-meta { display: flex; gap: 10px; align-items: center; }
.msg-date { font-size: 13px; color: #999; }
.read-btn {
  padding: 3px 10px;
  font-size: 12px;
  border: 1px solid #1a73e8;
  color: #1a73e8;
  background: transparent;
  border-radius: 4px;
  cursor: pointer;
}
.read-btn:hover { background: #e8f0fe; }
.msg-content { font-size: 14px; color: #555; line-height: 1.6; }
.empty { text-align: center; color: #999; padding: 48px; }
</style>
