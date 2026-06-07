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
  final String sellerId;
  final bool isSold;

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
    this.year = '',
    this.isbn = '',
    this.condition = '',
    this.isFavorite = false,
    this.isSold = false,
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
    String? sellerId,
    bool? isSold,
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
      sellerId: sellerId ?? this.sellerId,
      isSold: isSold ?? this.isSold,
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
        map['rating']
            .toString()
            .isNotEmpty) {
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
      'year': year,
      'isbn': isbn,
      'condition': condition,
      'isSold': isSold,
    };
  }
}