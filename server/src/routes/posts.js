import { Router } from 'express';
import pool from '../db.js';
import { authenticateToken } from '../middleware.js';

const router = Router();

// 公开：获取文章列表（分页，支持分类筛选）
router.get('/', async (req, res) => {
  try {
    const page = parseInt(req.query.page) || 1;
    const limit = parseInt(req.query.limit) || 10;
    const offset = (page - 1) * limit;
    const categoryId = req.query.category;

    let countSql = 'SELECT COUNT(*) as total FROM posts WHERE published = 1';
    let sql = `SELECT p.id, p.title, p.summary, p.cover_image, p.tags, p.view_count,
                      p.created_at, p.updated_at, c.name as category_name
               FROM posts p
               LEFT JOIN categories c ON p.category_id = c.id
               WHERE p.published = 1`;

    const params = [];
    if (categoryId) {
      const filter = ' AND p.category_id = ?';
      countSql += filter;
      sql += filter;
      params.push(categoryId);
    }

    const [countRows] = await pool.query(countSql, params);
    const total = countRows[0].total;

    sql += ' ORDER BY p.created_at DESC LIMIT ? OFFSET ?';
    const [rows] = await pool.query(sql, [...params, limit, offset]);

    res.json({ posts: rows, total, page, totalPages: Math.ceil(total / limit) });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: '服务器错误' });
  }
});

// 公开：获取推荐文章
router.get('/featured', async (_req, res) => {
  try {
    const [rows] = await pool.query(
      `SELECT p.id, p.title, p.summary, p.cover_image, p.tags, p.view_count,
              p.created_at, c.name as category_name
       FROM posts p
       LEFT JOIN categories c ON p.category_id = c.id
       WHERE p.published = 1
       ORDER BY p.view_count DESC, p.created_at DESC
       LIMIT 5`
    );
    res.json(rows);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: '服务器错误' });
  }
});

// 公开：搜索文章
router.get('/search', async (req, res) => {
  try {
    const q = req.query.q;
    if (!q) return res.json([]);

    const [rows] = await pool.query(
      `SELECT p.id, p.title, p.summary, p.tags, p.view_count, p.created_at,
              c.name as category_name
       FROM posts p
       LEFT JOIN categories c ON p.category_id = c.id
       WHERE p.published = 1
         AND (p.title LIKE ? OR p.summary LIKE ? OR p.tags LIKE ?)
       ORDER BY p.view_count DESC
       LIMIT 20`,
      [`%${q}%`, `%${q}%`, `%${q}%`]
    );
    res.json(rows);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: '服务器错误' });
  }
});

// 公开：获取单篇文章（含相关文章）
router.get('/:id', async (req, res) => {
  try {
    const [rows] = await pool.query(
      `SELECT p.*, c.name as category_name
       FROM posts p
       LEFT JOIN categories c ON p.category_id = c.id
       WHERE p.id = ?`,
      [req.params.id]
    );
    if (rows.length === 0) return res.status(404).json({ error: '文章不存在' });

    // 增加浏览量
    await pool.query('UPDATE posts SET view_count = view_count + 1 WHERE id = ?', [req.params.id]);
    rows[0].view_count += 1;

    // 获取相关文章（同分类）
    const [related] = await pool.query(
      `SELECT id, title, created_at
       FROM posts
       WHERE category_id = ? AND id != ? AND published = 1
       ORDER BY created_at DESC
       LIMIT 4`,
      [rows[0].category_id, req.params.id]
    );

    res.json({ ...rows[0], related });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: '服务器错误' });
  }
});

// 管理：创建文章
router.post('/', authenticateToken, async (req, res) => {
  try {
    const { title, summary, content, cover_image, category_id, tags, published } = req.body;
    const [result] = await pool.query(
      `INSERT INTO posts (title, slug, summary, content, cover_image, category_id, tags, published)
       VALUES (?, ?, ?, ?, ?, ?, ?, ?)`,
      [title, title, summary, content, cover_image || '', category_id || null, tags || '', published ? 1 : 0]
    );
    res.json({ id: result.insertId, message: '创建成功' });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: '服务器错误' });
  }
});

// 管理：更新文章
router.put('/:id', authenticateToken, async (req, res) => {
  try {
    const { title, summary, content, cover_image, category_id, tags, published } = req.body;
    await pool.query(
      `UPDATE posts SET title=?, summary=?, content=?, cover_image=?, category_id=?, tags=?, published=?
       WHERE id=?`,
      [title, summary, content, cover_image || '', category_id || null, tags || '', published ? 1 : 0, req.params.id]
    );
    res.json({ message: '更新成功' });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: '服务器错误' });
  }
});

// 管理：删除文章
router.delete('/:id', authenticateToken, async (req, res) => {
  try {
    await pool.query('DELETE FROM posts WHERE id = ?', [req.params.id]);
    res.json({ message: '删除成功' });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: '服务器错误' });
  }
});

export default router;
