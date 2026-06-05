class UserModel {
  final String uid;
  final String name;
  final String email;

  UserModel({required this.uid, required this.name, required this.email});

  // 🟢 Memetakan data dari dokumen Cloud Firestore ke Objek Dart
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
    );
  }

  // 🟢 Mengubah objek Dart menjadi JSON untuk dikirim ke database Cloud Firestore
  Map<String, dynamic> toJson() {
    return {'uid': uid, 'name': name, 'email': email};
  }
}
