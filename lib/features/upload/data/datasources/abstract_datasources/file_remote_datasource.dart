import 'dart:typed_data';

import 'package:GreenConnectMobile/features/upload/data/models/delete_file_request_model.dart';
import 'package:GreenConnectMobile/features/upload/data/models/upload_request_model.dart';
import 'package:GreenConnectMobile/features/upload/data/models/upload_url_model.dart';

abstract class FileRemoteDataSource {
  /// Upload avatar or verification (no entityId)
  Future<UploadUrlModel> uploadFile(UploadFileRequestModel request);

  /// Upload with entityId (scrap-post, check-in)
  Future<UploadUrlModel> uploadFileWithEntity(
    String entityType,
    UploadFileWithEntityRequestModel request,
  );

  Future<bool> deleteFile(DeleteFileRequestModel request);

  Future<bool> uploadBinaryFile({
    required String uploadUrl,
    required Uint8List fileBytes,
    required String contentType,
  });
}
