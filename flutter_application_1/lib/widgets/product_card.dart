import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductCard extends StatelessWidget {
  final String imageUrl;
  final String bookTitle;
  final String author;
  final String price;
  final String rating;
  final bool isSoldOut;
  final VoidCallback onEditPressed; // Aksi ketika tombol edit ditekan

  const ProductCard({
    super.key,
    required this.imageUrl,
    required this.bookTitle,
    required this.author,
    required this.price,
    required this.rating,
    this.isSoldOut = false,
    required this.onEditPressed,
  });

  @override
  Widget build(BuildContext context) {
    const primaryTextColor = Color(0xFF3E2723);
    const buttonColor = Color(0xFFB13D14);

    return Container(
      width: 200,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Cover Buku
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Opacity(
                  opacity: isSoldOut ? 0.4 : 1.0,
                  child: Image.network(
                    imageUrl,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 200,
                        color: Colors.grey[100],
                        child: const Icon(Icons.book_rounded, color: Colors.grey),
                      );
                    },
                  ),
                ),
              ),
              if (isSoldOut)
                Positioned.fill(
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: buttonColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        "TERJUAL",
                        style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),

          // Judul Buku
          Text(
            bookTitle,
            style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.bold, color: primaryTextColor),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          
          // Nama Penulis
          Text(
            "oleh $author",
            style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[500], fontWeight: FontWeight.w500),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),

          // Harga
          Text(
            price,
            style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: primaryTextColor),
          ),
          const SizedBox(height: 10),

          // Seller info & Rating
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: NetworkImage('https://i.imgur.com/8QjU0rU.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    "DynvaShv",
                    style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey[600], fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.star_rounded, color: Colors.amber, size: 16),
                  const SizedBox(width: 2),
                  Text(
                    rating,
                    style: GoogleFonts.poppins(fontSize: 11, color: Colors.grey[500], fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Tombol Edit
          SizedBox(
            width: double.infinity,
            height: 38,
            child: ElevatedButton(
              onPressed: onEditPressed, // Memanggil fungsi dari luar secara dinamis
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonColor,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              child: Text(
                "Edit",
                style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}