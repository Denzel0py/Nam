import 'package:fpdart/fpdart.dart';
import 'package:namhockey/core/error/failures.dart';
import 'package:namhockey/core/usecase/usecase.dart';
import 'package:namhockey/features/news/domain/entity/news_entity.dart';
import 'package:namhockey/features/news/domain/repository/news_repository.dart';

class GetNewsUseCase implements UseCase<List<NewsEntity>, NoParams> {
  final NewsRepository repository;

  GetNewsUseCase(this.repository);

  @override
  Future<Either<Failure, List<NewsEntity>>> call(NoParams params) async {
    return await repository.getNews();
  }
} 