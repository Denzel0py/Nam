import 'package:namhockey/core/error/server_exeption.dart';
import 'package:namhockey/features/discussion/data/model/message_model.dart';
import 'package:namhockey/features/discussion/domain/entity/message_entity.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class DiscussionRemoteDataSource {
  Future<List<MessageEntity>> getMessages(String teamId);
  Future<MessageEntity> sendMessage({
    required String content,
    required String teamId,
    String? replyToId,
  });
  Stream<List<MessageEntity>> watchMessages(String teamId);
}

class DiscussionRemoteDataSourceImpl implements DiscussionRemoteDataSource {
  final SupabaseClient supabaseClient;

  DiscussionRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<List<MessageEntity>> getMessages(String teamId) async {
    try {
      final response = await supabaseClient
          .from('messages')
          .select()
          .eq('team_id', teamId)
          .order('timestamp', ascending: true);
      
      return response.map((e) => MessageModel.fromJson(e)).toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<MessageEntity> sendMessage({
    required String content,
    required String teamId,
    String? replyToId,
  }) async {
    try {
      final user = await supabaseClient.auth.getUser();
      if (user.user == null) {
        throw ServerException('User not authenticated');
      }

      // Get user profile to get name and role
      final userProfile = await supabaseClient
          .from('profiles')
          .select('name, role')
          .eq('id', user.user!.id)
          .single();

      String? replyToContent;
      if (replyToId != null) {
        final replyToMessage = await supabaseClient
            .from('messages')
            .select('content')
            .eq('id', replyToId)
            .single();
        replyToContent = replyToMessage['content'];
      }

      final response = await supabaseClient.from('messages').insert({
        'content': content,
        'team_id': teamId,
        'sender_id': user.user!.id,
        'sender_name': userProfile['name'],
        'sender_role': userProfile['role'],
        'timestamp': DateTime.now().toIso8601String(),
        'reply_to_id': replyToId,
        'reply_to_content': replyToContent,
      }).select().single();

      return MessageModel.fromJson(response);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Stream<List<MessageEntity>> watchMessages(String teamId) {
    return supabaseClient
        .from('messages')
        .stream(primaryKey: ['id'])
        .eq('team_id', teamId)
        .order('timestamp')
        .map((events) => events.map((e) => MessageModel.fromJson(e)).toList());
  }
} 