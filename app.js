const express = require("express");
const path = require("path");
const cors = require("cors");
const app = express();

app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

const authRoutes = require("./routes/authRoutes");
app.use("/api/auth", authRoutes);
app.use("/api/kategori", require("./routes/kategoriRoutes"));
app.use("/api/katalog", require("./routes/katalogRoutes"));
app.use('/uploads', express.static(path.join(__dirname, '/uploads')));
app.get("/", (req, res) => {
  res.send("SERVER AKTIF");
});

module.exports = app;