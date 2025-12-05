import 'package:GreenConnectMobile/features/message/domain/entities/chat_room_entity.dart';

class PaginatedChatRoomEntity {
  final List<ChatRoomEntity> chatRooms;
  final int totalRecords;
  final int currentPage;
  final int totalPages;
  final int? nextPage;
  final int? prevPage;

  PaginatedChatRoomEntity({
    required this.chatRooms,
    required this.totalRecords,
    required this.currentPage,
    required this.totalPages,
    this.nextPage,
    this.prevPage,
  });

  bool get hasNextPage => nextPage != null;
  bool get hasPrevPage => prevPage != null;
}
