import 'package:flutter/material.dart';
import 'package:flutter_custom_month_picker/flutter_custom_month_picker.dart';
import 'package:help_sum/src/core/constants/app_palette.dart';
import 'package:help_sum/src/core/constants/app_texts.dart';
import 'package:help_sum/src/core/enums/job_status.dart';

class AppUtils {
  static String maskCardNumber(String cardNumber) {
    if (cardNumber.length < 4) return cardNumber;
    return '•••• •••• •••• ${cardNumber.substring(cardNumber.length - 4)}';
  }

  static Future<void> selectExpiryDate(
    BuildContext context, {
    required dynamic Function(int, int) onSelected,
  }) async {
    showMonthPicker(
      context,
      onSelected: onSelected,
      initialSelectedMonth: DateTime.now().month,
      initialSelectedYear: DateTime.now().year,
      firstYear: 2025,
      lastYear: 2050,
      firstEnabledMonth: DateTime.now().month,
      lastEnabledMonth: 12,
      selectButtonText: AppTexts.ok,
      cancelButtonText: AppTexts.cancel,
      highlightColor: AppPalette.primaryColor,
      textColor: Colors.black,
      contentBackgroundColor: Colors.white,
      dialogBackgroundColor: Colors.grey[100],
    );
  }

  static Color getJobColor(JobStatus job) {
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

  static String getJobString(JobStatus job) {
    switch (job) {
      case JobStatus.ongoing:
      case JobStatus.inProgress:
        return "In-Progress";
      case JobStatus.approved:
        return "Completed";
      case JobStatus.waitingConfirmation:
        return "Waiting Confirmation";
      case JobStatus.waitingPayment:
        return "Waiting Payment";
      case JobStatus.cancelled:
        return "Cancelled";
      case JobStatus.completed:
        return 'Completed';
      case JobStatus.all:
        return AppTexts.all;
      case JobStatus.pending:
        return AppTexts.pending;

      case JobStatus.rejected:
       return AppTexts.rejected;
    }
  }

  static String getServiceStartTimeTitle(JobStatus job) {
    switch (job) {
      case JobStatus.inProgress:
        return AppTexts.serviceStartTime;
      case JobStatus.pending:
        return AppTexts.requestedAt;
      case JobStatus.approved:
        return AppTexts.approvedAt;
      case JobStatus.cancelled:
        return AppTexts.rejectedAt;
      case JobStatus.waitingPayment:
      case JobStatus.completed:
        return AppTexts.serviceStartsOn;
         case JobStatus.waitingConfirmation:
         return AppTexts.confirmationRequestedAt;
      case JobStatus.all:
      case JobStatus.ongoing:
  
      case JobStatus.rejected:
        return AppTexts.approvedAt;
      
    }
  }

  static String getServiceEndTimeTitle(JobStatus job) {
    if (job == JobStatus.waitingPayment || job == JobStatus.completed) {
      return AppTexts.serviceEndsOn;
    } else {
      return AppTexts.serviceDateAndTime;
    }
  }
}
