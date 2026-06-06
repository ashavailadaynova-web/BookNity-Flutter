class UserModel {
  final String uid;
  final String name;
  final String email;
  final String bio;
  final String location;
  final String website;
  final String username;
  final String birthDate;
  final String photoUrl;

  const UserModel({
    required this.uid,
    required this.name,
    required this.email,
    this.bio = '',
    this.location = '',
    this.website = '',
    this.username = '',
    this.birthDate = '',
    this.photoUrl = '',
  });

  factory UserModel.fromMap(Map<String, dynamic> map, String uid) {
    return UserModel(
      uid: uid,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      bio: map['bio'] ?? '',
      location: map['location'] ?? '',
      website: map['website'] ?? '',
      username: map['username'] ?? '',
      birthDate: map['birthDate'] ?? '',    
      photoUrl: map['photoUrl'] ?? '',  
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'bio': bio,
      'location': location,
      'website': website,
      'username': username,
'birthDate': birthDate,
'photoUrl': photoUrl,

    };
  }
}
