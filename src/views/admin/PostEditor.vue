<script setup>
import { ref, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import api from '../../api/index.js'

const route = useRoute()
const router = useRouter()
const isEdit = !!route.params.id

const form = ref({
  title: '',
  summary: '',
  content: '',
  category_id: '',
  tags: '',
  published: true,
})
const saving = ref(false)
const categories = ref([])

onMounted(async () => {
  try {
    const res = await api.get('/categories')
    categories.value = res.data
  } catch (err) {
    console.error(err)
  }

  if (isEdit) {
    try {
      const res = await api.get(`/posts/${route.params.id}`)
      const p = res.data
      form.value = {
        title: p.title,
        summary: p.summary || '',
        content: p.content || '',
        cover_image: p.cover_image || '',
        category_id: p.category_id || '',
        tags: p.tags || '',
        published: !!p.published,
      }
    } catch (err) {
      alert('文章不存在')
      router.push('/admin')
    }
  }
})

async function save() {
  if (!form.value.title) { alert('请输入标题'); return }
  saving.value = true
  try {
    if (isEdit) {
      await api.put(`/posts/${route.params.id}`, form.value)
    } else {
      await api.post('/posts', form.value)
    }
    router.push('/admin')
  } catch (err) {
    alert('保存失败')
  } finally {
    saving.value = false
  }
}
</script>

<template>
  <div class="editor">
    <div class="editor-header">
      <h1>{{ isEdit ? '编辑文章' : '写文章' }}</h1>
      <router-link to="/admin" class="back-link">← 返回</router-link>
    </div>

    <form @submit.prevent="save" class="editor-form">
      <div class="form-group">
        <label>标题</label>
        <input v-model="form.title" type="text" placeholder="文章标题" />
      </div>

      <div class="form-row">
        <div class="form-group">
          <label>分类</label>
          <select v-model="form.category_id">
            <option value="">未分类</option>
            <option v-for="c in categories" :key="c.id" :value="c.id">{{ c.name }}</option>
          </select>
        </div>
        <div class="form-group">
          <label>标签（逗号分隔）</label>
          <input v-model="form.tags" type="text" placeholder="Vue, JavaScript" />
        </div>
      </div>

      <div class="form-group">
        <label>摘要</label>
        <textarea v-model="form.summary" rows="3" placeholder="文章摘要"></textarea>
      </div>

      <div class="form-group">
        <label>内容（支持 Markdown 格式）</label>
        <textarea v-model="form.content" rows="16" placeholder="文章内容..."></textarea>
      </div>

      <div class="form-group">
        <label>封面图片 URL（可选）</label>
        <input v-model="form.cover_image" type="text" placeholder="https://..." />
      </div>

      <div class="form-group checkbox">
        <label>
          <input v-model="form.published" type="checkbox" />
          发布
        </label>
      </div>

      <button type="submit" class="submit-btn" :disabled="saving">
        {{ saving ? '保存中...' : '保存' }}
      </button>
    </form>
  </div>
</template>

<style scoped>
.editor {
  max-width: 720px;
  margin: 0 auto;
  padding: 40px 0;
}
.editor-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 24px;
}
.editor-header h1 { font-size: 24px; color: #1a1a2e; }
.back-link { color: #1a73e8; text-decoration: none; font-size: 14px; }

.editor-form {
  background: #fff;
  padding: 28px;
  border-radius: 12px;
  box-shadow: 0 2px 8px rgba(0,0,0,0.06);
}
.form-group {
  margin-bottom: 20px;
}
.form-group label {
  display: block;
  font-size: 14px;
  font-weight: 500;
  color: #333;
  margin-bottom: 6px;
}
.form-group input,
.form-group textarea,
.form-group select {
  width: 100%;
  padding: 10px 14px;
  border: 1px solid #ddd;
  border-radius: 8px;
  font-size: 14px;
  font-family: inherit;
  transition: border-color 0.2s;
}
.form-group input:focus,
.form-group textarea:focus,
.form-group select:focus {
  outline: none;
  border-color: #1a73e8;
  box-shadow: 0 0 0 3px rgba(26,115,232,0.1);
}
.form-group textarea {
  resize: vertical;
  line-height: 1.6;
}
.form-row {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 16px;
}
.form-group.checkbox label {
  display: flex;
  align-items: center;
  gap: 8px;
  cursor: pointer;
}
.form-group.checkbox input {
  width: auto;
}
.submit-btn {
  width: 100%;
  padding: 12px;
  background: #1a73e8;
  color: #fff;
  border: none;
  border-radius: 8px;
  font-size: 15px;
  cursor: pointer;
  transition: background 0.2s;
}
.submit-btn:hover { background: #1557b0; }
.submit-btn:disabled { opacity: 0.6; cursor: not-allowed; }
</style>
