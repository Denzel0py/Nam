part of 'discussion_bloc.dart';

@immutable
abstract class DiscussionState {}

class DiscussionInitial extends DiscussionState {}

class DiscussionLoading extends DiscussionState {}

class DiscussionLoaded extends DiscussionState {
  final List<MessageEntity> messages;

  DiscussionLoaded(this.messages);
}

class DiscussionFailure extends DiscussionState {
  final String message;

  DiscussionFailure(this.message);
} 