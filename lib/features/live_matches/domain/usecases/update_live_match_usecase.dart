import 'package:fpdart/fpdart.dart';
import 'package:namhockey/core/error/failure.dart';
import 'package:namhockey/core/usecase/use_case.dart';
import 'package:namhockey/features/live_matches/domain/repository/live_match_repository.dart';

class UpdateLiveMatchParams {
  final String id;
  final String team1Score;
  final String team2Score;

  UpdateLiveMatchParams({
    required this.id,
    required this.team1Score,
    required this.team2Score,
  });
}

class UpdateLiveMatchUseCase implements UseCase<void, UpdateLiveMatchParams> {
  final LiveMatchRepository repository;

  UpdateLiveMatchUseCase({required this.repository});

  @override
  Future<Either<Failure, void>> call(UpdateLiveMatchParams params) async {
    try {
      await repository.updateLiveMatch(
        id: params.id,
        team1Score: params.team1Score,
        team2Score: params.team2Score,
      );
      return right(null);
    } on Failure catch (e) {
      return left(e);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
