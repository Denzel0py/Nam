import 'package:namhockey/features/teams/domain/repository/team_repository.dart';

class GetTeamNameUseCase {
  final TeamRepository repository;

  GetTeamNameUseCase(this.repository);

  Future<String> call(String teamId) async {
    return await repository.getTeamName(teamId);
  }
} 