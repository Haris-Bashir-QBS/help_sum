class CategoryRouteParams {
  final String categoryId;
  final String categoryName;

  const CategoryRouteParams({
    required this.categoryId,
    required this.categoryName,
  });

  factory CategoryRouteParams.fromMap(Map<String, dynamic> map) {
    return CategoryRouteParams(
      categoryId: map['categoryId'] as String,
      categoryName: map['categoryName'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {'categoryId': categoryId, 'categoryName': categoryName};
  }
}
