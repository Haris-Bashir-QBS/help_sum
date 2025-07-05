class CategoryEntity {
  final String id;
  final String name;
  final String? icon;
  final String addedById;
  final String? addedByEmail;
  final DateTime createdAt;
  final DateTime updatedAt;

  CategoryEntity({
    required this.id,
    required this.name,
    this.icon,
    required this.addedById,
    this.addedByEmail,
    required this.createdAt,
    required this.updatedAt,
  });
}
