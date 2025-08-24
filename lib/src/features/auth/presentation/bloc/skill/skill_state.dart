// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'skill_bloc.dart';

class SkillState extends Equatable {
  final bool isSearching;
  final bool savingSkills;
  final List<GroupedCategoryEntity> cats;
  final List<ServiceEntity> selectedServices;
  final List<GroupedCategoryEntity> filteredServices;
  final String apiErrorMessage;
  final bool isLoading;
  final bool skillUpdated;

  const SkillState({
    this.apiErrorMessage = '',
    this.savingSkills = false,
    this.cats = const [],
    this.selectedServices = const [],
    this.filteredServices = const [],
    this.isSearching = false,
    this.isLoading = false,
    this.skillUpdated = false,
  });

  @override
  List<Object> get props => [
    apiErrorMessage,
    cats,
    selectedServices,
    filteredServices,
    isSearching,
    savingSkills,
    isLoading,
    skillUpdated,
  ];

  SkillState copyWith({
    bool? isSearching,
    bool? savingSkills,
    List<GroupedCategoryEntity>? cats,
    List<ServiceEntity>? selectedServices,
    List<GroupedCategoryEntity>? filteredServices,
    String? apiErrorMessage,
    bool? isLoading,
    bool? skillUpdated,
  }) {
    return SkillState(
      isSearching: isSearching ?? this.isSearching,
      savingSkills: savingSkills ?? this.savingSkills,
      cats: cats ?? this.cats,
      selectedServices: selectedServices ?? this.selectedServices,
      filteredServices: filteredServices ?? this.filteredServices,
      apiErrorMessage: apiErrorMessage ?? '',
      isLoading: isLoading ?? this.isLoading,
      skillUpdated: skillUpdated ?? this.skillUpdated,
    );
  }
}
