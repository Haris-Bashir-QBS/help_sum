import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:help_sum/src/core/enums/job_status.dart' show JobStatus;
import 'package:help_sum/src/core/models/common/job_tracker_status_model.dart';

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
                              ? Colors.red.withOpacity(0.7)
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
