"use strict";
/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.createTable("Katalogs", {
      id: {
        allowNull: false,
        autoIncrement: true,
        primaryKey: true,
        type: Sequelize.INTEGER,
      },
      nama: {
        type: Sequelize.STRING,
        allowNull: false,
      },
      idKat: {
        type: Sequelize.INTEGER,
        allowNull: false,
        references: {
          model: 'kategoris',
          key: 'id'
        },
        onUpdate: 'CASCADE',
        onDelete: 'CASCADE'
      },
      tahun: {
        type: Sequelize.INTEGER,
        allowNull: false,
      },
      harga: {
        type: Sequelize.INTEGER,
        allowNull: false,
      },
      kapasitasMesin: {
        type: Sequelize.INTEGER,
        allowNull: false,
      },
      jumlahKursi: {
        type: Sequelize.INTEGER,
        allowNull: false,
      },
      warna: {
        type: Sequelize.STRING,
        allowNull: false,
      },
      gambar: {
        type: Sequelize.STRING,
        allowNull: false,
      },
      bahanBakar: {
        type: Sequelize.ENUM("Bensin", "Diesel", "Hybrid", "Listrik"),
        allowNull: false,
      },
      transmisi: {
        type: Sequelize.ENUM("Automatic", "Manual"),
        allowNull: false,
      },
      createdAt: {
        allowNull: false,
        type: Sequelize.DATE,
      },
      updatedAt: {
        allowNull: false,
        type: Sequelize.DATE,
      },
    });
  },
  async down(queryInterface, Sequelize) {
    await queryInterface.dropTable("Katalogs");
  },
};
