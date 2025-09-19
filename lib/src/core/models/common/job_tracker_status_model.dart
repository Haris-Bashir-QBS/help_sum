import 'package:help_sum/src/core/enums/job_status.dart';

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
