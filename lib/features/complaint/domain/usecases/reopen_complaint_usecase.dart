import 'package:GreenConnectMobile/features/complaint/domain/entities/complaint_entity.dart';
import 'package:GreenConnectMobile/features/complaint/domain/repositories/complaint_repository.dart';

class ReopenComplaintUsecase {
  final ComplaintRepository _repository;

  ReopenComplaintUsecase(this._repository);

  Future<ComplaintEntity> call(String complaintId) async {
    return await _repository.reopenComplaint(complaintId);
  }
}
