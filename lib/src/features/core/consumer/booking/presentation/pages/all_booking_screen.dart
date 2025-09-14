import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:help_sum/src/core/constants/app_palette.dart';
import 'package:help_sum/src/core/constants/app_texts.dart';
import 'package:help_sum/src/core/router/app_routes.dart';
import 'package:help_sum/src/core/utils/app_static_data.dart';
import 'package:help_sum/src/features/core/consumer/booking/data/models/job_response_model.dart';
import 'package:help_sum/src/features/core/consumer/booking/presentation/widgets/rich_booking_card.dart';
import 'package:help_sum/src/widgets/custom_loading_widget.dart';
import 'package:help_sum/src/widgets/custom_refresh_indicator.dart';
import 'package:help_sum/src/widgets/custom_search_field.dart';
import 'package:help_sum/src/widgets/custom_text.dart';

import '../controller/all_bookings_provider.dart';

class AllBookingsPage extends ConsumerStatefulWidget {
  const AllBookingsPage({super.key});

  @override
  ConsumerState<AllBookingsPage> createState() => _AllBookingsPageState();
}

class _AllBookingsPageState extends ConsumerState<AllBookingsPage> {
  final ScrollController scrollController = ScrollController();
  int selectedIndex = 0;
  final TextEditingController searchController = TextEditingController();

  // Add filter state
  String selectedFilter = AppTexts.all; // Default filter
  final List<String> filters = [
    AppTexts.all,
    AppTexts.completed,
    AppTexts.inProgress,
    AppTexts.pending,
    AppTexts.cancelled,
  ];

  // Add search state
  String searchQuery = '';

  // API mapping for filter values
  final Map<String, String> filterApiMap = {
    AppTexts.all: 'all',
    AppTexts.completed: 'completed',
    AppTexts.inProgress: 'in_progress',
    AppTexts.pending: 'pending',
    AppTexts.cancelled: 'cancelled',
  };

  static const List<String> jobTypes = AppStaticData.jobStatusTabs;

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    scrollController.dispose();
    searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 200) {
      _loadMore();
    }
  }

  void _loadMore() {
    if (!mounted) return; // Check if widget is still mounted

    final apiType = filterApiMap[selectedFilter] ?? 'all';
    final notifier = ref.read(allBookingsProvider(apiType).notifier);
    if (notifier.hasMore && !notifier.isLoadingMore) {
      notifier.loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final apiType = filterApiMap[selectedFilter] ?? 'all';
    final jobsAsync = ref.watch(allBookingsProvider(apiType));
    return Column(
      children: [
        _searchField(),
        20.verticalSpace,
        _buildFilterButton(context), // Replace tab bar with filter button
        20.verticalSpace,
        Expanded(
          child: jobsAsync.when(
            data: (response) {
              final allJobs = response.data.data;
              final notifier = ref.read(allBookingsProvider(apiType).notifier);

              // Filter jobs based on search query
              final jobs = _filterJobs(allJobs, searchQuery);

              if (jobs.isEmpty) {
                return Center(
                  child: CustomText(
                    text:
                        searchQuery.isNotEmpty
                            ? AppTexts.noServicesFound
                            : AppTexts.noBookingsFound,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                );
              }

              return CustomRefreshIndicator(
                onRefresh: () async {
                  ref.read(allBookingsProvider(apiType).notifier).refresh();
                },
                child: ListView.separated(
                  controller: scrollController,
                  itemCount: jobs.length + (notifier.hasMore ? 1 : 0),
                  itemBuilder: (c, i) {
                    if (i == jobs.length) {
                      // Show loading indicator for pagination
                      return Padding(
                        padding: EdgeInsets.all(16.w),
                        child: Center(child: CustomDotsLoader(size: 40)),
                      );
                    }

                    return RichBookingCard(
                      job: jobs[i],
                      showStatus: selectedIndex == 0,
                      //  index: i,
                      onTap: () {
                        // _navigateToPaymentScreen(context, jobs, i);
                        _navigateToJobDetailPage(context, jobs, i);
                      },
                    );
                  },
                  separatorBuilder: (context, index) => 10.verticalSpace,
                ),
              );
            },
            loading: () => Center(child: CustomDotsLoader()),
            error:
                (e, st) => Center(
                  child: CustomText(
                    text: e.toString(),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
          ),
        ),
      ],
    );
  }

  void _navigateToJobDetailPage(
    BuildContext context,
    List<JobData> jobs,
    int i,
  ) async {
    bool? isRefresh = await context.pushNamed(
      AppRoutes.bookingDetail,
      extra: {'job': jobs[i], 'tabName': jobTypes[selectedIndex]},
    );
    if (isRefresh == true && mounted) {
      _fetchJobs(selectedIndex);
    }
  }

  Widget _searchField() {
    return CustomSearchField(
      controller: searchController,

      onChanged: (value) {
        // Implement search logic here
        _performSearch(value);
      },
      onSearch: () {
        // Implement search on search button tap
        _performSearch(searchController.text);
      },
    );
  }

  void _performSearch(String query) {
    if (!mounted) return;

    setState(() {
      searchQuery = query.toLowerCase().trim();
    });
  }

  Widget _buildFilterButton(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Expanded(
              child: CustomText(
                text: "Filter Bookings",
                fontWeight: FontWeight.bold,
              ),
            ),
            GestureDetector(
              onTap: () async {
                final result = await showModalBottomSheet<String>(
                  context: context,
                  builder: (ctx) => _buildFilterSheet(ctx),
                );
                if (result != null && result != selectedFilter) {
                  setState(() {
                    selectedFilter = result;
                    selectedIndex = filters.indexOf(result);
                  });
                  _fetchJobs(selectedIndex);
                }
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomText(
                    text: selectedFilter,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                    color: AppPalette.primaryColor,
                  ),
                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: AppPalette.primaryColor,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterSheet(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children:
            filters.map((filter) {
              return ListTile(
                title: CustomText(
                  text: filter,
                  fontSize: 16.sp,
                  color:
                      filter == selectedFilter
                          ? AppPalette.primaryColor
                          : Colors.black,
                  fontWeight:
                      filter == selectedFilter
                          ? FontWeight.bold
                          : FontWeight.normal,
                ),
                onTap: () => Navigator.pop(context, filter),
                selected: filter == selectedFilter,
              );
            }).toList(),
      ),
    );
  }

  void _fetchJobs(int index) {
    if (!mounted) return; // Check if widget is still mounted

    Future.microtask(() {
      if (!mounted) return; // Check again after async operation
      final newType = filterApiMap[filters[index]] ?? 'all';
      ref.invalidate(allBookingsProvider(newType));
    });
  }

  List<JobData> _filterJobs(List<JobData> jobs, String query) {
    if (query.isEmpty) return jobs;

    return jobs.where((job) {
      final title = job.title.toLowerCase();
      final description = job.description.toLowerCase();
      final serviceName = job.serviceId.name.toLowerCase();
      final merchantName =
          '${job.merchantId.firstName} ${job.merchantId.lastName}'
              .toLowerCase();
      final consumerName =
          '${job.consumerId.firstName} ${job.consumerId.lastName}'
              .toLowerCase();

      return title.contains(query) ||
          description.contains(query) ||
          serviceName.contains(query) ||
          merchantName.contains(query) ||
          consumerName.contains(query);
    }).toList();
  }
}
