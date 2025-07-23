extension StringCasingExtension on String {
  String capitalizeAndReplaceUnderscore() {
    if (isEmpty) return this;

    final cleaned = replaceAll('_', ' ');
    return cleaned[0].toUpperCase() + cleaned.substring(1);
  }
}
