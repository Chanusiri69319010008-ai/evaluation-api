const mysql = require('mysql2/promise');

// กลุ่มการเชื่อมต่อ (pool) ไปที่ MySQL ค่าทั้งหมดอ่านจากไฟล์ .env
const db = mysql.createPool({
host: process.env.DB_HOST,
user: process.env.DB_USER,
password: process.env.DB_PASSWORD,
database: process.env.DB_NAME
});

module.exports = db;