import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:help_sum/src/core/constants/app_palette.dart';
import 'package:help_sum/src/core/constants/app_texts.dart';
import 'package:help_sum/src/core/enums/job_status.dart';
import 'package:help_sum/src/core/router/app_routes.dart';
import 'package:help_sum/src/core/utils/app_static_data.dart';
import 'package:help_sum/src/features/core/common/main_navigation/domain/model/job_model.dart';
import 'package:help_sum/src/features/core/consumer/booking/data/models/job_response_model.dart';
import 'package:help_sum/src/features/core/consumer/booking/presentation/widgets/booking_card.dart';
import 'package:help_sum/src/features/core/merchant/presentation/controller/job_request_provider.dart';
import 'package:help_sum/src/features/core/merchant/presentation/controller/job_request_states.dart';
import 'package:help_sum/src/widgets/app_tab_bar.dart';
import 'package:help_sum/src/widgets/custom_search_field.dart';
import 'package:help_sum/src/widgets/custom_text.dart';

import '../../../../../widgets/custom_refresh_indicator.dart';

class AllJobsScreen extends ConsumerStatefulWidget {
  const AllJobsScreen({super.key});

  @override
  ConsumerState<AllJobsScreen> createState() => _AllJobsScreenState();
}

class _AllJobsScreenState extends ConsumerState<AllJobsScreen> {
  final ScrollController scrollController = ScrollController();
  int selectedIndex = 0;
  List<JobModel> jobs = [];

  @override
  void initState() {
    jobs = AppStaticData.dummyJobs;
    ref
        .read(merchantJobsNotifierProvider.notifier)
        .getAllJobsByType(jobType: AppStaticData.jobStatusTabs.first);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(merchantJobsNotifierProvider);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // CustomSearchField(),
          CustomText(
            text: AppTexts.yourProgress,
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
          ),
          20.verticalSpace,
          _buildJobsTabBar(),
          20.verticalSpace,
          _jobListView(state),
        ],
      ),
    );
  }

  Widget _jobListView(MerchantJobsState state) {
    if (state is MerchantJobsLoading || state is MerchantJobsInitial) {
      return const Expanded(
        child: Center(
          child: CircularProgressIndicator(color: AppPalette.primaryColor),
        ),
      );
    } else if (state is MerchantJobsError) {
      return Expanded(child: Center(child: CustomText(text: state.message)));
    } else if (state is MerchantJobsLoaded) {
      final jobs = state.response.data;

      if (jobs.data.isEmpty == true) {
        return const Expanded(
          child: Center(child: CustomText(text: "No Data Found")),
        );
      }

      return Expanded(
        child: CustomRefreshIndicator(
          onRefresh: () async {
            ref
                .read(merchantJobsNotifierProvider.notifier)
                .getAllJobsByType(
                  jobType: AppStaticData.jobStatusTabs[selectedIndex],
                  refresh: true,
                );
          },
          child: ListView.separated(
            separatorBuilder: (context, index) => 10.verticalSpace,
            itemCount: jobs.data.length,
            itemBuilder: (c, i) {
              final job = jobs.data[i];
              return JobCardMerchant(
                job: job,
                showStatus: true,
                index: i,
                onTap: () => _navigateToJobDetailScreen(job),
              );
            },
          ),
        ),
      );
    }

    return const Expanded(child: SizedBox());
  }

  void _navigateToJobDetailScreen(JobData? job) async {
    bool? isRefresh = await context.pushNamed(
      AppRoutes.jobDetail,
      extra: {
        'job': job,
        'tabName': AppStaticData.jobStatusTabs[selectedIndex],
      },
    );
    if (isRefresh == true) {
      _fetchJobs();
    }
  }

  String getJobString(JobStatus job) {
    log(job.name);
    switch (job) {
      case JobStatus.ongoing:
      case JobStatus.in_progress:
        return "In-Progress";
      case JobStatus.approved:
      case JobStatus.accepted:
        return "Approved";
      case JobStatus.completed:
        return "Completed";
      case JobStatus.waitingConfirmation:
        return "Waiting Confirmation";
      case JobStatus.waitingPayment:
        return "Waiting Payment";
      case JobStatus.cancelled:
        return "Cancelled";
      case JobStatus.all:
        return AppTexts.all;
      case JobStatus.pending:
        return AppTexts.pending;
      case JobStatus.rejected:
        return AppTexts.rejected;
    }
  }

  Color getJobColor(JobStatus job) {
    switch (job) {
      case JobStatus.ongoing:
      case JobStatus.in_progress:
      case JobStatus.pending:
        return Color(0xFFFFC680);
      case JobStatus.approved:
      case JobStatus.accepted:
      case JobStatus.completed:
        return Color(0xFFAFFFA8);
      case JobStatus.waitingConfirmation:
      case JobStatus.waitingPayment:
        return Color(0xFFFFC680);
      case JobStatus.cancelled:
      case JobStatus.rejected:
        return Color(0xFFFF0000);
      case JobStatus.all:
        return Colors.transparent;
    }
  }

  _buildJobsTabBar() {
    return AppTabBar(
      selectedIndex: selectedIndex,
      tabs: AppStaticData.jobStatusTabs,
      onTapChanged: (index) {
        setState(() {
          selectedIndex = index;
        });
        _fetchJobs();
      },
    );
  }

  void _fetchJobs() {
    Future.microtask(() {
      ref
          .read(merchantJobsNotifierProvider.notifier)
          .getAllJobsByType(
            jobType: AppStaticData.jobStatusTabs[selectedIndex],
            refresh: true,
          );
    });
  }
}
