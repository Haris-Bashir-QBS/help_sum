class UserLocalModel {
  final String firstName;
  final String lastName;
  final String emailAddress;
  final String phoneNumber;
  final bool isVerified;

  const UserLocalModel({
    required this.firstName,
    required this.lastName,
    required this.emailAddress,
    required this.phoneNumber,
    required this.isVerified,
  });

  UserLocalModel copyWith({
    String? firstName,
    String? lastName,
    String? emailAddress,
    String? phoneNumber,
    bool? isVerified,
  }) {
    return UserLocalModel(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      emailAddress: emailAddress ?? this.emailAddress,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      isVerified: isVerified ?? this.isVerified,
    );
  }
}
