// Data Model for a skill category
import 'package:help_sum/src/features/auth/domain/model/skill_model.dart';

class SkillCategory {
  final String categoryName;
  List<Skill> skills;

  SkillCategory({required this.categoryName, required this.skills});

  // Helper to create a copy with updated skills list
  SkillCategory copyWith({List<Skill>? skills}) {
    return SkillCategory(
      categoryName: categoryName,
      skills: skills ?? this.skills,
    );
  }
}
