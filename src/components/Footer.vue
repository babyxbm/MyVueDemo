<template>
  <footer class="footer">
    <div class="footer-inner">
      <div class="footer-grid">
        <div class="footer-col">
          <h4 class="footer-logo">&lt;/&gt; MyBlog</h4>
          <p class="footer-desc">分享技术、记录成长。用代码探索世界，用文字传递思考。</p>
        </div>
        <div class="footer-col">
          <h4>导航</h4>
          <router-link to="/">首页</router-link>
          <router-link to="/about">关于</router-link>
          <router-link to="/projects">项目</router-link>
          <router-link to="/contact">留言</router-link>
        </div>
        <div class="footer-col">
          <h4>技术栈</h4>
          <span>Vue 3</span>
          <span>Node.js</span>
          <span>MySQL</span>
          <span>Vite</span>
        </div>
        <div class="footer-col">
          <h4>社交</h4>
          <a href="https://github.com" target="_blank">GitHub</a>
          <a href="https://juejin.cn" target="_blank">掘金</a>
          <a href="https://zhihu.com" target="_blank">知乎</a>
        </div>
      </div>
      <div class="footer-bottom">
        <p>&copy; {{ new Date().getFullYear() }} MyBlog. All rights reserved.</p>
        <p class="tagline">用代码记录成长</p>
      </div>
    </div>
  </footer>
</template>

<style scoped>
.footer {
  background: #1a1a2e;
  color: #aaa;
  margin-top: auto;
}
.footer-inner {
  max-width: 1000px;
  margin: 0 auto;
  padding: 48px 20px 0;
}
.footer-grid {
  display: grid;
  grid-template-columns: 2fr 1fr 1fr 1fr;
  gap: 32px;
  padding-bottom: 32px;
  border-bottom: 1px solid rgba(255,255,255,0.08);
}
.footer-col {
  display: flex;
  flex-direction: column;
  gap: 8px;
}
.footer-col h4 {
  color: #fff;
  font-size: 15px;
  margin-bottom: 8px;
}
.footer-logo {
  font-size: 18px;
  font-weight: 700;
}
.footer-desc {
  font-size: 13px;
  line-height: 1.6;
  color: #777;
}
.footer-col a,
.footer-col span {
  color: #888;
  font-size: 13px;
  text-decoration: none;
  transition: color 0.2s;
}
.footer-col a:hover {
  color: #66b1ff;
}

.footer-bottom {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 20px 0;
  font-size: 13px;
  color: #666;
}
.tagline {
  color: #555;
}

@media (max-width: 640px) {
  .footer-grid {
    grid-template-columns: 1fr 1fr;
    gap: 24px;
  }
}
</style>
