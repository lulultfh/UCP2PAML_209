"use strict";
const { Model } = require("sequelize");
module.exports = (sequelize, DataTypes) => {
  class Katalog extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      // define association here
      Katalog.belongsTo(models.Kategori, {
        foreignKey: "idKat",
        as: "kategori",
      });
    }
  }
  Katalog.init(
    {
      nama: {
        type: DataTypes.STRING,
        allowNull: false,
      },
      idKat: {
        type: DataTypes.INTEGER,
        allowNull: false,
      },
      tahun: {
        type: DataTypes.INTEGER,
        allowNull: false,
      },
      harga: {
        type: DataTypes.INTEGER,
        allowNull: false,
      },
      kapasitasMesin: {
        type: DataTypes.INTEGER,
        allowNull: false,
      },
      jumlahKursi: {
        type: DataTypes.INTEGER,
        allowNull: false,
      },
      warna: {
        type: DataTypes.STRING,
        allowNull: false,
      },
      gambar: {
        type: DataTypes.STRING,
        allowNull: false,
      },
      bahanBakar: {
        type: DataTypes.ENUM("Bensin", "Diesel", "Hybrid", "Listrik"),
        allowNull: false,
      },

      transmisi: {
        type: DataTypes.ENUM("Automatic", "Manual"),
        allowNull: false,
      },
    },
    {
      sequelize,
      modelName: "Katalog",
    },
  );
  return Katalog;
};
