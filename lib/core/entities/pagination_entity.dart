class PaginationEntity<T> {
  final List<T> data;
  final int totalRecords;
  final int currentPage;
  final int totalPages;
  final int? nextPage;
  final int? prevPage;

  PaginationEntity({
    required this.data,
    required this.totalRecords,
    required this.currentPage,
    required this.totalPages,
    this.nextPage,
    this.prevPage,
  });
}
