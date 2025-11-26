import 'dart:typed_data';
import 'package:GreenConnectMobile/features/upload/domain/repository/file_repository.dart';

class UploadBinaryFileUseCase {
  final FileRepository repository;

  UploadBinaryFileUseCase(this.repository);

  Future<void> call({
    required String uploadUrl,
    required Uint8List fileBytes,
    required String contentType,
  }) {
    return repository.uploadBinaryFile(
      uploadUrl: uploadUrl,
      fileBytes: fileBytes,
      contentType: contentType,
    );
  }
}
