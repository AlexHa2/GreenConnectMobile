import 'package:GreenConnectMobile/features/upload/domain/entities/delete_file_request_entity.dart';

class DeleteFileRequestModel extends DeleteFileRequest {
  const DeleteFileRequestModel({required super.filePath});

  Map<String, dynamic> toJson() {
    return {"filePath": filePath};
  }
}
