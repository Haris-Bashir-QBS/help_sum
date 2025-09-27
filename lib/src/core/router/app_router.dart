import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:help_sum/src/core/enums/content_type.dart';
import 'package:help_sum/src/core/observers/navigator_observer.dart';
import 'package:help_sum/src/core/router/app_routes.dart';
import 'package:help_sum/src/core/services/session_service.dart';
import 'package:help_sum/src/features/auth/domain/entities/user_entity.dart';
import 'package:help_sum/src/features/auth/presentation/screens/select_skill_page.dart';
import 'package:help_sum/src/features/auth/presentation/screens/login_page.dart';
import 'package:help_sum/src/features/auth/presentation/screens/role_selection_page.dart';
import 'package:help_sum/src/features/auth/presentation/screens/signup_page.dart';
import 'package:help_sum/src/features/core/common/chat/domain/entities/inbox_chat_entity.dart';
import 'package:help_sum/src/features/core/common/general/presentation/pages/inbox_and_notifications_page.dart';
import 'package:help_sum/src/features/core/common/intro/spash/pages/splash_page.dart';
import 'package:help_sum/src/features/auth/presentation/screens/otp_verification_page.dart';
import 'package:help_sum/src/features/core/common/intro/onboarding/pages/onboarding_page.dart';
import 'package:help_sum/src/features/core/common/main_navigation/pages/content_page.dart';
import 'package:help_sum/src/features/core/common/main_navigation/pages/main_navigation_page.dart';
import 'package:help_sum/src/features/core/common/profile/presentation/pages/portfolio_screen.dart';
import 'package:help_sum/src/features/core/common/profile/presentation/pages/settings_page.dart';
import 'package:help_sum/src/features/core/consumer/booking/data/models/job_response_model.dart';
import 'package:help_sum/src/features/core/consumer/booking/presentation/pages/booking_tracker_page.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/data/models/route/Booking_route_params.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/presentation/pages/all_categories_listing_page.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/presentation/pages/all_service_providers_listing_page.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/presentation/pages/services_per_category_page.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/data/models/route/category_route_params.dart';
import 'package:help_sum/src/features/core/common/payment/presentation/screens/add_card_screen.dart';
import 'package:help_sum/src/features/core/common/payment/presentation/screens/card_details_screen.dart';
import 'package:help_sum/src/features/core/common/payment/presentation/screens/payment_method_screen.dart';
import 'package:help_sum/src/features/core/common/payment/presentation/screens/payment_result_screen.dart';
import 'package:help_sum/src/features/core/common/payment/presentation/screens/rate_job_screen.dart';
import 'package:help_sum/src/features/core/common/profile/presentation/pages/edit_contact_info_screen.dart';
import 'package:help_sum/src/features/core/common/profile/presentation/pages/profile_details_page.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/presentation/pages/create_request_screen.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/presentation/pages/find_merchant_screen.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/presentation/pages/immediate_book_screen.dart';
import 'package:help_sum/src/features/core/merchant/presentation/pages/job_detail_screen.dart';
import 'package:help_sum/src/features/core/merchant/presentation/pages/change_description_page.dart';
import 'package:help_sum/src/features/core/merchant/presentation/pages/change_rate_page.dart';
import 'package:help_sum/src/features/core/merchant/presentation/pages/manage_job_page.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/presentation/pages/merchant_view_profile_page.dart';
import 'package:help_sum/src/features/core/consumer/booking/presentation/pages/booking_detail_page.dart';
import 'package:help_sum/src/features/core/consumer/booking/presentation/pages/other_options_page.dart';
import 'package:help_sum/src/features/core/common/chat/presentation/pages/chat_page.dart';
import 'package:help_sum/src/features/core/common/map_tracking/pages/map_tracking_page.dart';

import '../../features/auth/presentation/screens/create_schdule_page.dart';
import '../../features/core/common/profile/presentation/pages/edit_basic_info_screen.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/data/models/route/create_job_route_model.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/${AppRoutes.splash}',
  navigatorKey: SessionManager.navigatorKey,
  observers: [UnFocusOnNavigateObserver()],
  routes: <RouteBase>[
    /// ====================== Auth Routes ======================
    _splash(),
    _selectSkill(),
    _createSchdule(),
    _roleSelection(),
    _login(),
    _signUp(),
    _verifyOtp(),
    _onboarding(),
    _changeDescription(),
    _changeRates(),
    _portfolio(),
    _settings(),

    _mainNavigation(),
    _allCategoriesListing(),
    _allServiceProvidersListing(),
    _merchantProfile(),
    _bookingDetail(),
    _bookingTracker(),
    // Payment routes
    _paymentMethod(),
    _cardDetails(),
    _addCard(),
    _paymentResult(),
    _rateScreen(),
    // Profile routes
    _account(),
    _editBasicInfo(),
    _editContactInfo(),
    _otherOptions(),
    _chatScreen(),
    _mapTracking(),
    _findMerchant(),
    _createRequest(),
    _immediateBooking(),
    _servicesPerCategory(),
    _jobDetail(),
    _manageJob(),
    _content(),
    _inboxAndNotifcations(),
  ],
);

