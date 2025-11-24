class PaginationEntity {
  final int totalRecords;
  final int currentPage;
  final int totalPages;
  final int? nextPage;
  final int? prevPage;

  PaginationEntity({
    required this.totalRecords,
    required this.currentPage,
    required this.totalPages,
    this.nextPage,
    this.prevPage,
  });
}

class PaginatedResponseEntity<T> {
  final List<T> data;
  final PaginationEntity pagination;

  PaginatedResponseEntity({required this.data, required this.pagination});
}
