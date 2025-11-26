import 'dart:typed_data';

import 'package:GreenConnectMobile/core/di/auth_injector.dart';
import 'package:GreenConnectMobile/core/network/api_client.dart';
import 'package:GreenConnectMobile/features/upload/data/datasources/abstract_datasources/file_remote_datasource.dart';
import 'package:GreenConnectMobile/features/upload/data/models/delete_file_request_model.dart';
import 'package:GreenConnectMobile/features/upload/data/models/upload_request_model.dart';
import 'package:GreenConnectMobile/features/upload/data/models/upload_url_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class FileRemoteDataSourceImpl implements FileRemoteDataSource {
  final ApiClient _apiClient = sl<ApiClient>();
  final String _baseUrl = '/v1/files';

  @override
  Future<UploadUrlModel> uploadFile(UploadFileRequestModel request) async {
    final response = await _apiClient.post(
      '$_baseUrl/upload-url/avatar',
      data: request.toJson(),
    );
    return UploadUrlModel.fromJson(response.data);
  }

  @override
  Future<UploadUrlModel> uploadFileWithEntity(
    String entityType,
    UploadFileWithEntityRequestModel request,
  ) async {
    final response = await _apiClient.post(
      '$_baseUrl/upload-url/$entityType',
      data: request.toJson(),
    );
    return UploadUrlModel.fromJson(response.data);
  }

  @override
  Future<bool> deleteFile(DeleteFileRequestModel request) async {
    final response = await _apiClient.delete(_baseUrl, data: request.toJson());
    return response.statusCode == 204;
  }

  @override
  Future<bool> uploadBinaryFile({
    required String uploadUrl,
    required Uint8List fileBytes,
    required String contentType,
  }) async {
    final response = await _apiClient.put(
      uploadUrl,
      data: fileBytes,
      options: Options(
        headers: {
          'Content-Type': contentType,
          'Content-Length': fileBytes.length,
        },
      ),
    );
    debugPrint('Upload binary file response status: ');
    return response.statusCode == 200 || response.statusCode == 201;
  }
}
