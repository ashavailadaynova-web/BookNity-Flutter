import 'package:flutter/material.dart';

class BuyerProductCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String author;
  final String price;
  final String rating;
  final String storeName;
  final bool isFavorite;
  final bool isSellerSide; // 👈 Menentukan apakah ini versi penjual (bisa edit/hapus)
  final VoidCallback onTap;
  final VoidCallback onFavoriteTap;
  final VoidCallback? onEditTap;   // Aksi khusus penjual
  final VoidCallback? onDeleteTap; // Aksi khusus penjual

  const BuyerProductCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.author,
    required this.price,
    required this.rating,
    required this.storeName,
    this.isFavorite = false,
    this.isSellerSide = false, // Default: versi pembeli biasa
    required this.onTap,
    required this.onFavoriteTap,
    this.onEditTap,
    this.onDeleteTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        // Menghapus hardcode width agar mengikuti ruang Grid 2 kolom secara otomatis
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(8), // Padding dalam kontainer kartu
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Jaga isi atas & bawah seimbang
          children: [
            // --- BAGIAN ATAS: GAMBAR BUKU & FAVORITE ---
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    AspectRatio(
                      aspectRatio: 3 / 4, // Rasio cover buku seragam
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: imageUrl.startsWith('http')
                              ? Image.network(imageUrl, fit: BoxFit.cover)
                              : Image.asset(
                                  imageUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: Colors.grey.shade300,
                                      alignment: Alignment.center,
                                      child: const Icon(Icons.book, color: Colors.grey, size: 40),
                                    );
                                  },
                                ),
                        ),
                      ),
                    ),
                    // Hanya munculkan tombol favorit jika bukan di halaman manajemen penjual
                    if (!isSellerSide)
                      Positioned(
                        top: 6,
                        right: 6,
                        child: GestureDetector(
                          onTap: onFavoriteTap,
                          child: CircleAvatar(
                            radius: 13,
                            backgroundColor: Colors.white.withOpacity(0.9),
                            child: Icon(
                              isFavorite ? Icons.favorite : Icons.favorite_border,
                              color: isFavorite ? Colors.red : Colors.grey,
                              size: 15,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 1),
                Text(
                  'oleh $author',
                  style: const TextStyle(color: Colors.grey, fontSize: 11),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            
            // --- BAGIAN BAWAH: HARGA & INFO TOKO / STRUKTUR AKSI ---
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  price,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFA23914),
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                // Kondisi: Jika halaman penjual, ganti info toko jadi tombol kelola
                isSellerSide
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: onEditTap,
                            child: const Icon(Icons.edit_note_rounded, size: 18, color: Colors.orange),
                          ),
                          const SizedBox(width: 10),
                          GestureDetector(
                            onTap: onDeleteTap,
                            child: const Icon(Icons.delete_outline_rounded, size: 18, color: Colors.red),
                          ),
                        ],
                      )
                    : Row(
                        children: [
                          const Icon(Icons.store, size: 11, color: Colors.grey),
                          const SizedBox(width: 3),
                          Expanded(
                            child: Text(
                              storeName,
                              style: const TextStyle(color: Colors.grey, fontSize: 10),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const Icon(Icons.star_rounded, size: 12, color: Colors.amber),
                          const SizedBox(width: 1),
                          Text(
                            rating,
                            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}