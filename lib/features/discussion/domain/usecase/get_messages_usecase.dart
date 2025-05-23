import 'package:fpdart/fpdart.dart';
import 'package:namhockey/core/error/failure.dart';
import 'package:namhockey/core/usecase/use_case.dart';
import 'package:namhockey/features/discussion/domain/entity/message_entity.dart';
import 'package:namhockey/features/discussion/domain/repository/discussion_repository.dart';

class GetMessagesUseCase implements UseCase<List<MessageEntity>, String> {
  final DiscussionRepository repository;

  GetMessagesUseCase({required this.repository});

  @override
  Future<Either<Failure, List<MessageEntity>>> call(String teamId) async {
    return await repository.getMessages(teamId);
  }
} 