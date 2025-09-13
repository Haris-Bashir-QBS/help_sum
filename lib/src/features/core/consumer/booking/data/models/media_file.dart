import 'package:help_sum/src/core/enums/media_type.dart';

class MediaFile {
  final String path;
  final Media media;
  final MediaType mediaType;

  MediaFile({required this.media, required this.mediaType, required this.path});
}
