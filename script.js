  const express = require('express');
  const port = 3000;
  const path = require('path');
  const app = express();
  const router = express.Router();
  const mysql = require('mysql2');

  const db = mysql.createConnection({
    host: 'localhost',
    user: 'Bellebear',
    password: 'BBB888', 
    database: 'Belle_Bear'
  });

  db.connect((err) => {
    if (err) {
      console.error('DB connect error:', err);
    } else {
      console.log('Connected to MySQL');
    }
  });

  router.use(express.json());
  app.use(express.static('public'));
  router.use(express.urlencoded({ extended: true }));


  app.use(router);

  router.get('/login', (req, res) => {
    res.redirect('/login.html');
  });


  router.post('/login', (req, res) => {
    res.sendFile(path.join(__dirname, 'public', 'login.html'));
    const { username, password } = req.body;
    console.log(`Received login attempt with username: ${username} and password: ${password}`);
    res.send(`Login successful for user: ${username}`);
  });

  app.listen(port, () => {
    console.log(`Server is running on port ${port}`);
  });


  //database search product
  router.get('/search', (req, res) => {
    let name = req.query.name || '';
    let brand = req.query.brand || '';
    let min = req.query.min || 0;
    let max = req.query.max || 999999;

    let sql = `
      SELECT Product.Name, Product.Brand, Stock.Price
      FROM Product
      JOIN Stock ON Product.Product_ID = Stock.Product_ID
      WHERE 1=1
    `;

    let params = [];

    // 🔥 name filter
    if (name !== '') {
      sql += ` AND LOWER(Product.Name) LIKE ?`;
      params.push(`%${name.toLowerCase()}%`);
    }

    // 🔥 brand filter
    if (brand !== '') {
      sql += ` AND Product.Brand = ?`;
      params.push(brand);
    }

    // 🔥 price filter
    sql += ` AND Stock.Price BETWEEN ? AND ?`;
    params.push(min, max);

    db.query(sql, params, (err, result) => {
      if (err) res.send(err);
      else res.json(result);
    });
  });


  // ===== GET BRANDS =====
router.get('/brands', (req, res) => {
  const sql = `SELECT DISTINCT Brand FROM Product`;

  db.query(sql, (err, result) => {
    if (err) {
      res.send(err);
    } else {
      res.json(result);
    }
  });
});
