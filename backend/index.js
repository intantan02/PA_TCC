// index.js
const express = require("express");
const cors = require("cors");
const bodyParser = require("body-parser");
require("dotenv").config();            
require("./db/mysql");                 

const app = express();
const PORT = 3000;

// Middlewares
app.use(cors());
app.use(bodyParser.json());            

// Routes
const userRoutes = require("./routes/users");  
app.use("/api/users", userRoutes);             

// Default route
app.get("/", (req, res) => {
  res.send("REST API backend for Flutter is running.");
});

// Start server
app.listen(PORT, () => {
  console.log(`🚀 Server running on http://localhost:${PORT}`);
});
