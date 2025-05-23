import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:namhockey/core/common/cubit/app_user/app_user_cubit.dart';
import 'package:namhockey/features/discussion/domain/entity/message_entity.dart';
import 'package:namhockey/features/discussion/presentation/bloc/discussion_bloc.dart';
import 'package:namhockey/features/discussion/presentation/widgets/message_bubble.dart';

class DiscussionPage extends StatefulWidget {
  final String teamId;
  final String teamName;

  const DiscussionPage({
    super.key,
    required this.teamId,
    required this.teamName,
  });

  @override
  State<DiscussionPage> createState() => _DiscussionPageState();
}

class _DiscussionPageState extends State<DiscussionPage> {
  final _messageController = TextEditingController();
  String? _replyingToId;
  String? _replyingToContent;

  @override
  void initState() {
    super.initState();
    context.read<DiscussionBloc>().add(GetMessagesEvent(teamId: widget.teamId));
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    context.read<DiscussionBloc>().add(
      SendMessageEvent(
        content: _messageController.text.trim(),
        teamId: widget.teamId,
        replyToId: _replyingToId,
      ),
    );

    _messageController.clear();
    setState(() {
      _replyingToId = null;
      _replyingToContent = null;
    });
  }

  void _onReply(MessageEntity message) {
    setState(() {
      _replyingToId = message.id;
      _replyingToContent = message.content;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId =
        context.read<AppUserCubit>().state is AppUserLoggedIn
            ? (context.read<AppUserCubit>().state as AppUserLoggedIn).user.id
            : '';

    return Scaffold(
      appBar: AppBar(title: Text(widget.teamName)),
      backgroundColor: const Color.fromARGB(255, 240, 231, 231),
      body: Column(
        children: [
          if (_replyingToContent != null)
            Container(
              padding: const EdgeInsets.all(8.0),
              color: Colors.grey[200],
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Replying to: $_replyingToContent',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      setState(() {
                        _replyingToId = null;
                        _replyingToContent = null;
                      });
                    },
                  ),
                ],
              ),
            ),
          Expanded(
            child: BlocBuilder<DiscussionBloc, DiscussionState>(
              builder: (context, state) {
                if (state is DiscussionLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is DiscussionLoaded) {
                  return ListView.builder(
                    reverse: true,
                    itemCount: state.messages.length,
                    itemBuilder: (context, index) {
                      final message =
                          state.messages[state.messages.length - 1 - index];
                      return MessageBubble(
                        message: message,
                        isMe: message.senderId == currentUserId,
                        onReply: () => _onReply(message),
                      );
                    },
                  );
                }

                if (state is DiscussionFailure) {
                  return Center(child: Text(state.message));
                }

                return const Center(child: Text('No messages yet'));
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, -1),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Type a message...',
                      border: InputBorder.none,
                    ),
                    maxLines: null,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
