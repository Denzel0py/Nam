import 'package:namhockey/features/teams/data/datasources/team_remote_source.dart';
import 'package:namhockey/features/teams/domain/repository/team_repository.dart';

class TeamRepositoryImpl implements TeamRepository {
  final TeamRemoteDataSource remoteDataSource;

  TeamRepositoryImpl(this.remoteDataSource);

  @override
  Future<String> getTeamName(String teamId) async {
    return await remoteDataSource.getTeamName(teamId);
  }
} 