import 'package:GreenConnectMobile/features/complaint/domain/entities/complaint_list_response.dart';
import 'package:GreenConnectMobile/features/complaint/domain/repositories/complaint_repository.dart';

class GetAllComplaintsUsecase {
  final ComplaintRepository _repository;

  GetAllComplaintsUsecase(this._repository);

  Future<ComplaintListResponse> call({
    int? pageNumber,
    int? pageSize,
    bool? sortByCreatedAt,
    String? sortByStatus,
  }) async {
    return await _repository.getAllComplaints(
      pageNumber: pageNumber,
      pageSize: pageSize,
      sortByCreatedAt: sortByCreatedAt,
      sortByStatus: sortByStatus,
    );
  }
}
