const express = require('express');
const port = 3000;
const path = require('path');
const app = express();
const router = express.Router();
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