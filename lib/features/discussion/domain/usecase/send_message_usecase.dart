import 'package:fpdart/fpdart.dart';
import 'package:namhockey/core/error/failure.dart';
import 'package:namhockey/core/usecase/use_case.dart';
import 'package:namhockey/features/discussion/domain/entity/message_entity.dart';
import 'package:namhockey/features/discussion/domain/repository/discussion_repository.dart';

class SendMessageUseCase implements UseCase<MessageEntity, SendMessageParams> {
  final DiscussionRepository repository;

  SendMessageUseCase({required this.repository});

  @override
  Future<Either<Failure, MessageEntity>> call(SendMessageParams params) async {
    return await repository.sendMessage(
      content: params.content,
      teamId: params.teamId,
      replyToId: params.replyToId,
    );
  }
}

class SendMessageParams {
  final String content;
  final String teamId;
  final String? replyToId;

  SendMessageParams({
    required this.content,
    required this.teamId,
    this.replyToId,
  });
} 