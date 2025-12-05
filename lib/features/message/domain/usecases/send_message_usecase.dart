import 'package:GreenConnectMobile/features/message/domain/entities/message_entity.dart';
import 'package:GreenConnectMobile/features/message/domain/repository/message_repository.dart';

class SendMessageUsecase {
  final MessageRepository _repository;

  SendMessageUsecase(this._repository);

  Future<MessageEntity> call({
    required String transactionId,
    required String content,
  }) async {
    return await _repository.sendMessage(
      transactionId: transactionId,
      content: content,
    );
  }
}
