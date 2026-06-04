class OrderModel {
  final String? id;
  final String title;
  final String author;
  final String price;
  final String status;
  final String image;

  OrderModel({
    this.id,
    required this.title,
    required this.author,
    required this.price,
    required this.status,
    required this.image,
  });

  // Mengubah data dari Firestore (Map) menjadi Objek OrderModel
  factory OrderModel.fromMap(Map<String, dynamic> map, String id) {
    return OrderModel(
      id: id,
      title: map['title'] ?? '',
      author: map['author'] ?? '',
      price: map['price'] ?? '',
      status: map['status'] ?? 'Diproses',
      image: map['image'] ?? '',
    );
  }

  // Mengubah Objek OrderModel menjadi Map untuk dikirim ke Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'author': author,
      'price': price,
      'status': status,
      'image': image,
    };
  }
}