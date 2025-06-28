class Skill {
  final String id;
  final String name;
  bool selected;

  Skill({required this.id, required this.name, this.selected = false});

  // Helper to create a copy with updated selected status
  Skill copyWith({bool? selected}) {
    return Skill(id: id, name: name, selected: selected ?? this.selected);
  }
}
