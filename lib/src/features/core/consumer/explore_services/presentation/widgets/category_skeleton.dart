import 'package:flutter/material.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/presentation/widgets/category_card.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CategorySkeleton extends StatelessWidget {
  const CategorySkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    // Create dummy category data
    final dummyCategories = [
      {'name': 'Electrician'},
      {'name': 'Plumber'},
      {'name': 'Cleaner'},
      {'name': 'Tutor'},
      {'name': 'Mechanic'},
      {'name': 'Artist'},
      {'name': 'Chef'},
      {'name': 'Driver'},
      {'name': 'Gardener'},
    ];

    return Skeletonizer(
      enabled: true,
      child: GridView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 1.0,
        ),
        itemCount: dummyCategories.length,
        itemBuilder: (context, index) {
          final category = dummyCategories[index];
          return CategoryCard(title: category['name'] as String, onTap: () {});
        },
      ),
    );
  }
}
