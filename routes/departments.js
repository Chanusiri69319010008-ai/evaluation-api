const express = require('express');
const db = require('../db');

const router = express.Router();

// GET /api/departments รายชื่อแผนกทั้งหมด
router.get('/', async (req, res) => {
const [rows] = await db.query('SELECT id, name FROM departments ORDER BY id');

res.json({
status: 'success',
message: 'พบ ' + rows.length + ' แผนก',
data: rows
});
});

module.exports = router;