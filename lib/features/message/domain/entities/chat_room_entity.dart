class ChatRoomEntity {
  final String chatRoomId;
  final String transactionId;
  final String partnerName;
  final String? partnerAvatar;
  final String? lastMessage;
  final DateTime? lastMessageTime;
  final int unreadCount;

  ChatRoomEntity({
    required this.chatRoomId,
    required this.transactionId,
    required this.partnerName,
    this.partnerAvatar,
    this.lastMessage,
    this.lastMessageTime,
    required this.unreadCount,
  });
}
