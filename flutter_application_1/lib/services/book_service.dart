import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../model/book_model.dart';

class BookService {
final FirebaseFirestore _firestore =
FirebaseFirestore.instance;

final FirebaseStorage _storage =
FirebaseStorage.instance;

static const String collectionName =
'books';

// =========================
// CREATE BOOK
// =========================

Future<void> addBook(
BookModel book,
) async {
await _firestore
.collection(collectionName)
.add({
...book.toMap(),
'createdAt':
FieldValue.serverTimestamp(),
});
}

// =========================
// READ BOOKS
// =========================

Stream<List<BookModel>> getBooks() {
return _firestore
.collection(collectionName)
.orderBy(
'createdAt',
descending: true,
)
.snapshots()
.map((snapshot) {
return snapshot.docs.map((doc) {
return BookModel.fromMap(
doc.data(),
doc.id,
);
}).toList();
});
}

// =========================
// UPDATE BOOK
// =========================

Future<void> updateBook(
BookModel book,
) async {
if (book.id == null) return;


await _firestore
    .collection(collectionName)
    .doc(book.id)
    .update(book.toMap());

}

// =========================
// DELETE BOOK
// =========================

Future<void> deleteBook(
String id,
) async {
await _firestore
.collection(collectionName)
.doc(id)
.delete();
}

// =========================
// GET SINGLE BOOK
// =========================

Future<BookModel?> getBookById(
String id,
) async {
final doc =
await _firestore
.collection(collectionName)
.doc(id)
.get();

if (!doc.exists) {
  return null;
}

return BookModel.fromMap(
  doc.data()!,
  doc.id,
);


}

// =========================
// UPLOAD IMAGE
// =========================

Future<String> uploadImage(
File imageFile,
) async {
final fileName =
DateTime.now()
.millisecondsSinceEpoch
.toString();

final ref = _storage
    .ref()
    .child(
      'book_covers/$fileName.jpg',
    );

await ref.putFile(imageFile);

return await ref.getDownloadURL();

}
}
