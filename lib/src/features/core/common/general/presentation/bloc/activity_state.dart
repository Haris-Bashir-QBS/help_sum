// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'activity_bloc.dart';

class ActivityState extends Equatable {
  final int selectedTab;

  const ActivityState({this.selectedTab = 0});

  @override
  List<Object> get props => [selectedTab];

  ActivityState copyWith({int? selectedTab}) {
    return ActivityState(selectedTab: selectedTab ?? this.selectedTab);
  }
}
