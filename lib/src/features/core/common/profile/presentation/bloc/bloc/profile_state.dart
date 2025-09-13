part of 'profile_bloc.dart';

class ProfileBlocState extends Equatable {
  const ProfileBlocState({
    this.selectedIndex = 0,
    this.isLoading = false,
    this.ratings = const [],
    this.apiErrorMessage = '',
    this.isDeletingAccount = false,
    this.accountDeleted = false,
  });
  
  final int selectedIndex;
  final bool isLoading;
  final List<RatingEntity> ratings;
  final String apiErrorMessage;
  final bool isDeletingAccount;
  final bool accountDeleted;

  @override
  List<Object> get props => [
    selectedIndex, 
    isLoading, 
    ratings, 
    apiErrorMessage,
    isDeletingAccount,
    accountDeleted,
  ];

  //Copy with
  ProfileBlocState copyWith({
    int? selectedIndex,
    bool? isLoading,
    List<RatingEntity>? ratings,
    String? apiErrorMessage,
    bool? isDeletingAccount,
    bool? accountDeleted,
  }) {
    return ProfileBlocState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      isLoading: isLoading ?? this.isLoading,
      ratings: ratings ?? this.ratings,
      apiErrorMessage: apiErrorMessage ?? this.apiErrorMessage,
      isDeletingAccount: isDeletingAccount ?? this.isDeletingAccount,
      accountDeleted: accountDeleted ?? this.accountDeleted,
    );
  }
}
