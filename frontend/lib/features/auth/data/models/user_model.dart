import 'package:equatable/equatable.dart';

enum UserRole { buyer, seller, both }

class UserModel extends Equatable {
  final String uid;
  final String email;
  final String name;
  final UserRole role;
  final DateTime createdAt;

  const UserModel({
    required this.uid,
    required this.email,
    required this.name,
    required this.role,
    required this.createdAt,
  });

  UserModel copyWith({
    String? uid,
    String? email,
    String? name,
    UserRole? role,
    DateTime? createdAt,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      name: name ?? this.name,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'role': role.toString().split('.').last,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      role: _parseRole(map['role']),
      createdAt: map['createdAt'] != null 
          ? DateTime.parse(map['createdAt']) 
          : DateTime.now(),
    );
  }

  static UserRole _parseRole(String? roleStr) {
    switch (roleStr) {
      case 'seller':
        return UserRole.seller;
      case 'both':
        return UserRole.both;
      case 'buyer':
      default:
        return UserRole.buyer;
    }
  }

  @override
  List<Object?> get props => [uid, email, name, role, createdAt];
}
