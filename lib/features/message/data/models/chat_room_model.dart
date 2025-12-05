import 'package:GreenConnectMobile/features/message/domain/entities/chat_room_entity.dart';

class ChatRoomModel {
  final String chatRoomId;
  final String transactionId;
  final String partnerName;
  final String? partnerAvatar;
  final String? lastMessage;
  final DateTime? lastMessageTime;
  final int unreadCount;

  ChatRoomModel({
    required this.chatRoomId,
    required this.transactionId,
    required this.partnerName,
    this.partnerAvatar,
    this.lastMessage,
    this.lastMessageTime,
    required this.unreadCount,
  });

  factory ChatRoomModel.fromJson(Map<String, dynamic> json) {
    return ChatRoomModel(
      chatRoomId: json['chatRoomId'] ?? '',
      transactionId: json['transactionId'] ?? '',
      partnerName: json['partnerName'] ?? '',
      partnerAvatar: json['partnerAvatar'],
      lastMessage: json['lastMessage'],
      lastMessageTime: json['lastMessageTime'] != null
          ? DateTime.parse(json['lastMessageTime'])
          : null,
      unreadCount: json['unreadCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chatRoomId': chatRoomId,
      'transactionId': transactionId,
      'partnerName': partnerName,
      'partnerAvatar': partnerAvatar,
      'lastMessage': lastMessage,
      'lastMessageTime': lastMessageTime?.toIso8601String(),
      'unreadCount': unreadCount,
    };
  }

  ChatRoomEntity toEntity() {
    return ChatRoomEntity(
      chatRoomId: chatRoomId,
      transactionId: transactionId,
      partnerName: partnerName,
      partnerAvatar: partnerAvatar,
      lastMessage: lastMessage,
      lastMessageTime: lastMessageTime,
      unreadCount: unreadCount,
    );
  }
}
