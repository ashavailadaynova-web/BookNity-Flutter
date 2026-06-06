class UserModel {
  final String uid;
  final String name;
  final String email;
  final String bio;
  final String location;
  final String website;

  const UserModel({
    required this.uid,
    required this.name,
    required this.email,
    this.bio = '',
    this.location = '',
    this.website = '',
  });

  factory UserModel.fromMap(Map<String, dynamic> map, String uid) {
    return UserModel(
      uid: uid,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      bio: map['bio'] ?? '',
      location: map['location'] ?? '',
      website: map['website'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'bio': bio,
      'location': location,
      'website': website,
    };
  }
}
