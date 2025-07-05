var _auth = "user";

enum ApiEndpoints {
  /// ================= Auth =======================
  login,
  signup,
  verifyOtp,
  resendCode,
  logout,

  /// ================= Categories =======================
  categories;

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

      /// ================= Categories =======================
      case ApiEndpoints.categories:
        return "/category";
    }
  }
}
