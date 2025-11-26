class UploadFileRequest {
  final String fileName;
  final String contentType;

  const UploadFileRequest({required this.fileName, required this.contentType});
}

class UploadFileWithEntityRequest {
  final String fileName;
  final String contentType;
  final String entityId;

  const UploadFileWithEntityRequest({
    required this.fileName,
    required this.contentType,
    required this.entityId,
  });
}
