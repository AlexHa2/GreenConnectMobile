import 'package:GreenConnectMobile/features/message/domain/entities/paginated_message_entity.dart';
import 'package:GreenConnectMobile/features/message/domain/repository/message_repository.dart';

class GetMessagesUsecase {
  final MessageRepository _repository;

  GetMessagesUsecase(this._repository);

  Future<PaginatedMessageEntity> call({
    required String chatRoomId,
    required int pageNumber,
    required int pageSize,
  }) async {
    return await _repository.getMessages(
      chatRoomId: chatRoomId,
      pageNumber: pageNumber,
      pageSize: pageSize,
    );
  }
}
