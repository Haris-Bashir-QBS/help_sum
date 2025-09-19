import 'package:flutter/material.dart';
import 'package:help_sum/src/core/enums/job_status.dart';
import 'package:help_sum/src/core/utils/app_utils.dart';
import 'package:help_sum/src/features/core/consumer/booking/data/models/job_response_model.dart';
import 'package:help_sum/src/features/core/consumer/booking/presentation/widgets/job_status_card.dart';
import '../../../../../../core/models/common/job_tracker_status_model.dart';

class JobProgressTimeline extends StatelessWidget {
  final JobData job;
  final String tabName;
  final VoidCallback onTap;

  const JobProgressTimeline({
    super.key,
    required this.job,
    required this.tabName,
    required this.onTap,
  });

  JobStatus get currentStatus => AppUtils.parseJobStatus(job.status);

  List<JobTrackerStatus> _getJobStatuses() {
    final baseDate = DateTime.tryParse(job.createdAt) ?? DateTime.now();

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
    }

    if (currentStatus == JobStatus.rejected) {
      statuses.add(
        JobTrackerStatus(
          title: "Job Rejected",
          description: "Merchant rejected your job request.",
          date: _formatDate(baseDate.add(const Duration(hours: 1))),
          jobStatus: JobStatus.rejected,
        ),
      );
    }

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
              onTap: onTap,
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
