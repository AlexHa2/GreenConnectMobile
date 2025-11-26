import 'package:GreenConnectMobile/features/upload/domain/entities/upload_request_entity.dart';

class UploadFileRequestModel extends UploadFileRequest {
  const UploadFileRequestModel({
    required super.fileName,
    required super.contentType,
  });

  Map<String, dynamic> toJson() {
    return {"fileName": fileName, "contentType": contentType};
  }
}

class UploadFileWithEntityRequestModel extends UploadFileWithEntityRequest {
  const UploadFileWithEntityRequestModel({
    required super.fileName,
    required super.contentType,
    required super.entityId,
  });

  Map<String, dynamic> toJson() {
    return {
      "fileName": fileName,
      "contentType": contentType,
      "entityId": entityId,
    };
  }
}
