CREATE DATABASE IF NOT EXISTS blog DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE blog;

-- 管理员用户
CREATE TABLE IF NOT EXISTS users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  username VARCHAR(50) NOT NULL UNIQUE,
  password_hash VARCHAR(255) NOT NULL,
  avatar VARCHAR(500) DEFAULT '',
  bio TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 文章分类
CREATE TABLE IF NOT EXISTS categories (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(50) NOT NULL,
  description VARCHAR(200) DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 博客文章
CREATE TABLE IF NOT EXISTS posts (
  id INT AUTO_INCREMENT PRIMARY KEY,
  title VARCHAR(200) NOT NULL,
  slug VARCHAR(200) NOT NULL,
  summary TEXT,
  content LONGTEXT,
  cover_image VARCHAR(500) DEFAULT '',
  category_id INT,
  tags VARCHAR(200) DEFAULT '',
  view_count INT DEFAULT 0,
  published TINYINT(1) DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 项目作品
CREATE TABLE IF NOT EXISTS projects (
  id INT AUTO_INCREMENT PRIMARY KEY,
  title VARCHAR(200) NOT NULL,
  description TEXT,
  content TEXT,
  tech_stack VARCHAR(300) DEFAULT '',
  image_url VARCHAR(500) DEFAULT '',
  demo_url VARCHAR(500) DEFAULT '',
  github_url VARCHAR(500) DEFAULT '',
  featured TINYINT(1) DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 留言
CREATE TABLE IF NOT EXISTS messages (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  email VARCHAR(200) NOT NULL,
  content TEXT NOT NULL,
  `read` TINYINT(1) DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 清空旧数据重新插入
SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE posts;
TRUNCATE TABLE projects;
TRUNCATE TABLE messages;
TRUNCATE TABLE categories;
TRUNCATE TABLE users;
SET FOREIGN_KEY_CHECKS = 1;

-- 管理员（密码：admin123）
INSERT INTO users (username, password_hash, avatar, bio) VALUES
('admin', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy',
 'https://api.dicebear.com/7.x/avataaars/svg?seed=admin',
 '热爱技术的前端开发者，专注于 Vue.js 和全栈开发。拥有 3 年 Web 开发经验，喜欢探索新技术，用代码创造价值。');

-- 分类
INSERT INTO categories (name, description) VALUES
('前端技术', 'HTML、CSS、JavaScript、Vue 等前端相关技术文章'),
('后端开发', 'Node.js、数据库、API 设计等后端相关内容'),
('项目实战', '实际项目开发经验分享'),
('个人随笔', '技术之外的生活思考与记录'),
('AI 与机器学习', '人工智能、机器学习、LLM 等相关内容'),
('DevOps', 'Docker、CI/CD、部署运维相关');

-- 示例文章
INSERT INTO posts (title, slug, summary, content, cover_image, category_id, tags, published, view_count, created_at) VALUES
(
  'Vue 3 组合式 API 入门指南',
  'vue3-composition-api-guide',
  '全面了解 Vue 3 的组合式 API，包括 ref、reactive、computed、watch 等核心概念的使用方法，以及 setup 语法糖的最佳实践。',
  '# Vue 3 组合式 API 入门指南\n\n## 什么是组合式 API\n\n组合式 API（Composition API）是 Vue 3 中引入的一套全新的 API 风格，它让我们能够更灵活地组织组件逻辑。\n\n## ref 和 reactive\n\n```javascript\nimport { ref, reactive } from \"vue\"\n\nconst count = ref(0)\nconst state = reactive({ name: \"Vue\" })\n```\n\n### ref\n`ref` 用于创建一个响应式引用，可以包裹任何类型的值。\n\n### reactive\n`reactive` 只接受对象类型，返回一个深层次的响应式代理。\n\n## computed\n\n计算属性让我们能够声明式地描述依赖关系：\n\n```javascript\nimport { computed } from \"vue\"\n\nconst doubleCount = computed(() => count.value * 2)\n```\n\n## watch 和 watchEffect\n\n```javascript\nimport { watch, watchEffect } from \"vue\"\n\nwatch(count, (newVal, oldVal) => {\n  console.log(`count 从 ${oldVal} 变为 ${newVal}`)\n})\n\nwatchEffect(() => {\n  console.log(`count 的值是: ${count.value}`)\n})\n```\n\n## 生命周期\n\n组合式 API 中的生命周期钩子以 `on` 开头：\n\n```javascript\nimport { onMounted, onUnmounted } from \"vue\"\nonMounted(() => {\n  console.log(\"组件已挂载\")\n})\n```\n\n## 总结\n\n组合式 API 相比选项式 API 有更好的逻辑复用能力和 TypeScript 支持，是 Vue 3 推荐的开发方式。\n\n> 参考：[Vue 3 官方文档](https://vuejs.org/)',
 '', 1, 'Vue3,JavaScript,组合式API', 1, 128, '2024-01-15 10:00:00'),

(
  '从零搭建 Node.js 后端服务',
  'nodejs-backend-setup',
  '使用 Express 框架从零开始搭建一个完整的 Node.js 后端服务，包含路由设计、中间件、数据库操作、错误处理等核心内容。',
  '# 从零搭建 Node.js 后端服务\n\n## 初始化项目\n\n```bash\nmkdir my-server && cd my-server\nnpm init -y\n```\n\n## 安装依赖\n\n```bash\nnpm install express cors mysql2\n```\n\n## 创建服务器\n\n```javascript\nimport express from \"express\"\nimport cors from \"cors\"\n\nconst app = express()\napp.use(cors())\napp.use(express.json())\n\napp.listen(3000, () => {\n  console.log(\"Server running on port 3000\")\n})\n```\n\n## 路由设计\n\n良好的路由设计是后端服务的核心。推荐按功能模块拆分：\n\n```\nroutes/\n  ├── auth.js\n  ├── posts.js\n  ├── users.js\n  └── categories.js\n```\n\n## 中间件\n\n中间件是 Express 的灵魂，可以用于日志记录、身份验证、错误处理等。\n\n## 数据库操作\n\n使用连接池管理 MySQL 连接，避免频繁创建连接带来的性能开销。\n\n## 错误处理\n\n统一错误处理中间件可以避免重复的 try-catch 代码。',
 '', 2, 'Node.js,Express,后端', 1, 85, '2024-02-20 14:30:00'),

(
  '我的第一个全栈项目经验总结',
  'first-fullstack-project',
  '分享从零到一完成全栈项目的心得体会，包括技术选型、开发流程、遇到的问题以及解决方案。',
  '# 我的第一个全栈项目经验总结\n\n## 项目背景\n\n作为一个开发者，完成一个全栈项目是成长路上的重要里程碑。\n\n## 技术选型\n\n- **前端**：Vue 3 + Vite\n- **后端**：Node.js + Express\n- **数据库**：MySQL\n- **部署**：Docker + Nginx\n\n## 遇到的挑战\n\n### 1. 跨域问题\n\n前后端分离开发时，跨域是最常见的问题。可以通过 CORS 中间件解决。\n\n### 2. 数据库设计\n\n合理的表结构和索引设计对后期维护至关重要。\n\n### 3. 部署上线\n\n使用 Docker 容器化部署，配合 Nginx 反向代理。\n\n## 收获\n\n全栈开发不仅仅是写代码，更是对整个系统的理解和把控。从数据库设计到前端展示，每一个环节都密不可分。',
 '', 3, '全栈,项目经验,Vue,Node.js', 1, 56, '2024-03-10 09:15:00'),

(
  '2024 年前端技术趋势展望',
  'frontend-trends-2024',
  '探讨前端领域的最新发展趋势，包括 AI 集成、WebAssembly、新型框架、微前端等热点话题。',
  '# 2024 年前端技术趋势展望\n\n## AI 与前端\n\nAI 正在改变前端开发的方式，从代码生成到智能测试，AI 辅助开发已经成为新常态。\n\n## 新框架\n\n- **Solid.js**：以细粒度响应式著称\n- **Qwik**：创新的可恢复性架构\n- **Svelte 5**：引入 Runes 响应式系统\n\n## 构建工具\n\nVite 已经成为主流构建工具，Turbopack 也在快速发展。\n\n## 微前端\n\nModule Federation 让微前端架构变得更加成熟。\n\n## WebAssembly\n\nWasm 在前端的应用场景越来越广泛，特别是在图像处理、游戏引擎等领域。',
 '', 1, '前端趋势,AI,WebAssembly', 1, 210, '2024-01-05 08:00:00'),

(
  'Docker 容器化部署实战',
  'docker-deployment-guide',
  '详细介绍如何使用 Docker 和 Docker Compose 对前后端项目进行容器化部署，包括多阶段构建、网络配置等高级技巧。',
  '# Docker 容器化部署实战\n\n## 为什么选择 Docker\n\nDocker 解决了「在我机器上能跑」的问题，让环境一致性成为现实。\n\n## Dockerfile 编写\n\n### 前端多阶段构建\n\n```dockerfile\n# 构建阶段\nFROM node:18 AS builder\nWORKDIR /app\nCOPY package*.json ./\nRUN npm install\nCOPY . .\nRUN npm run build\n\n# 运行阶段\nFROM nginx:alpine\nCOPY --from=builder /app/dist /usr/share/nginx/html\n```\n\n## Docker Compose\n\n```yaml\nversion: \"3\"\nservices:\n  app:\n    build: .\n    ports:\n      - \"3000:3000\"\n    depends_on:\n      - db\n  db:\n    image: mysql:8\n    environment:\n      MYSQL_ROOT_PASSWORD: secret\n```\n\n## 最佳实践\n\n1. 使用 .dockerignore 减少构建上下文\n2. 利用层缓存优化构建速度\n3. 使用健康检查确保服务可用性',
 '', 6, 'Docker,DevOps,部署', 1, 67, '2024-04-02 16:45:00'),

(
  '深入理解 JavaScript 异步编程',
  'async-javascript-deep-dive',
  '从回调函数到 Promise，再到 async/await，全面梳理 JavaScript 异步编程的演进历程和核心概念。',
  '# 深入理解 JavaScript 异步编程\n\n## 同步 vs 异步\n\nJavaScript 是单线程语言，但通过事件循环机制实现了非阻塞的异步编程。\n\n## 回调函数\n\n```javascript\nfs.readFile(\"file.txt\", (err, data) => {\n  if (err) throw err\n  console.log(data)\n})\n```\n\n## Promise\n\n```javascript\nfetch(\"/api/data\")\n  .then(res => res.json())\n  .then(data => console.log(data))\n  .catch(err => console.error(err))\n```\n\n## async/await\n\n```javascript\nasync function fetchData() {\n  try {\n    const res = await fetch(\"/api/data\")\n    const data = await res.json()\n    return data\n  } catch (err) {\n    console.error(err)\n  }\n}\n```\n\n## 事件循环\n\n理解宏任务和微任务的区别是掌握异步编程的关键。',
 '', 1, 'JavaScript,异步,Promise', 1, 93, '2024-03-22 11:20:00'),

(
  'MySQL 性能优化实战',
  'mysql-performance-optimization',
  '分享 MySQL 数据库性能优化的实用技巧，包括索引优化、查询优化、表结构设计以及配置调优等。',
  '# MySQL 性能优化实战\n\n## 索引优化\n\n合理的索引是性能优化的第一步：\n\n```sql\n-- 复合索引\nCREATE INDEX idx_category_status ON posts(category_id, published);\n\n-- 覆盖索引\nEXPLAIN SELECT id, title FROM posts WHERE category_id = 1;\n```\n\n## 查询优化\n\n- 避免 SELECT *\n- 使用 LIMIT 分页\n- 合理使用 JOIN\n- 避免在 WHERE 中对字段做函数操作\n\n## 表结构设计\n\n- 选择合适的数据类型\n- 使用 NOT NULL 约束\n- 合理拆分大表\n\n## 配置调优\n\n```ini\ninnodb_buffer_pool_size = 1G\nmax_connections = 500\nquery_cache_type = 0\n```\n\n## 慢查询日志\n\n开启慢查询日志是定位性能问题的有效手段。',
 '', 2, 'MySQL,性能优化,数据库', 1, 45, '2024-05-08 13:30:00'),

(
  'TypeScript 高级类型技巧',
  'typescript-advanced-types',
  '深入 TypeScript 的高级类型系统，包括泛型、条件类型、映射类型、模板字面量类型等进阶内容。',
  '# TypeScript 高级类型技巧\n\n## 泛型约束\n\n```typescript\nfunction getProperty<T, K extends keyof T>(obj: T, key: K): T[K] {\n  return obj[key]\n}\n```\n\n## 条件类型\n\n```typescript\ntype IsString<T> = T extends string ? true : false\ntype Result = IsString<\"hello\"> // true\n```\n\n## 映射类型\n\n```typescript\ntype Readonly<T> = {\n  readonly [P in keyof T]: T[P]\n}\n```\n\n## 模板字面量类型\n\n```typescript\ntype EventName = `on${Capitalize<string>}`\n```\n\n## 实用工具类型\n\nTypeScript 内置了 Partial、Required、Pick、Omit 等实用类型，灵活运用可以大幅提升开发效率。',
 '', 1, 'TypeScript,类型系统,前端', 1, 72, '2024-06-12 10:00:00'),

(
  '构建高颜值 UI 组件库',
  'building-ui-component-library',
  '分享如何从零构建一套企业级 UI 组件库，包括设计系统、组件架构、主题定制、文档建设等方面的经验。',
  '# 构建高颜值 UI 组件库\n\n## 设计系统\n\n在动手编码之前，先定义设计 Token：\n\n```css\n:root {\n  --color-primary: #1a73e8;\n  --color-success: #4caf50;\n  --radius-sm: 4px;\n  --radius-md: 8px;\n  --shadow-sm: 0 1px 3px rgba(0,0,0,0.1);\n}\n```\n\n## 组件架构\n\n### Button 组件示例\n\n每个组件应该支持：\n1. 多种变体（primary、secondary、ghost）\n2. 多种尺寸（sm、md、lg）\n3. 加载状态\n4. 自定义样式\n\n## 主题定制\n\n使用 CSS 变量实现主题切换，Context API 实现全局主题配置。\n\n## 文档建设\n\nStorybook 是组件库文档的标准选择。\n\n## 测试\n\n组件测试推荐使用 Vitest + Testing Library。',
 '', 3, 'UI组件库,Vue3,设计系统', 1, 38, '2024-07-01 15:00:00'),

(
  '程序员如何保持持续学习',
  'how-to-keep-learning',
  '在技术快速迭代的今天，如何保持持续学习的动力和效率，分享我的学习方法和工具。',
  '# 程序员如何保持持续学习\n\n## 制定学习计划\n\n不要试图一次学太多，建议：\n- 每月聚焦一个主题\n- 每天投入 30-60 分钟\n- 理论与实践结合\n\n## 学习方法\n\n### 费曼学习法\n\n尝试用简单的语言向他人解释你学到的知识。\n\n### 项目驱动\n\n带着项目去学习，效果远比看书好。\n\n## 优质资源\n\n- **官方文档**：最权威的学习资料\n- **GitHub**：阅读优质开源项目源码\n- **技术博客**：追踪行业动态\n\n## 建立知识体系\n\n使用笔记工具（如 Notion、Obsidian）建立个人知识库，定期回顾和整理。\n\n> 学习的本质不在于记住多少，而在于能够运用多少。',
 '', 4, '学习方法,个人成长', 1, 112, '2024-08-05 09:30:00'),

(
  'React 18 新特性详解',
  'react-18-new-features',
  '全面解析 React 18 的核心新特性，包括并发模式、自动批处理、Suspense、useTransition 等。',
  '# React 18 新特性详解\n\n## 并发模式\n\nReact 18 引入了并发渲染能力，让 UI 渲染可以中断和恢复。\n\n## 自动批处理\n\n```javascript\n// React 18 中，多个 setState 会自动批处理\nsetCount(c => c + 1)\nsetFlag(f => !f)\n// 只会触发一次重渲染\n```\n\n## useTransition\n\n```javascript\nconst [isPending, startTransition] = useTransition()\n\nstartTransition(() => {\n  setSearchQuery(input)\n})\n```\n\n## Suspense\n\nSuspense 现在支持服务端渲染和数据获取场景。\n\n## 新 Hooks\n\n- useId：生成唯一 ID\n- useDeferredValue：延迟更新部分 UI',
 '', 1, 'React,JavaScript,前端框架', 1, 55, '2024-09-10 14:00:00'),

(
  'Nginx 配置最佳实践',
  'nginx-best-practices',
  '分享 Nginx 在生产环境中的最佳配置实践，包括反向代理、负载均衡、HTTPS 配置、性能优化等内容。',
  '# Nginx 配置最佳实践\n\n## 反向代理\n\n```nginx\nserver {\n  listen 80;\n  server_name example.com;\n\n  location / {\n    proxy_pass http://localhost:3000;\n    proxy_set_header Host $host;\n    proxy_set_header X-Real-IP $remote_addr;\n  }\n}\n```\n\n## HTTPS 配置\n\n```nginx\nserver {\n  listen 443 ssl;\n  ssl_certificate /etc/ssl/certs/server.crt;\n  ssl_certificate_key /etc/ssl/private/server.key;\n  ssl_protocols TLSv1.2 TLSv1.3;\n}\n```\n\n## 性能优化\n\n```nginx\n# 开启 gzip 压缩\ngzip on;\ngzip_types text/plain application/javascript text/css;\n\n# 缓存静态资源\nlocation ~* \\.(jpg|png|svg|ico)$ {\n  expires 30d;\n}\n```\n\n## 安全配置\n\n限制请求速率、隐藏版本号、配置 CORS 头等安全措施。',
 '', 6, 'Nginx,DevOps,运维', 1, 34, '2024-10-18 11:00:00'),

(
  'AI 辅助编程实战经验',
  'ai-assisted-programming',
  '分享使用 GitHub Copilot、ChatGPT 等 AI 工具辅助编程的实战经验，提升开发效率的技巧和方法。',
  '# AI 辅助编程实战经验\n\n## 常用 AI 工具\n\n- **GitHub Copilot**：代码补全\n- **ChatGPT / Claude**：问题解答和代码生成\n- **Cursor**：AI-first IDE\n\n## 如何写好 Prompt\n\n好的提示词能大幅提升 AI 输出的质量：\n\n1. **明确上下文**：告诉 AI 你使用的技术栈\n2. **给出示例**：提供期望的输出格式\n3. **分步提问**：复杂问题拆解为多个小问题\n\n## AI 的局限性\n\nAI 生成的代码需要人工审查，特别是：\n- 安全性问题\n- 性能问题\n- 版权问题\n\n## 推荐工作流\n\nAI 辅助 + 人工审查 + 自动化测试，三者结合才能保证代码质量。',
 '', 5, 'AI,Copilot,效率工具', 1, 156, '2024-11-20 16:00:00'),

(
  'Vue 3 性能优化指南',
  'vue3-performance-optimization',
  '深入探讨 Vue 3 应用的性能优化策略，包括虚拟列表、懒加载、缓存策略、组件优化等方面。',
  '# Vue 3 性能优化指南\n\n## 虚拟列表\n\n当渲染大量列表数据时，使用虚拟列表只渲染可视区域内的元素：\n\n```vue\n<template v-for=\"item in visibleItems\" :key=\"item.id\">\n  <Item :data=\"item\" />\n</template>\n```\n\n## 懒加载\n\n### 路由懒加载\n\n```javascript\nconst Home = () => import(\"./views/Home.vue\")\n```\n\n### 图片懒加载\n\n使用 IntersectionObserver 实现图片懒加载。\n\n## 组件优化\n\n- 合理使用 v-show 和 v-if\n- 使用 shallowRef 减少深层响应式开销\n- 函数式组件减少实例开销\n\n## 缓存策略\n\nKeepAlive 缓存组件状态，避免重复渲染。',
 '', 1, 'Vue3,性能优化,前端', 1, 48, '2025-01-08 10:30:00');

-- 示例项目
INSERT INTO projects (title, description, content, tech_stack, image_url, demo_url, github_url, featured, created_at) VALUES
('个人博客系统', '基于 Vue 3 + Node.js + MySQL 的全栈个人博客，支持文章管理、留言互动、分类筛选等完整功能。', '完整的全栈博客系统，包含前台展示和后台管理功能。前台支持文章列表、文章详情、项目作品展示、留言互动；后台支持文章 CRUD、留言管理。', 'Vue 3, Node.js, MySQL, Vite', '', '', 'https://github.com/example/blog', 1, '2024-01-15 10:00:00'),

('天气预报 APP', '使用 Vue 3 和公共天气 API 开发的天气预报应用，支持城市搜索、未来 7 天预报、空气质量指数等功能。', '调用第三方天气 API，展示实时天气数据。支持搜索城市、查看未来一周天气预报、空气质量指数、紫外线指数等。', 'Vue 3, Axios, API, Chart.js', '', '', 'https://github.com/example/weather', 1, '2024-03-20 14:30:00'),

('待办事项管理器', '简洁高效的待办事项管理工具，支持分类、标签、拖拽排序、番茄钟计时等功能。', '一个功能完整的 Todo 应用，支持多列表管理、标签分类、优先级标记、到期提醒、数据本地持久化。', 'Vue 3, Pinia, Vue Draggable', '', '', 'https://github.com/example/todo', 0, '2024-04-10 09:00:00'),

('在线代码编辑器', '基于 Monaco Editor 的在线代码编辑器，支持多语言语法高亮、代码补全、实时预览等功能。', '类似 CodePen 的在线代码编辑平台，支持 HTML/CSS/JS 实时预览，代码片段保存和分享。', 'Vue 3, Monaco Editor, WebSocket', '', '', 'https://github.com/example/code-editor', 1, '2024-06-01 11:20:00'),

('电商管理后台', '完整的电商后台管理系统，包含商品管理、订单管理、数据分析、用户管理等核心模块。', '企业级电商后台管理面板，使用 Vue 3 + Element Plus 构建，包含数据可视化大屏、权限管理、国际化等功能。', 'Vue 3, Element Plus, ECharts, Pinia', '', '', 'https://github.com/example/ecommerce', 1, '2024-08-15 15:00:00'),

('Markdown 笔记应用', '支持 Markdown 编辑、实时预览、标签分类、全文搜索的云端笔记应用。', '类 Notion 风格的笔记应用，支持 Markdown 语法、代码高亮、图片上传、导出 PDF、多端同步。', 'Vue 3, Firebase, Markdown-It', '', '', 'https://github.com/example/notes', 0, '2024-10-05 08:45:00'),

('实时聊天应用', '基于 WebSocket 的实时聊天应用，支持群聊、私聊、消息通知、表情包发送等功能。', '使用 Socket.io 实现实时双向通信，支持多房间、在线状态显示、消息历史记录、文件传输。', 'Vue 3, Socket.io, Node.js, Redis', '', '', 'https://github.com/example/chat', 0, '2024-12-01 13:30:00'),

('AI 图片生成工具', '集成 Stable Diffusion API 的 AI 图片生成工具，支持文生图、图生图、风格迁移等。', '调用 Stable Diffusion API，提供直观的图片生成界面，支持提示词模板、生成历史、图片下载。', 'Vue 3, AI API, Canvas', '', 'https://ai-demo.example.com', 'https://github.com/example/ai-image', 1, '2025-02-10 16:00:00');
