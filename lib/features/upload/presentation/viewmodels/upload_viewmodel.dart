import 'package:GreenConnectMobile/core/error/failure.dart';
import 'package:GreenConnectMobile/features/upload/domain/entities/delete_file_request_entity.dart';
import 'package:GreenConnectMobile/features/upload/domain/entities/upload_request_entity.dart';
import 'package:GreenConnectMobile/features/upload/domain/usecases/delete_file_usecase.dart';
import 'package:GreenConnectMobile/features/upload/domain/usecases/recognize_scrap_usecase.dart';
import 'package:GreenConnectMobile/features/upload/domain/usecases/upload_binary_file_usecase.dart';
import 'package:GreenConnectMobile/features/upload/domain/usecases/upload_file_for_complaint_usecase.dart';
import 'package:GreenConnectMobile/features/upload/domain/usecases/upload_file_for_scrap_post_usecase.dart';
import 'package:GreenConnectMobile/features/upload/domain/usecases/upload_file_usecase.dart';
import 'package:GreenConnectMobile/features/upload/domain/usecases/upload_file_with_entity_usecase.dart';
import 'package:GreenConnectMobile/features/upload/presentation/providers/upload_provider.dart';
import 'package:GreenConnectMobile/features/upload/presentation/viewmodels/states/upload_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UploadViewModel extends Notifier<UploadState> {
  late UploadFileUseCase _uploadFileUseCase;
  late UploadFileWithEntityUseCase _uploadFileWithEntityUseCase;
  late UploadBinaryFileUseCase _uploadBinaryFileUseCase;
  late DeleteFileUseCase _deleteFileUseCase;
  late UploadFileForScrapPostUseCase _uploadFileForScrapPostUseCase;
  late UploadFileForComplaintUseCase _uploadFileForComplaintUseCase;
  late RecognizeScrapUseCase _recognizeScrapUseCase;

  @override
  UploadState build() {
    _uploadFileUseCase = ref.read(uploadFileUsecaseProvider);
    _uploadFileWithEntityUseCase = ref.read(
      uploadFileWithEntityUsecaseProvider,
    );
    _uploadBinaryFileUseCase = ref.read(uploadBinaryFileUsecaseProvider);
    _deleteFileUseCase = ref.read(deleteFileUsecaseProvider);
    _uploadFileForScrapPostUseCase = ref.read(uploadFileForScrapPostUsecaseProvider);
    _uploadFileForComplaintUseCase = ref.read(uploadFileForComplaintUsecaseProvider);
    _recognizeScrapUseCase = ref.read(recognizeScrapUsecaseProvider);
    return UploadState();
  }  // ---------------- REQUEST SIGNED URL (NO ENTITY) ----------------
  Future<void> requestUploadUrl(UploadFileRequest request) async {
    state = state.copyWith(isLoading: true);
    try {
      final response = await _uploadFileUseCase(request);
      state = state.copyWith(isLoading: false, uploadUrl: response);
    } catch (e, stack) {
      if (e is AppException) {
        debugPrint('❌ ERROR REQUEST UPLOAD URL: ${e.message}');
      }
      debugPrint('📌 STACK TRACE: $stack');
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> requestUploadUrlWithEntity(
    String entityType,
    UploadFileWithEntityRequest request,
  ) async {
    state = state.copyWith(isLoading: true);
    try {
      final response = await _uploadFileWithEntityUseCase(entityType, request);
      state = state.copyWith(isLoading: false, uploadUrl: response);
    } catch (e, stack) {
      if (e is AppException) {
        debugPrint('❌ ERROR REQUEST UPLOAD URL WITH ENTITY: ${e.message}');
      }
      debugPrint('📌 STACK TRACE: $stack');
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> uploadBinary({
    required String uploadUrl,
    required Uint8List fileBytes,
    required String contentType,
  }) async {
    state = state.copyWith(isLoading: true);
    try {
      await _uploadBinaryFileUseCase(
        uploadUrl: uploadUrl,
        fileBytes: fileBytes,
        contentType: contentType,
      );
      state = state.copyWith(isLoading: false, isUploaded: true);
    } catch (e, stack) {
      if (e is AppException) {
        debugPrint('❌ ERROR UPLOAD BINARY FILE: ${e.message}');
      }
      debugPrint('📌 STACK TRACE: $stack');
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> deleteFile(DeleteFileRequest request) async {
    state = state.copyWith(isLoading: true);
    try {
      await _deleteFileUseCase(request);
      state = state.copyWith(isLoading: false, deleted: true);
    } catch (e, stack) {
      if (e is AppException) {
        debugPrint('❌ ERROR DELETE FILE SYSTEM: ${e.message}');
      }
      debugPrint('📌 STACK TRACE: $stack');
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> requestUploadUrlForScrapPost(UploadFileRequest request) async {
    state = state.copyWith(isLoading: true);
    try {
      final response = await _uploadFileForScrapPostUseCase(request);
      state = state.copyWith(isLoading: false, uploadUrl: response);
    } catch (e, stack) {
      if (e is AppException) {
        debugPrint('❌ ERROR REQUEST UPLOAD URL FOR SCRAP POST: ${e.message}');
      }
      debugPrint('📌 STACK TRACE: $stack');
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> requestUploadUrlForComplaint(UploadFileRequest request) async {
    state = state.copyWith(isLoading: true);
    try {
      final response = await _uploadFileForComplaintUseCase(request);
      state = state.copyWith(isLoading: false, uploadUrl: response);
    } catch (e, stack) {
      if (e is AppException) {
        debugPrint('❌ ERROR REQUEST UPLOAD URL FOR COMPLAINT: ${e.message}');
      }
      debugPrint('📌 STACK TRACE: $stack');
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> recognizeScrap(Uint8List imageBytes, String fileName) async {
    state = state.copyWith(isLoading: true);
    try {
      final response = await _recognizeScrapUseCase(imageBytes, fileName);
      state = state.copyWith(isLoading: false, recognizeScrapResponse: response);
    } catch (e, stack) {
      if (e is AppException) {
        debugPrint('❌ ERROR RECOGNIZE SCRAP: ${e.message}');
      }
      debugPrint('📌 STACK TRACE: $stack');
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  void reset() {
    state = UploadState();
  }
}
