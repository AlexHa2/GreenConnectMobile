import 'package:GreenConnectMobile/features/message/domain/entities/chat_room_entity.dart';
import 'package:GreenConnectMobile/features/message/domain/entities/paginated_chat_room_entity.dart';
import 'package:GreenConnectMobile/features/message/domain/entities/paginated_message_entity.dart';

class MessageState {
  // Chat rooms list state
  final bool isLoadingRooms;
  final PaginatedChatRoomEntity? chatRooms;
  final String? searchQuery;

  // Messages state
  final bool isLoadingMessages;
  final PaginatedMessageEntity? messages;
  final String? currentChatRoomId;
  final String? currentTransactionId;

  // Send message state
  final bool isSendingMessage;

  // Mark as read state
  final bool isMarkingRead;

  // General state
  final String? errorMessage;

  MessageState({
    this.isLoadingRooms = false,
    this.chatRooms,
    this.searchQuery,
    this.isLoadingMessages = false,
    this.messages,
    this.currentChatRoomId,
    this.currentTransactionId,
    this.isSendingMessage = false,
    this.isMarkingRead = false,
    this.errorMessage,
  });

  MessageState copyWith({
    bool? isLoadingRooms,
    PaginatedChatRoomEntity? chatRooms,
    String? searchQuery,
    bool? isLoadingMessages,
    PaginatedMessageEntity? messages,
    String? currentChatRoomId,
    String? currentTransactionId,
    bool? isSendingMessage,
    bool? isMarkingRead,
    String? errorMessage,
  }) {
    return MessageState(
      isLoadingRooms: isLoadingRooms ?? this.isLoadingRooms,
      chatRooms: chatRooms ?? this.chatRooms,
      searchQuery: searchQuery ?? this.searchQuery,
      isLoadingMessages: isLoadingMessages ?? this.isLoadingMessages,
      messages: messages ?? this.messages,
      currentChatRoomId: currentChatRoomId ?? this.currentChatRoomId,
      currentTransactionId: currentTransactionId ?? this.currentTransactionId,
      isSendingMessage: isSendingMessage ?? this.isSendingMessage,
      isMarkingRead: isMarkingRead ?? this.isMarkingRead,
      errorMessage: errorMessage,
    );
  }

  bool get hasChatRooms => chatRooms != null && chatRooms!.chatRooms.isNotEmpty;
  bool get hasMessages => messages != null && messages!.messages.isNotEmpty;
  bool get hasNextRoomsPage => chatRooms?.hasNextPage ?? false;
  bool get hasNextMessagesPage => messages?.hasNextPage ?? false;

  int get totalUnreadCount =>
      chatRooms?.chatRooms.fold<int>(
        0,
        (sum, room) => sum + room.unreadCount,
      ) ??
      0;

  ChatRoomEntity? getCurrentChatRoom() {
    if (currentChatRoomId == null || chatRooms == null) return null;
    try {
      return chatRooms!.chatRooms.firstWhere(
        (room) => room.chatRoomId == currentChatRoomId,
      );
    } catch (e) {
      return null;
    }
  }
}
