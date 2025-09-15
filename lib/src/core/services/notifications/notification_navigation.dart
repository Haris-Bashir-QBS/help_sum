import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:help_sum/src/core/router/app_routes.dart';
import 'package:help_sum/src/core/services/session_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

/// Centralized navigation logic for notification taps from any app state.
class NotificationNavigation {
  NotificationNavigation._();

  /// Handle FCM message tap coming from background/terminated via FCM APIs.
  static Future<void> handleMessageTap(RemoteMessage message) async {
    try {
      await _navigateFromData(message.data);
    } catch (e) {
      if (kDebugMode) debugPrint('handleMessageTap error: $e');
    }
  }

  /// Handle local notification payload tap.
  static Future<void> handlePayloadTap(String? payload) async {
    if (payload == null || payload.isEmpty) return;
    try {
      final Map<String, dynamic> map =
          jsonDecode(payload) as Map<String, dynamic>;
      final Map<String, dynamic> data =
          (map['data'] as Map).cast<String, dynamic>();
      await _navigateFromData(data);
    } catch (e) {
      if (kDebugMode) debugPrint('handlePayloadTap error: $e');
    }
  }

  /// Decide where to navigate based on message data.
  /// Expected keys (example):
  ///   type: chat|booking|job|inbox
  ///   id: resource id
  ///   tabName: optional tab selector
  static Future<void> _navigateFromData(Map<String, dynamic> data) async {
    final String? type = data['type'] as String?;
    final String? id = data['id']?.toString();
    final String? tabName = data['tabName'] as String?;

    final GoRouter router = GoRouter.of(
      SessionManager.navigatorKey.currentContext!,
    );

    switch (type) {
      case 'chat':
        // You may need to fetch an InboxChatEntity by id before navigate.
        // For now navigate to inbox/notifications hub.
        router.pushNamed(AppRoutes.inboxAndNotifcations);
        break;
      case 'booking':
        // Navigate to booking detail/tracker depending on tabName
        router.pushNamed(
          AppRoutes.bookingDetail,
          extra: {'job': _buildJobDataPlaceholder(id), 'tabName': tabName},
        );
        break;
      case 'job':
        router.pushNamed(
          AppRoutes.jobDetail,
          extra: {'job': _buildJobDataPlaceholder(id), 'tabName': tabName},
        );
        break;
      default:
        router.pushNamed(AppRoutes.inboxAndNotifcations);
    }
  }

  /// Placeholder: replace with real mapping from id -> domain entity.
  static dynamic _buildJobDataPlaceholder(String? id) {
    return null;
  }
}
