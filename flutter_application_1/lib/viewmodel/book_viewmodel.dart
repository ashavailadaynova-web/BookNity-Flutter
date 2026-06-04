import '../model/book_model.dart';

class BookViewModel {
  final List<BookModel> _books = [
    BookModel(
      id: 1,
      title: "Laut Bercerita",
      author: "Leila S. Chudori",
      image: "assets/laut_bercerita.png",
      price: "Rp. 60.000",
      category: "Fiksi",
      description:
          "Novel sejarah Indonesia yang menceritakan perjuangan aktivis pada masa Orde Baru.",
      rating: 4.7,
      storeName: "Toko Buku Aceng",
    ),

    BookModel(
      id: 2,
      title: "Cantik Itu Luka",
      author: "Eka Kurniawan",
      image: "assets/cantik_itu_luka.png",
      price: "Rp. 58.000",
      category: "Fiksi",
      description:
          "Novel sastra Indonesia karya Eka Kurniawan.",
      rating: 4.8,
      storeName: "Buku Bekas Ayu",
    ),

    BookModel(
      id: 3,
      title: "Coding Untuk PAUD",
      author: "Ria Hayyu",
      image: "assets/coding_paud.png",
      price: "Rp. 29.900",
      category: "Sekolah",
      description:
          "Belajar coding dasar untuk anak usia dini.",
      rating: 4.7,
      storeName: "Toko Buku Aceng",
    ),

    BookModel(
      id: 4,
      title: "Project Hail Mary",
      author: "Andy Weir",
      image: "assets/hail_mary.png",
      price: "Rp. 58.000",
      category: "Fiksi",
      description:
          "Novel science fiction karya Andy Weir.",
      rating: 4.7,
      storeName: "Rumahnya Buku",
    ),

    BookModel(
      id: 5,
      title: "The Midnight Library",
      author: "Matt Haig",
      image: "assets/midnight_library.png",
      price: "Rp. 76.000",
      category: "Self Help",
      description:
          "Novel refleksi kehidupan dan pilihan hidup.",
      rating: 4.7,
      storeName: "Serba Ada",
    ),

    BookModel(
      id: 6,
      title: "Hukum Perdata Internasional",
      author: "Dr. Ronald Saija",
      image: "assets/hukum_perdata.png",
      price: "Rp. 58.000",
      category: "Sekolah",
      description:
          "Buku hukum perdata internasional.",
      rating: 4.5,
      storeName: "Buku Surabaya",
    ),
  ];

  List<BookModel> get books => _books;

  List<BookModel> getAllBooks() {
    return _books;
  }

  List<BookModel> searchBooks(String keyword) {
  print("Keyword: $keyword");
  final result = _books.where((book) {
    return book.title
            .toLowerCase()
            .contains(
              keyword.toLowerCase(),
            ) ||

        book.author
            .toLowerCase()
            .contains(
              keyword.toLowerCase(),
            );
  }).toList();
  print("Jumlah ditemukan: ${result.length}");
  return result;
}

  List<BookModel> getBooksByCategory(
    String category,
  ) {
    if (category == "SEMUA") {
      return _books;
    }

    return _books.where((book) {
      return book.category.toLowerCase() ==
          category.toLowerCase();
    }).toList();
  }

  void addBook(BookModel book) {
    _books.add(book);
  }

  void deleteBook(int id) {
    _books.removeWhere(
      (book) => book.id == id,
    );
  }

  void toggleFavorite(int id) {
    final index = _books.indexWhere(
      (book) => book.id == id,
    );

    if (index != -1) {
      _books[index] = _books[index].copyWith(
        isFavorite: !_books[index].isFavorite,
      );
    }
  }

  BookModel? getBookById(int id) {
    try {
      return _books.firstWhere(
        (book) => book.id == id,
      );
    } catch (_) {
      return null;
    }
  }
  List<BookModel> filterBooks({
  String? category,
  double? minRating,
}) {

  List<BookModel> result = _books;

  if (category != null &&
      category.isNotEmpty &&
      category != "SEMUA") {

    result = result.where((book) {
      return book.category.toLowerCase() ==
          category.toLowerCase();
    }).toList();
  }

  if (minRating != null) {
    result = result.where((book) {
      return book.rating >= minRating;
    }).toList();
  }

  return result;
}

List<BookModel> getPopularBooks() {
  List<BookModel> sortedBooks =
      List.from(_books);

  sortedBooks.sort(
    (a, b) => b.rating.compareTo(a.rating),
  );

  return sortedBooks;
}

List<BookModel> getRecommendedBooks() {
  return _books.take(4).toList();
}

List<BookModel> getWishlistBooks() {
  return _books.where(
    (book) => book.isFavorite,
  ).toList();
}

}

