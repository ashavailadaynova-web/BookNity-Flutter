class BookModel {
  final String? id;
  final String title;
  final String author;
  final String image;
  final String price;
  final String category;
  final String description;
  final double rating;
  final String storeName;
  final bool isFavorite;
  final String year;
  final String isbn;
  final String condition;

  const BookModel({
    this.id,
    required this.title,
    required this.author,
    required this.image,
    required this.price,
    required this.category,
    required this.description,
    required this.rating,
    required this.storeName,
    this.year = '',
    this.isbn = '',
    this.condition = '',
    this.isFavorite = false,
  });

  BookModel copyWith({
    String? id,
    String? title,
    String? author,
    String? image,
    String? price,
    String? category,
    String? description,
    double? rating,
    String? storeName,
    bool? isFavorite,
    String? year,
    String? isbn,
    String? condition,
  }) {
    return BookModel(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      image: image ?? this.image,
      price: price ?? this.price,
      category: category ?? this.category,
      description: description ?? this.description,
      rating: rating ?? this.rating,
      storeName: storeName ?? this.storeName,
      isFavorite: isFavorite ?? this.isFavorite,
      year: year ?? this.year,
      isbn: isbn ?? this.isbn,
      condition: condition ?? this.condition,
    );
  }

  factory BookModel.fromMap(Map<String, dynamic> map, String documentId) {
    // 🟢 FUNGSI PENGAMANAN RATING (Sudah Bagus!)
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
      // Menyelaraskan nama field image/imageUrl agar fleksibel membaca data Firestore
      image: map['image'] ?? map['imageUrl'] ?? '',
      price: map['price']?.toString() ?? '',
      category: map['category'] ?? '',
      description: map['description'] ?? '',
      rating: parsedRating,
      storeName: map['storeName'] ?? '',
      isFavorite: map['isFavorite'] ?? false,
      year: map['year'] ?? '',
      isbn: map['isbn'] ?? '',
      condition: map['condition'] ?? '',
    );
  }

  // 🟢 REVISI UTAMA: Menambahkan field year, isbn, dan condition ke map data agar ikut terupload ke Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'author': author,
      'image': image,
      'price': price,
      'category': category,
      'description': description,
      'rating': rating,
      'storeName': storeName,
      'isFavorite': isFavorite,
      'year': year,
      'isbn': isbn,
      'condition': condition,
    };
  }
}
