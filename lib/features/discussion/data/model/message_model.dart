import 'package:namhockey/features/discussion/domain/entity/message_entity.dart';

class MessageModel extends MessageEntity {
  MessageModel({
    required super.id,
    required super.content,
    required super.senderId,
    required super.senderName,
    required super.senderRole,
    required super.teamId,
    required super.timestamp,
    super.replyToId,
    super.replyToContent,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'] ?? '',
      content: json['content'] ?? '',
      senderId: json['sender_id'] ?? '',
      senderName: json['sender_name'] ?? '',
      senderRole: json['sender_role'] ?? '',
      teamId: json['team_id'] ?? '',
      timestamp: DateTime.parse(json['timestamp'] ?? DateTime.now().toIso8601String()),
      replyToId: json['reply_to_id'],
      replyToContent: json['reply_to_content'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'sender_id': senderId,
      'sender_name': senderName,
      'sender_role': senderRole,
      'team_id': teamId,
      'timestamp': timestamp.toIso8601String(),
      'reply_to_id': replyToId,
      'reply_to_content': replyToContent,
    };
  }
} 