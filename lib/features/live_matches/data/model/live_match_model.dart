import 'package:namhockey/features/live_matches/domain/entity/live_match_entity.dart';

class LiveMatchModel extends LiveMatchEntity {
  LiveMatchModel({
    required super.id,
    required super.team1Logo,
    required super.team2Logo,
    required super.team1Name,
    required super.team2Name,
    required super.team1Score,
    required super.team2Score,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'team1Logo': team1Logo,
      'team2Logo': team2Logo,
      'team1Name': team1Name,
      'team2Name': team2Name,
      'team1Score': team1Score,
      'team2Score': team2Score,
    };
  }

  factory LiveMatchModel.fromJson(Map<String, dynamic> map) {
    return LiveMatchModel(
      id: map['id'] ?? '',
      team1Logo: map['team1Logo'] ?? '',
      team2Logo: map['team2Logo'] ?? '',
      team1Name: map['team1Name'] ?? '',
      team2Name: map['team2Name'] ?? '',
      team1Score: map['team1Score'] ?? '',
      team2Score: map['team2Score'] ?? '',
    );
  }
}
