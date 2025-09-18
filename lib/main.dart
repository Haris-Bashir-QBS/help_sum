import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:help_sum/src/core/constants/app_secrets.dart';
import 'package:help_sum/src/core/constants/app_texts.dart';
import 'package:help_sum/src/core/dependency_injection/di_barrel.dart';
import 'package:help_sum/src/core/extensions/context_extensions.dart';
import 'package:help_sum/src/core/router/app_router.dart';
import 'package:help_sum/src/core/themes/app_theme.dart';
import 'package:help_sum/src/core/services/notifications/push_notifications_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = AppSecrets.stripePublicKey;
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint('Firebase init failed: $e');
  }
  await initializeDI();
  try {
    await PushNotificationsService.instance.init();
    final String? token = await PushNotificationsService.instance.getFcmToken();
    log("FCM $token");
  } catch (e) {
    debugPrint('PushNotificationsService init failed: $e');
  }
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MaterialApp.router(
          title: AppTexts.appTitle,
          theme: AppTheme.lightTheme,

          // ThemeData(
          //   primarySwatch: AppPalette.whiteSwatch,
          //   iconTheme: IconThemeData(color: AppPalette.blackColor),
          //   useMaterial3: false,
          //   appBarTheme: AppBarTheme(elevation: 0),
          //   scaffoldBackgroundColor: Colors.white,
          //   colorScheme: ColorScheme.fromSwatch().copyWith(
          //     secondary: AppPalette.primaryColor,
          //     primary: AppPalette.secondayColor,
          //     brightness: Brightness.light,
          //   ),
          //   brightness: Brightness.light,
          //   fontFamily: 'Poppins',

          //   dividerTheme: DividerThemeData(
          //     color: AppPalette.greyColor,
          //     space: 24,
          //     thickness: 0.8,
          //   ),
          //   textSelectionTheme: TextSelectionThemeData(
          //     cursorColor: Colors.grey, // Cursor color
          //     selectionColor: Colors.grey[200], // Text highlight color
          //     selectionHandleColor: Colors.grey, // Handle (for drag)
          //   ),
          // ),
          debugShowCheckedModeBanner: false,
          routerConfig: appRouter,
          builder: (context, child) {
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => context.dismissKeyboard(),
              child: ScreenUtilInit(
                designSize: const Size(428, 926),
                splitScreenMode: true,
                useInheritedMediaQuery: true,
                child: child,
              ),
            );
          }, // Will create SplashPage next
        );
      },
    );
  }
}
