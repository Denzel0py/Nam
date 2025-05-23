part of 'news_bloc.dart';

@immutable
abstract class NewsState {}

class NewsInitial extends NewsState {}

class NewsLoading extends NewsState {}

class NewsLoaded extends NewsState {
  final List<NewsEntity> news;

  NewsLoaded(this.news);
}

class NewsFailure extends NewsState {
  final String message;

  NewsFailure(this.message);
} 