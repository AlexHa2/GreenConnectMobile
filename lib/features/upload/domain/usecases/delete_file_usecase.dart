import 'package:GreenConnectMobile/features/upload/domain/entities/delete_file_request_entity.dart';
import 'package:GreenConnectMobile/features/upload/domain/repository/file_repository.dart';

class DeleteFileUseCase {
  final FileRepository repository;

  DeleteFileUseCase(this.repository);

  Future<void> call(DeleteFileRequest request) {
    return repository.deleteFile(request);
  }
}
