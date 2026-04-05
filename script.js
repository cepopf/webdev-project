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

app.use(express.json({ limit: '50mb' }));
app.use(express.urlencoded({ extended: true, limit: '50mb' }));
app.use(express.static('public'));
app.use(router);



router.post('/login', (req, res) => {
  const { username, password } = req.body;
  console.log(`Received login attempt with username: ${username} and password: ${password}`);
  res.redirect('/product');
});

// router.get('/product', (req, res) => {
//   res.sendFile(path.join(__dirname, 'public', 'product.html'));
// });


router.get('/search', (req, res) => {
  let name = req.query.name || '';
  let brand = req.query.brand || '';
  let min = req.query.min || 0;
  let max = req.query.max || 999999;

  let sql = `
    SELECT 
      Product.Name,
      Product.Brand,
      Stock.Price,
      (
        SELECT Image.Image_Data
        FROM Image
        WHERE Image.Stock_ID = Stock.Stock_ID
        ORDER BY Image.Image_num
        LIMIT 1
      ) AS image
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


// ===== ADMIN =====
// get all product
router.get('/admin/products', (req, res) => {
  const sql = `
    SELECT 
      Product.Product_ID AS id,
      Product.Name AS name,
      Product.Brand AS brand,
      Product.Description AS description,
      Stock.Stock_ID AS stockId,
      Stock.Price AS price,
      Stock.Quantity AS quantity
    FROM Product
    JOIN Stock ON Product.Product_ID = Stock.Product_ID
    ORDER BY Product.Product_ID
  `;

  db.query(sql, (err, products) => {
    if (err) return res.status(500).json({ error: err.message });

    if (products.length === 0) {
      return res.json([]);
    }

    const stockIds = products.map(p => p.stockId);
    const placeholders = stockIds.map(() => '?').join(',');

    const imageSql = `
      SELECT Stock_ID AS stockId, Image_num AS imageNum, Image_Data AS image
      FROM Image
      WHERE Stock_ID IN (${placeholders})
      ORDER BY Image_num
    `;

    db.query(imageSql, stockIds, (err2, images) => {
      if (err2) return res.status(500).json({ error: err2.message });

      const imageMap = {};
      images.forEach(img => {
        if (!imageMap[img.stockId]) imageMap[img.stockId] = [];
        imageMap[img.stockId].push(img.image);
      });

      const result = products.map(product => ({
        id: product.id,
        name: product.name,
        brand: product.brand,
        description: product.description,
        price: product.price,
        quantity: product.quantity,
        images: imageMap[product.stockId] || []
      }));

      res.json(result);
    });
  });
});

// add product
router.post('/admin/products', (req, res) => {
  const { id, name, brand, description, images, price, quantity, releaseDate, stockId, size } = req.body;

  const sqlProduct = `
    INSERT INTO Product (Product_ID, Brand, Name, Release_Date, Description)
    VALUES (?, ?, ?, ?, ?)
  `;

  const sqlStock = `
    INSERT INTO Stock (Stock_ID, Size, Price, Quantity, Product_ID)
    VALUES (?, ?, ?, ?, ?)
  `;

  db.query(sqlProduct, [id, brand, name, releaseDate, description], (err) => {
    if (err) return res.status(500).json({ error: err.message });

    db.query(sqlStock, [stockId, size || 'M', price, quantity, id], (err2) => {
      if (err2) return res.status(500).json({ error: err2.message });

      if (!images || images.length === 0) {
        return res.json({ message: 'Product added successfully' });
      }

      const imageValues = images.map((img, index) => {
        const imageId = 'Img' + String(Date.now() + index).slice(-9);
        return [imageId, index + 1, stockId, img];
      });

      const sqlImage = `
        INSERT INTO Image (Image_ID, Image_num, Stock_ID, Image_Data)
        VALUES ?
      `;

      db.query(sqlImage, [imageValues], (err3) => {
        if (err3) return res.status(500).json({ error: err3.message });
        res.json({ message: 'Product added successfully' });
      });
    });
  });
});

// update product
router.put('/admin/products/:id', (req, res) => {
  const productId = req.params.id;
  const { name, brand, description, images, price, quantity } = req.body;

  const sqlProduct = `
    UPDATE Product
    SET Name = ?, Brand = ?, Description = ?
    WHERE Product_ID = ?
  `;

  const sqlStock = `
    UPDATE Stock
    SET Price = ?, Quantity = ?
    WHERE Product_ID = ?
  `;

  const findStockSql = `SELECT Stock_ID FROM Stock WHERE Product_ID = ?`;

  db.query(sqlProduct, [name, brand, description, productId], (err) => {
    if (err) return res.status(500).json({ error: err.message });

    db.query(sqlStock, [price, quantity, productId], (err2) => {
      if (err2) return res.status(500).json({ error: err2.message });

      db.query(findStockSql, [productId], (err3, stockRows) => {
        if (err3) return res.status(500).json({ error: err3.message });
        if (!stockRows.length) return res.status(500).json({ error: 'Stock not found' });

        const stockId = stockRows[0].Stock_ID;

        db.query(`DELETE FROM Image WHERE Stock_ID = ?`, [stockId], (err4) => {
          if (err4) return res.status(500).json({ error: err4.message });

          if (!images || images.length === 0) {
            return res.json({ message: 'Product updated successfully' });
          }

          const imageValues = images.map((img, index) => {
            const imageId = 'Img' + String(Date.now() + index).slice(-9);
            return [imageId, index + 1, stockId, img];
          });

          const sqlImage = `
            INSERT INTO Image (Image_ID, Image_num, Stock_ID, Image_Data)
            VALUES ?
          `;

          db.query(sqlImage, [imageValues], (err5) => {
            if (err5) return res.status(500).json({ error: err5.message });
            res.json({ message: 'Product updated successfully' });
          });
        });
      });
    });
  });
});

// delete product
router.delete('/admin/products/:id', (req, res) => {
  const productId = req.params.id;

  const findStockSql = `SELECT Stock_ID FROM Stock WHERE Product_ID = ?`;

  db.query(findStockSql, [productId], (err, stocks) => {
    if (err) return res.status(500).json({ error: err.message });

    const deleteStockAndProduct = () => {
      db.query(`DELETE FROM Stock WHERE Product_ID = ?`, [productId], (err2) => {
        if (err2) return res.status(500).json({ error: err2.message });

        db.query(`DELETE FROM Product WHERE Product_ID = ?`, [productId], (err3) => {
          if (err3) return res.status(500).json({ error: err3.message });
          res.json({ message: 'Product deleted successfully' });
        });
      });
    };

    if (!stocks || stocks.length === 0) {
      return deleteStockAndProduct();
    }

    const stockIds = stocks.map(s => s.Stock_ID);
    const placeholders = stockIds.map(() => '?').join(',');

    db.query(
      `DELETE FROM Image WHERE Stock_ID IN (${placeholders})`,
      stockIds,
      (err4) => {
        if (err4) return res.status(500).json({ error: err4.message });
        deleteStockAndProduct();
      }
    );
  });
});

app.listen(port, () => {
  console.log(`Server is running on port ${port}`);
});