import 'package:GreenConnectMobile/features/complaint/domain/entities/complaint_entity.dart';

class ComplaintListResponse {
  final List<ComplaintEntity> data;
  final PaginationInfo pagination;

  ComplaintListResponse({
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
