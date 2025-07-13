import 'dart:io';
import 'package:dio/dio.dart';
import 'package:mime/mime.dart';

class UploadFileRequest {
  final List<File> files;
  UploadFileRequest(this.files);

  FormData toFormData() {
    return FormData.fromMap({
      'files':
          files.map((file) {
            final mimeType =
                lookupMimeType(file.path) ?? 'application/octet-stream';
            return MultipartFile.fromFileSync(
              file.path,
              filename: file.uri.pathSegments.last,
              contentType: DioMediaType.parse(mimeType),
            );
          }).toList(),
    });
  }
}

class MediaType {
  static MediaType parse(String mimeType) {
    final parts = mimeType.split('/');
    return MediaType(parts[0], parts.length > 1 ? parts[1] : '');
  }

  final String type;
  final String subtype;

  MediaType(this.type, this.subtype);
}
