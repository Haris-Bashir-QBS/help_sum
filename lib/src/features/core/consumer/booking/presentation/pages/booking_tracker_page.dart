import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:help_sum/src/core/constants/app_role.dart';
import 'package:help_sum/src/core/constants/app_texts.dart';
import 'package:help_sum/src/core/router/app_routes.dart';
import 'package:help_sum/src/core/utils/app_utils.dart';
import 'package:help_sum/src/features/auth/presentation/bloc/login/login_bloc.dart';
import 'package:help_sum/src/features/core/consumer/booking/data/models/job_response_model.dart';

import '../../../../../../core/dependency_injection/di_barrel.dart';
import '../../../../../../core/enums/job_status.dart';
import '../../../../../../widgets/custom_app_bar.dart';

class BookingTrackerPage extends StatefulWidget {
  final JobData job;
  final String? tabName;

  const BookingTrackerPage({
    super.key,
    required this.job,
    required this.tabName,
  });

  @override
  State<BookingTrackerPage> createState() => _BookingTrackerPageState();
}

class _BookingTrackerPageState extends State<BookingTrackerPage> {
  @override
  void initState() {
    super.initState();
    print("Job Status: ${widget.job.status}");
    print("Parsed Job Status: ${AppUtils.parseJobStatus(widget.job.status)}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: CustomAppBar(
        title: AppTexts.jobDetailsUpdates,
        onBackButtonPressed: () {
          context.pop(true);
        },
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
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
            JobProgressTimeline(job: widget.job, tabName: widget.tabName ?? ""),
          ],
        ),
      ),
    );
  }
}

class JobProgressTimeline extends StatelessWidget {
  final JobData job;
  final String tabName;

  const JobProgressTimeline({
    super.key,
    required this.job,
    required this.tabName,
  });

  JobStatus get currentStatus => AppUtils.parseJobStatus(job.status);

  List<JobTrackerStatus> _getJobStatuses() {
    final baseDate = DateTime.tryParse(job.createdAt ?? '') ?? DateTime.now();

    final List<JobTrackerStatus> statuses = [
      JobTrackerStatus(
        title: "Job Requested",
        description: "Your job request has been submitted.",
        date: _formatDate(baseDate),
        jobStatus: JobStatus.pending,
      ),
    ];

    // ✅ Show Cancelled step only if status is cancelled
    if (currentStatus == JobStatus.cancelled) {
      statuses.add(
        JobTrackerStatus(
          title: "Job Cancelled",
          description: "Your job has been cancelled.",
          date: _formatDate(baseDate.add(const Duration(hours: 1))),
          jobStatus: JobStatus.cancelled,
        ),
      );
      // return statuses; // stop here, baad ke steps nahi dikhayenge
    }

    // ✅ Show Rejected step only if status is rejected
    if (currentStatus == JobStatus.rejected) {
      statuses.add(
        JobTrackerStatus(
          title: "Job Rejected",
          description: "Merchant rejected your job request.",
          date: _formatDate(baseDate.add(const Duration(hours: 1))),
          jobStatus: JobStatus.rejected,
        ),
      );
      // return statuses; // stop here, baad ke steps nahi dikhayenge
    }

    // ✅ Normal flow agar cancel/reject nahi hua
    statuses.addAll([
      JobTrackerStatus(
        title: "Job Accepted",
        description: "Merchant has accepted your job request.",
        date: _formatDate(baseDate.add(const Duration(hours: 2))),
        jobStatus: JobStatus.approved,
      ),
      JobTrackerStatus(
        title: "Waiting for Confirmation",
        description: "Merchant rescheduled, waiting for consumer acceptance.",
        date: _formatDate(baseDate.add(const Duration(hours: 4))),
        jobStatus: JobStatus.waitingConfirmation,
      ),
      JobTrackerStatus(
        title: "In Progress",
        description: "Merchant has started working on the job.",
        date: _formatDate(baseDate.add(const Duration(days: 1))),
        jobStatus: JobStatus.in_progress,
      ),
      JobTrackerStatus(
        title: "Completed",
        description: "The job has been completed successfully.",
        date: _formatDate(baseDate.add(const Duration(days: 2))),
        jobStatus: JobStatus.completed,
      ),
    ]);

    return statuses;
  }

  String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final jobStatuses = _getJobStatuses();
    final currentIndex = jobStatuses.indexWhere(
      (s) => s.jobStatus == currentStatus,
    );

    return Column(
      children:
          jobStatuses.asMap().entries.map((entry) {
            int index = entry.key;
            JobTrackerStatus jobStatus = entry.value;
            bool isFirst = index == 0;
            bool isLast = index == jobStatuses.length - 1;

            return GestureDetector(
              onTap: () {
                if (sl<LoginBloc>().state.userEntity?.role ==
                    AppRole.merchant.name) {
                  context.pushNamed(
                    AppRoutes.jobDetail,
                    extra: {'job': job, 'tabName': tabName},
                  );
                } else {
                  context.pushNamed(
                    AppRoutes.bookingDetail,
                    extra: {'job': job, 'tabName': tabName},
                  );
                }
              },
              child: JobStatusCard(
                jobStatus: jobStatus,
                isFirst: isFirst,
                isLast: isLast,
                isCompleted: index < currentIndex,
                isCurrent: index == currentIndex,
              ),
            );
          }).toList(),
    );
  }
}

class JobStatusCard extends StatelessWidget {
  final JobTrackerStatus jobStatus;
  final bool isFirst;
  final bool isLast;
  final bool isCompleted;
  final bool isCurrent;

  const JobStatusCard({
    super.key,
    required this.jobStatus,
    required this.isFirst,
    required this.isLast,
    required this.isCompleted,
    required this.isCurrent,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor =
        isCompleted
            ? Colors.green
            : isCurrent
            ? Theme.of(context).primaryColor
            : Colors.grey;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timeline Column
        Column(
          children: [
            if (!isFirst)
              CustomPaint(
                painter: StraightLinePainter(color: statusColor),
                size: Size(2.w, 16.h),
              ),
            Container(
              width: 14.w,
              height: 14.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: statusColor,
              ),
            ),
            if (!isLast)
              CustomPaint(
                painter: StraightLinePainter(color: statusColor),
                size: Size(2.w, 80.h),
              ),
          ],
        ),
        SizedBox(width: 16.w),

        // Card Content
        Expanded(
          child: Container(
            margin: EdgeInsets.only(bottom: 0.h),
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration:
                isCurrent
                    ? BoxDecoration(
                      color:
                          (jobStatus.jobStatus == JobStatus.cancelled ||
                                  jobStatus.jobStatus == JobStatus.rejected)
                              ? Colors.red.withOpacity(
                                0.7,
                              ) // 🔴 red for cancel/reject
                              : Theme.of(context).primaryColor.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(12.r),
                    )
                    : null,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  jobStatus.title,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: isCurrent ? Colors.white : Colors.black87,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  jobStatus.description,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: isCurrent ? Colors.white70 : Colors.grey[600],
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  jobStatus.date,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: isCurrent ? Colors.white70 : Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class StraightLinePainter extends CustomPainter {
  final Color color;

  StraightLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..strokeWidth = 2;

    canvas.drawLine(
      Offset(size.width / 2, 0),
      Offset(size.width / 2, size.height),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class JobTrackerStatus {
  final String title;
  final String description;
  final String date;
  final JobStatus jobStatus;

  JobTrackerStatus({
    required this.title,
    required this.description,
    required this.date,
    required this.jobStatus,
  });
}
