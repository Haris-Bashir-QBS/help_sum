class UploadedFileModel extends UploadedFileEntity {
  UploadedFileModel({
    required super.originalName,
    required super.mimeType,
    required super.url,
  });

  factory UploadedFileModel.fromJson(Map<String, dynamic> json) {
    return UploadedFileModel(
      originalName: json['originalName'] ?? '',
      mimeType: json['mimeType'] ?? '',
      url: json['url'] ?? '',
    );
  }
}

class UploadedFileEntity {
  final String originalName;
  final String mimeType;
  final String url;

  UploadedFileEntity({
    required this.originalName,
    required this.mimeType,
    required this.url,
  });
}
