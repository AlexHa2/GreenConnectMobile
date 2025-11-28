import 'package:GreenConnectMobile/features/offer/domain/entities/collection_offer_entity.dart';

class PaginatedOfferEntity {
  final List<CollectionOfferEntity> data;
  final PaginationInfo pagination;

  PaginatedOfferEntity({
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
