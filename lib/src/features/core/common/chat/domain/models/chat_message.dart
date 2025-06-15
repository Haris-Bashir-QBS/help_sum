import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ChatMessage {
  final GlobalKey? key;
  final String sender;
  final String text;
  final bool isMe;
  final bool seen;

  ChatMessage({
    this.key,
    required this.sender,
    required this.text,
    required this.isMe,
    required this.seen,
  });
}
 