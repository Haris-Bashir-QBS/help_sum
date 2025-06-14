import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:help_sum/src/core/observers/navigator_observer.dart';
import 'package:help_sum/src/core/router/app_routes.dart';
import 'package:help_sum/src/core/services/session_service.dart';
import 'package:help_sum/src/features/auth/presentation/pages/login_page.dart';
import 'package:help_sum/src/features/auth/presentation/pages/signup_page.dart';
import 'package:help_sum/src/features/core/common/intro/spash/pages/splash_page.dart';
import 'package:help_sum/src/features/auth/presentation/pages/otp_verification_page.dart';
import 'package:help_sum/src/features/core/common/intro/onboarding/pages/onboarding_page.dart';
import 'package:help_sum/src/features/core/common/main_navigation/pages/main_navigation_page.dart';
import 'package:help_sum/src/features/core/common/main_navigation/pages/all_categories_listing_page.dart';
import 'package:help_sum/src/features/core/common/main_navigation/pages/all_service_providers_listing_page.dart';
import 'package:help_sum/src/features/core/common/payment/models/card_detail_params.dart';
import 'package:help_sum/src/features/core/common/payment/screens/card_details_screen.dart';
import 'package:help_sum/src/features/core/common/payment/screens/payment_confirmation_screen.dart';
import 'package:help_sum/src/features/core/common/payment/screens/payment_method_screen.dart';
import 'package:help_sum/src/features/core/common/payment/screens/payment_result_screen.dart';
import 'package:help_sum/src/features/core/merchant/domain/models/service_provider_model.dart';
import 'package:help_sum/src/features/core/merchant/presentation/pages/merchant_profile_page.dart';
import 'package:help_sum/src/features/core/common/profile/pages/profile_details_page.dart';
import 'package:help_sum/src/features/core/common/profile/pages/edit_basic_info_screen.dart';
import 'package:help_sum/src/features/core/common/profile/pages/edit_contact_info_screen.dart';
import 'package:help_sum/src/features/core/common/profile/models/user_model.dart';


final GoRouter appRouter = GoRouter(
  initialLocation: '/${AppRoutes.mainNavigation}',
  navigatorKey: SessionManager.navigatorKey,
  observers: [ UnFocusOnNavigateObserver()],
  routes: [
    /// ====================== Auth Routes ======================
    _splash(),
    _login(),
    _signUp(),
    _verifyOtp(),
    _onboarding(),
    _mainNavigation(),
    _allCategoriesListing(),
    _allServiceProvidersListing(),
    _merchantProfile(),
    // Payment routes
    _paymentMethod(),
    _cardDetails(),
    _paymentConfirmation(),
    _paymentResult(),
    // Profile routes
    _account(),
    _editBasicInfo(),
    _editContactInfo(),
  ],
);

GoRoute _splash() {
  return GoRoute(
    path: '/splash',
    name: AppRoutes.splash,
    builder: (context, state) => SplashPage(),
  );
}

GoRoute _login() {
  return GoRoute(
    path: '/login',
    name: AppRoutes.login,
    pageBuilder: (context, state) => CustomTransitionPage(
      key: state.pageKey,
      child: const LoginPage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.easeOutCubic;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    ),
  );
}

GoRoute _signUp() {
  return GoRoute(
    path: '/signup',
    name: AppRoutes.signUp,
    pageBuilder: (context, state) => CustomTransitionPage(
      key: state.pageKey,
      child: const SignupPage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.easeOutCubic;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    ),
  );
}

GoRoute _verifyOtp() {
  return GoRoute(
    path: '/verify-otp',
    name: AppRoutes.verifyOtp,
    pageBuilder: (context, state) {
      final phoneNumber = state.extra as String?;
      return CustomTransitionPage(
        key: state.pageKey,
        child: OtpVerificationPage(phoneNumber: phoneNumber ?? ''),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.easeOutCubic;

          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      );
    },
  );
}

GoRoute _onboarding() {
  return GoRoute(
    path: '/onboarding',
    name: AppRoutes.onboarding,
    builder: (context, state) => const OnboardingPage(),
  );
}

GoRoute _mainNavigation() {
  return GoRoute(
    path: '/main_navigation',
    name: AppRoutes.mainNavigation,
    builder: (context, state) => const MainNavigationPage(),
  );
}

GoRoute _allCategoriesListing() {
  return GoRoute(
    path: '/all-categories-listing',
    name: AppRoutes.allCategoriesListing,
    builder: (context, state) => const AllCategoriesListingPage(),
  );
}

GoRoute _allServiceProvidersListing() {
  return GoRoute(
    path: '/all-service-providers-listing',
    name: AppRoutes.allServiceProvidersListing,
    builder: (context, state) => const AllServiceProvidersListingPage(),
  );
}

GoRoute _merchantProfile() {
  return GoRoute(
    path: '/merchant-profile',
    name: AppRoutes.merchantProfile,
    pageBuilder: (context, state) {
      final serviceProvider = state.extra as ServiceProviderModel;
      return CustomTransitionPage(
        key: state.pageKey,
        child: MerchantProfilePage(serviceProvider: serviceProvider),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.easeOutCubic;

          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      );
    },
  );
}

GoRoute _paymentMethod() {
  return GoRoute(
    path: '/payment-method',
    name: AppRoutes.paymentMethod,
    builder: (context, state) => const PaymentMethodScreen(),
  );
}

GoRoute _cardDetails() {
  return GoRoute(
    path: '/card-details',
    name: AppRoutes.cardDetails,
    builder: (context, state) => const CardDetailsScreen(),
  );
}

GoRoute _paymentConfirmation() {
  return GoRoute(
    path: AppRoutes.paymentConfirmation,
    name: AppRoutes.paymentConfirmation,
    builder: (context, state) {
      final params = state.extra as CardDetailParams;
      return PaymentConfirmationScreen(params: params);
    },
  );
}

GoRoute _paymentResult() {
  return GoRoute(
    path: AppRoutes.paymentResult,
    name: AppRoutes.paymentResult,
    builder: (context, state) {
      final isSuccess = state.extra as bool;
      return PaymentResultScreen(isSuccess: isSuccess);
    },
  );
}

// Profile Routes
GoRoute _account() {
  return GoRoute(
    path: '/account',
    name: AppRoutes.account,
    builder: (context, state) {
      return const ProfileDetailsPage();
    },
  );
}

GoRoute _editBasicInfo() {
  return GoRoute(
    path: '/edit-basic-info',
    name: AppRoutes.editBasicInfo,
    builder: (context, state) {
      final user = state.extra as UserModel;
      return EditBasicInfoScreen(user: user);
    },
  );
}

GoRoute _editContactInfo() {
  return GoRoute(
    path: '/edit-contact-info',
    name: AppRoutes.editContactInfo,
    builder: (context, state) {
      final user = state.extra as UserModel;
      return EditContactInfoScreen(user: user);
    },
  );
}