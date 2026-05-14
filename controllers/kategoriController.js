const { Kategori } = require("../models");

exports.createKategori = async (req, res) => {
  try {
    const { nama } = req.body;
    if (!nama) {
      return res.status(400).json({ message: "Nama kategori wajib diisi!" });
    }
    const newKat = await Kategori.create({ nama });
    res.status(201).json({
      message: "Kategori berhasil dibuat",
      data: newKat,
    });
  } catch (error) {
    if (error.name === "SequelizeUniqueConstraintError") {
      return res
        .status(400)
        .json({ message: "Nama kategori sudah terdaftar." });
    }
    res
      .status(500)
      .json({ message: "Terjadi kesalahan pada server", error: error.message });
  }
};

exports.updateKategori = async (req, res) => {
  try {
    const { nama } = req.body;
    const kategori = await Kategori.findByPk(req.params.id);
    if (!kategori) {
      return res.status(404).json({ message: "Kategori tidak ditemukan" });
    }
    await kategori.update({ nama });
    res.json({
      status: true,
      message: "Kategori berhasil diupdate",
    });
  } catch (error) {
    res
      .status(500)
      .json({ message: "Terjadi kesalahan pada server", error: error.message });
  }
};

exports.deleteKategori = async (req, res) => {
  const kategori = await Kategori.findByPk(req.params.id);
  if (!kategori) {
    return res.status(404).json({ message: "Kategori tidak ditemukan" });
  }
  await kategori.destroy();
  res.json({
    status: true,
    message: "Kategori berhasil dihapus",
  });
};

exports.getAllKat = async (req, res) => {
  const kategori = await Kategori.findAll();
  res.json({
    status: true,
    message: "Kategori berhasil ditampilkan semua",
    data: kategori,
  });
};
