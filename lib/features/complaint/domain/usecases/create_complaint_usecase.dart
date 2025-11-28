import 'package:GreenConnectMobile/features/complaint/domain/entities/complaint_entity.dart';
import 'package:GreenConnectMobile/features/complaint/domain/entities/create_complaint_request.dart';
import 'package:GreenConnectMobile/features/complaint/domain/repositories/complaint_repository.dart';

class CreateComplaintUsecase {
  final ComplaintRepository _repository;

  CreateComplaintUsecase(this._repository);

  Future<ComplaintEntity> call(CreateComplaintRequest request) async {
    return await _repository.createComplaint(request);
  }
}
