import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:help_sum/src/core/router/app_router.dart';
import 'package:help_sum/src/core/router/app_routes.dart';
import 'package:help_sum/src/core/services/local_storage_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:help_sum/src/features/core/common/main_navigation/pages/main_navigation_page.dart';

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
    final isLogin = LocalStorageService().getAccessToken();

    if (isLogin != null && isLogin.isNotEmpty) {
      if (jobId != null) {
        if (appRouter.state.name == AppRoutes.bookingTracker) {
          appRouter.pushReplacementNamed(
            AppRoutes.bookingTracker,
            extra: {'job': jobId},
          );
        } else {
          appRouter.goNamed(AppRoutes.bookingTracker, extra: {'job': jobId});
        }
      } else {
        // Always set the main navigation index directly
        mainNavKey.currentState?.setIndex(2); // or whatever index you want
        if (appRouter.state.name != AppRoutes.mainNavigation) {
          appRouter.replaceNamed(AppRoutes.mainNavigation, extra: {"index": 2});
        }
      }
    } else {
      appRouter.goNamed(AppRoutes.roleSelection);
    }
  }

  /// Placeholder: replace with real mapping from id -> domain entity.
  static dynamic _buildJobDataPlaceholder(String? id) {
    return null;
  }
}
