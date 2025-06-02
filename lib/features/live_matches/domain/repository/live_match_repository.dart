import 'package:fpdart/fpdart.dart';
import 'package:namhockey/core/error/failure.dart';
import 'package:namhockey/features/live_matches/domain/entity/live_match_entity.dart';

abstract interface class LiveMatchRepository {
  Future<Either<Failure, List<LiveMatchEntity>>> getLiveMatches();
  Future<Either<Failure, LiveMatchEntity>> makeLiveMatch({
    required String team1Logo,
    required String team2Logo,
    required String team1Name,
    required String team2Name,
    required String team1Score,
    required String team2Score,
  });
  Future<Either<Failure, void>> updateLiveMatch({
    required String id,
    required String team1Score,
    required String team2Score,
  });
}
