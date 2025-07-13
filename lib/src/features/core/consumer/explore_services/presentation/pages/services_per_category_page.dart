import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:help_sum/src/core/constants/app_texts.dart';
import 'package:help_sum/src/core/constants/app_palette.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/data/models/response/services_response_model.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/presentation/controller/services_provider.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/presentation/controller/services_state.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/presentation/widgets/service_card.dart';
import 'package:help_sum/src/widgets/custom_app_bar.dart';
import 'package:help_sum/src/widgets/custom_search_field.dart';
import 'package:help_sum/src/widgets/custom_text.dart';
import 'package:help_sum/src/widgets/custom_refresh_indicator.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ServicesPerCategoryPage extends ConsumerStatefulWidget {
  final String categoryId;
  final String categoryName;

  const ServicesPerCategoryPage({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  ConsumerState<ServicesPerCategoryPage> createState() =>
      _ServicesPerCategoryPageState();
}

class _ServicesPerCategoryPageState
    extends ConsumerState<ServicesPerCategoryPage> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<ServiceModel> _filteredServices = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(servicesNotifierProvider.notifier)
          .getServicesByCategory(categoryId: widget.categoryId, refresh: true);
    });

    // Add scroll listener for pagination
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent) {
      _fetchMoreServices();
    }
  }

  void _fetchMoreServices() {
    ref
        .read(servicesNotifierProvider.notifier)
        .getServicesByCategory(categoryId: widget.categoryId, refresh: false);
  }

  void _filterServices(List<ServiceModel> services, String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredServices = services;
        _isSearching = false;
      });
    } else {
      setState(() {
        _filteredServices =
            services
                .where(
                  (service) =>
                      service.name.toLowerCase().contains(query.toLowerCase()),
                )
                .toList();
        _isSearching = true;
      });
    }
  }

  void _onSearchChanged(String query) {
    final currentState = ref.read(servicesNotifierProvider);
    if (currentState is GetServicesLoaded) {
      _filterServices(currentState.services, query);
    }
  }

  Widget _buildServicesContent(ServicesState state) {
    if (state is GetServicesLoading) {
      return _buildServicesSkeleton();
    } else if (state is GetServicesLoaded) {
      final services = _isSearching ? _filteredServices : state.services;

      if (services.isEmpty) {
        return _buildEmptyState();
      }

      return CustomRefreshIndicator(
        onRefresh: () async {
          ref
              .read(servicesNotifierProvider.notifier)
              .getServicesByCategory(
                categoryId: widget.categoryId,
                refresh: true,
              );
        },
        child: GridView.builder(
          controller: _scrollController,
          padding: EdgeInsets.symmetric(horizontal: 16.0.w),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12.0.w,
            mainAxisSpacing: 12.0.h,
            childAspectRatio: 1.2,
          ),
          itemCount: services.length + (state.hasMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == services.length) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(
                    color: AppPalette.primaryColor,
                  ),
                ),
              );
            }

            final service = services[index];
            return ServiceCard(
              title: service.name,
              photo: service.photo,
              onTap: () {
                // TODO: Navigate to service details
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Service: ${service.name}')),
                );
              },
            );
          },
        ),
      );
    } else if (state is GetServicesError) {
      return _buildErrorState(state.message);
    } else {
      return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    final servicesState = ref.watch(servicesNotifierProvider);

    return Scaffold(
      appBar: CustomAppBar(title: widget.categoryName, centerTitle: true),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0.w),
              child: CustomSearchField(
                controller: _searchController,
                hintText: AppTexts.searchServices,
                onChanged: _onSearchChanged,
              ),
            ),
            SizedBox(height: 16.0.h),

            // Services Grid
            Expanded(child: _buildServicesContent(servicesState)),
          ],
        ),
      ),
    );
  }

  Widget _buildServicesSkeleton() {
    return Skeletonizer(
      enabled: true,
      child: GridView.builder(
        padding: EdgeInsets.symmetric(horizontal: 16.0.w),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12.0.w,
          mainAxisSpacing: 12.0.h,
          childAspectRatio: 1.2,
        ),
        itemCount: 10,
        itemBuilder: (context, index) {
          return ServiceCard(title: 'Service Name', onTap: () {});
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64.sp, color: Colors.grey),
          SizedBox(height: 16.0.h),
          CustomText(
            text:
                _isSearching
                    ? AppTexts.noServicesFound
                    : AppTexts.noServicesAvailable,
            fontSize: 16.sp,
            color: Colors.grey,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64.sp, color: Colors.red),
          SizedBox(height: 16.0.h),
          CustomText(
            text: message,
            fontSize: 16.sp,
            color: Colors.red,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16.0.h),
          ElevatedButton(
            onPressed: () {
              ref
                  .read(servicesNotifierProvider.notifier)
                  .getServicesByCategory(
                    categoryId: widget.categoryId,
                    refresh: true,
                  );
            },
            child: Text(AppTexts.retry),
          ),
        ],
      ),
    );
  }
}
