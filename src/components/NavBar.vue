<script setup>
import { ref, computed } from 'vue'
import { useRoute } from 'vue-router'

const route = useRoute()
const token = ref(localStorage.getItem('token'))
const isLoggedIn = computed(() => !!token.value)

const navItems = [
  { path: '/', label: '首页' },
  { path: '/about', label: '关于' },
  { path: '/projects', label: '项目' },
  { path: '/contact', label: '留言' },
]

const menuOpen = ref(false)

function logout() {
  localStorage.removeItem('token')
  localStorage.removeItem('username')
  token.value = null
  window.location.href = '/'
}

function toggleMenu() {
  menuOpen.value = !menuOpen.value
}
</script>

<template>
  <nav class="navbar">
    <div class="nav-inner">
      <router-link to="/" class="logo">
        <span class="logo-icon">&lt;/&gt;</span>
        <span class="logo-text">MyBlog</span>
      </router-link>
      <button class="menu-toggle" @click="toggleMenu" :class="{ open: menuOpen }">
        <span></span><span></span><span></span>
      </button>
      <div class="nav-links" :class="{ open: menuOpen }">
        <router-link
          v-for="item in navItems"
          :key="item.path"
          :to="item.path"
          class="nav-link"
          :class="{ active: route.path === item.path }"
          @click="menuOpen = false"
        >
          {{ item.label }}
        </router-link>
        <template v-if="isLoggedIn">
          <router-link to="/admin" class="nav-link admin-link" :class="{ active: route.path.startsWith('/admin') }" @click="menuOpen = false">
            管理
          </router-link>
          <a href="#" class="nav-link logout-link" @click.prevent="logout">退出</a>
        </template>
      </div>
    </div>
  </nav>
</template>

<style scoped>
.navbar {
  background: rgba(255,255,255,0.95);
  backdrop-filter: blur(10px);
  box-shadow: 0 1px 4px rgba(0,0,0,0.06);
  position: sticky;
  top: 0;
  z-index: 100;
}
.nav-inner {
  max-width: 1000px;
  margin: 0 auto;
  padding: 0 20px;
  height: 60px;
  display: flex;
  align-items: center;
  justify-content: space-between;
}
.logo {
  display: flex;
  align-items: center;
  gap: 8px;
  text-decoration: none;
}
.logo-icon {
  font-size: 18px;
  font-weight: 800;
  color: #1a73e8;
  background: #e8f0fe;
  padding: 4px 8px;
  border-radius: 6px;
}
.logo-text {
  font-size: 20px;
  font-weight: 700;
  color: #1a1a2e;
  letter-spacing: -0.5px;
}
.nav-links {
  display: flex;
  gap: 2px;
  align-items: center;
}
.nav-link {
  padding: 8px 16px;
  text-decoration: none;
  color: #555;
  font-size: 14px;
  font-weight: 500;
  border-radius: 8px;
  transition: all 0.2s;
}
.nav-link:hover {
  background: #f0f4ff;
  color: #1a73e8;
}
.nav-link.active {
  background: #1a73e8;
  color: #fff;
}
.admin-link {
  color: #e67e22;
}
.logout-link {
  color: #d32f2f;
}
.menu-toggle {
  display: none;
  flex-direction: column;
  gap: 5px;
  background: none;
  border: none;
  cursor: pointer;
  padding: 4px;
  z-index: 10;
}
.menu-toggle span {
  display: block;
  width: 22px;
  height: 2px;
  background: #333;
  border-radius: 2px;
  transition: all 0.3s;
}
.menu-toggle.open span:nth-child(1) {
  transform: rotate(45deg) translate(5px, 5px);
}
.menu-toggle.open span:nth-child(2) {
  opacity: 0;
}
.menu-toggle.open span:nth-child(3) {
  transform: rotate(-45deg) translate(5px, -5px);
}

@media (max-width: 640px) {
  .menu-toggle { display: flex; }
  .nav-links {
    display: none;
    position: absolute;
    top: 60px;
    left: 0;
    right: 0;
    background: rgba(255,255,255,0.98);
    backdrop-filter: blur(10px);
    flex-direction: column;
    padding: 12px;
    box-shadow: 0 8px 20px rgba(0,0,0,0.1);
    border-top: 1px solid #f0f0f0;
  }
  .nav-links.open { display: flex; }
  .nav-link { width: 100%; padding: 12px 16px; }
}
</style>
