import 'dart:convert';

class UserModel {
  final String id;
  final String username;
  final String firstname;
  final String lastname;
  final String phone;
  String avatar;

  UserModel({
    required this.id,
    required this.username,
    required this.phone,
    required this.firstname,
    required this.lastname,
    required this.avatar,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    // log('json: $json');
    // log('Username: ${json['username']}');
    return UserModel(
      id: json['_id'] ?? '',
      username: json['username'] ?? '',
      phone: json['phone'] ?? '',
      firstname: json['firstname'] ?? '',
      lastname: json['lastname'] ?? '',
      avatar: json['avatar'] ?? '',
    );
  }

  @override
  String toString() {
    return 'UserModel(id: $id, username: $username, firstname: $firstname, lastname: $lastname, phone: $phone, avatar: $avatar)';
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'id': id});
    result.addAll({'username': username});
    result.addAll({'firstname': firstname});
    result.addAll({'lastname': lastname});
    result.addAll({'avatar': avatar});

    return result;
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['_id'] ?? '',
      phone: map['phone'] ?? '',
      username: map['username'] ?? '',
      firstname: map['firstname'] ?? '',
      lastname: map['lastname'] ?? '',
      avatar: map['avatar'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  // factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source));
}
