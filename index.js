require('dotenv').config();
const express = require('express');
 const departmentRouter = require('./routes/departments');
const userRouter = require('./routes/users')

const app = express();
app.use(express.static('public'));
 
// URL ไหนขึ้นต้นด้วย /api/evaluatees ส่งต่อให้ไฟล์ routes/evaluatees.js จัดการ
app.use('/api/departments', departmentRouter);
app.use('/api/users', userRouter);
 
app.listen(3000, () => {
  console.log('เซิร์ฟเวอร์ทำงานที่ http://localhost:3000');
});