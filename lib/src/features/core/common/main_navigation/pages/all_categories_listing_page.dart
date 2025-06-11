import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:help_sum/src/core/constants/app_texts.dart';
import 'package:help_sum/src/core/utils/app_static_data.dart';
import 'package:help_sum/src/features/core/common/main_navigation/widgets/category_card.dart';
import 'package:help_sum/src/widgets/custom_app_bar.dart';

class AllCategoriesListingPage extends StatelessWidget {
  const AllCategoriesListingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: AppTexts.allCategories,
        centerTitle: true,
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(16.w),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 10.w,
          mainAxisSpacing: 10.h,
          childAspectRatio: 1.0,
        ),
        itemCount: AppStaticData.categories.length,
        itemBuilder: (context, index) {
          final category = AppStaticData.categories[index];
          return CategoryCard(title: category.name, icon: category.icon);
        },
      ),
    );
  }
} 