import 'package:GreenConnectMobile/features/message/domain/repository/message_repository.dart';

class MarkChatRoomAsReadUsecase {
  final MessageRepository _repository;

  MarkChatRoomAsReadUsecase(this._repository);

  Future<bool> call(String chatRoomId) async {
    return await _repository.markChatRoomAsRead(chatRoomId);
  }
}
