import 'package:GreenConnectMobile/features/message/data/models/message_model.dart';
import 'package:GreenConnectMobile/features/message/data/models/paginated_chat_room_model.dart';
import 'package:GreenConnectMobile/features/message/data/models/paginated_message_model.dart';

abstract class MessageRemoteDataSource {
  /// Get chat rooms with optional search
  Future<PaginatedChatRoomModel> getChatRooms({
    String? name,
    required int pageNumber,
    required int pageSize,
  });

  /// Get messages in a specific chat room
  Future<PaginatedMessageModel> getMessages({
    required String chatRoomId,
    required int pageNumber,
    required int pageSize,
  });

  /// Send a message
  Future<MessageModel> sendMessage({
    required String transactionId,
    required String content,
  });

  /// Mark a chat room as read
  Future<bool> markChatRoomAsRead(String chatRoomId);
}
