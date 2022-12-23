import 'dart:convert';

class UserModel {
  final String token, uid, name, email, profilePic;

  UserModel({
    this.token = '',
    this.uid = '',
    required this.name,
    required this.email,
    required this.profilePic,
  });

  Map<String, dynamic> toMap() {
    return {
      'token': token,
      'uid': uid,
      'name': name,
      'email': email,
      'profilePic': profilePic,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      token: map['token'] ?? '',
      uid: map['_id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      profilePic: map['profilePic'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));

  UserModel copyWith({
    String? token,
    String? uid,
  }) {
    return UserModel(
      token: token ?? this.token,
      uid: uid ?? this.uid,
      name: name,
      email: email,
      profilePic: profilePic,
    );
  }
}
