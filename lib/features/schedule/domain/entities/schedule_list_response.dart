import 'package:GreenConnectMobile/features/schedule/domain/entities/schedule_proposal_entity.dart';

class ScheduleListResponse {
  final List<ScheduleProposalEntity> data;
  final PaginationInfo pagination;

  ScheduleListResponse({
    required this.data,
    required this.pagination,
  });
}

class PaginationInfo {
  final int totalRecords;
  final int currentPage;
  final int totalPages;
  final int? nextPage;
  final int? prevPage;

  PaginationInfo({
    required this.totalRecords,
    required this.currentPage,
    required this.totalPages,
    this.nextPage,
    this.prevPage,
  });
}
