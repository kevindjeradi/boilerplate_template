import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String? email;
  final String? phoneNumber;
  final DateTime? createdAt;

  UserModel({
    required this.id,
    this.email,
    this.phoneNumber,
    this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      createdAt: json['createdAt'] != null
          ? (json['createdAt'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'phoneNumber': phoneNumber,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}
