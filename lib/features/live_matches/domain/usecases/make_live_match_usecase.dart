import 'package:fpdart/fpdart.dart';
import 'package:namhockey/core/error/failure.dart';
import 'package:namhockey/core/usecase/use_case.dart';
import 'package:namhockey/features/live_matches/domain/entity/live_match_entity.dart';
import 'package:namhockey/features/live_matches/domain/repository/live_match_repository.dart';

class MakeLiveMatchParams {
  final String team1Logo;
  final String team2Logo;
  final String team1Name;
  final String team2Name;
  final String team1Score;
  final String team2Score;

  MakeLiveMatchParams({
    required this.team1Logo,
    required this.team2Logo,
    required this.team1Name,
    required this.team2Name,
    required this.team1Score,
    required this.team2Score,
  });
}

class MakeLiveMatchUseCase
    implements UseCase<LiveMatchEntity, MakeLiveMatchParams> {
  final LiveMatchRepository repository;

  MakeLiveMatchUseCase({required this.repository});

  @override
  Future<Either<Failure, LiveMatchEntity>> call(
    MakeLiveMatchParams params,
  ) async {
    return await repository.makeLiveMatch(
      team1Logo: params.team1Logo,
      team2Logo: params.team2Logo,
      team1Name: params.team1Name,
      team2Name: params.team2Name,
      team1Score: params.team1Score,
      team2Score: params.team2Score,
    );
  }
}
