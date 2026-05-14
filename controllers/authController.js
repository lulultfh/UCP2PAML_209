require("dotenv").config();
const jwt = require('jsonwebtoken');

const { User } = require("../models");
const bcrypt = require("bcryptjs");
const JWT_SECRET = process.env.JWT_SECRET;

exports.register = async (req, res) => {
  try {
    const { nama, email, username, password, role } = req.body;

    if ((!nama || !email, !username, !password, !role)) {
      return res.status(400).json({ message: "Semua kolom wajib diisi" });
    }
    // let finalRole = "user";
    // if(role === "admin"){
    //     if (adminCode === process.env.ADMIN_REGISTRATION_CODE) {
    //     finalRole = "admin";
    //   } else {
    //     return res.status(403).json({ message: "Kode rahasia admin tidak valid!" });
    //   }
    // }
    if (role && !["user", "admin"].includes(role)) {
      return res
        .status(400)
        .json({ message: "Role tidak valid! Isikan 'user' atau 'admin'" });
    }
    const hashedPassword = await bcrypt.hash(password, 12);
    const newUser = await User.create({
      nama,
      email,
      username,
      password: hashedPassword,
      role: role || "user",
    });

    res.status(201).json({
      message: "Registrasi berhasil",
      data: {
        id: newUser.id,
        email: newUser.email,
        username: newUser.username,
        role: newUser.role,
        updateAt: newUser.updatedAt,
        createdAt: newUser.createdAt,
      },
    });
  } catch (error) {
    if (error.name === "SequelizeUniqueConstraintError") {
      return res.status(400).json({ message: "Email sudah terdaftar." });
    }
    res
      .status(500)
      .json({ message: "Terjadi kesalahan pada server", error: error.message });
  }
};

exports.login = async (req, res) => {
  try {
    const { username, password } = req.body;

    const user = await User.findOne({ where: { username } });

    if (!user) {
      return res.status(400).json({ message: "Username tidak ditemukan" });
    }
    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) {
      return res.status(401).json({ message: "Password salah." });
    }

    const payload = {
      id: user.id,
      nama: user.nama,
      role: user.role,
    };
    const token = jwt.sign(payload, JWT_SECRET, {
      expiresIn: "1h",
    });

    res.json({
      message: "Login berhasil",
      token: token,
      data: {
        id: user.id,
        email: user.email,
        username: user.username,
        role: user.role,
        updateAt: user.updatedAt,
        createdAt: user.createdAt,
      },
    });
  } catch (error) {
    console.error("Login Error:", error);
    res
      .status(500)
      .json({ message: "Terjadi kesalahan pada server", error: error.message });
  }
};
