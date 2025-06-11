class AppRegex {
  AppRegex._();

  static final RegExp phoneRegExp = RegExp(r'^03[0-9]{9}$');
  static final RegExp passwordRegExp = RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$');
  static final RegExp emailRegExp = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
} 