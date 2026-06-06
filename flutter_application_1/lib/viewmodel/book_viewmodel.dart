import 'dart:io';

import 'package:flutter/material.dart';

import '../model/book_model.dart';
import '../services/book_service.dart';

class BookViewModel extends ChangeNotifier {
final BookService _service = BookService();

bool _isLoading = false;

bool get isLoading => _isLoading;

Stream<List<BookModel>> get booksStream =>
_service.getBooks();

List<BookModel> _books = [];

List<BookModel> getAllBooks() {
  return _books;
}

List<BookModel> searchBooks(String keyword) {
  return _books.where((book) {
    return book.title
            .toLowerCase()
            .contains(keyword.toLowerCase()) ||
        book.author
            .toLowerCase()
            .contains(keyword.toLowerCase());
  }).toList();
}

List<BookModel> getBooksByCategory(
  String category,
) {
  if (category == 'SEMUA') {
    return _books;
  }

  return _books.where((book) {
    return book.category.toLowerCase() ==
        category.toLowerCase();
  }).toList();
}

List<BookModel> filterBooks({
  String? category,
  double? minRating,
}) {
  List<BookModel> result = _books;

  if (category != null &&
      category.isNotEmpty &&
      category != 'SEMUA') {
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

Future<String> uploadImage(
File imageFile,
) async {
return await _service.uploadImage(
imageFile,
);
}

Future<void> addBook(
BookModel book,
) async {
_isLoading = true;
notifyListeners();

try {
  await _service.addBook(book);
} finally {
  _isLoading = false;
  notifyListeners();
}

}

Future<void> updateBook(
BookModel book,
) async {
await _service.updateBook(book);
}

Future<void> deleteBook(
String id,
) async {
await _service.deleteBook(id);
}

Future<BookModel?> getBookById(
String id,
) async {
return await _service.getBookById(id);
}
}
