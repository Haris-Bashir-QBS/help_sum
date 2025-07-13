import 'package:help_sum/src/features/core/consumer/explore_services/domain/entities/category_entity.dart';

class   CategoryModel extends CategoryEntity {
  CategoryModel({
    required super.id,
    required super.name,
    super.icon,
    required super.addedById,
    super.addedByEmail,
    required super.createdAt,
    required super.updatedAt,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      icon: json['icon'],
      addedById: json['addedBy']?['_id'] ?? '',
      addedByEmail: json['addedBy']?['email'],
      createdAt: DateTime.parse(
        json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updatedAt'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'icon': icon,
      'addedBy': {'_id': addedById, 'email': addedByEmail},
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
