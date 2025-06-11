class UserModel {
  final String firstName;
  final String lastName;
  final String emailAddress;
  final String phoneNumber;
  final bool isVerified;

  const UserModel({
    required this.firstName,
    required this.lastName,
    required this.emailAddress,
    required this.phoneNumber,
    required this.isVerified,
  });

  
  UserModel copyWith({
    String? firstName,
    String? lastName,
    String? emailAddress,
    String? phoneNumber,
    bool? isVerified
  }) {
    return UserModel(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      emailAddress: emailAddress ?? this.emailAddress,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      isVerified: isVerified??this.isVerified,
    );
  }
} 