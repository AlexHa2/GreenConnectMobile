import 'package:GreenConnectMobile/features/message/domain/entities/paginated_chat_room_entity.dart';
import 'package:GreenConnectMobile/features/message/domain/repository/message_repository.dart';

class GetChatRoomsUsecase {
  final MessageRepository _repository;

  GetChatRoomsUsecase(this._repository);

  Future<PaginatedChatRoomEntity> call({
    String? name,
    required int pageNumber,
    required int pageSize,
  }) async {
    return await _repository.getChatRooms(
      name: name,
      pageNumber: pageNumber,
      pageSize: pageSize,
    );
  }
}
