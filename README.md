# BookNity - Platform E-Commerce Buku Bekas Kampung Ilmu Surabaya

BookNity adalah aplikasi *mobile e-commerce* berbasis digital yang dirancang khusus sebagai solusi konversi sistem penjualan konvensional buku bekas di Kampung Ilmu Surabaya. 
Aplikasi ini bertujuan untuk memperluas jangkauan pasar para pedagang lokal agar dapat menjangkau konsumen di seluruh Indonesia, 
mendukung perputaran buku bekas guna meningkatkan akses literasi dengan harga terjangkau, serta mendigitalisasi proses transaksi dan pencatatan riwayat pemesanan secara terintegrasi.

## 👥 Nama Kelompok Gunung Fuji

Aplikasi ini dikembangkan oleh Tim Mahasiswa Program Studi Sistem Informasi:

 **24082010050**  Daynova Ashavaila Ramadhani
 **24082010051**  Meineza Dilga Putri Nabela
 **24082010074**  Vina Dwi Maulita 
 **24082010081**  Rania Zahiyah Jasmine

## 🚀 Fitur-Fitur Utama Aplikasi

Aplikasi BookNity berfokus pada fungsionalitas inti perdagangan buku bekas dengan beberapa fitur utama sebagai berikut:

1. **Registrasi & Autentikasi Pengguna**: Sistem pendaftaran akun baru, masuk log (*login*), keluar sistem (*logout*), hingga fitur pengaturan ulang kata sandi melalui surel (*reset password*) secara aman.
2. **Pengelolaan Katalog Buku (CRUD Listing)**: Fitur khusus bagi pedagang untuk menambah (*create*), melihat (*read*), mengubah data (*update*), dan menghapus (*delete*) informasi buku bekas yang dijual.
3. **Pencarian & Filter Buku**: Memudahkan pembeli dalam menemukan buku spesifik berdasarkan judul, penulis, maupun kategori tertentu secara cepat.
4. **Fitur Wishlist (Favorit)**: Memungkinkan pengguna untuk menandai dan menyimpan buku-buku bekas favorit ke dalam daftar tunggu agar mudah diakses kembali di kemudian hari.
5. **Real-Time Chat Room**: Fitur percakapan interaktif langsung di dalam aplikasi yang menghubungkan pembeli dan pedagang secara *real-time* untuk negosiasi atau tanya jawab produk.
6. **Proses Pemesanan & Alur Transaksi**: Sistem pencatatan pesanan terintegrasi yang mendokumentasikan setiap alur transaksi, peminjaman, atau pembelian buku bekas secara digital.
7. **Manajemen Profil & Alamat**: Fitur bagi pengguna untuk mengelola informasi pribadi, foto profil, serta detail alamat pengiriman guna mendukung akurasi distribusi fisik buku.


## 🛠️ Tech Stack (Teknologi yang Digunakan)

Aplikasi ini dibangun menggunakan kombinasi teknologi modern berbasis *cloud* dan pola arsitektur yang terstruktur:

*   **Frontend & Mobile Framework**: 
    *   **Flutter (Dart)**: Framework *cross-platform* yang digunakan untuk membangun antarmuka pengguna (UI/UX) aplikasi secara responsif dan efisien.
*   **Arsitektur & State Management**:
    *   **MVVM (Model-View-ViewModel)**: Pola arsitektur yang diterapkan secara ketat untuk memisahkan logika bisnis dari lapisan antarmuka.
    *   **Provider**: Sebagai komponen *state management* untuk mengatur aliran data dan memperbarui tampilan UI secara reaktif via `notifyListeners()`.
*   **Backend-as-a-Service (BaaS) - Firebase**:
    *   **Firebase Authentication**: Digunakan untuk mengelola keamanan autentikasi akun pengguna.
    *   **Cloud Firestore**: Basis data NoSQL untuk menyimpan data teks terstruktur secara *real-time* (data pengguna, katalog buku, pesan *chat*, alamat, dan transaksi).
*   **Media Storage & Cloud Management**:
    *   **Cloudinary API**: Layanan pihak ketiga yang diintegrasikan melalui HTTP Multipart Request untuk mengunggah, mengoptimasi, dan menyimpan berkas gambar (foto profil dan sampul buku) dalam bentuk URL HTTPS.


## 📱 Metode Pengujian (Testing)

Pengembangan aplikasi ini melalui tahap uji coba fungsional menggunakan metode **Manual Testing** melalui mekanisme **Physical Device Debugging**. Kode program dijalankan secara langsung (*flutter run*) pada perangkat keras fisik Android dengan memanfaatkan koneksi kabel data USB guna memastikan performa aplikasi berjalan dengan lancar, responsif, dan bebas dari kendala (*bug*) pada lingkungan seluler yang sebenarnya.
