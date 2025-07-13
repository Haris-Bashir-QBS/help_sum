// lib/data/models/grouped_category_model.dart

import 'package:help_sum/src/features/auth/domain/entities/grouped_category_entity.dart';

class GroupedCategoryModel extends GroupedCategoryEntity {
  const GroupedCategoryModel({
    required super.id,
    required super.categoryName,
    required List<ServiceModel> super.services,
  });

  factory GroupedCategoryModel.fromJson(Map<String, dynamic> json) {
    return GroupedCategoryModel(
      id: json['_id'],
      categoryName: json['categoryName'] ?? '',
      services:
          (json['services'] as List)
              .map((e) => ServiceModel.fromJson(e))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'categoryName': categoryName,
      'services': services.map((e) => (e as ServiceModel).toJson()).toList(),
    };
  }
}

// lib/data/models/service_model.dart

class ServiceModel extends ServiceEntity {
  const ServiceModel({
    required super.id,
    required super.name,
    super.photo,
    required super.approved,
    required super.addedBy,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['_id'],
      name: json['name'] ?? '',
      photo: json['photo'],
      approved: json['approved'],
      addedBy: json['addedBy'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'photo': photo,
      'approved': approved,
      'addedBy': addedBy,
    };
  }
}
