import 'package:fpdart/fpdart.dart';
import 'package:namhockey/core/error/failure.dart';
import 'package:namhockey/core/usecase/use_case.dart';
import 'package:namhockey/features/live_matches/domain/entity/live_match_entity.dart';
import 'package:namhockey/features/live_matches/domain/repository/live_match_repository.dart';

class GetLiveMatchesUseCase
    implements UseCase<List<LiveMatchEntity>, NoParams> {
  final LiveMatchRepository repository;

  GetLiveMatchesUseCase({required this.repository});

  @override
  Future<Either<Failure, List<LiveMatchEntity>>> call(NoParams params) async {
    return await repository.getLiveMatches();
  }
}
