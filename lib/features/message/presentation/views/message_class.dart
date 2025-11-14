class Message {
  final String sender;
  final String lastMessage;
  final String time;
  final String avatarInitials;
  final bool isUnread;

  const Message({
    required this.sender,
    required this.lastMessage,
    required this.time,
    required this.avatarInitials,
    this.isUnread = false,
  });
}
