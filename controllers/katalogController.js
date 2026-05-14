const { Katalog, Kategori } = require("../models");

exports.createKatalog = async (req, res) => {
  try {
    const {
      nama,
      idKat,
      tahun,
      harga,
      kapasitasMesin,
      jumlahKursi,
      warna,
      bahanBakar,
      transmisi,
    } = req.body;
    const gambar = req.file ? req.file.filename : null;
    const kategori = await Kategori.findByPk(idKat);
    if (!kategori)
      return res.status(404).json({ message: "Kategori tidak ditemukan" });

    const newKatalog = await Katalog.create({
      nama,
      idKat,
      tahun,
      harga,
      kapasitasMesin,
      jumlahKursi,
      warna,
      gambar,
      bahanBakar,
      transmisi,
    });
    res.status(201).json({
      message: "Katalog berhasil dibuat",
      data: newKatalog,
    });
  } catch (error) {
    res
      .status(500)
      .json({ message: "Terjadi kesalahan pada server", error: error.message });
  }
};

exports.updateKatalog = async (req, res) => {
  const { id } = req.body;
  try {
    const katalog = await Katalog.findByPk(idKat);
    if (!katalog)
      return res.status(404).json({ message: "Katalog tidak ditemukan" });
    await katalog.update(req.body);
    res.status(201).json({
      message: "Katalog berhasil diubah",
      data: katalog,
    });
  } catch (error) {
    res
      .status(500)
      .json({ message: "Terjadi kesalahan pada server", error: error.message });
  }
};

exports.getAllKatalog = async (req, res) => {
  try {
    const katalog = await Katalog.findAll({
      include: [
        {
          model: Kategori,
          as: "kategori",
          attributes: ["nama"],
        },
      ],
      order: [["createdAt", "DESC"]],
    });
    res.status(200).json({
      status: true,
      message: "Semua katalog berhasil didapatkan",
      data: katalog,
    });
  } catch (error) {
    res
      .status(500)
      .json({ message: "Terjadi kesalahan pada server", error: error.message });
  }
};

exports.getKatById = async (req, res) => {
  const { id } = req.params;
  try {
    const katalog = await Katalog.findByPk(id);
    if (!katalog)
      return res.status(404).json({ message: "Katalog tidak ditemukan" });
    res.status(200).json({
      status: true,
      message: "Data katalog berhasil didapatkan",
      data: katalog,
    });
  } catch (error) {
    res
      .status(500)
      .json({ message: "Terjadi kesalahan pada server", error: error.message });
  }
};

exports.deleteKatalog = async (req, res) => {
  try {
    const katalog = await Katalog.findByPk(id);
    if (!katalog)
      return res.status(404).json({ message: "Katalog tidak ditemukan" });
    await katalog.destroy();
    res.status(200).json({ message: "Data katalog berhasil dihapus" });
  } catch (error) {
    res
      .status(500)
      .json({ message: "Terjadi kesalahan pada server", error: error.message });
  }
};
