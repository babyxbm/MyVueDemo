<script setup>
import { ref } from 'vue'
import api from '../api/index.js'

const form = ref({ name: '', email: '', content: '' })
const submitting = ref(false)
const submitted = ref(false)
const error = ref('')

async function submitForm() {
  if (!form.value.name || !form.value.email || !form.value.content) {
    error.value = '请填写完整信息'
    return
  }
  submitting.value = true
  error.value = ''
  try {
    await api.post('/messages', form.value)
    submitted.value = true
    form.value = { name: '', email: '', content: '' }
  } catch (err) {
    error.value = '提交失败，请稍后重试'
  } finally {
    submitting.value = false
  }
}
</script>

<template>
  <div class="contact-page">
    <div class="page-header">
      <h1>联系我</h1>
      <p>有任何问题或想法，欢迎留言交流</p>
    </div>

    <div class="contact-layout">
      <div class="contact-card" v-if="!submitted">
        <h2 class="form-title">发送留言</h2>
        <form @submit.prevent="submitForm">
          <div class="form-group">
            <label>姓名</label>
            <input v-model="form.name" type="text" placeholder="你的名字" />
          </div>
          <div class="form-group">
            <label>邮箱</label>
            <input v-model="form.email" type="email" placeholder="your@email.com" />
          </div>
          <div class="form-group">
            <label>留言内容</label>
            <textarea v-model="form.content" rows="5" placeholder="写下你想说的..."></textarea>
          </div>
          <p class="error-msg" v-if="error">{{ error }}</p>
          <button type="submit" class="submit-btn" :disabled="submitting">
            {{ submitting ? '提交中...' : '发送留言' }}
          </button>
        </form>
      </div>

      <div class="success-card" v-else>
        <div class="success-icon">✓</div>
        <h2>留言成功！</h2>
        <p>感谢你的留言，我会尽快回复。</p>
        <button class="submit-btn" @click="submitted = false">再写一条</button>
      </div>

      <div class="side-info">
        <div class="info-card">
          <h3>联系方式</h3>
          <div class="info-item">
            <span class="info-icon">📧</span>
            <div>
              <span class="info-label">邮箱</span>
              <span>hello@example.com</span>
            </div>
          </div>
          <div class="info-item">
            <span class="info-icon">📍</span>
            <div>
              <span class="info-label">位置</span>
              <span>中国 · 北京</span>
            </div>
          </div>
        </div>

        <div class="info-card">
          <h3>社交链接</h3>
          <div class="social-links">
            <a href="https://github.com" target="_blank" class="social-link">
              <span class="social-icon">💻</span>
              <span>GitHub</span>
            </a>
            <a href="https://juejin.cn" target="_blank" class="social-link">
              <span class="social-icon">📖</span>
              <span>掘金</span>
            </a>
            <a href="https://zhihu.com" target="_blank" class="social-link">
              <span class="social-icon">🔍</span>
              <span>知乎</span>
            </a>
            <a href="https://twitter.com" target="_blank" class="social-link">
              <span class="social-icon">🐦</span>
              <span>Twitter</span>
            </a>
          </div>
        </div>

        <div class="info-card">
          <h3>常见问题</h3>
          <div class="faq-item">
            <strong>多久回复？</strong>
            <p>通常 24 小时内回复</p>
          </div>
          <div class="faq-item">
            <strong>合作咨询？</strong>
            <p>欢迎通过留言或邮件联系</p>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
.contact-page {
  max-width: 900px;
  margin: 0 auto;
  padding: 40px 20px;
}
.page-header {
  text-align: center;
  margin-bottom: 32px;
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

.contact-layout {
  display: grid;
  grid-template-columns: 1fr 320px;
  gap: 24px;
  align-items: start;
}
.contact-card, .success-card {
  background: #fff;
  padding: 32px;
  border-radius: 14px;
  box-shadow: 0 2px 12px rgba(0,0,0,0.06);
}
.form-title {
  font-size: 18px;
  color: #222;
  margin-bottom: 20px;
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
.form-group textarea {
  width: 100%;
  padding: 10px 14px;
  border: 1px solid #ddd;
  border-radius: 8px;
  font-size: 14px;
  transition: border-color 0.2s;
  font-family: inherit;
}
.form-group input:focus,
.form-group textarea:focus {
  outline: none;
  border-color: #1a73e8;
  box-shadow: 0 0 0 3px rgba(26,115,232,0.1);
}
.error-msg {
  color: #d32f2f;
  font-size: 14px;
  margin-bottom: 12px;
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
  transition: all 0.2s;
  font-weight: 500;
}
.submit-btn:hover { background: #1557b0; }
.submit-btn:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

.success-card {
  text-align: center;
  padding: 60px 32px;
}
.success-icon {
  width: 64px;
  height: 64px;
  border-radius: 50%;
  background: #e8f5e9;
  color: #4caf50;
  font-size: 30px;
  display: flex;
  align-items: center;
  justify-content: center;
  margin: 0 auto 16px;
}
.success-card h2 {
  font-size: 22px;
  color: #222;
  margin-bottom: 8px;
}
.success-card p {
  color: #666;
  margin-bottom: 24px;
}

/* Side */
.side-info {
  display: flex;
  flex-direction: column;
  gap: 16px;
}
.info-card {
  background: #fff;
  padding: 20px;
  border-radius: 14px;
  box-shadow: 0 2px 8px rgba(0,0,0,0.06);
}
.info-card h3 {
  font-size: 16px;
  color: #222;
  margin-bottom: 14px;
  padding-bottom: 10px;
  border-bottom: 1px solid #f0f0f0;
}
.info-item {
  display: flex;
  gap: 12px;
  align-items: center;
  padding: 8px 0;
  font-size: 14px;
  color: #555;
}
.info-icon {
  font-size: 20px;
  width: 36px;
  height: 36px;
  background: #f5f5f5;
  border-radius: 8px;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}
.info-item div {
  display: flex;
  flex-direction: column;
}
.info-label {
  font-size: 12px;
  color: #999;
}

/* Social */
.social-links {
  display: flex;
  flex-direction: column;
  gap: 8px;
}
.social-link {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 8px 12px;
  border-radius: 8px;
  text-decoration: none;
  color: #555;
  font-size: 14px;
  transition: all 0.2s;
}
.social-link:hover {
  background: #f0f4ff;
  color: #1a73e8;
}
.social-icon {
  font-size: 16px;
  width: 32px;
  height: 32px;
  background: #f5f5f5;
  border-radius: 8px;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}

/* FAQ */
.faq-item {
  padding: 10px 0;
  border-bottom: 1px solid #f5f5f5;
}
.faq-item:last-child { border-bottom: none; }
.faq-item strong {
  display: block;
  font-size: 14px;
  color: #333;
  margin-bottom: 2px;
}
.faq-item p {
  font-size: 13px;
  color: #888;
}

@media (max-width: 768px) {
  .contact-layout { grid-template-columns: 1fr; }
}
</style>
