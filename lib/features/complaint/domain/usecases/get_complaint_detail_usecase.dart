import 'package:GreenConnectMobile/features/complaint/domain/entities/complaint_entity.dart';
import 'package:GreenConnectMobile/features/complaint/domain/repositories/complaint_repository.dart';

class GetComplaintDetailUsecase {
  final ComplaintRepository _repository;

  GetComplaintDetailUsecase(this._repository);

  Future<ComplaintEntity> call(String complaintId) async {
    return await _repository.getComplaintDetail(complaintId);
  }
}
