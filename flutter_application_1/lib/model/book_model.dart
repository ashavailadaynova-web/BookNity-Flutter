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
  final String sellerId;
  final bool isFavorite;
  final bool isSold;
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
    required this.sellerId,
    this.isFavorite = false,
    this.isSold = false,
    this.year = '',
    this.isbn = '',
    this.condition = '',
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
    String? sellerId,
    bool? isFavorite,
    bool? isSold,
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
      sellerId: sellerId ?? this.sellerId,
      isFavorite: isFavorite ?? this.isFavorite,
      isSold: isSold ?? this.isSold,
      year: year ?? this.year,
      isbn: isbn ?? this.isbn,
      condition: condition ?? this.condition,
    );
  }

  factory BookModel.fromMap(
    Map<String, dynamic> map,
    String documentId,
  ) {
    double parsedRating = 0.0;

    if (map['rating'] is num) {
      parsedRating =
          (map['rating'] as num).toDouble();
    } else if (map['rating'] != null &&
        map['rating'].toString().isNotEmpty) {
      parsedRating =
          double.tryParse(
                map['rating'].toString(),
              ) ??
              0.0;
    }

    return BookModel(
      id: documentId,
      title: map['title'] ?? '',
      author: map['author'] ?? '',
      image:
          map['image'] ??
          map['imageUrl'] ??
          '',
      price:
          map['price']?.toString() ?? '',
      category:
          map['category'] ?? '',
      description:
          map['description'] ?? '',
      rating: parsedRating,
      storeName:
          map['storeName'] ?? '',
      sellerId:
          map['sellerId'] ?? '',
      isFavorite:
          map['isFavorite'] ?? false,
      isSold:
          map['isSold'] ?? false,
      year:
          map['year'] ?? '',
      isbn:
          map['isbn'] ?? '',
      condition:
          map['condition'] ?? '',
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
      'rating': rating,
      'storeName': storeName,
      'sellerId': sellerId,
      'isFavorite': isFavorite,
      'isSold': isSold,
      'year': year,
      'isbn': isbn,
      'condition': condition,
    };
  }
}