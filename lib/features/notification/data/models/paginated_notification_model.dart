import 'package:GreenConnectMobile/features/notification/data/models/notification_model.dart';
import 'package:GreenConnectMobile/features/notification/domain/entities/paginated_notification_entity.dart';

class PaginatedNotificationModel {
  final List<NotificationModel> data;
  final PaginationModel pagination;

  PaginatedNotificationModel({required this.data, required this.pagination});

  factory PaginatedNotificationModel.fromJson(Map<String, dynamic> json) {
    return PaginatedNotificationModel(
      data:
          (json['data'] as List?)
              ?.map((e) => NotificationModel.fromJson(e))
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

  PaginatedNotificationEntity toEntity() {
    return PaginatedNotificationEntity(
      notifications: data.map((e) => e.toEntity()).toList(),
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
