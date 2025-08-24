part of 'skill_bloc.dart';

sealed class SkillEvent extends Equatable {
  const SkillEvent();

  @override
  List<Object> get props => [];
}

class LoadSkills extends SkillEvent {
  const LoadSkills();
}

class UpdateSkill extends SkillEvent {
  final List<String> selectedSkills;
  const UpdateSkill({required this.selectedSkills});
}

class SearchSkill extends SkillEvent {
  final String searchText;
  const SearchSkill({required this.searchText});

  @override
  List<Object> get props => [searchText];
}

class AddSkill extends SkillEvent {
  final ServiceEntity skill;
  const AddSkill({required this.skill});

  @override
  List<Object> get props => [skill];
}

class RemoveSkill extends SkillEvent {
  final ServiceEntity skill;
  const RemoveSkill({required this.skill});

  @override
  List<Object> get props => [skill];
}
