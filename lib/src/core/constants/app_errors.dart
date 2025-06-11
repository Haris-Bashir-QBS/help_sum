class AppErrors {
  AppErrors._();

  static const String emptyFieldError = ' is required';
  static const String phoneNumberInvalid = 'Enter a valid phone number';
  static const String fullNameTooShort = 'Full name must be at least 3 characters long';
  static const String fullNameTooLong = 'Full name must be at most 50 characters long';
  static const String passwordInvalid = 'Password must contain at least one uppercase letter, one lowercase letter, one number, and one special character';
  static const String passwordLengthError = 'Password must be at least 8 characters long';
  static const String passwordsDoNotMatch = 'Passwords do not match';

  // Card validation errors
  static const String cardNumberRequired = 'Please enter card number';
  static const String invalidCardNumberLength = 'Invalid card number length';
  static const String invalidCardNumber = 'Invalid card number';
  static const String cardHolderRequired = 'Please enter card holder name';
  static const String invalidCardHolderLength = 'Name must be at least 3 characters';
  static const String expiryDateRequired = 'Please enter expiry date';
  static const String invalidExpiryFormat = 'Invalid expiry date format (MM/YY)';
  static const String invalidMonth = 'Invalid month';
  static const String cardExpired = 'Card has expired';
  static const String cvvRequired = 'Please enter CVV';
  static const String invalidCVV = 'Invalid CVV';

  static const String invalidEmail = 'Enter a valid email address';
} 