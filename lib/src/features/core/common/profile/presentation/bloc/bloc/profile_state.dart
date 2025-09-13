part of 'profile_bloc.dart';

class ProfileBlocState extends Equatable {
  const ProfileBlocState({
    this.selectedIndex = 0,
    this.isLoading = false,
    this.ratings = const [],
    this.apiErrorMessage = '',
  });
  
  final int selectedIndex;
  final bool isLoading;
  final List<RatingEntity> ratings;
  final String apiErrorMessage;

  @override
  List<Object> get props => [selectedIndex, isLoading, ratings, apiErrorMessage];

  //Copy with
  ProfileBlocState copyWith({
    int? selectedIndex,
    bool? isLoading,
    List<RatingEntity>? ratings,
    String? apiErrorMessage,
  }) {
    return ProfileBlocState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      isLoading: isLoading ?? this.isLoading,
      ratings: ratings ?? this.ratings,
      apiErrorMessage: apiErrorMessage ?? this.apiErrorMessage,
    );
  }
}
