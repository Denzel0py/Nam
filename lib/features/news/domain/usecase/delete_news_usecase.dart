import 'package:fpdart/fpdart.dart';
import 'package:namhockey/core/error/failures.dart';
import 'package:namhockey/core/usecase/usecase.dart';
import 'package:namhockey/features/news/domain/repository/news_repository.dart';

class DeleteNewsParams {
  final String id;

  DeleteNewsParams({required this.id});
}

class DeleteNewsUseCase implements UseCase<void, DeleteNewsParams> {
  final NewsRepository repository;

  DeleteNewsUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(DeleteNewsParams params) async {
    return await repository.deleteNews(params.id);
  }
} 