GoRoute _settings() {
  return GoRoute(
    path: '/settings',
    name: AppRoutes.settings,
    builder: (context, state) {
      return SettingsPage();
    },
  );
}

GoRoute _jobDetail() {
  return GoRoute(
    path: '/job-detail',
    name: AppRoutes.jobDetail,
    builder: (context, state) {
      final Map<String, dynamic> extras = state.extra as Map<String, dynamic>;
      final JobData job = extras['job'];
      final String? tabName = extras['tabName'];
      return JobDetailPage(job: job, tabName: tabName);
    },
  );
}

GoRoute _manageJob() {
  return GoRoute(
    path: '/manage-job',
    name: AppRoutes.manageJob,
    builder: (context, state) {
      return ManageJobPage();
    },
  );
}

GoRoute _findMerchant() {
  return GoRoute(
    path: '/find-merchant',
    name: AppRoutes.findMerchant,
    builder: (context, state) {
      BookingRouteParams? params = state.extra as BookingRouteParams?;
      return FindMerchantScreen(bookingRouteParams: params);
    },
  );
}

GoRoute _immediateBooking() {
  return GoRoute(
    path: '/immediate-booking',
    name: AppRoutes.immediateBooking,
    builder: (context, state) => const ImmediateBookingScreen(),
  );
}

GoRoute _createRequest() {
  return GoRoute(
    path: '/create-request',
    name: AppRoutes.createRequest,
    builder: (context, state) {
      final args = state.extra as CreateJobRouteModel;
      return CreateRequestScreen(args: args);
    },
  );
}

GoRoute _splash() {
  return GoRoute(
    path: '/splash',
    name: AppRoutes.splash,
    builder: (context, state) => SplashPage(),
  );
}

GoRoute _changeRates() {
  return GoRoute(
    path: '/rates',
    name: AppRoutes.rates,
    builder: (context, state) {
      return ChangeRatePage();
    },
  );
}

GoRoute _portfolio() {
  return GoRoute(
    path: '/portfolio',
    name: AppRoutes.portfolio,
    builder: (context, state) {
      return PortfolioScreen();
    },
  );
}

GoRoute _changeDescription() {
  return GoRoute(
    path: '/change_description',
    name: AppRoutes.changeDescriptipon,
    builder: (context, state) => ChangeDescriptionPage(),
  );
}

GoRoute _roleSelection() {
  return GoRoute(
    path: '/roleSelection',
    name: AppRoutes.roleSelection,
    builder: (context, state) => RoleSelectionPage(),
  );
}

