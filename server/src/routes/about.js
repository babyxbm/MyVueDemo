import { Router } from 'express';
import pool from '../db.js';

const router = Router();

router.get('/', async (req, res) => {
  try {
    const [rows] = await pool.query(
      'SELECT id, username, avatar, bio FROM users LIMIT 1'
    );
    if (rows.length === 0) return res.status(404).json({ error: '无个人信息' });
    res.json(rows[0]);
  } catch (err) {
    res.status(500).json({ error: '服务器错误' });
  }
});

export default router;
