import { createRouter, createWebHistory } from 'vue-router'
import Home from '../views/Home.vue'
import PostDetail from '../views/PostDetail.vue'
import About from '../views/About.vue'
import Projects from '../views/Projects.vue'
import Contact from '../views/Contact.vue'
import Dashboard from '../views/admin/Dashboard.vue'
import PostEditor from '../views/admin/PostEditor.vue'
import Messages from '../views/admin/Messages.vue'

const routes = [
  { path: '/', name: 'Home', component: Home },
  { path: '/post/:id', name: 'PostDetail', component: PostDetail },
  { path: '/about', name: 'About', component: About },
  { path: '/projects', name: 'Projects', component: Projects },
  { path: '/contact', name: 'Contact', component: Contact },
  { path: '/admin', name: 'Dashboard', component: Dashboard },
  { path: '/admin/post/:id?', name: 'PostEditor', component: PostEditor },
  { path: '/admin/messages', name: 'Messages', component: Messages },
]

const router = createRouter({
  history: createWebHistory(),
  routes,
})

export default router
