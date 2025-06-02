import 'package:namhockey/core/error/server_exeption.dart';
import 'package:namhockey/features/live_matches/domain/entity/live_match_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class LiveMatchRemoteDataSource {
  Future<List<LiveMatchEntity>> getLiveMatches();
  Future<LiveMatchEntity> makeLiveMatch({
    required String team1Logo,
    required String team2Logo,
    required String team1Name,
    required String team2Name,
    required String team1Score,
    required String team2Score,
  });
  Future<void> updateLiveMatch({
    required String id,
    required String team1Score,
    required String team2Score,
  });
}

class LiveMatchRemoteDataSourceImpl implements LiveMatchRemoteDataSource {
  final SupabaseClient supabaseClient;

  LiveMatchRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<List<LiveMatchEntity>> getLiveMatches() async {
    try {
      final response = await supabaseClient
          .from('live_matches')
          .select()
          .order('created_at', ascending: false);

      return response
          .map(
            (json) => LiveMatchEntity(
              id: json['id'] ?? '',
              team1Logo: json['team1_logo'] ?? '',
              team2Logo: json['team2_logo'] ?? '',
              team1Name: json['team1_name'] ?? '',
              team2Name: json['team2_name'] ?? '',
              team1Score: json['team1_score'] ?? '0',
              team2Score: json['team2_score'] ?? '0',
            ),
          )
          .toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<LiveMatchEntity> makeLiveMatch({
    required String team1Logo,
    required String team2Logo,
    required String team1Name,
    required String team2Name,
    required String team1Score,
    required String team2Score,
  }) async {
    try {
      print('Creating live match with data:');
      print('team1_logo: $team1Logo');
      print('team2_logo: $team2Logo');
      print('team1_name: $team1Name');
      print('team2_name: $team2Name');
      print('team1_score: $team1Score');
      print('team2_score: $team2Score');

      // Get team IDs from the teams table
      final team1Response =
          await supabaseClient
              .from('teams')
              .select('id')
              .eq('name', team1Name)
              .single();
      final team2Response =
          await supabaseClient
              .from('teams')
              .select('id')
              .eq('name', team2Name)
              .single();

      final team1Id = team1Response['id'];
      final team2Id = team2Response['id'];

      print('Found team IDs:');
      print('team1_id: $team1Id');
      print('team2_id: $team2Id');

      final response =
          await supabaseClient
              .from('live_matches')
              .insert({
                'team1_id': team1Id,
                'team2_id': team2Id,
                'team1_logo': team1Logo,
                'team2_logo': team2Logo,
                'team1_name': team1Name,
                'team2_name': team2Name,
                'team1_score': team1Score,
                'team2_score': team2Score,
                'created_at': DateTime.now().toIso8601String(),
              })
              .select()
              .single();

      return LiveMatchEntity(
        id: response['id'] ?? '',
        team1Logo: response['team1_logo'] ?? '',
        team2Logo: response['team2_logo'] ?? '',
        team1Name: response['team1_name'] ?? '',
        team2Name: response['team2_name'] ?? '',
        team1Score: response['team1_score'] ?? '0',
        team2Score: response['team2_score'] ?? '0',
      );
    } catch (e) {
      print('Error creating live match: $e');
      if (e is PostgrestException) {
        print('Postgrest error details: ${e.details}');
        print('Postgrest error message: ${e.message}');
        print('Postgrest error hint: ${e.hint}');
      }
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> updateLiveMatch({
    required String id,
    required String team1Score,
    required String team2Score,
  }) async {
    try {
      await supabaseClient
          .from('live_matches')
          .update({
            'team1_score': team1Score,
            'team2_score': team2Score,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', id);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
