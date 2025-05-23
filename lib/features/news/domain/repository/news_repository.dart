import 'package:fpdart/fpdart.dart';
import 'package:namhockey/core/error/failures.dart';
import 'package:namhockey/features/news/domain/entity/news_entity.dart';

abstract class NewsRepository {
  Future<Either<Failure, List<NewsEntity>>> getNews();
  Future<Either<Failure, NewsEntity>> addNews({
    required String title,
    required String description,
    required String imageUrl,
    required String publishedAt,
  });
  Future<Either<Failure, void>> deleteNews(String id);
}

