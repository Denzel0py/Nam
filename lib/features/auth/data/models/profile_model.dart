import 'package:namhockey/features/auth/data/models/user_model.dart';

class ProfileModel extends UserModel {
  final String? username;
  final String? avatarUrl;
  final String? website;
  final DateTime? updatedAt;

  ProfileModel({
    required super.id,
    required super.name,
    required super.email,
    required super.role,
    this.username,
    this.avatarUrl,
    this.website,
    this.updatedAt,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      username: json['username'],
      avatarUrl: json['avatar_url'],
      website: json['website'],
      updatedAt:
          json['updated_at'] != null
              ? DateTime.parse(json['updated_at'])
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'username': username,
      'avatar_url': avatarUrl,
      'role': role,
      'website': website,
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  ProfileModel copyWith({
    String? id,
    String? name,
    String? email,
    String? username,
    String? avatarUrl,
    String? website,
    String? role,
    DateTime? updatedAt,
  }) {
    return ProfileModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      username: username ?? this.username,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      role: role ?? this.role,
      website: website ?? this.website,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
