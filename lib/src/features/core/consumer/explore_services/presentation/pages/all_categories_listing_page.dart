import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:help_sum/src/core/constants/app_texts.dart';
import 'package:help_sum/src/features/core/common/main_navigation/widgets/category_card.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/presentation/controller/category_provider.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/presentation/controller/category_state.dart';
import 'package:help_sum/src/core/constants/app_palette.dart';
import 'package:help_sum/src/widgets/custom_app_bar.dart';

class AllCategoriesListingPage extends ConsumerStatefulWidget {
  const AllCategoriesListingPage({super.key});

  @override
  ConsumerState<AllCategoriesListingPage> createState() =>
      _AllCategoriesListingPageState();
}

class _AllCategoriesListingPageState
    extends ConsumerState<AllCategoriesListingPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Fetch categories when the page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchCategories(refresh: true);
    });

    // Add scroll listener for pagination
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _fetchCategories({bool refresh = false}) {
    ref
        .read(categoryNotifierProvider.notifier)
        .fetchCategories(refresh: refresh);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _fetchCategories(refresh: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoryAsync = ref.watch(categoryNotifierProvider);

    return Scaffold(
      appBar: CustomAppBar(title: AppTexts.allCategories, centerTitle: true),
      body: RefreshIndicator(
        color: AppPalette.primaryColor,
        onRefresh: () async {
          _fetchCategories(refresh: true);
        },
        child: _buildBody(categoryAsync),
      ),
    );
  }

  Widget _buildBody(CategoryState state) {
    if (state is GetCategoriesLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppPalette.primaryColor),
      );
    }

    if (state is GetCategoriesError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(state.message),
            SizedBox(height: 16.h),
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

    if (state is GetCategoriesLoaded) {
      return Column(
        children: [
          Expanded(
            child: GridView.builder(
              controller: _scrollController,
              padding: EdgeInsets.all(16.w),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10.w,
                mainAxisSpacing: 10.h,
                childAspectRatio: 1.0,
              ),
              itemCount: state.categories.length + (state.hasMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == state.categories.length) {
                  // Show loading indicator at the bottom for pagination
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppPalette.primaryColor,
                    ),
                  );
                }

                final category = state.categories[index];
                return CategoryCard(
                  title: category.name,
                  icon: category.icon,
                  onTap: () {
                    // Handle category tap
                  },
                );
              },
            ),
          ),
          if (state.hasMore || state.categories.isNotEmpty)
            Container(
              padding: EdgeInsets.all(16.w),
              child: Center(
                child: Text(
                  'Showing ${state.categories.length} of ${state.totalCount} categories',
                  style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
                ),
              ),
            ),
        ],
      );
    }

    return const Center(child: Text('No categories available'));
  }
}
