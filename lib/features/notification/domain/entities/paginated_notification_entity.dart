import 'package:GreenConnectMobile/features/notification/domain/entities/notification_entity.dart';

class PaginatedNotificationEntity {
  final List<NotificationEntity> notifications;
  final int totalRecords;
  final int currentPage;
  final int totalPages;
  final int? nextPage;
  final int? prevPage;

  PaginatedNotificationEntity({
    required this.notifications,
    required this.totalRecords,
    required this.currentPage,
    required this.totalPages,
    this.nextPage,
    this.prevPage,
  });

  bool get hasNextPage => nextPage != null;
  bool get hasPrevPage => prevPage != null;
}
