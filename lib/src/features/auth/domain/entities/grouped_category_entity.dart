// lib/domain/entities/grouped_category_entity.dart

import 'package:equatable/equatable.dart';

class GroupedCategoryEntity extends Equatable {
  final String id;
  final String categoryName;
  final List<ServiceEntity> services;

  const GroupedCategoryEntity({
    required this.id,
    required this.categoryName,
    required this.services,
  });

  @override
  List<Object?> get props => [id, categoryName, services];
}

// lib/domain/entities/service_entity.dart
class ServiceEntity extends Equatable {
  final String id;
  final String name;
  final String? photo;
  final bool approved;
  final String addedBy;

  const ServiceEntity({
    required this.id,
    required this.name,
    required this.photo,
    required this.approved,
    required this.addedBy,
  });

  @override
  List<Object?> get props => [id, name, photo, approved, addedBy];
}
