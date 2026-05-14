# 🚗 DriveEase Frontend

Aplikasi mobile berbasis Flutter untuk manajemen katalog kendaraan yang dibangun menggunakan pendekatan **Clean Architecture** serta **BLoC Pattern** untuk state management yang scalable, maintainable, dan terstruktur.

Aplikasi ini terintegrasi dengan Backend REST API berbasis Node.js dan mendukung autentikasi JWT, manajemen data kendaraan, serta upload gambar kendaraan.

---

# ✨ Features

* 🔐 Authentication menggunakan JWT
* 👤 Login & Register User
* 🚘 CRUD Data Kendaraan
* 🗂️ CRUD Kategori Kendaraan
* 🖼️ Upload Gambar dari Gallery Device
* 🎨 Modern UI dengan Glassmorphism Design
* ⚡ State Management menggunakan BLoC
* 🔄 Pull to Refresh & Custom Animation
* 📱 Responsive Mobile Layout

---

# 🛠️ Tech Stack

| Technology               | Description                     |
| ------------------------ | ------------------------------- |
| Flutter                  | Cross-platform mobile framework |
| Dart                     | Programming language            |
| flutter_bloc             | State Management                |
| equatable                | State comparison optimization   |
| http                     | REST API communication          |
| flutter_secure_storage   | Secure JWT Token storage        |
| image_picker             | Image upload from device        |
| intl                     | Currency & date formatting      |
| permission_handler       | Device permission management    |
| lottie                   | Animation support               |
| custom_refresh_indicator | Custom pull-to-refresh UI       |

---

# 📂 Project Structure

Project ini menggunakan pendekatan **Clean Architecture** untuk memisahkan setiap tanggung jawab aplikasi menjadi beberapa layer.

```text
lib/
├── core/                 # Global configuration, theme, constants, reusable widgets
│
├── data/                 # Data layer
│   ├── models/           # Data models
│   ├── datasource/       # API services
│   └── repositories/     # Repository implementation
│
├── logic/                # BLoC layer
│   ├── auth/
│   ├── katalog/
│   └── kategori/
│
├── ui/                   # Presentation layer
│   ├── pages/
│   ├── widgets/
│   └── screens/
│
└── main.dart             # Application entry point
```

---

# 🚀 Getting Started

## Prerequisites

Pastikan perangkat development sudah memiliki:

* Flutter SDK `3.10.8` atau lebih baru
* Android Studio / VS Code
* Emulator Android atau device fisik
* Backend API sudah berjalan

---

# ⚙️ Installation

## 1. Clone Repository

```bash
git clone https://github.com/username/repository-name.git
cd repository-name
```

---

## 2. Install Dependencies

```bash
flutter pub get
```

---

## 3. Configure API Endpoint

Sesuaikan `baseUrl` API pada file konfigurasi project.

Contoh:

```dart
const String baseUrl = "http://10.0.2.2:3000/api";
```

### Notes

* Gunakan `10.0.2.2` untuk Android Emulator
* Gunakan IP lokal komputer jika testing menggunakan physical device

---

## 4. Run Application

```bash
flutter run
```

---

# 🔐 Authentication Flow

Aplikasi menggunakan sistem autentikasi berbasis:

* JSON Web Token (JWT)
* Secure local token storage
* Protected API request
* Role-based access dari backend

---

# 📦 Main Modules

## Authentication

* Login
* Register
* JWT Session Handling

## Category Management

* Create Category
* Read Category
* Update Category
* Delete Category

## Vehicle Catalog

* Create Vehicle Data
* Read Vehicle Data
* Update Vehicle Data
* Delete Vehicle Data
* Upload Vehicle Image

---

# 🎨 UI & Design

Aplikasi mengimplementasikan konsep UI modern seperti:

* Glassmorphism Components
* Smooth Animation
* Clean Layout
* Reusable Custom Widgets
* Responsive Design

---

# 🔗 Backend Integration

Frontend ini terhubung dengan REST API backend berbasis:

* Node.js
* Express.js
* Sequelize ORM
* MySQL Database

---

# 👨‍💻 Author

**Lu'lu' Luthfiah**

---

# 📄 License

Project ini dibuat untuk UCP 2 PAML
