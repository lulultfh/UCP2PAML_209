# 🚗 DriveEase Backend API

Backend API untuk aplikasi manajemen katalog kendaraan dan kategori menggunakan **Node.js**, **Express.js**, dan **Sequelize ORM**.
Project ini menyediakan sistem autentikasi berbasis JWT, manajemen katalog kendaraan, upload gambar, serta role-based access control antara admin dan user.

---

# 📌 Features

* 🔐 Authentication & Authorization (JWT)
* 👤 Role-Based Access Control (Admin/User)
* 🚘 CRUD Katalog Kendaraan
* 🗂️ CRUD Kategori Kendaraan
* 🖼️ Upload Gambar Kendaraan
* 🛡️ Middleware Authentication & Permission
* 🗄️ Database Migration & Seeder menggunakan Sequelize

---

# 🛠️ Tech Stack

| Technology    | Description                  |
| ------------- | ---------------------------- |
| Node.js       | JavaScript Runtime           |
| Express.js    | Backend Web Framework        |
| Sequelize ORM | ORM untuk database SQL       |
| MySQL2        | Driver MySQL untuk Node.js   |
| JWT           | Authentication Token         |
| BcryptJS      | Password Hashing             |
| Multer        | File Upload Handler          |
| Dotenv        | Environment Variable Manager |
| Nodemon       | Development Server           |

---

# 📁 Project Structure

```text
BE_FIKS/
├── config/                 # Konfigurasi database Sequelize
│
├── controllers/            # Business logic aplikasi
│   ├── authController.js
│   ├── katalogController.js
│   └── kategoriController.js
│
├── middleware/             # Middleware aplikasi
│   ├── auth.js             # Verifikasi JWT Token
│   ├── permission.js       # Validasi role user
│   └── upload.js           # Konfigurasi Multer
│
├── migrations/             # Sequelize migration files
│
├── models/                 # Definisi model database
│   ├── index.js
│   ├── katalog.js
│   ├── kategori.js
│   └── user.js
│
├── routes/                 # Routing endpoint API
│   ├── authRoutes.js
│   ├── katalogRoutes.js
│   └── kategoriRoutes.js
│
├── seeders/                # Seeder data awal
│
├── uploads/                # Penyimpanan file upload
│
├── .env                    # Environment variables
├── .sequelizerc            # Konfigurasi Sequelize CLI
├── app.js                  # Setup Express app
├── server.js               # Entry point server
└── package.json            # Dependency & scripts
```

---

# ⚙️ Installation

## 1. Clone Repository

```bash
git clone <repository-url>
```

## 2. Install Dependencies

```bash
npm install
```

---

# 🔧 Environment Configuration

Buat file `.env` pada root project lalu isi konfigurasi berikut:

```env
PORT=3000

DB_USERNAME=usernamedbkamu
DB_PASSWORD=passworddbkamu
DB_NAME=namadbkamu
DB_PORT=portdbkamu

JWT_SECRET=your_secret_key
```

---

# 🗄️ Database Setup

Jalankan perintah berikut untuk membuat database, migration, dan seeder:

```bash
npx sequelize-cli db:create
npx sequelize-cli db:migrate
npx sequelize-cli db:seed:all
```

---

# ▶️ Running the Server

Menjalankan server dalam mode development:

```bash
npm start
```

Server akan berjalan pada:

```text
http://localhost:3000
```

---

# 🔐 Authentication

Project ini menggunakan:

* **JSON Web Token (JWT)** untuk autentikasi
* **BcryptJS** untuk hashing password
* Middleware authentication untuk proteksi endpoint tertentu

---

# 📦 API Modules

## Auth

* Register User
* Login User
* JWT Authentication

## Kategori

* Create Kategori
* Read Kategori
* Update Kategori
* Delete Kategori

## Katalog

* Create Data Kendaraan
* Read Data Kendaraan
* Update Data Kendaraan
* Delete Data Kendaraan
* Upload Gambar Kendaraan

---

# 📂 File Upload

Upload gambar kendaraan disimpan pada folder:

```text
/uploads
```

Middleware upload menggunakan **Multer** dengan penyimpanan lokal.

---

# 👥 Role Access

| Role  | Permission       |
| ----- | ---------------- |
| Admin | Full Access CRUD |
| User  | Read Only        |

---

# 📄 Scripts

| Command   | Description                       |
| --------- | --------------------------------- |
| npm start | Menjalankan server dengan nodemon |
| npm test  | Menjalankan testing               |

---

# ✨ Author

**Lu'lu' Luthfiah**

---

# 📜 License

Project ini dibuat untuk UCP 2 PAML
