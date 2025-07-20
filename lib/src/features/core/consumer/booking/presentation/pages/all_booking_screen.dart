import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:help_sum/src/core/router/app_routes.dart';
import 'package:help_sum/src/widgets/app_tab_bar.dart';
import 'package:help_sum/src/widgets/custom_search_field.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:help_sum/src/widgets/custom_text.dart';
import 'package:help_sum/src/core/constants/app_texts.dart';
import 'package:help_sum/src/core/utils/app_static_data.dart';
import 'package:help_sum/src/core/constants/app_palette.dart';
import 'package:help_sum/src/widgets/custom_refresh_indicator.dart';
import '../controller/all_bookings_provider.dart';
import '../widgets/booking_card.dart';

class AllBookingsPage extends ConsumerStatefulWidget {
  const AllBookingsPage({super.key});

  @override
  ConsumerState<AllBookingsPage> createState() => _AllBookingsPageState();
}

class _AllBookingsPageState extends ConsumerState<AllBookingsPage> {
  final ScrollController scrollController = ScrollController();
  int selectedIndex = 0;
  final TextEditingController searchController = TextEditingController();

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
    final type = jobTypes[selectedIndex];
    final notifier = ref.read(allBookingsProvider(type).notifier);
    if (notifier.hasMore && !notifier.isLoadingMore) {
      notifier.loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final type = jobTypes[selectedIndex];
    final jobsAsync = ref.watch(allBookingsProvider(type));

    return Column(
      children: [
        _searchField(),
        20.verticalSpace,
        _buildJobsTabBar(),
        20.verticalSpace,
        Expanded(
          child: jobsAsync.when(
            data: (response) {
              final jobs = response.data.data;
              final notifier = ref.read(allBookingsProvider(type).notifier);

              if (jobs.isEmpty) {
                return Center(
                  child: CustomText(
                    text: AppTexts.noBookingsFound,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                );
              }

              return CustomRefreshIndicator(
                onRefresh: () async {
                  ref.read(allBookingsProvider(type).notifier).refresh();
                },
                child: ListView.separated(
                  controller: scrollController,
                  itemCount: jobs.length + (notifier.hasMore ? 1 : 0),
                  itemBuilder: (c, i) {
                    if (i == jobs.length) {
                      // Show loading indicator for pagination
                      return Padding(
                        padding: EdgeInsets.all(16.w),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: AppPalette.primaryColor,
                          ),
                        ),
                      );
                    }

                    return BookingCard(
                      job: jobs[i],
                      showStatus: selectedIndex == 0,
                      index: i,
                      onTap: () {
                        context.pushNamed(
                          AppRoutes.bookingDetail,
                          extra: {
                            'job': jobs[i],
                            'tabName': jobTypes[selectedIndex],
                          },
                        );
                      },
                    );
                  },
                  separatorBuilder: (context, index) => 10.verticalSpace,
                ),
              );
            },
            loading:
                () => Center(
                  child: CircularProgressIndicator(
                    color: AppPalette.primaryColor,
                  ),
                ),
            error:
                (e, st) => Center(
                  child: CustomText(
                    text: '${AppTexts.somethingWentWrong}: ${e.toString()}',
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
          ),
        ),
      ],
    );
  }

  Widget _searchField() {
    return CustomSearchField(
      controller: searchController,
      onChanged: (value) {},
      onSearch: () {},
    );
  }

  Widget _buildJobsTabBar() {
    return AppTabBar(
      selectedIndex: selectedIndex,
      tabs: jobTypes,
      onTapChanged: (index) {
        setState(() => selectedIndex = index);
        Future.microtask(() {
          final newType = jobTypes[index];
          ref.invalidate(allBookingsProvider(newType));
        });
      },
    );
  }
}
