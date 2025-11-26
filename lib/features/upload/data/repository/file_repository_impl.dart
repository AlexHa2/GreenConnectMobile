import 'dart:typed_data';
import 'package:GreenConnectMobile/core/error/exception_mapper.dart';
import 'package:GreenConnectMobile/features/upload/data/datasources/abstract_datasources/file_remote_datasource.dart';
import 'package:GreenConnectMobile/features/upload/data/models/delete_file_request_model.dart';
import 'package:GreenConnectMobile/features/upload/data/models/upload_request_model.dart';
import 'package:GreenConnectMobile/features/upload/domain/entities/delete_file_request_entity.dart';
import 'package:GreenConnectMobile/features/upload/domain/entities/upload_request_entity.dart';
import 'package:GreenConnectMobile/features/upload/domain/entities/upload_url_entity.dart';
import 'package:GreenConnectMobile/features/upload/domain/repository/file_repository.dart';

class FileRepositoryImpl implements FileRepository {
  final FileRemoteDataSource remote;

  FileRepositoryImpl(this.remote);

  @override
  Future<UploadUrl> uploadFile(UploadFileRequest request) {
    return guard(() async {
      final model = UploadFileRequestModel(
        fileName: request.fileName,
        contentType: request.contentType,
      );

      final response = await remote.uploadFile(model);
      return UploadUrl(
        uploadUrl: response.uploadUrl,
        filePath: response.filePath,
      );
    });
  }

  @override
  Future<UploadUrl> uploadFileWithEntity(
    String entityType,
    UploadFileWithEntityRequest request,
  ) {
    return guard(() async {
      final model = UploadFileWithEntityRequestModel(
        fileName: request.fileName,
        contentType: request.contentType,
        entityId: request.entityId,
      );

      final response = await remote.uploadFileWithEntity(entityType, model);
      return UploadUrl(
        uploadUrl: response.uploadUrl,
        filePath: response.filePath,
      );
    });
  }

  @override
  Future<bool> deleteFile(DeleteFileRequest request) {
    return guard(() async {
      final model = DeleteFileRequestModel(filePath: request.filePath);
      await remote.deleteFile(model);
      return true;
    });
  }

  @override
  Future<bool> uploadBinaryFile({
    required String uploadUrl,
    required Uint8List fileBytes,
    required String contentType,
  }) {
    return guard(() async {
      await remote.uploadBinaryFile(
        uploadUrl: uploadUrl,
        fileBytes: fileBytes,
        contentType: contentType,
      );
      return true;
    });
  }
}
