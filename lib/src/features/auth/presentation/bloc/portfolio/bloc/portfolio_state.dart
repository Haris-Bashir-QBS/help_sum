// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'portfolio_bloc.dart';

class PortfolioState extends Equatable {
  const PortfolioState({
    this.apiErrorMessage = '',
    this.fileUploaded = false,
    this.isLoading = false,
    this.userEntity,
    this.profileUpdated = false,
  });
  final String apiErrorMessage;
  final bool isLoading;
  final bool fileUploaded;
  final UserEntity? userEntity;
  final bool profileUpdated;

  @override
  List<Object?> get props => [
    apiErrorMessage,
    isLoading,
    fileUploaded,
    userEntity,
    profileUpdated,
  ];

  PortfolioState copyWith({
    String? apiErrorMessage,
    bool? isLoading,
    bool? fileUploaded,
    UserEntity? userEntity,
    bool? profileUpdated,
  }) {
    return PortfolioState(
      apiErrorMessage: apiErrorMessage ?? '',
      isLoading: isLoading ?? this.isLoading,
      fileUploaded: fileUploaded ?? false,
      userEntity: userEntity ?? this.userEntity,
      profileUpdated: profileUpdated ?? false,
    );
  }
}
