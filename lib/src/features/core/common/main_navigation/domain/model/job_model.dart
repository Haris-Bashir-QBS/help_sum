import 'package:help_sum/src/core/enums/job_status.dart';

class JobModel {
  final String date;
  final String time;
  final String customerName;
  final String serviceName;
  final JobStatus jobStatus;

  JobModel({
    required this.date,
    required this.time,
    required this.customerName,
    required this.serviceName,
    required this.jobStatus,
  });
}
