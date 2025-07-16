import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:help_sum/src/core/router/app_routes.dart';
import 'package:help_sum/src/widgets/app_tab_bar.dart';
import 'package:help_sum/src/widgets/custom_search_field.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:help_sum/src/widgets/custom_text.dart';
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

  static const List<String> jobTypes = [
    'all',
    'completed',
    'inProgress',
    'pending',
    'approved',
    'confirmation waiting',
    'payment waiting',
    'cancelled',
    'rejected',
  ];

  @override
  Widget build(BuildContext context) {
    final type = jobTypes[selectedIndex];
    final jobsAsync = ref.watch(allBookingsProvider(type));
    return Column(
      children: [
        _searchField(),
        20.verticalSpace,
        _buildJobsTabbar(),
        20.verticalSpace,
        Expanded(
          child: jobsAsync.when(
            data: (response) {
              final jobs = response.data.data;
              if (jobs.isEmpty) {
                return Center(
                  child: CustomText(
                    text: 'No bookings found.',
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                );
              }
              return ListView.separated(
                itemCount: jobs.length,
                itemBuilder: (c, i) {
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
              );
            },
            loading: () => Center(child: CircularProgressIndicator()),
            error: (e, st) => Center(child: CustomText(text: 'Error: $e')),
          ),
        ),
      ],
    );
  }

  Widget _searchField() {
    return CustomSearchField(
      controller: searchController,
      onChanged: (value) {
        // Handle search text changes
      },
      onSearch: () {
        // Handle search button press
      },
    );
  }

  Widget _buildJobsTabbar() {
    return AppTabBar(
      selectedIndex: selectedIndex,
      tabs: jobTypes,
      onTapChanged: (index) {
        setState(() => selectedIndex = index);
      },
    );
  }
}
