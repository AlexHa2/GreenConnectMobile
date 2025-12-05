class MessageEntity {
  final String messageId;
  final String senderId;
  final String senderName;
  final String? senderAvatar;
  final String content;
  final DateTime timestamp;
  final bool isRead;

  MessageEntity({
    required this.messageId,
    required this.senderId,
    required this.senderName,
    this.senderAvatar,
    required this.content,
    required this.timestamp,
    required this.isRead,
  });

  bool isSentByMe(String currentUserId) => senderId == currentUserId;
}
