import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:help_sum/src/core/constants/app_role.dart';
import 'package:help_sum/src/core/constants/app_texts.dart';
import 'package:help_sum/src/core/router/app_routes.dart';
import 'package:help_sum/src/features/auth/presentation/bloc/login/login_bloc.dart';
import 'package:help_sum/src/features/core/consumer/booking/data/models/job_response_model.dart';
import 'package:help_sum/src/features/core/consumer/booking/presentation/bloc/job_detail/job_detail_cubit.dart';
import 'package:help_sum/src/features/core/consumer/booking/presentation/widgets/job_progress_tracker_shimmer.dart';
import 'package:help_sum/src/features/core/consumer/booking/presentation/widgets/job_time_line_widget.dart';

import '../../../../../../core/dependency_injection/di_barrel.dart';
import '../../../../../../widgets/custom_app_bar.dart';

class BookingTrackerPage extends StatelessWidget {
  final JobData job;
  final String? tabName;

  const BookingTrackerPage({super.key, required this.job, this.tabName});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<JobDetailCubit>()..fetchJobDetail(job.id),
      child: BlocBuilder<JobDetailCubit, JobDetailState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.grey[50],
            appBar: CustomAppBar(
              title: AppTexts.jobDetailsUpdates,
              onBackButtonPressed: () {
                context.pop(true);
              },
            ),
            body: Padding(
              padding: EdgeInsets.all(20.w),
              child: _buildBody(context, state),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, JobDetailState state) {
    if (state is JobDetailLoading) {
      return const JobProgressTimelineShimmer();
    } else if (state is JobDetailError) {
      return Center(child: Text(state.message));
    } else if (state is JobDetailLoaded) {
      // return JobProgressTimelineShimmer();
      final jobDetail = state.job;

      return RefreshIndicator(
        onRefresh: () async {
          context.read<JobDetailCubit>().fetchJobDetail(jobDetail.id);
        },
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppTexts.yourProgress,
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 20.h),
              JobProgressTimeline(
                job: jobDetail,
                tabName: tabName ?? "",
                onTap: () {
                  final cubit = context.read<JobDetailCubit>();
                  _navigateToDetailScreen(context, jobDetail, cubit);
                },
              ),
            ],
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }

  void _navigateToDetailScreen(
    BuildContext context,
    JobData jobDetail,
    JobDetailCubit cubit,
  ) {
    if (sl<LoginBloc>().state.userEntity?.role == AppRole.merchant.name) {
      navigateToDetailScreen(context, jobDetail, cubit);
    } else {
      navigateToDetailScreen(context, jobDetail, cubit);
    }
  }

  void navigateToDetailScreen(
    BuildContext context,
    JobData jobDetail,
    JobDetailCubit cubit,
  ) {
    final isMerchant =
        sl<LoginBloc>().state.userEntity?.role == AppRole.merchant.name;

    final route = isMerchant ? AppRoutes.jobDetail : AppRoutes.bookingDetail;

    context
        .pushNamed(route, extra: {'job': jobDetail, 'tabName': tabName})
        .then((_) {
          // Refresh job when user comes back
          cubit.fetchJobDetail(jobDetail.id);
        });
  }
}
