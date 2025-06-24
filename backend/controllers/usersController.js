// controllers/usersController.js
const db = require("../db/mysql");

exports.registerUser = (req, res) => {
  const { username, password } = req.body;
  const query = "INSERT INTO users (username, password) VALUES (?, ?)";

  db.query(query, [username, password], (err, result) => {
    if (err) return res.status(500).json({ error: "Gagal register" });
    res.status(201).json({ message: "Register berhasil" });
  });
};

exports.loginUser = (req, res) => {
  const { username, password } = req.body;
  const query = "SELECT * FROM users WHERE username = ? AND password = ?";

  db.query(query, [username, password], (err, results) => {
    if (err) return res.status(500).json({ error: "Gagal login" });
    if (results.length === 0) return res.status(401).json({ error: "User tidak ditemukan" });
    res.status(200).json({ message: "Login berhasil" });
  });
};
