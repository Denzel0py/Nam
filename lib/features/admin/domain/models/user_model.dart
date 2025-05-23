class UserModel {
  final String id;
  final String email;
  final String name;
  final String role;
  final String? teamId;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    this.teamId,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      role: json['role'] as String,
      teamId: json['team_id'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'role': role,
      'team_id': teamId,
    };
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    String? role,
    String? teamId,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      role: role ?? this.role,
      teamId: teamId ?? this.teamId,
    );
  }
} 