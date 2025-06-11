import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:help_sum/src/core/constants/app_texts.dart';
import 'package:help_sum/src/core/router/app_routes.dart';

class SessionManager {
  SessionManager._();

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static Future<void> showSessionExpiredDialog() async {
    final context = navigatorKey.currentContext;
    if (context == null) return;
    await _clearData();
    await showDialog(
      context: navigatorKey.currentContext!,
      barrierDismissible: false,
      builder:
          (context) => PopScope(
            canPop: false,
            child: AlertDialog(
              title: Text(AppTexts.sessionExpired),
              content: Text(AppTexts.pleaseLoginAgain),
              actions: [
                TextButton(
                  onPressed: () {
                    context.goNamed(AppRoutes.login);
                    // logoutUser();
                  },
                  child: Text(AppTexts.backToLogin),
                ),
              ],
            ),
          ),
    );
  }

  static Future<void> logoutUser({required VoidCallback onSuccess}) async {
    await _clearData();
    onSuccess.call();
  }


  static Future<void> _clearData() async {
    // Clear User  
  }
}
