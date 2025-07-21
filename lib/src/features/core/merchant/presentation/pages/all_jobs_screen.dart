import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:help_sum/src/core/constants/app_palette.dart';
import 'package:help_sum/src/core/constants/app_texts.dart';

import 'package:help_sum/src/core/enums/job_status.dart';
import 'package:help_sum/src/core/router/app_routes.dart';
import 'package:help_sum/src/core/utils/app_static_data.dart';
import 'package:help_sum/src/features/core/common/main_navigation/domain/model/job_model.dart';
import 'package:help_sum/src/features/core/consumer/booking/presentation/widgets/booking_card.dart';
import 'package:help_sum/src/features/core/merchant/domain/entities/merchant_job_request_resposne_entity.dart';
import 'package:help_sum/src/features/core/merchant/presentation/controller/job_request_provider.dart';
import 'package:help_sum/src/features/core/merchant/presentation/controller/job_request_states.dart';
import 'package:help_sum/src/widgets/app_tab_bar.dart';
import 'package:help_sum/src/widgets/custom_search_field.dart';
import 'package:help_sum/src/widgets/custom_text.dart';

class AllJobsScreen extends ConsumerStatefulWidget {
  const AllJobsScreen({super.key});

  @override
  ConsumerState<AllJobsScreen> createState() => _AllJobsScreenState();
}

class _AllJobsScreenState extends ConsumerState<AllJobsScreen> {
  // static const List<String> jobTypes = [
  //   'all',
  //   'completed',
  //   'on going',
  //   'pending',
  //   'approved',
  //   'confirmation waiting',
  //   'payment waiting',
  //   'cancelled',
  //   'rejected',
  // ];
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

    return Column(
      children: [
        CustomSearchField(),
        20.verticalSpace,
        _buildJobsTabbar(),
        20.verticalSpace,
        _jobListView(state),
      ],
    );
  }

  Widget _jobListView(MerchantJobsState state) {
    if (state is MerchantJobsLoading) {
      return const Expanded(
        child: Center(
          child: CircularProgressIndicator(color: AppPalette.primaryColor),
        ),
      );
    } else if (state is MerchantJobsError) {
      return Expanded(child: Center(child: CustomText(text: state.message)));
    } else if (state is MerchantJobsLoaded) {
      final jobs = state.response.data;

      if (jobs?.data?.isEmpty == true) {
        return const Expanded(
          child: Center(child: CustomText(text: "No Data Found")),
        );
      }

      return Expanded(
        child: ListView.builder(
          itemCount: jobs?.data?.length ?? 0,
          itemBuilder: (c, i) {
            final job = jobs?.data?[i];
            return JobCardMerchant(
              job: job!,
              showStatus: true,
              index: i,
              onTap: () => _navigateToJobDetailScreen(job),
            );
          },
        ),
      );
    }

    return const Expanded(child: SizedBox()); // fallback for initial state
  }

  // Widget _jobListView(List<JobRequestEntity> _allJobs) {
  //   return Expanded(
  //     child:
  //         _allJobs.isEmpty
  //             ? Center(child: CustomText(text: "No Data Found"))
  //             : ListView.builder(
  //               itemCount: _allJobs.length,
  //               itemBuilder: (c, i) {
  //                 // return Container();
  //                 return JobCardMerchant(
  //                   job: _allJobs[i],
  //                   showStatus: true,
  //                   index: i,
  //                   onTap: () {
  //                     _navigateToJobDetailScreen(i);
  //                   },
  //                 );
  //               },
  //             ),
  //   );
  // }

  void _navigateToJobDetailScreen(JobRequestEntity? job) {
    context.pushNamed(
      AppRoutes.jobDetail,
      extra: {
        'job': job,
        'tabName': AppStaticData.jobStatusTabs[selectedIndex],
      },
    );
  }

  String getJobString(JobStatus job) {
    log(job.name);
    switch (job) {
      case JobStatus.ongoing:
      case JobStatus.inProgress:
        return "In-Progress";
      case JobStatus.approved:
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
      case JobStatus.inProgress:
      case JobStatus.pending:
        return Color(0xFFFFC680);
      case JobStatus.approved:
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

  _buildJobsTabbar() {
    return AppTabBar(
      selectedIndex: selectedIndex,
      tabs: AppStaticData.jobStatusTabs,
      onTapChanged: (index) {
        // switch (index) {
        //   case 0:
        //     jobs = AppStaticData.dummyJobs;
        //     break;
        //   case 1:
        //     jobs =
        //         AppStaticData.dummyJobs
        //             .where((e) => e.status == JobStatus.inProgress)
        //             .toList();
        //   case 2:
        //     jobs =
        //         AppStaticData.dummyJobs
        //             .where((e) => e.status == JobStatus.pending)
        //             .toList();

        //     break;
        //   case 3:
        //     jobs =
        //         AppStaticData.dummyJobs
        //             .where((e) => e.status == JobStatus.approved)
        //             .toList();
        //     break;
        //   case 4:
        //     jobs =
        //       AppStaticData.dummyJobs
        //           .where((e) => e.status == JobStatus.waitingConfirmation)
        //           .toList();

        //   break;

        // case 5:
        //   jobs =
        //       AppStaticData.dummyJobs
        //           .where((e) => e.status == JobStatus.waitingPayment)
        //           .toList();

        //   break;

        // case 6:
        //   jobs =
        //       AppStaticData.dummyJobs
        //           .where((e) => e.status == JobStatus.cancelled)
        //           .toList();

        //   break;
        // case 7:
        //   jobs =
        //       AppStaticData.dummyJobs
        //           .where((e) => e.status == JobStatus.rejected)
        //           .toList();
        // case 8:
        //   jobs =
        //       AppStaticData.dummyJobs
        //           .where((e) => e.status == JobStatus.completed)
        //           .toList();

        //   break;
        // // }
        setState(() {
          selectedIndex = index;
        });

        ref
            .read(merchantJobsNotifierProvider.notifier)
            .getAllJobsByType(
              jobType: AppStaticData.jobStatusTabs[index],
              refresh: true,
            );

        print("object");
      },
    );
  }
}
