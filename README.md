# Terminal Math & Team Utility

Versi Flutter dari aplikasi tugas CLI sebelumnya. Aplikasi ini menyediakan login, menu utama, data kelompok, kalkulator, pengecekan ganjil/genap, dan penjumlahan digit.

## Akun aplikasi

Buat akun baru melalui tombol `Daftar`. Data akun disimpan di database lokal
dan tidak ada akun demo bawaan.

## Menjalankan aplikasi

Pastikan Flutter sudah terpasang, lalu jalankan:

```bash
flutter pub get
flutter run -d chrome --web-port 58245
```

## Penyimpanan database

Data akun dan jurnal disimpan di SQLite. Pada Chrome, SQLite menggunakan
IndexedDB browser sehingga data tetap ada setelah aplikasi di-terminate atau
browser di-refresh, selama aplikasi dibuka pada browser dan port yang sama.
Gunakan perintah `flutter run -d chrome --web-port 58245` setiap kali agar
database yang sama digunakan kembali. Mengganti port, menghapus data situs,
menggunakan mode incognito, atau memakai browser/perangkat lain akan membuat
database terlihat kosong karena penyimpanan Web terpisah berdasarkan origin.

Database runtime tidak disimpan ke GitHub. GitHub menyimpan kode, schema, dan
file konfigurasi aplikasi; setiap pengguna membuat database lokalnya sendiri.
Jika data perlu dibagikan antaranggota, gunakan database server/online atau
tambahkan fitur export-import, bukan meng-commit file database lokal.

## Fitur

1. Data kelompok berisi nama, NIM, dan tugas anggota.
2. Kalkulator operasi tambah, kurang, kali, dan bagi.
3. Pengecekan bilangan ganjil atau genap.
4. Penjumlahan setiap digit, misalnya `852` menjadi `8 + 5 + 2 = 15`.
5. Jurnal riset dengan CRUD dan penyimpanan database lokal.
6. Tombol logout untuk kembali ke halaman login.

Validasi input dan pembagian dengan nol ditangani oleh aplikasi.
