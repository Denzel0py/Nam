import 'package:fpdart/fpdart.dart';
import 'package:namhockey/core/error/failure.dart';
import 'package:namhockey/core/error/server_exeption.dart';
import 'package:namhockey/features/live_matches/data/datasources/live_match_remote_data_source.dart';
import 'package:namhockey/features/live_matches/domain/entity/live_match_entity.dart';
import 'package:namhockey/features/live_matches/domain/repository/live_match_repository.dart';

class LiveMatchRepositoryImpl implements LiveMatchRepository {
  final LiveMatchRemoteDataSource remoteDataSource;

  LiveMatchRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<LiveMatchEntity>>> getLiveMatches() async {
    try {
      final matches = await remoteDataSource.getLiveMatches();
      return right(matches);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, LiveMatchEntity>> makeLiveMatch({
    required String team1Logo,
    required String team2Logo,
    required String team1Name,
    required String team2Name,
    required String team1Score,
    required String team2Score,
  }) async {
    try {
      final match = await remoteDataSource.makeLiveMatch(
        team1Logo: team1Logo,
        team2Logo: team2Logo,
        team1Name: team1Name,
        team2Name: team2Name,
        team1Score: team1Score,
        team2Score: team2Score,
      );
      return right(match);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateLiveMatch({
    required String id,
    required String team1Score,
    required String team2Score,
  }) async {
    try {
      await remoteDataSource.updateLiveMatch(
        id: id,
        team1Score: team1Score,
        team2Score: team2Score,
      );
      return right(null);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
