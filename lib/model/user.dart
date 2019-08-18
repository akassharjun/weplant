// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

class User {
  int id;
  String fullName;
  String password;
  String email;
  String clubName;
  String createdAt;
  String createdBy;
  String updatedAt;
  String updatedBy;

  User({
    this.id,
    this.fullName,
    this.password,
    this.email,
    this.clubName,
    this.createdAt,
    this.createdBy,
    this.updatedAt,
    this.updatedBy,
  });

  factory User.fromJson(String str) => User.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory User.fromMap(Map<String, dynamic> json) => new User(
        id: json["id"] == null ? null : json["id"],
        fullName: json["fullName"] == null ? null : json["fullName"],
        password: json["password"] == null ? null : json["password"],
        email: json["email"] == null ? null : json["email"],
        clubName: json["clubName"] == null ? null : json["clubName"],
        createdAt: json["createdAt"] == null ? null : json["createdAt"],
        createdBy: json["createdBy"] == null ? null : json["createdBy"],
        updatedAt: json["updatedAt"] == null ? null : json["updatedAt"],
        updatedBy: json["updatedBy"] == null ? null : json["updatedBy"],
      );

  Map<String, dynamic> toMap() => {
        "id": id == null ? null : id,
        "fullName": fullName == null ? null : fullName,
        "password": password == null ? null : password,
        "email": email == null ? null : email,
        "clubName": clubName == null ? null : clubName,
        "createdAt": createdAt == null ? null : createdAt,
        "createdBy": createdBy == null ? null : createdBy,
        "updatedAt": updatedAt == null ? null : updatedAt,
        "updatedBy": updatedBy == null ? null : updatedBy,
      };
}
