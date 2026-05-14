const app = require("./app");
const db = require("./models");
const PORT = process.env.PORT;

db.sequelize.sync({ alter: true })
  .then(() => {
    app.listen(PORT, () => {
      console.log(`Server nyala di http://localhost:${PORT}`);
    });
  })
  .catch(err => {
    console.error("Gagal konek DB:", err);
    process.exit(1);
  });