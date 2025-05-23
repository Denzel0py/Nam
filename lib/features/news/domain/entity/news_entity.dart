import 'package:equatable/equatable.dart';

class NewsEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final String publishedAt;

  const NewsEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.publishedAt,
  });

  @override
  List<Object?> get props => [id, title, description, imageUrl, publishedAt];
}
