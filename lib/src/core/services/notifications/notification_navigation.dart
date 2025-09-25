import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:help_sum/src/core/router/app_routes.dart';
import 'package:help_sum/src/core/services/local_storage_service.dart';
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
    final String? jobId = data['jobId'] as String?;

    final GoRouter _router = GoRouter.of(
      SessionManager.navigatorKey.currentContext!,
    );
    final isLogin = LocalStorageService().getAccessToken();
    final context = SessionManager.navigatorKey.currentContext;

    if (isLogin != null && isLogin.isNotEmpty) {
      if (jobId != null) {
        if (_router.state.name == AppRoutes.bookingTracker) {
          context?.pushReplacementNamed(
            AppRoutes.bookingTracker,
            extra: {
              'job': jobId,
            },
          );
        } else {
          context?.pushNamed(
            AppRoutes.bookingTracker,
            extra: {
              'job': jobId,
            },
          );
        }
      }
    } else {
      context?.goNamed(AppRoutes.roleSelection);
    }
  }

  /// Placeholder: replace with real mapping from id -> domain entity.
  static dynamic _buildJobDataPlaceholder(String? id) {
    return null;
  }
}
