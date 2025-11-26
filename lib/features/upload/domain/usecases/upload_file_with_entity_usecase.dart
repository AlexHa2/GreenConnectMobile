import 'package:GreenConnectMobile/features/upload/domain/entities/upload_request_entity.dart';
import 'package:GreenConnectMobile/features/upload/domain/entities/upload_url_entity.dart';
import 'package:GreenConnectMobile/features/upload/domain/repository/file_repository.dart';

class UploadFileWithEntityUseCase {
  final FileRepository repository;

  UploadFileWithEntityUseCase(this.repository);

  Future<UploadUrl> call(String entityType, UploadFileWithEntityRequest request) {
    return repository.uploadFileWithEntity(entityType, request);
  }
}
