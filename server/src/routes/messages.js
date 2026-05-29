import { Router } from 'express';
import pool from '../db.js';
import { authenticateToken } from '../middleware.js';

const router = Router();

// 公开：提交留言
router.post('/', async (req, res) => {
  try {
    const { name, email, content } = req.body;
    if (!name || !email || !content) {
      return res.status(400).json({ error: '请填写完整信息' });
    }
    await pool.query(
      'INSERT INTO messages (name, email, content) VALUES (?, ?, ?)',
      [name, email, content]
    );
    res.json({ message: '留言成功' });
  } catch (err) {
    res.status(500).json({ error: '服务器错误' });
  }
});

// 管理：获取留言列表
router.get('/', authenticateToken, async (req, res) => {
  try {
    const [rows] = await pool.query(
      'SELECT * FROM messages ORDER BY created_at DESC'
    );
    res.json(rows);
  } catch (err) {
    res.status(500).json({ error: '服务器错误' });
  }
});

// 管理：标记已读
router.put('/:id/read', authenticateToken, async (req, res) => {
  try {
    await pool.query('UPDATE messages SET `read` = 1 WHERE id = ?', [req.params.id]);
    res.json({ message: '已标记' });
  } catch (err) {
    res.status(500).json({ error: '服务器错误' });
  }
});

export default router;
