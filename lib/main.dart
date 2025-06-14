import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:help_sum/src/core/constants/app_texts.dart';
import 'package:help_sum/src/core/extensions/context_extensions.dart';
import 'package:help_sum/src/core/router/app_router.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
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



