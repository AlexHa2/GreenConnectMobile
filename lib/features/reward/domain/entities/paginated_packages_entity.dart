import 'package:GreenConnectMobile/features/reward/domain/entities/package_entity.dart';

class PaginationEntity {
  final int totalRecords;
  final int currentPage;
  final int totalPages;
  final int nextPage;
  final int prevPage;

  PaginationEntity({
    required this.totalRecords,
    required this.currentPage,
    required this.totalPages,
    required this.nextPage,
    required this.prevPage,
  });
}

class PaginatedPackagesEntity {
  final List<PackageEntity> data;
  final PaginationEntity pagination;

  PaginatedPackagesEntity({
    required this.data,
    required this.pagination,
  });
}
