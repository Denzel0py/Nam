part of 'news_bloc.dart';

@immutable
abstract class NewsEvent {}

class GetNewsEvent extends NewsEvent {}

class AddNewsEvent extends NewsEvent {
  final String title;
  final String description;
  final String imageUrl;
  final String publishedAt;

  AddNewsEvent({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.publishedAt,
  });
}

class DeleteNewsEvent extends NewsEvent {
  final String id;

  DeleteNewsEvent({required this.id});
} 