import 'package:fpdart/fpdart.dart';
import 'package:namhockey/core/error/failure.dart';
import 'package:namhockey/core/error/server_exeption.dart';
import 'package:namhockey/features/discussion/data/datasources/discussion_remote_source.dart';
import 'package:namhockey/features/discussion/domain/entity/message_entity.dart';
import 'package:namhockey/features/discussion/domain/repository/discussion_repository.dart';

class DiscussionRepositoryImpl implements DiscussionRepository {
  final DiscussionRemoteDataSource remoteDataSource;

  DiscussionRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<MessageEntity>>> getMessages(String teamId) async {
    try {
      final messages = await remoteDataSource.getMessages(teamId);
      return right(messages);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, MessageEntity>> sendMessage({
    required String content,
    required String teamId,
    String? replyToId,
  }) async {
    try {
      final message = await remoteDataSource.sendMessage(
        content: content,
        teamId: teamId,
        replyToId: replyToId,
      );
      return right(message);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Stream<List<MessageEntity>> watchMessages(String teamId) {
    return remoteDataSource.watchMessages(teamId);
  }
} 