import 'package:GreenConnectMobile/core/error/exception_mapper.dart';
import 'package:GreenConnectMobile/features/message/data/datasources/message_remote_datasource.dart';
import 'package:GreenConnectMobile/features/message/domain/entities/message_entity.dart';
import 'package:GreenConnectMobile/features/message/domain/entities/paginated_chat_room_entity.dart';
import 'package:GreenConnectMobile/features/message/domain/entities/paginated_message_entity.dart';
import 'package:GreenConnectMobile/features/message/domain/repository/message_repository.dart';

class MessageRepositoryImpl implements MessageRepository {
  final MessageRemoteDataSource _remoteDataSource;

  MessageRepositoryImpl(this._remoteDataSource);

  @override
  Future<PaginatedChatRoomEntity> getChatRooms({
    String? name,
    required int pageNumber,
    required int pageSize,
  }) async {
    return guard(() async {
      final result = await _remoteDataSource.getChatRooms(
        name: name,
        pageNumber: pageNumber,
        pageSize: pageSize,
      );
      return result.toEntity();
    });
  }

  @override
  Future<PaginatedMessageEntity> getMessages({
    required String chatRoomId,
    required int pageNumber,
    required int pageSize,
  }) async {
    return guard(() async {
      final result = await _remoteDataSource.getMessages(
        chatRoomId: chatRoomId,
        pageNumber: pageNumber,
        pageSize: pageSize,
      );
      return result.toEntity();
    });
  }

  @override
  Future<MessageEntity> sendMessage({
    required String transactionId,
    required String content,
  }) async {
    return guard(() async {
      final result = await _remoteDataSource.sendMessage(
        transactionId: transactionId,
        content: content,
      );
      return result.toEntity();
    });
  }

  @override
  Future<bool> markChatRoomAsRead(String chatRoomId) async {
    return guard(() async {
      return await _remoteDataSource.markChatRoomAsRead(chatRoomId);
    });
  }
}
