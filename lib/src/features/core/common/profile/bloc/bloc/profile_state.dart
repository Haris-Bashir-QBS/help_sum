part of 'profile_bloc.dart';

class ProfileBlocState extends Equatable {
  const ProfileBlocState({this.selectedIndex = 0});
  final int selectedIndex;

  @override
  List<Object> get props => [selectedIndex];

  //Copy with
  ProfileBlocState copyWith({int? selectedIndex}) {
    return ProfileBlocState(selectedIndex: selectedIndex ?? this.selectedIndex);
  }
}
