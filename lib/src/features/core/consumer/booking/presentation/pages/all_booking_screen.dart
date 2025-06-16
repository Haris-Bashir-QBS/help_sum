import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:help_sum/src/core/constants/app_palette.dart';
import 'package:help_sum/src/core/enums/job_status.dart';
import 'package:help_sum/src/core/router/app_routes.dart';
import 'package:help_sum/src/core/utils/app_static_data.dart';
import 'package:help_sum/src/features/core/common/main_navigation/domain/model/job_model.dart';
import 'package:help_sum/src/widgets/app_tab_bar.dart';
import 'package:help_sum/src/widgets/custom_search_field.dart';

import '../widgets/booking_card.dart';

class AllBookingsPage extends StatefulWidget {
  const AllBookingsPage({super.key});

  @override
  State<AllBookingsPage> createState() => _AllBookingsPageState();
}

class _AllBookingsPageState extends State<AllBookingsPage> {
  final ScrollController scrollController = ScrollController();
  int selectedIndex = 0;
  List<JobModel> jobs = [];
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    jobs = AppStaticData.dummyJobs;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _searchField(),
        20.verticalSpace,
        _buildJobsTabbar(),
        20.verticalSpace,
        _jobListView(),
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

  _jobListView() {
    return Expanded(
      child: RefreshIndicator(
        color: AppPalette.warningColor,
        onRefresh: () async {
          await Future.delayed(Duration(milliseconds: 600));
        },
        child: ListView.separated(
          itemCount: jobs.length,
          itemBuilder: (c, i) {
            return BookingCard(
              job: jobs[i],
              showStatus: selectedIndex == 0,
              index: i,
              onTap: () {
                print("Clicked hereee");
                context.pushNamed(
                  AppRoutes.bookingDetail,
                  extra: {
                    'job': jobs[i],
                    'tabName': AppStaticData.jobStatusTabs[selectedIndex],
                  },
                );
              },
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return 10.verticalSpace;
          },
        ),
      ),
    );
  }

  _buildJobsTabbar() {
    return AppTabBar(
      selectedIndex: selectedIndex,
      tabs: AppStaticData.jobStatusTabs,
      onTapChanged: (index) {
        final jobStatusMap = {
          0: JobStatus.all,
          1: JobStatus.completed,
          2: JobStatus.inProgress,
          3: JobStatus.pending,
          4: JobStatus.approved,
          5: JobStatus.waitingConfirmation,
          6: JobStatus.waitingPayment,
          7: JobStatus.cancelled,
          8: JobStatus.rejected,
        };

        jobs =
            jobStatusMap[index] == JobStatus.all
                ? AppStaticData.dummyJobs
                : AppStaticData.dummyJobs
                    .where((e) => e.status == jobStatusMap[index])
                    .toList();

        setState(() => selectedIndex = index);
      },
    );
  }
}
