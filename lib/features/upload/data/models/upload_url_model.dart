import 'package:GreenConnectMobile/features/upload/domain/entities/upload_url_entity.dart';

class UploadUrlModel extends UploadUrl {
  const UploadUrlModel({required super.uploadUrl, required super.filePath});

  factory UploadUrlModel.fromJson(Map<String, dynamic> json) {
    return UploadUrlModel(
      uploadUrl: json['uploadUrl'] as String,
      filePath: json['filePath'] as String,
    );
  }
}
