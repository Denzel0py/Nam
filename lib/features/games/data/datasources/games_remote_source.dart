import 'package:namhockey/core/error/server_exeption.dart';
import 'package:namhockey/features/games/data/model/game_model.dart';
import 'package:namhockey/features/games/domain/entity/game_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class GamesRemoteDataSource {
  Future<List<GameEntity>> getGames();
  Future<List<GameEntity>> makeGames({
    required String team1,
    required String team2,
    required String league,
    required String team1Logo,
    required String team2Logo,
    required String gameDate,
    required String gameTime,
    required String gameLocation,
  });
}

class GamesRemoteDataSourceImpl implements GamesRemoteDataSource {
  final SupabaseClient supabaseClient;
  GamesRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<List<GameEntity>> getGames() async {
    try {
      print('Fetching games from Supabase...');
      final response = await supabaseClient
          .from('games')
          .select('''
            *,
            team1:team1_id(name, logo_url),
            team2:team2_id(name, logo_url)
          ''');
      print('Games fetched successfully: ${response.toString()}');
      return response.map((e) => GameModel.fromJson(e)).toList();
    } catch (e) {
      print('Error fetching games: $e');
      if (e is PostgrestException) {
        print('PostgreSQL Error Details:');
        print('Code: ${e.code}');
        print('Message: ${e.message}');
        print('Details: ${e.details}');
        print('Hint: ${e.hint}');
      }
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<GameEntity>> makeGames({
    required String team1,
    required String team2,
    required String league,
    required String team1Logo,
    required String team2Logo,
    required String gameDate,
    required String gameTime,
    required String gameLocation,
  }) async {
    try {
      print('Creating new game...');
      print('Parameters: team1=$team1, team2=$team2, league=$league, gameDate=$gameDate, gameTime=$gameTime, gameLocation=$gameLocation');

      // Verify required fields
      if (team1.isEmpty || team2.isEmpty || league.isEmpty || 
          team1Logo.isEmpty || team2Logo.isEmpty || 
          gameDate.isEmpty || gameTime.isEmpty || gameLocation.isEmpty) {
        throw ServerException('All fields are required');
      }

      // Check if user is admin
      final user = await supabaseClient.auth.getUser();
      if (user.user == null) {
        throw ServerException('User not authenticated');
      }

      final userProfile = await supabaseClient
          .from('profiles')
          .select('role')
          .eq('id', user.user!.id)
          .single();

      if (userProfile['role'] != 'admin') {
        throw ServerException('Only admins can create games');
      }

      final response = await supabaseClient.from('games').insert({
        'team1_id': team1,
        'team2_id': team2,
        'league': league,
        'game_date': gameDate,
        'game_time': gameTime,
        'game_location': gameLocation,
        'created_at': DateTime.now().toIso8601String(),
      }).select();
      
      print('Game created successfully: ${response.toString()}');
      return response.map((e) => GameModel.fromJson(e)).toList();
    } catch (e) {
      print('Error creating game: $e');
      if (e is PostgrestException) {
        print('PostgreSQL Error Details:');
        print('Code: ${e.code}');
        print('Message: ${e.message}');
        print('Details: ${e.details}');
        print('Hint: ${e.hint}');
        
        if (e.code == '42501') {
          throw ServerException('Permission denied. Only admins can create games.');
        }
      }
      throw ServerException(e.toString());
    }
  }
}
