import 'package:GreenConnectMobile/features/complaint/domain/entities/complaint_entity.dart';
import 'package:GreenConnectMobile/features/complaint/domain/entities/update_complaint_request.dart';
import 'package:GreenConnectMobile/features/complaint/domain/repositories/complaint_repository.dart';

class UpdateComplaintUsecase {
  final ComplaintRepository _repository;

  UpdateComplaintUsecase(this._repository);

  Future<ComplaintEntity> call({
    required String complaintId,
    required UpdateComplaintRequest request,
  }) async {
    return await _repository.updateComplaint(
      complaintId: complaintId,
      request: request,
    );
  }
}
