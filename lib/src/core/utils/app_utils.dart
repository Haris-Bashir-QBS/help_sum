import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_custom_month_picker/flutter_custom_month_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;
import 'package:help_sum/src/core/constants/app_palette.dart';
import 'package:help_sum/src/core/constants/app_texts.dart';
import 'package:help_sum/src/core/enums/job_status.dart';
import 'package:help_sum/src/core/enums/permission_status.dart';
import 'package:help_sum/src/core/services/permission_manager.dart';
import 'package:help_sum/src/core/utils/app_static_data.dart';
import 'package:help_sum/src/features/auth/data/models/request/schdule_request_model.dart';
import 'package:help_sum/src/widgets/custom_text.dart';
import 'package:help_sum/src/widgets/modal_progress_hud.dart';
import 'package:intl/intl.dart';

import '../../features/auth/domain/entities/user_entity.dart';

class AppUtils {
  static String formatReadableDate(String dateString) {
    final dateTime = DateFormat('M/d/y').parse(dateString); // handles 7/22/2025
    final dayOfWeek = DateFormat('EEEE').format(dateTime);
    final day = DateFormat('d').format(dateTime);
    final month = DateFormat('MMMM').format(dateTime);
    final year = DateFormat('y').format(dateTime);
    return '$dayOfWeek, $day $month $year';
  }

  static String formatReadableTime(String timeString) {
    try {
      final dateTime = DateFormat('H:mm').parse(timeString); // 24-hour input
      return DateFormat('hh:mm a').format(dateTime); // 02:00 PM
    } catch (_) {
      return 'Invalid time';
    }
  }

  static Future<void> showProgressLoader({required BuildContext context}) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      useRootNavigator: true,
      barrierColor: Colors.black.withValues(alpha: .4),
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Center(
            child: CircularProgressIndicator(color: AppPalette.primaryColor),
          ),
        );
      },
    );
  }

  static void hideLoader(BuildContext context) {
    Navigator.of(context, rootNavigator: true).maybePop();
  }

  /// Picks a date with optional range.
  static Future<DateTime?> pickDate(
    BuildContext context, {
    required DateTime firstDate,
    required DateTime lastDate,
  }) async {
    return await showDatePicker(
      context: context,
      // useRootNavigator: true,
      initialDate: DateTime.now(),
      firstDate: firstDate,
      lastDate: lastDate,
      currentDate: DateTime.now(),
    );
  }

  static Future<TimeOfDay?> pickTime(
    BuildContext context, {
    bool restrictPast = false,
    TimeOfDay? initialTime,
  }) async {
    final now = TimeOfDay.now();
    final time = initialTime ?? now;

    final picked = await showTimePicker(
      context: context,
      initialTime: time,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            timePickerTheme: const TimePickerThemeData(
              backgroundColor: Colors.white,
              hourMinuteTextColor: Colors.black,
              dialHandColor: Colors.blue,
            ),
            colorScheme: ColorScheme.light(
              primary: Colors.blue, // OK/Cancel buttons
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && restrictPast) {
      final pickedMinutes = picked.hour * 60 + picked.minute;
      final nowMinutes = now.hour * 60 + now.minute;

      if (pickedMinutes < nowMinutes) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select a future time'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.redAccent,
          ),
        );
        return null;
      }
    }

    return picked;
  }

  static void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  static String maskCardNumber(String cardNumber) {
    if (cardNumber.length < 4) return cardNumber;
    return '•••• •••• •••• ${cardNumber.substring(cardNumber.length - 4)}';
  }

  ///ShowLoading
  static void showLoadingDialog({
    required BuildContext context,
    String message = "Please wait...",
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          content: Row(
            children: [
              const CircularProgressIndicator(color: AppPalette.primaryColor),
              const SizedBox(width: 20),
              Expanded(child: CustomText(text: message, maxLines: 3)),
            ],
          ),
        );
      },
    );
  }

  /// CLose Loading Dialog
  static void closeLoadingDialog(BuildContext context) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
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
        return Color.fromARGB(255, 239, 160, 160);
      case JobStatus.all:
        return Colors.transparent;
    }
  }

  static String getJobString(JobStatus job) {
    switch (job) {
      case JobStatus.ongoing:
      case JobStatus.in_progress:
        return "In-Progress";
      case JobStatus.approved:
      case JobStatus.accepted:
        return "Approved";
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
      case JobStatus.in_progress:
        return AppTexts.serviceStartTime;
      case JobStatus.pending:
        return AppTexts.requestedAt;
      case JobStatus.approved:
      case JobStatus.accepted:
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

  static JobStatus parseJobStatus(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return JobStatus.completed;
      case 'inprogress':
        return JobStatus.in_progress;
      case 'pending':
        return JobStatus.pending;
      case 'accepted':
        return JobStatus.approved;
      case 'confirmation waiting':
        return JobStatus.waitingConfirmation;
      case 'payment waiting':
        return JobStatus.waitingPayment;
      case 'cancelled':
        return JobStatus.cancelled;
      case 'rejected':
        return JobStatus.rejected;
      default:
        return JobStatus.all;
    }
  }

  static Future<LatLng?> getLocation() async {
    final permission = await PermissionManager().requestLocationPermission();

    log(permission.name.toString());

    if (permission == PermissionState.granted) {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 10,
        ),
      );
      return LatLng(position.latitude, position.longitude);
    } else if (permission == PermissionState.permnantlyDenied) {
      return null;
    }
    return null;
  }

  static String getTodayScheduleSubtitle(UserEntity user) {
    final now = DateTime.now();
    final days = AppStaticData.daysOfWeek;
    final today = days[now.weekday - 1];
    final schedule = user.schedule;
    if (schedule == null || schedule.isEmpty) {
      return 'No schedule for today';
    }
    final todaySchedule = schedule.firstWhere(
      (s) => s.dayOfWeek?.toLowerCase() == today.toLowerCase(),
      orElse: () => Schedule(dayOfWeek: today, timeSlots: []),
    );
    if (todaySchedule.timeSlots == null || todaySchedule.timeSlots!.isEmpty) {
      return 'No schedule for today';
    }
    final slot = todaySchedule.timeSlots!.first;
    if (slot.startTime == null || slot.endTime == null) {
      return 'No schedule for today';
    }
    final formattedStart = _formatTime(slot.startTime!);
    final formattedEnd = _formatTime(slot.endTime!);
    return "Today: $formattedStart - $formattedEnd";
  }

  static String _formatTime(String time) {
    try {
      final dt = DateFormat('H:mm').parse(time);
      return DateFormat('h:mm a').format(dt);
    } catch (_) {
      return time;
    }
  }
}
