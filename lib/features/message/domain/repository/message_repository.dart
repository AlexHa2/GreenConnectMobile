import 'package:GreenConnectMobile/features/message/domain/entities/message_entity.dart';
import 'package:GreenConnectMobile/features/message/domain/entities/paginated_chat_room_entity.dart';
import 'package:GreenConnectMobile/features/message/domain/entities/paginated_message_entity.dart';

abstract class MessageRepository {
  /// Get chat rooms with optional search
  Future<PaginatedChatRoomEntity> getChatRooms({
    String? name,
    required int pageNumber,
    required int pageSize,
  });

  /// Get messages in a specific chat room
  Future<PaginatedMessageEntity> getMessages({
    required String chatRoomId,
    required int pageNumber,
    required int pageSize,
  });

  /// Send a message
  Future<MessageEntity> sendMessage({
    required String transactionId,
    required String content,
  });

  /// Mark a chat room as read
  Future<bool> markChatRoomAsRead(String chatRoomId);
}
