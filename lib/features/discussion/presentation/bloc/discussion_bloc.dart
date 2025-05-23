import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:namhockey/features/discussion/domain/entity/message_entity.dart';
import 'package:namhockey/features/discussion/domain/usecase/get_messages_usecase.dart';
import 'package:namhockey/features/discussion/domain/usecase/send_message_usecase.dart';

part 'discussion_event.dart';
part 'discussion_state.dart';

class DiscussionBloc extends Bloc<DiscussionEvent, DiscussionState> {
  final GetMessagesUseCase _getMessagesUseCase;
  final SendMessageUseCase _sendMessageUseCase;

  DiscussionBloc({
    required GetMessagesUseCase getMessagesUseCase,
    required SendMessageUseCase sendMessageUseCase,
  })  : _getMessagesUseCase = getMessagesUseCase,
        _sendMessageUseCase = sendMessageUseCase,
        super(DiscussionInitial()) {
    on<GetMessagesEvent>(_onGetMessages);
    on<SendMessageEvent>(_onSendMessage);
  }

  void _onGetMessages(GetMessagesEvent event, Emitter<DiscussionState> emit) async {
    emit(DiscussionLoading());
    final res = await _getMessagesUseCase(event.teamId);
    
    res.fold(
      (l) => emit(DiscussionFailure(l.message)),
      (r) => emit(DiscussionLoaded(r)),
    );
  }

  void _onSendMessage(SendMessageEvent event, Emitter<DiscussionState> emit) async {
    final res = await _sendMessageUseCase(SendMessageParams(
      content: event.content,
      teamId: event.teamId,
      replyToId: event.replyToId,
    ));
    
    res.fold(
      (l) => emit(DiscussionFailure(l.message)),
      (r) {
        if (state is DiscussionLoaded) {
          final currentState = state as DiscussionLoaded;
          emit(DiscussionLoaded([...currentState.messages, r]));
        }
      },
    );
  }
} 