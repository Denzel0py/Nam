import 'package:namhockey/features/games/domain/entity/game_entity.dart';

class GameModel extends GameEntity {
  GameModel({
    required super.id,
    required super.team1,
    required super.team2,
    required super.league,
    required super.team1Logo,
    required super.team2Logo,
    required super.gameDate,
    required super.gameTime,
    required super.gameLocation,
  });

  factory GameModel.fromJson(Map<String, dynamic> json) {
    return GameModel(
      id: json['id'] ?? '',
      team1: json['team1']?['name'] ?? '',
      team2: json['team2']?['name'] ?? '',
      league: json['league'] ?? '',
      team1Logo: json['team1']?['logo_url'] ?? '',
      team2Logo: json['team2']?['logo_url'] ?? '',
      gameDate: json['game_date'] ?? '',
      gameTime: json['game_time'] ?? '',
      gameLocation: json['game_location'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'team1_id': team1,
      'team2_id': team2,
      'league': league,
      'team1_logo': team1Logo,
      'team2_logo': team2Logo,
      'game_date': gameDate,
      'game_time': gameTime,
      'game_location': gameLocation,
    };
  }
}
