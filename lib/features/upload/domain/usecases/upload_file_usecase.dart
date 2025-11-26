import 'package:GreenConnectMobile/features/upload/domain/entities/upload_request_entity.dart';
import 'package:GreenConnectMobile/features/upload/domain/entities/upload_url_entity.dart';
import 'package:GreenConnectMobile/features/upload/domain/repository/file_repository.dart';

class UploadFileUseCase {
  final FileRepository repository;

  UploadFileUseCase(this.repository);

  Future<UploadUrl> call(UploadFileRequest request) {
    return repository.uploadFile(request);
  }
}
