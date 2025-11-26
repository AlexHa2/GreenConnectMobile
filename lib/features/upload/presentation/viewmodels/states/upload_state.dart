import 'package:GreenConnectMobile/features/upload/domain/entities/upload_url_entity.dart';

class UploadState {
  final bool isLoading;
  final UploadUrl? uploadUrl;
  final bool isUploaded;
  final bool deleted;
  final String? errorMessage;

  UploadState({
    this.isLoading = false,
    this.uploadUrl,
    this.isUploaded = false,
    this.deleted = false,
    this.errorMessage,
  });

  UploadState copyWith({
    bool? isLoading,
    UploadUrl? uploadUrl,
    bool? isUploaded,
    bool? deleted,
    String? errorMessage,
  }) {
    return UploadState(
      isLoading: isLoading ?? this.isLoading,
      uploadUrl: uploadUrl ?? this.uploadUrl,
      isUploaded: isUploaded ?? this.isUploaded,
      deleted: deleted ?? this.deleted,
      errorMessage: errorMessage,
    );
  }
}
