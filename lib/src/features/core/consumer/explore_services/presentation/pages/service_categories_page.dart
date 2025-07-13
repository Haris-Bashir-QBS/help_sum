import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:help_sum/src/core/constants/app_texts.dart';
import 'package:help_sum/src/core/router/app_routes.dart';
import 'package:help_sum/src/core/utils/app_static_data.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/presentation/widgets/category_card.dart';
import 'package:help_sum/src/features/core/common/main_navigation/widgets/heading_with_view_all.dart';
import 'package:help_sum/src/features/core/common/main_navigation/widgets/home_service_provider_card.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/presentation/controller/category_provider.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/presentation/controller/category_state.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/domain/entities/category_entity.dart';
import 'package:help_sum/src/core/constants/app_palette.dart';
import 'package:help_sum/src/widgets/custom_search_field.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/presentation/widgets/category_skeleton.dart';

class ServiceCategoriesPage extends ConsumerStatefulWidget {
  const ServiceCategoriesPage({super.key});

  @override
  ConsumerState<ServiceCategoriesPage> createState() =>
      _ServiceCategoriesPageState();
}

class _ServiceCategoriesPageState extends ConsumerState<ServiceCategoriesPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchCategories(refresh: true);
    });
  }

  void _fetchCategories({bool refresh = false}) {
    ref
        .read(categoryNotifierProvider.notifier)
        .fetchCategories(refresh: refresh);
  }

  @override
  Widget build(BuildContext context) {
    final categoryAsync = ref.watch(categoryNotifierProvider);

    return Column(
      children: [
        CustomSearchField(),
        SizedBox(height: 15.h),
        Divider(height: 1.h, thickness: 1.h),
        SizedBox(height: 15.h),
        Expanded(
          child: RefreshIndicator(
            color: AppPalette.primaryColor,
            onRefresh: () async {
              _fetchCategories(refresh: true);
            },
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _categoryGrid(context, categoryAsync),
                  SizedBox(height: 20.h),
                  _recommendedSection(context),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _categoryGrid(BuildContext context, CategoryState categoryAsync) {
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
        _buildCategoryContent(categoryAsync),
      ],
    );
  }

  Widget _buildCategoryContent(CategoryState state) {
    if (state is GetCategoriesLoading) {
      return _buildLoadingWidget();
    }

    if (state is GetCategoriesError) {
      return _buildErrorWidget(state.message);
    }

    if (state is GetCategoriesLoaded) {
      return Column(children: [_buildCategoriesGrid(state.categories)]);
    }

    return _buildLoadingWidget();
  }

  Widget _buildLoadingWidget() {
    return const CategorySkeleton();
  }

  Widget _buildErrorWidget(String message) {
    return Center(
      child: Column(
        children: [
          Text(message),
          ElevatedButton(
            onPressed: () {
              _fetchCategories(refresh: true);
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesGrid(List<CategoryEntity> categories) {
    // Limit to 9 categories maximum
    final displayCategories = categories.take(9).toList();

    return GridView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10.w,
        mainAxisSpacing: 10.h,
        childAspectRatio: 1,
      ),
      itemCount: displayCategories.length,
      itemBuilder: (context, index) {
        final category = displayCategories[index];
        return CategoryCard(
          title: category.name,
          icon: category.icon,
          onTap: () {
            context.pushNamed(AppRoutes.findMerchant);
          },
        );
      },
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
          height: 150.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: AppStaticData.serviceProviders.length,
            itemBuilder: (context, index) {
              final item = AppStaticData.serviceProviders[index];
              return HomeServiceProviderCard(
                title: item.name,
                reviews: item.reviewsCount.toString(),
                rating: item.rating.toString(),
                onTap: () {
                  context.pushNamed(AppRoutes.merchantProfile, extra: item);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
