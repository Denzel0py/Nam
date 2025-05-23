import 'package:namhockey/core/error/server_exeption.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class TeamRemoteDataSource {
  Future<String> getTeamName(String teamId);
}

class TeamRemoteDataSourceImpl implements TeamRemoteDataSource {
  final SupabaseClient supabaseClient;

  TeamRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<String> getTeamName(String teamId) async {
    try {
      final response = await supabaseClient
          .from('teams')
          .select('name')
          .eq('id', teamId)
          .single();
      
      return response['name'];
    } catch (e) {
      print('Error fetching team name: $e');
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
} 