import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:help_sum/src/core/constants/app_palette.dart';
import 'package:help_sum/src/core/constants/app_texts.dart';
import 'package:help_sum/src/core/utils/app_static_data.dart';
import 'package:help_sum/src/features/core/common/main_navigation/widgets/category_card.dart';
import 'package:help_sum/src/widgets/custom_text_formfield.dart';
import 'package:help_sum/src/features/core/common/main_navigation/widgets/recommended_card.dart';
import 'package:help_sum/src/features/core/common/main_navigation/widgets/heading_with_view_all.dart';
import 'package:go_router/go_router.dart';
import 'package:help_sum/src/core/router/app_routes.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return  Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: _searchBar(),
          ),
          SizedBox(height: 15.h),
          Divider(height: 1.h, thickness: 1.h,),
          SizedBox(height: 15.h),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _categoryGrid(context),
                  SizedBox(height: 20.h),
                  _recommendedSection(context),
                ],
              ),
            ),
          ),
        ],
      );
    
  }

  Widget _searchBar() {
    return CustomTextFormField(
      hint: AppTexts.searchHint,
      prefixIcon: Icons.search,
      fillColor: AppPalette.lightGreyColor,
      borderRadius: BorderRadius.circular(10.0.r),
      isOutlinedBorder: false,
    );
  }

  Widget _categoryGrid(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HeadingWithViewAll(
          title: AppTexts.categories,
          onViewAllTap: () {
            context.pushNamed(AppRoutes.allCategoriesListing);
          },
        ),
        5.verticalSpace,
        GridView.builder(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10.w,
            mainAxisSpacing: 10.h,
            childAspectRatio: 1.0,
          ),
          itemCount: 9, // Fixed to 9 items as per image
          itemBuilder: (context, index) {
            final categories = AppStaticData.categories;

            if (index < categories.length) {
              return CategoryCard(title: categories[index].name, icon: categories[index].icon);
            } else {
              return Container();
            }
          },
        ),
      ],
    );
  }

  Widget _recommendedSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HeadingWithViewAll(
          title: AppTexts.recommendedForYou,
          onViewAllTap: () {
            context.pushNamed(AppRoutes.allServiceProvidersListing);
          },
        ),
        SizedBox(height: 15.h),
        SizedBox(
          height: 120.h, 
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: AppStaticData.serviceProviders.length,
            itemBuilder: (context, index) {
              final item = AppStaticData.serviceProviders[index];
              return RecommendedServiceProviderCard(title: item.name, reviews: item.reviews.length.toString(),onTap: (){
                  context.pushNamed(AppRoutes.merchantProfile,extra: item); 
              },);
            },
          ),
        ),
      ],
    );
  }
} 