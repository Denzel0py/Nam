import 'package:fpdart/fpdart.dart';
import 'package:namhockey/core/error/failure.dart';
import 'package:namhockey/features/discussion/domain/entity/message_entity.dart';

abstract class DiscussionRepository {
  Future<Either<Failure, List<MessageEntity>>> getMessages(String teamId);
  Future<Either<Failure, MessageEntity>> sendMessage({
    required String content,
    required String teamId,
    String? replyToId,
  });
  Stream<List<MessageEntity>> watchMessages(String teamId);
} 