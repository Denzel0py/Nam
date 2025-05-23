class MessageEntity {
  final String id;
  final String content;
  final String senderId;
  final String senderName;
  final String senderRole; // 'coach' or 'player'
  final String teamId;
  final DateTime timestamp;
  final String? replyToId; // ID of the message this is replying to, null if it's a new message
  final String? replyToContent; // Content of the message being replied to, for quick reference

  MessageEntity({
    required this.id,
    required this.content,
    required this.senderId,
    required this.senderName,
    required this.senderRole,
    required this.teamId,
    required this.timestamp,
    this.replyToId,
    this.replyToContent,
  });
} 