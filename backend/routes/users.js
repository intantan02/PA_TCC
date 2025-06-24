const express = require("express");
const router = express.Router();
const db = require("../db/mysql"); 

// REGISTER USER
router.post("/register", (req, res) => {
  const { username, password } = req.body;
  if (!username || !password) {
    return res.status(400).json({ error: "Username dan password wajib diisi" });
  }

  const query = "INSERT INTO users (username, password) VALUES (?, ?)";
  db.query(query, [username, password], (err, result) => {
    if (err) {
      return res.status(500).json({ error: "Gagal register user" });
    }
    res.status(201).json({ message: "User berhasil didaftarkan" });
  });
});

// LOGIN USER
router.post("/login", (req, res) => {
  const { username, password } = req.body;
  console.log("Login attempt:", req.body.username); 

  const query = "SELECT * FROM users WHERE username = ? AND password = ?";
  db.query(query, [username, password], (err, results) => {
    if (err) {
      return res.status(500).json({ error: "Login gagal" });
    }

    if (results.length > 0) {
      res.status(200).json({ message: "Login berhasil" });
    } else {
      res.status(401).json({ error: "Username atau password salah" });
    }
  });
});

module.exports = router;
