import 'package:GreenConnectMobile/features/upload/domain/entities/recognize_scrap_response_entity.dart';
import 'package:GreenConnectMobile/features/upload/domain/entities/upload_url_entity.dart';

class UploadState {
  final bool isLoading;
  final UploadUrl? uploadUrl;
  final bool isUploaded;
  final bool deleted;
  final RecognizeScrapResponse? recognizeScrapResponse;
  final String? errorMessage;

  UploadState({
    this.isLoading = false,
    this.uploadUrl,
    this.isUploaded = false,
    this.deleted = false,
    this.recognizeScrapResponse,
    this.errorMessage,
  });

  UploadState copyWith({
    bool? isLoading,
    UploadUrl? uploadUrl,
    bool? isUploaded,
    bool? deleted,
    RecognizeScrapResponse? recognizeScrapResponse,
    String? errorMessage,
  }) {
    return UploadState(
      isLoading: isLoading ?? this.isLoading,
      uploadUrl: uploadUrl ?? this.uploadUrl,
      isUploaded: isUploaded ?? this.isUploaded,
      deleted: deleted ?? this.deleted,
      recognizeScrapResponse: recognizeScrapResponse ?? this.recognizeScrapResponse,
      errorMessage: errorMessage,
    );
  }
}
