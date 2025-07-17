var _auth = "user";

enum ApiEndpoints {
  /// ================= Auth =======================
  login,
  signup,
  verifyOtp,
  resendCode,
  logout,
  uploadFile,
  serviceGrouped,

  /// ================= Categories =======================
  categories,

  /// ================= Payment =======================
  addCard,
  getCards,
  deleteCard,
  setDefaultCard,
  updateProfile,
  merchantSetup,
  jobMerchantByType,

  /// ================= Services =======================
  getServicesByCategory,
  merchantsNearby,
  createJob,
  fetchJobs;

  String get value {
    switch (this) {
      /// ================= Authentication =======================
      case ApiEndpoints.signup:
        return "/$_auth/signup";
      case ApiEndpoints.login:
        return "/$_auth/login";
      case ApiEndpoints.logout:
        return "logout";
      case ApiEndpoints.verifyOtp:
        return "/$_auth/verify-otp";
      case ApiEndpoints.resendCode:
        return "/$_auth/resend-otp";

      case ApiEndpoints.updateProfile:
        return "/$_auth/update-user";

      case ApiEndpoints.uploadFile:
        return "/upload/";

      /// ================= Categories =======================
      case ApiEndpoints.categories:
        return "/category";

      /// ================= Payment =======================
      case ApiEndpoints.addCard:
        return "/card";
      case ApiEndpoints.getCards:
        return "/card";
      case ApiEndpoints.deleteCard:
        return "/card"; // Will be appended with /:cardId
      case ApiEndpoints.setDefaultCard:
        return "/card"; // Will be appended with /:cardId
      case ApiEndpoints.serviceGrouped:
        return '/service/grouped';

      /// ================= Services =======================
      case ApiEndpoints.getServicesByCategory:
        return "/service/category"; // Will be appended with /:categoryId
      case ApiEndpoints.merchantsNearby:
        return "/job/merchants/nearby";
      case ApiEndpoints.createJob:
        return "/job";
      case ApiEndpoints.fetchJobs:
        return "/job/consumer/all";
      case ApiEndpoints.merchantSetup:
        return "/$_auth/merchant-account-setup";
      case ApiEndpoints.jobMerchantByType:
        return '/job/merchant';
    }
  }
}
