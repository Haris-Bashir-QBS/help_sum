// lib/domain/entities/grouped_category_entity.dart

import 'package:equatable/equatable.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/data/models/response/services_response_model.dart';

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
  final IconInfo? icon;

  const ServiceEntity({
    required this.id,
    required this.name,
    required this.photo,
    required this.approved,
    required this.addedBy,
    required this.icon,
  });

  @override
  List<Object?> get props => [id, name, photo, approved, addedBy, icon];
}
