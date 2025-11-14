class ChatMessage {
  final String text;
  final String time;
  final bool isSentByMe;

  const ChatMessage({
    required this.text,
    required this.time,
    required this.isSentByMe,
  });
}