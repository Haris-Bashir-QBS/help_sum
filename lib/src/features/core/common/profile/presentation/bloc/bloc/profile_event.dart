part of 'profile_bloc.dart';

sealed class ProfileBlocEvent extends Equatable {
  const ProfileBlocEvent();

  @override
  List<Object> get props => [];
}

class ProfileTabChanged extends ProfileBlocEvent {
  final int selectedIndex;
  const ProfileTabChanged({required this.selectedIndex});

  @override
  List<Object> get props => [selectedIndex];
}

class FetchMerchantRatings extends ProfileBlocEvent {
  final String merchantId;
  const FetchMerchantRatings({required this.merchantId});

  @override
  List<Object> get props => [merchantId];
}