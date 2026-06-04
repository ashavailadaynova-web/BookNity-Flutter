class BookModel {
  final int id;
  final String title;
  final String author;
  final String image;
  final String price;
  final String category;
  final String description;
  final double rating;
  final String storeName;
  final bool isFavorite;

  const BookModel({
    required this.id,
    required this.title,
    required this.author,
    required this.image,
    required this.price,
    required this.category,
    required this.description,
    required this.rating,
    required this.storeName,
    this.isFavorite = false,
  });

  BookModel copyWith({
    int? id,
    String? title,
    String? author,
    String? image,
    String? price,
    String? category,
    String? description,
    double? rating,
    String? storeName,
    bool? isFavorite,
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
    );
  }
}