part of 'discussion_bloc.dart';

@immutable
abstract class DiscussionEvent {}

class GetMessagesEvent extends DiscussionEvent {
  final String teamId;

  GetMessagesEvent({required this.teamId});
}

class SendMessageEvent extends DiscussionEvent {
  final String content;
  final String teamId;
  final String? replyToId;

  SendMessageEvent({
    required this.content,
    required this.teamId,
    this.replyToId,
  });
} 