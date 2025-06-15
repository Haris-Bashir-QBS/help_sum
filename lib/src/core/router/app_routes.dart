class AppRoutes {
  AppRoutes._();
  //============================== Auth ==============================
  static const String splash = 'splash';
  static const String login = 'login';
  static const String signUp = 'signup';
  static const String forgotPassword = 'forgot_password';
  static const String resetPassword = 'reset_password';
  static const String changePassword = 'change_password';
  static const String verifyOtp = 'verify_otp';
  static const String onboarding = 'onboarding';
  static const String selectSkill = 'select_skill';
  static const String mainNavigation = 'main_navigation';
  static const String allCategoriesListing = 'all_categories_listing';
  static const String allServiceProvidersListing =
      'all_service_providers_listing';
  static const String merchantProfile = 'merchant-profile';

  //============================== Payment ==============================
  static const String paymentMethod = 'payment-method';
  static const String cardDetails = 'card-details';
  static const String paymentConfirmation = 'payment-confirmation';
  static const String paymentResult = 'payment-result';
  static const String rateScreen = 'rate-screen';

  // Profile Routes
  static const String account = 'account';
  static const String editBasicInfo = 'edit-basic-info';
  static const String editContactInfo = 'edit-contact-info';
  //============================== Booking ==============================
  static const String bookingDetail = 'booking-detail';
  static const String otherOptions = '/otherOptions';
  static const String chatScreen = '/chatScreen';
  static const String mapTracking = '/mapTracking';
  static const String findMerchant = '/findMerchant';
}
