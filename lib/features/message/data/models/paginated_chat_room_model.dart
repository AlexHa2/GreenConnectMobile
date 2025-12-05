import 'package:GreenConnectMobile/features/message/data/models/chat_room_model.dart';
import 'package:GreenConnectMobile/features/message/domain/entities/paginated_chat_room_entity.dart';

class PaginatedChatRoomModel {
  final List<ChatRoomModel> data;
  final PaginationModel pagination;

  PaginatedChatRoomModel({
    required this.data,
    required this.pagination,
  });

  factory PaginatedChatRoomModel.fromJson(Map<String, dynamic> json) {
    return PaginatedChatRoomModel(
      data: (json['data'] as List?)
              ?.map((e) => ChatRoomModel.fromJson(e))
              .toList() ??
          [],
      pagination: PaginationModel.fromJson(json['pagination'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data.map((e) => e.toJson()).toList(),
      'pagination': pagination.toJson(),
    };
  }

  PaginatedChatRoomEntity toEntity() {
    return PaginatedChatRoomEntity(
      chatRooms: data.map((e) => e.toEntity()).toList(),
      totalRecords: pagination.totalRecords,
      currentPage: pagination.currentPage,
      totalPages: pagination.totalPages,
      nextPage: pagination.nextPage,
      prevPage: pagination.prevPage,
    );
  }
}

class PaginationModel {
  final int totalRecords;
  final int currentPage;
  final int totalPages;
  final int? nextPage;
  final int? prevPage;

  PaginationModel({
    required this.totalRecords,
    required this.currentPage,
    required this.totalPages,
    this.nextPage,
    this.prevPage,
  });

  factory PaginationModel.fromJson(Map<String, dynamic> json) {
    return PaginationModel(
      totalRecords: json['totalRecords'] ?? 0,
      currentPage: json['currentPage'] ?? 1,
      totalPages: json['totalPages'] ?? 0,
      nextPage: json['nextPage'],
      prevPage: json['prevPage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalRecords': totalRecords,
      'currentPage': currentPage,
      'totalPages': totalPages,
      'nextPage': nextPage,
      'prevPage': prevPage,
    };
  }
}
