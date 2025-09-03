import 'package:flutter/material.dart';
import 'package:help_sum/src/core/models/common/paginated_model.dart';

class ServicesResponseModel {
  final bool status;
  final int code;
  final ServicesData data;
  final String message;

  ServicesResponseModel({
    required this.status,
    required this.code,
    required this.data,
    required this.message,
  });

  factory ServicesResponseModel.fromJson(Map<String, dynamic> json) {
    return ServicesResponseModel(
      status: json['status'] ?? false,
      code: json['code'] ?? 0,
      data: ServicesData.fromJson(json['data'] ?? {}),
      message: json['message'] ?? '',
    );
  }
}

class ServicesData {
  final List<ServiceModel> data;
  final PaginationModel pagination;

  ServicesData({required this.data, required this.pagination});

  factory ServicesData.fromJson(Map<String, dynamic> json) {
    return ServicesData(
      data:
          (json['data'] as List<dynamic>?)
              ?.map((service) => ServiceModel.fromJson(service))
              .toList() ??
          [],
      pagination: PaginationModel.fromJson(json['pagination'] ?? {}),
    );
  }
}

class ServiceModel {
  final String id;
  final CategoryInfo categoryId;
  final String name;
  final String? photo;
  final String addedBy;
  final bool approved;
  final String createdAt;
  final String updatedAt;
  final IconInfo? icon;

  ServiceModel({
    required this.id,
    required this.categoryId,
    required this.name,
    this.photo,
    required this.addedBy,
    required this.approved,
    required this.createdAt,
    required this.updatedAt,
    this.icon,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['_id'] ?? '',
      categoryId: CategoryInfo.fromJson(json['categoryId'] ?? {}),
      name: json['name'] ?? '',
      photo: json['photo'],
      addedBy: json['addedBy'] ?? '',
      approved: json['approved'] ?? false,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      icon: json['icon'] != null ? IconInfo.fromJson(json['icon']) : null,
    );
  }
}

class CategoryInfo {
  final String id;
  final String name;

  CategoryInfo({required this.id, required this.name});

  factory CategoryInfo.fromJson(Map<String, dynamic> json) {
    return CategoryInfo(id: json['_id'] ?? '', name: json['name'] ?? '');
  }
}

class IconInfo {
  final int codePoint;
  final String fontFamily;

  IconInfo({required this.codePoint, required this.fontFamily});

  factory IconInfo.fromJson(Map<String, dynamic> json) {
    int parsedCodePoint = 0;

    final raw = json['codePoint'];

    if (raw is int) {
      parsedCodePoint = raw;
    } else if (raw is String) {
      if (raw.startsWith("0x")) {
        parsedCodePoint = int.tryParse(raw.substring(2), radix: 16) ?? 0;
      } else {
        parsedCodePoint = int.tryParse(raw) ?? 0;
      }
    }

    return IconInfo(
      codePoint: parsedCodePoint,
      fontFamily: json['fontFamily'] ?? 'MaterialIcons',
    );
  }

  IconData toIconData() {
    try {
      return IconData(codePoint, fontFamily: fontFamily);
    } catch (_) {
      return Icons.photo; // fallback if corrupt
    }
  }
}
