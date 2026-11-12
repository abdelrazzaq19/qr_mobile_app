# qr_app

A new Flutter project.
---

## 📖 Tentang Project

**QR Scanner Pro (EventPass)** membantu proses pendaftaran dan kehadiran peserta
pada sebuah event. Pengguna dapat melihat daftar event, memesan tiket, lalu
menggunakan QR code sebagai bukti check-in saat hadir. Data akun dan event
disimpan di Firebase sehingga tersinkronisasi secara real-time.

### Tujuan
- Mempercepat proses check-in peserta
- Mengurangi kesalahan pencatatan kehadiran manual
- Memudahkan pengelolaan kuota tiket event

---

## ✨ Fitur Utama

### 🔐 Autentikasi (Firebase Authentication)
- Login dengan email dan password
- Register akun baru

### 🏠 Beranda
- Tombol **Tap to Scan** untuk membuka kamera dan memindai QR code
- Daftar event berlabel **LIVE** dari Cloud Firestore
- Info tiap event: nama, deskripsi, status (**Active**), tanggal, jumlah peserta,
  kuota, dan progress bar kapasitas
- Tombol **Reserve Ticket** untuk memesan tiket

### 📷 Scan QR
- Memindai QR code peserta lewat kamera
- Validasi tiket dengan mencocokkan data di Firestore

### 🧭 Navigasi
- Bottom navigation: **Home**, **Events**, **Profile**

---

## 🔄 Alur Penggunaan

1. Pengguna membuka aplikasi (splash screen)
2. Login, atau register jika belum punya akun
3. Di beranda, pengguna melihat daftar event
4. Pengguna menekan **Reserve Ticket** untuk memesan tiket
5. Saat hari event, panitia menekan **Tap to Scan** dan memindai QR peserta
6. Sistem memvalidasi tiket dan mencatat kehadiran

---

## 📸 Tampilan Aplikasi

| <img width="1280" height="2856" alt="Screenshot_1776773492" src="https://github.com/user-attachments/assets/40a04dc2-8bf9-4a24-b95f-1e379c345b27" />
| <img width="1280" height="2856" alt="Screenshot_1776773501" src="https://github.com/user-attachments/assets/b63c3903-e3c4-42fb-8cb9-6854dd2909a9" />
 | <img width="1280" height="2856" alt="Screenshot_1776773528" src="https://github.com/user-attachments/assets/92e153d9-038f-46a2-838a-1317bd66c919" /> |

---

## 🛠️ Tech Stack

| Kategori | Teknologi |
|----------|-----------|
| Frontend | Flutter (Dart) |
| Backend | Firebase |
| Autentikasi | Firebase Authentication |
| Database | Cloud Firestore |
| Scan QR | (isi package yang kamu pakai, misalnya `mobile_scanner`) |
| State Management | (isi jika ada, misalnya Provider / Bloc / GetX) |

---

## 📋 Prasyarat

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (cek versi dengan `flutter --version`)
- Android Studio atau VS Code
- Emulator Android atau perangkat fisik
- Akun Google untuk Firebase Console
- Git dan Node.js (dibutuhkan untuk Firebase CLI)

---

## 🚀 Instalasi dan Cara Menjalankan

```bash
# 1. Clone repository
git clone https://github.com/USERNAME/NAMA-REPO.git
cd NAMA-REPO

# 2. Install dependency
flutter pub get

# 3. Jalankan aplikasi
flutter run
```

### 🔥 Konfigurasi Firebase

1. Buka [Firebase Console](https://console.firebase.google.com) lalu buat project baru
2. Aktifkan **Authentication** (metode Email/Password)
3. Buat database **Cloud Firestore**
4. Install Firebase CLI dan FlutterFire CLI:
   ```bash
   npm install -g firebase-tools
   dart pub global activate flutterfire_cli
   ```
5. Login dan hubungkan project:
   ```bash
   firebase login
   flutterfire configure
   ```
   Perintah ini membuat file `lib/firebase_options.dart` secara otomatis.
6. Jalankan ulang aplikasi dengan `flutter run`

> ⚠️ File konfigurasi seperti `google-services.json` dan `firebase_options.dart`
> berisi identitas project Firebase milikmu. Sebaiknya jangan dibagikan di
> repo publik. Pastikan Firestore Rules sudah dibatasi (jangan biarkan mode test
> terbuka untuk semua orang).

---

## 📂 Struktur Folder

```
NAMA-REPO/
├── android/
├── images/              # Screenshot dan banner untuk README
├── lib/
│   ├── main.dart
│   ├── firebase_options.dart
│   ├── screens/         # splash, login, register, home, events, profile
│   ├── widgets/         # komponen UI yang dipakai ulang
│   ├── models/          # model data (event, user, tiket)
│   └── services/        # auth_service, firestore_service
├── pubspec.yaml
└── README.md
```
(Sesuaikan dengan struktur folder asli projectmu.)

---

## 🗄️ Struktur Data Firestore

Contoh koleksi yang dipakai (sesuaikan dengan milikmu):

| Koleksi | Field |
|---------|-------|
| `users` | `uid`, `email`, `createdAt` |
| `events` | `title`, `description`, `date`, `capacity`, `registered`, `status` |
| `tickets` | `eventId`, `userId`, `qrCode`, `checkedIn` |

---

## 🗺️ Rencana Pengembangan

- [x] Splash, login, dan register
- [x] Tampilan daftar event
- [x] Scan QR dan validasi tiket
- [x] Riwayat check-in
- [ ] Mode offline
- [x] Notifikasi

---

## ❗ Troubleshooting

| Masalah | Solusi |
|---------|--------|
| Kamera tidak terbuka | Cek izin kamera di `AndroidManifest.xml` dan di pengaturan HP |
| `No Firebase App '[DEFAULT]'` | Pastikan `Firebase.initializeApp()` dipanggil di `main()` setelah `WidgetsFlutterBinding.ensureInitialized()` |
| Build Android gagal | Jalankan `flutter clean` lalu `flutter pub get` |
| Login gagal | Pastikan metode Email/Password sudah diaktifkan di Firebase Console |

---

## 👤 Author

**M.Ziad Abdel Razzaq**
- GitHub: 


##Hasil 
<img width="1920" height="1080" alt="qr scanner app" src="https://github.com/user-attachments/assets/6b074266-74f1-4cb1-a610-841b91596ea9" />
