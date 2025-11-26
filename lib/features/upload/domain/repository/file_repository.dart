import 'dart:typed_data';

import 'package:GreenConnectMobile/features/upload/domain/entities/delete_file_request_entity.dart';
import 'package:GreenConnectMobile/features/upload/domain/entities/upload_request_entity.dart';
import 'package:GreenConnectMobile/features/upload/domain/entities/upload_url_entity.dart';

abstract class FileRepository {
  Future<UploadUrl> uploadFile(UploadFileRequest request);

  Future<UploadUrl> uploadFileWithEntity(
    String entityType,
    UploadFileWithEntityRequest request,
  );

  Future<bool> deleteFile(DeleteFileRequest request);
  Future<bool> uploadBinaryFile({
    required String uploadUrl,
    required Uint8List fileBytes,
    required String contentType,
  });
}
