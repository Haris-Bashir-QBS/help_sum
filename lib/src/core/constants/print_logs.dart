import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

final _logger = Logger();
bool isLoggingEnabled = kDebugMode;

/// Prints logs with optional [tag].
/// Automatically adds caller class and method info to the tag.
///
/// Example:
/// ```dart
/// printLogs('Hello world', tag: 'MyTag');
/// ```
/// Output:
/// [MyTag | ClassName.methodName] Hello world
void printLogs(dynamic message, {String? tag}) {
  if (!isLoggingEnabled) return;

  final callerInfo = _getCallerInfo();

  String output;

  try {
    if (message is String) {
      output = message;
    } else if (message is Map || message is List) {
      const encoder = JsonEncoder.withIndent('  ');
      output = encoder.convert(message);
    } else {
      output = message.toString();
    }
  } catch (e) {
    output = message.toString();
  }

  // Combine custom tag and caller info
  String combinedTag;
  if (tag != null && tag.isNotEmpty && callerInfo.isNotEmpty) {
    combinedTag = '$tag | $callerInfo';
  } else if (tag != null && tag.isNotEmpty) {
    combinedTag = tag;
  } else {
    combinedTag = callerInfo;
  }

  if (combinedTag.isNotEmpty) {
    output = '[$combinedTag] $output';
  }

  _logger.i(output);
}

String _getCallerInfo() {
  try {
    final stackTrace = StackTrace.current.toString().split('\n');
    if (stackTrace.length > 2) {
      final callerLine = stackTrace[2];
      final regex = RegExp(r'#\d+\s+([\w<>]+\.)?([\w<>]+)\s+\(');
      final match = regex.firstMatch(callerLine);
      if (match != null) {
        final className = match.group(1)?.replaceAll('.', '') ?? '';
        final methodName = match.group(2) ?? '';
        return className.isNotEmpty ? '$className.$methodName' : methodName;
      }
    }
  } catch (_) {}

  return '';
}
