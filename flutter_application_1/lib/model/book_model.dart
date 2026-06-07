class BookModel {
  final String? id;
  final String title;
  final String author;
  final String image;
  final String price;
  final String category;
  final String description;
  // 🟢 Tambahan properti baru untuk Deskripsi Fisik Buku
  final String physicalDescription;
  final double rating;
  final String storeName;
  final bool isFavorite;
  final String year;
  final String isbn;
  final String condition;

  final int stock; // Untuk menampilkan Stok Lapak
  final int likes; // Untuk menampilkan jumlah Orang yang menyukai
  final String sellerId; // Id Unik penjual untuk fungsi Chat / Lihat Toko
  final String sellerCity; // Lokasi kota penjual (misal: Surabaya)
  final String sellerAvatar; // Foto profil toko penjual
  final String? physicalDetail; // Data Detail Fisik opsional dari database
  final List<dynamic>? reviews; // Data Review pembeli opsional dari database

  const BookModel({
    this.id,
    required this.title,
    required this.author,
    required this.image,
    required this.price,
    required this.category,
    required this.description,
    // 🟢 Diwajibkan diisi (atau set default nilai kosong jika opsional di form)
    this.physicalDescription = '',
    required this.rating,
    required this.storeName,
    this.year = '',
    this.isbn = '',
    this.condition = '',
    this.isFavorite = false,
    this.stock = 1,
    this.likes = 0,
    this.sellerId = '',
    this.sellerCity = 'Indonesia',
    this.sellerAvatar = '',
    this.physicalDetail,
    this.reviews,
  });

  BookModel copyWith({
    String? id,
    String? title,
    String? author,
    String? image,
    String? price,
    String? category,
    String? description,
    String? physicalDescription, // 🟢 Ditambahkan ke fungsi copyWith
    double? rating,
    String? storeName,
    bool? isFavorite,
    String? year,
    String? isbn,
    String? condition,
    int? stock,
    int? likes,
    String? sellerId,
    String? sellerCity,
    String? sellerAvatar,
    String? physicalDetail,
    List<dynamic>? reviews,
  }) {
    return BookModel(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      image: image ?? this.image,
      price: price ?? this.price,
      category: category ?? this.category,
      description: description ?? this.description,
      physicalDescription:
          physicalDescription ??
          this.physicalDescription, // 🟢 Sinkronisasi copyWith
      rating: rating ?? this.rating,
      storeName: storeName ?? this.storeName,
      isFavorite: isFavorite ?? this.isFavorite,
      year: year ?? this.year,
      isbn: isbn ?? this.isbn,
      condition: condition ?? this.condition,
      stock: stock ?? this.stock,
      likes: likes ?? this.likes,
      sellerId: sellerId ?? this.sellerId,
      sellerCity: sellerCity ?? this.sellerCity,
      sellerAvatar: sellerAvatar ?? this.sellerAvatar,
      physicalDetail: physicalDetail ?? this.physicalDetail,
      reviews: reviews ?? this.reviews,
    );
  }

  factory BookModel.fromMap(Map<String, dynamic> map, String documentId) {
    // Fungsi pengamanan rating dari Firestore
    double parsedRating = 0.0;
    if (map['rating'] is num) {
      parsedRating = (map['rating'] as num).toDouble();
    } else if (map['rating'] != null && map['rating'].toString().isNotEmpty) {
      parsedRating = double.tryParse(map['rating'].toString()) ?? 0.0;
    }

    return BookModel(
      id: documentId,
      title: map['title'] ?? '',
      author: map['author'] ?? '',
      image: map['image'] ?? map['imageUrl'] ?? '',
      price: map['price']?.toString() ?? '',
      category: map['category'] ?? '',
      description: map['description'] ?? '',
      physicalDescription:
          map['physicalDescription'] ??
          '', // 🟢 Mengambil data fisik dari Firestore Map
      rating: parsedRating,
      storeName: map['storeName'] ?? '',
      isFavorite: map['isFavorite'] ?? false,
      year: map['year'] ?? '',
      isbn: map['isbn'] ?? '',
      condition: map['condition'] ?? '',
      stock: map['stock'] ?? 1,
      likes: map['likes'] ?? 0,
      sellerId: map['sellerId'] ?? '',
      sellerCity: map['sellerCity'] ?? 'Indonesia',
      sellerAvatar: map['sellerAvatar'] ?? '',
      physicalDetail: map['physicalDetail'],
      reviews: map['reviews'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'author': author,
      'image': image,
      'price': price,
      'category': category,
      'description': description,
      'physicalDescription':
          physicalDescription, // 🟢 Mengubah data fisik menjadi Map sebelum di-upload ke Firestore
      'rating': rating,
      'storeName': storeName,
      'isFavorite': isFavorite,
      'year': year,
      'isbn': isbn,
      'condition': condition,
      'stock': stock,
      'likes': likes,
      'sellerId': sellerId,
      'sellerCity': sellerCity,
      'sellerAvatar': sellerAvatar,
      'physicalDetail': physicalDetail,
      'reviews': reviews,
    };
  }
}
