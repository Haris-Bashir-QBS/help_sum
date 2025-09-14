import 'package:flutter/material.dart';

class TimeUtils {
  TimeUtils._();

  /// Formats a DateTime to a human-readable relative time string
  /// Examples: "2h ago", "3d ago", "Just now", "12:30"
  static String formatRelativeTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  /// Formats a DateTime to a detailed time string for chat messages
  /// Examples: "12:30", "2/12 14:30", "Just now"
  static String formatChatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inDays > 0) {
      return '${time.day}/${time.month} ${time.hour}:${time.minute.toString().padLeft(2, '0')}';
    } else if (difference.inHours > 0) {
      return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
    } else if (difference.inMinutes > 0) {
      return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
    } else {
      return 'Just now';
    }
  }

  /// Formats a DateTime to a short time string
  /// Examples: "12:30", "2/12", "Yesterday"
  static String formatShortTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inDays > 1) {
      return '${time.day}/${time.month}';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inHours > 0) {
      return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
    } else if (difference.inMinutes > 0) {
      return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
    } else {
      return 'Just now';
    }
  }

  /// Formats a DateTime to a full date and time string
  /// Examples: "2 Dec 2023, 12:30 PM", "Today, 12:30 PM"
  static String formatFullDateTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    final timeString = '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
    
    if (difference.inDays > 1) {
      final months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      return '${time.day} ${months[time.month - 1]} ${time.year}, $timeString';
    } else if (difference.inDays == 1) {
      return 'Yesterday, $timeString';
    } else {
      return 'Today, $timeString';
    }
  }

  /// Checks if two DateTime objects are on the same day
  static bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
           date1.month == date2.month &&
           date1.day == date2.day;
  }

  /// Gets the start of the day for a given DateTime
  static DateTime startOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  /// Gets the end of the day for a given DateTime
  static DateTime endOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59, 999);
  }
}
