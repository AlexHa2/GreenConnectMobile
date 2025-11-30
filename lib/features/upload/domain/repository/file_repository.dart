import 'dart:typed_data';

import 'package:GreenConnectMobile/features/upload/domain/entities/delete_file_request_entity.dart';
import 'package:GreenConnectMobile/features/upload/domain/entities/recognize_scrap_response_entity.dart';
import 'package:GreenConnectMobile/features/upload/domain/entities/upload_request_entity.dart';
import 'package:GreenConnectMobile/features/upload/domain/entities/upload_url_entity.dart';

abstract class FileRepository {
  Future<UploadUrl> uploadFile(UploadFileRequest request);

  Future<UploadUrl> uploadFileWithEntity(
    String entityType,
    UploadFileWithEntityRequest request,
  );

  Future<UploadUrl> uploadFileForScrapPost(UploadFileRequest request);

  Future<UploadUrl> uploadFileForComplaint(UploadFileRequest request);

  Future<RecognizeScrapResponse> recognizeScrap(Uint8List imageBytes, String fileName);

  Future<bool> deleteFile(DeleteFileRequest request);
  Future<bool> uploadBinaryFile({
    required String uploadUrl,
    required Uint8List fileBytes,
    required String contentType,
  });
}
