abstract class UserEntity {
  final String id;
  final String email;
  final String name;
  final String role; // 'user', 'player', or 'coach'
  final String? teamId;
  final String? teamName;
  final String? profilePictureUrl;

  UserEntity({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    this.teamId,
    this.teamName,
    this.profilePictureUrl,
  });
}
