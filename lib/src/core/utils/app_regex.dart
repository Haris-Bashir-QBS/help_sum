class AppRegex {
  AppRegex._();

  static final RegExp phoneRegExp = RegExp(r'^[\+]?[0-9\s\-\(\)\.]{7,15}$');
  static final RegExp passwordRegExp = RegExp(
    r'^(?=.*[A-Z])(?=.*\d)(?=.*[!@#\$&*~]).{8,}$',
  );
  static final RegExp emailRegExp = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );
}
