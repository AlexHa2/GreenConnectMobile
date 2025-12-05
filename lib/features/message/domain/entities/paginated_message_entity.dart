import 'package:GreenConnectMobile/features/message/domain/entities/message_entity.dart';

class PaginatedMessageEntity {
  final List<MessageEntity> messages;
  final int totalRecords;
  final int currentPage;
  final int totalPages;
  final int? nextPage;
  final int? prevPage;

  PaginatedMessageEntity({
    required this.messages,
    required this.totalRecords,
    required this.currentPage,
    required this.totalPages,
    this.nextPage,
    this.prevPage,
  });

  bool get hasNextPage => nextPage != null;
  bool get hasPrevPage => prevPage != null;
}
