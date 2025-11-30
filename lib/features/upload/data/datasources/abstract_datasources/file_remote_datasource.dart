import 'dart:typed_data';

import 'package:GreenConnectMobile/features/upload/data/models/delete_file_request_model.dart';
import 'package:GreenConnectMobile/features/upload/data/models/recognize_scrap_response_model.dart';
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

  /// Upload file for scrap-post
  Future<UploadUrlModel> uploadFileForScrapPost(UploadFileRequestModel request);

  /// Upload file for complaint
  Future<UploadUrlModel> uploadFileForComplaint(UploadFileRequestModel request);

  /// Recognize scrap from image using AI
  Future<RecognizeScrapResponseModel> recognizeScrap(Uint8List imageBytes, String fileName);

  Future<bool> deleteFile(DeleteFileRequestModel request);

  Future<bool> uploadBinaryFile({
    required String uploadUrl,
    required Uint8List fileBytes,
    required String contentType,
  });
}
