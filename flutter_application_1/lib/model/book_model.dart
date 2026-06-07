class BookModel {
  final String? id;
  final String title;
  final String author;
  final String image;
  final String price;
  final String category;
  final String description;
  final String physicalDescription;
  final double rating;
  final String storeName;
  final String sellerId;
  final bool isFavorite;
  final bool isSold;
  final String year;
  final String isbn;
  final String condition;

  // 🟢 Properti tambahan yang dicari oleh product_detail_screen.dart
  final int likes;
  final int stock;
  final String sellerAvatar;
  final String sellerCity;

  const BookModel({
    this.id,
    required this.title,
    required this.author,
    required this.image,
    required this.price,
    required this.category,
    required this.description,
    this.physicalDescription = '',
    required this.rating,
    required this.storeName,
    required this.sellerId,
    this.isFavorite = false,
    this.isSold = false,
    this.year = '',
    this.isbn = '',
    this.condition = '',
    // 🟢 Default value baru agar aman jika data di database kosong
    this.likes = 0,
    this.stock = 1,
    this.sellerAvatar = '',
    this.sellerCity = '',
  });

  // 🟢 Getter tambahan agar widget.book.physicalDetail tidak eror
  String get physicalDetail => physicalDescription;

  BookModel copyWith({
    String? id,
    String? title,
    String? author,
    String? image,
    String? price,
    String? category,
    String? description,
    String? physicalDescription,
    double? rating,
    String? storeName,
    String? sellerId,
    bool? isFavorite,
    bool? isSold,
    String? year,
    String? isbn,
    String? condition,
    int? likes,
    int? stock,
    String? sellerAvatar,
    String? sellerCity,
  }) {
    return BookModel(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      image: image ?? this.image,
      price: price ?? this.price,
      category: category ?? this.category,
      description: description ?? this.description,
      physicalDescription: physicalDescription ?? this.physicalDescription,
      rating: rating ?? this.rating,
      storeName: storeName ?? this.storeName,
      sellerId: sellerId ?? this.sellerId,
      isFavorite: isFavorite ?? this.isFavorite,
      isSold: isSold ?? this.isSold,
      year: year ?? this.year,
      isbn: isbn ?? this.isbn,
      condition: condition ?? this.condition,
      likes: likes ?? this.likes,
      stock: stock ?? this.stock,
      sellerAvatar: sellerAvatar ?? this.sellerAvatar,
      sellerCity: sellerCity ?? this.sellerCity,
    );
  }

  factory BookModel.fromMap(Map<String, dynamic> map, String documentId) {
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
          map['physicalDescription'] ?? map['physicalDetail'] ?? '',
      rating: parsedRating,
      storeName: map['storeName'] ?? '',
      sellerId: map['sellerId'] ?? '',
      isFavorite: map['isFavorite'] ?? false,
      isSold: map['isSold'] ?? false,
      year: map['year'] ?? '',
      isbn: map['isbn'] ?? '',
      condition: map['condition'] ?? '',
      likes: map['likes'] ?? 0,
      stock: map['stock'] ?? 1,
      sellerAvatar: map['sellerAvatar'] ?? map['avatarSeller'] ?? '',
      sellerCity: map['sellerCity'] ?? '',
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
      'physicalDescription': physicalDescription,
      'rating': rating,
      'storeName': storeName,
      'sellerId': sellerId,
      'isFavorite': isFavorite,
      'isSold': isSold,
      'year': year,
      'isbn': isbn,
      'condition': condition,
      'likes': likes,
      'stock': stock,
      'sellerAvatar': sellerAvatar,
      'sellerCity': sellerCity,
    };
  }
}