GoRoute _login() {
  return GoRoute(
    path: '/login',
    name: AppRoutes.login,
    pageBuilder:
        (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: LoginPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(0.0, 1.0);
            const end = Offset.zero;
            const curve = Curves.easeOutCubic;

            var tween = Tween(
              begin: begin,
              end: end,
            ).chain(CurveTween(curve: curve));

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
    pageBuilder:
        (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const SignupPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(0.0, 1.0);
            const end = Offset.zero;
            const curve = Curves.easeOutCubic;

            var tween = Tween(
              begin: begin,
              end: end,
            ).chain(CurveTween(curve: curve));

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
      final data = state.extra as Map<String, dynamic>;
      final phoneNumber = data['phone'] as String?;
      final userId = data['userId'] as String?;
      return CustomTransitionPage(
        key: state.pageKey,
        child: OtpVerificationPage(
          phoneNumber: phoneNumber ?? '',
          userId: userId ?? '',
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.easeOutCubic;

          var tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));

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

GoRoute _selectSkill() {
  return GoRoute(
    path: '/select_skill',
    name: AppRoutes.selectSkill,
    builder: (context, state) {
      final isEdit = state.extra as bool?;

      return SkillSelectionScreen(isEdit: isEdit ?? false);
    },
  );
}

GoRoute _createSchdule() {
  return GoRoute(
    path: '/create-schedule',
    name: AppRoutes.createSchedule,
    builder: (context, state) {
      final isEdit = state.extra as bool?;
      return SchedulePage(isEdit: isEdit ?? false);
    },
  );
}

GoRoute _mainNavigation() {
  return GoRoute(
    path: '/main_navigation',
    name: AppRoutes.mainNavigation,
    builder: (context, state) {
      final Map<String, dynamic>? extras = state.extra as Map<String, dynamic>?;
      final index = extras?['index'] as int?;
      return MainNavigationPage(key: mainNavKey, index: index);
    },
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
      final createJobArgs = state.extra as CreateJobRouteModel;
      return CustomTransitionPage(
        key: state.pageKey,
        child: MerchantViewProfilePage(routeModel: createJobArgs),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.easeOutCubic;

          var tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      );
    },
  );
}

GoRoute _bookingDetail() {
  return GoRoute(
    path: '/booking-detail',
    name: AppRoutes.bookingDetail,
    builder: (context, state) {
      final Map<String, dynamic> extras = state.extra as Map<String, dynamic>;
      final JobData job = extras['job'];
      final String? tabName = extras['tabName'];
      return BookingDetailPage(job: job, tabName: tabName);
    },
  );
}

GoRoute _bookingTracker() {
  return GoRoute(
    path: '/booking-tracker',
    name: AppRoutes.bookingTracker,
    builder: (context, state) {
      final Map<String, dynamic> extras = state.extra as Map<String, dynamic>;
      final String job = extras['job'];
      final String? tabName = extras['tabName'];
      return BookingTrackerPage(jobId: job, tabName: tabName);
    },
  );
}

GoRoute _paymentMethod() {
  return GoRoute(
    path: '/payment-method',
    name: AppRoutes.paymentMethod,
    builder: (context, state) {
      final JobData job = state.extra as JobData;
      return PaymentMethodScreen(job: job);
    },
  );
}

GoRoute _cardDetails() {
  return GoRoute(
    path: '/card-details',
    name: AppRoutes.cardDetails,
    builder: (context, state) => const CardDetailsScreen(),
  );
}

GoRoute _addCard() {
  return GoRoute(
    path: '/add-card',
    name: AppRoutes.addCard,
    builder: (context, state) => const AddCardScreen(),
  );
}

GoRoute _paymentResult() {
  return GoRoute(
    path: "/${AppRoutes.paymentResult}",
    name: AppRoutes.paymentResult,
    builder: (context, state) {
      final Map<String, dynamic> extras = state.extra as Map<String, dynamic>;
      final bool isSuccess = extras['isSuccess'] as bool;
      final JobData? job = extras['job'] as JobData?;
      return PaymentResultScreen(isSuccess: isSuccess, job: job);
    },
  );
}

GoRoute _rateScreen() {
  return GoRoute(
    path: '/rate-screen',
    name: AppRoutes.rateScreen,
    builder: (context, state) {
      final JobData job = state.extra as JobData;
      return RatingPage(job: job);
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
      final user = state.extra as UserEntity;
      return EditBasicInfoScreen(user: user);
    },
  );
}

GoRoute _editContactInfo() {
  return GoRoute(
    path: '/edit-contact-info',
    name: AppRoutes.editContactInfo,
    builder: (context, state) {
      final user = state.extra as UserEntity;
      return EditContactInfoScreen(user: user);
    },
  );
}

GoRoute _otherOptions() {
  return GoRoute(
    path: '/other-options',
    name: AppRoutes.otherOptions,
    builder: (context, state) => const OtherOptionsPage(),
  );
}

GoRoute _chatScreen() {
  return GoRoute(
    path: '/chat-screen',
    name: AppRoutes.chatScreen,
    builder: (context, state) {
      final InboxChatEntity user = state.extra as InboxChatEntity;
      return ChatScreen(user: user);
    },
  );
}

GoRoute _mapTracking() {
  return GoRoute(
    path: '/map-tracking',
    name: AppRoutes.mapTracking,
    builder: (context, state) => const MapTrackingPage(),
  );
}

GoRoute _servicesPerCategory() {
  return GoRoute(
    path: '/services-per-category',
    name: AppRoutes.servicesPerCategory,
    builder: (context, state) {
      final CategoryRouteParams params = CategoryRouteParams.fromMap(
        state.extra as Map<String, dynamic>,
      );
      return ServicesPerCategoryPage(
        categoryId: params.categoryId,
        categoryName: params.categoryName,
      );
    },
  );
}

GoRoute _content() {
  return GoRoute(
    name: AppRoutes.content,
    path: '/content',
    builder: (context, state) {
      final contentType = state.extra as AppContentType;
      return ContentScreen(contentType: contentType);
    },
  );
}

GoRoute _inboxAndNotifcations() {
  return GoRoute(
    name: AppRoutes.inboxAndNotifcations,
    path: '/inboxAndNotifications',
    builder: (context, state) {
      return InboxAndNotificationsView();
    },
  );
}
