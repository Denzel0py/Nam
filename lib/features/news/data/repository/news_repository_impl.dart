import 'package:fpdart/fpdart.dart';
import 'package:namhockey/core/error/failures.dart';
import 'package:namhockey/features/news/data/datasource/news_remote_data_source.dart';
import 'package:namhockey/features/news/domain/entity/news_entity.dart';
import 'package:namhockey/features/news/domain/repository/news_repository.dart';

class NewsRepositoryImpl implements NewsRepository {
  final NewsRemoteDataSource remoteDataSource;

  NewsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<NewsEntity>>> getNews() async {
    try {
      print('Repository: Getting news...');
      final news = await remoteDataSource.getNews();
      print('Repository: News retrieved successfully: ${news.length} items');
      return Right(news);
    } catch (e) {
      print('Repository: Error getting news: $e');
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, NewsEntity>> addNews({
    required String title,
    required String description,
    required String imageUrl,
    required String publishedAt,
  }) async {
    try {
      print('Repository: Adding news...');
      final news = await remoteDataSource.addNews(
        title: title,
        description: description,
        imageUrl: imageUrl,
        publishedAt: publishedAt,
      );
      print('Repository: News added successfully');
      return Right(news);
    } catch (e) {
      print('Repository: Error adding news: $e');
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteNews(String id) async {
    try {
      print('Repository: Deleting news...');
      await remoteDataSource.deleteNews(id);
      print('Repository: News deleted successfully');
      return const Right(null);
    } catch (e) {
      print('Repository: Error deleting news: $e');
      return Left(ServerFailure());
    }
  }
}