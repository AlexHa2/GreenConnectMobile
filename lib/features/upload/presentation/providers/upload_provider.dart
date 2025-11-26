import 'package:GreenConnectMobile/features/upload/data/datasources/abstract_datasources/file_remote_datasource.dart';
import 'package:GreenConnectMobile/features/upload/data/datasources/file_remote_datasource_impl.dart';
import 'package:GreenConnectMobile/features/upload/data/repository/file_repository_impl.dart';
import 'package:GreenConnectMobile/features/upload/domain/usecases/delete_file_usecase.dart';
import 'package:GreenConnectMobile/features/upload/domain/usecases/upload_binary_file_usecase.dart';
import 'package:GreenConnectMobile/features/upload/domain/usecases/upload_file_usecase.dart';
import 'package:GreenConnectMobile/features/upload/domain/usecases/upload_file_with_entity_usecase.dart';
import 'package:GreenConnectMobile/features/upload/presentation/viewmodels/states/upload_state.dart';
import 'package:GreenConnectMobile/features/upload/presentation/viewmodels/upload_viewmodel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ---------------- Datasource ----------------
final fileRemoteDatasourceProvider = Provider<FileRemoteDataSource>((ref) {
  return FileRemoteDataSourceImpl();
});

// ---------------- Repository ----------------
final fileRepositoryProvider = Provider<FileRepositoryImpl>((ref) {
  final datasource = ref.read(fileRemoteDatasourceProvider);
  return FileRepositoryImpl(datasource);
});

// ---------------- UseCases ----------------
final uploadFileUsecaseProvider = Provider<UploadFileUseCase>((ref) {
  return UploadFileUseCase(ref.read(fileRepositoryProvider));
});

final uploadFileWithEntityUsecaseProvider =
    Provider<UploadFileWithEntityUseCase>((ref) {
      return UploadFileWithEntityUseCase(ref.read(fileRepositoryProvider));
    });

final uploadBinaryFileUsecaseProvider = Provider<UploadBinaryFileUseCase>((
  ref,
) {
  return UploadBinaryFileUseCase(ref.read(fileRepositoryProvider));
});

final deleteFileUsecaseProvider = Provider<DeleteFileUseCase>((ref) {
  return DeleteFileUseCase(ref.read(fileRepositoryProvider));
});

// ---------------- ViewModel ----------------
final uploadViewModelProvider = NotifierProvider<UploadViewModel, UploadState>(
  () => UploadViewModel(),
);
