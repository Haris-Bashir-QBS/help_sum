part of 'portfolio_bloc.dart';

sealed class PortfolioEvent {
  const PortfolioEvent();
}

class UpdatePortfolioEvent extends PortfolioEvent {
  final UploadFileRequest params;
  const UpdatePortfolioEvent({required this.params});
}

class UpdateUserEvent extends PortfolioEvent {
  final UserEntity userEntity;
  const UpdateUserEvent({required this.userEntity});
}

class UpdateUserProfile extends PortfolioEvent {
  final UpdateProfileRequest updateProfileRequest;
  const UpdateUserProfile({required this.updateProfileRequest});
}
