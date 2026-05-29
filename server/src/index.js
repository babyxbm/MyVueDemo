import express from 'express';
import cors from 'cors';
import authRoutes from './routes/auth.js';
import postRoutes from './routes/posts.js';
import categoryRoutes from './routes/categories.js';
import projectRoutes from './routes/projects.js';
import messageRoutes from './routes/messages.js';
import aboutRoutes from './routes/about.js';

const app = express();
const PORT = 3000;

app.use(cors());
app.use(express.json());

app.use('/api/auth', authRoutes);
app.use('/api/posts', postRoutes);
app.use('/api/categories', categoryRoutes);
app.use('/api/projects', projectRoutes);
app.use('/api/messages', messageRoutes);
app.use('/api/about', aboutRoutes);

app.listen(PORT, () => {
  console.log(`Blog API server running at http://localhost:${PORT}`);
});
