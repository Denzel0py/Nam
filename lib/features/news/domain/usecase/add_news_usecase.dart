import 'package:fpdart/fpdart.dart';
import 'package:namhockey/core/error/failures.dart';
import 'package:namhockey/core/usecase/usecase.dart';
import 'package:namhockey/features/news/domain/entity/news_entity.dart';
import 'package:namhockey/features/news/domain/repository/news_repository.dart';

class AddNewsParams {
  final String title;
  final String description;
  final String imageUrl;
  final String publishedAt;

  AddNewsParams({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.publishedAt,
  });
}

class AddNewsUseCase implements UseCase<NewsEntity, AddNewsParams> {
  final NewsRepository repository;

  AddNewsUseCase(this.repository);

  @override
  Future<Either<Failure, NewsEntity>> call(AddNewsParams params) async {
    return await repository.addNews(
      title: params.title,
      description: params.description,
      imageUrl: params.imageUrl,
      publishedAt: params.publishedAt,
    );
  }
} 