import { Router } from 'express';
import pool from '../db.js';
import { authenticateToken } from '../middleware.js';

const router = Router();

// 公开：获取项目列表（支持技术筛选）
router.get('/', async (req, res) => {
  try {
    const tech = req.query.tech;
    let sql = 'SELECT * FROM projects';
    const params = [];
    if (tech) {
      sql += ' WHERE tech_stack LIKE ?';
      params.push(`%${tech}%`);
    }
    sql += ' ORDER BY featured DESC, created_at DESC';
    const [rows] = await pool.query(sql, params);
    res.json(rows);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: '服务器错误' });
  }
});

// 管理：创建项目
router.post('/', authenticateToken, async (req, res) => {
  try {
    const { title, description, content, tech_stack, image_url, demo_url, github_url, featured } = req.body;
    const [result] = await pool.query(
      `INSERT INTO projects (title, description, content, tech_stack, image_url, demo_url, github_url, featured)
       VALUES (?, ?, ?, ?, ?, ?, ?, ?)`,
      [title, description, content || '', tech_stack || '', image_url || '', demo_url || '', github_url || '', featured ? 1 : 0]
    );
    res.json({ id: result.insertId, message: '创建成功' });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: '服务器错误' });
  }
});

// 管理：更新项目
router.put('/:id', authenticateToken, async (req, res) => {
  try {
    const { title, description, content, tech_stack, image_url, demo_url, github_url, featured } = req.body;
    await pool.query(
      `UPDATE projects SET title=?, description=?, content=?, tech_stack=?, image_url=?, demo_url=?, github_url=?, featured=?
       WHERE id=?`,
      [title, description, content || '', tech_stack || '', image_url || '', demo_url || '', github_url || '', featured ? 1 : 0, req.params.id]
    );
    res.json({ message: '更新成功' });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: '服务器错误' });
  }
});

// 管理：删除项目
router.delete('/:id', authenticateToken, async (req, res) => {
  try {
    await pool.query('DELETE FROM projects WHERE id = ?', [req.params.id]);
    res.json({ message: '删除成功' });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: '服务器错误' });
  }
});

export default router;
