import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:help_sum/src/core/constants/app_palette.dart';
import 'package:help_sum/src/core/router/app_routes.dart';
import 'package:help_sum/src/features/auth/data/models/request/schdule_request_model.dart';
import 'package:help_sum/src/features/auth/data/models/request/time_slot_model.dart';
import 'package:help_sum/src/features/auth/data/models/request/update_profile_request_model.dart';
import 'package:help_sum/src/features/auth/presentation/controller/notifiers/auth_notifier.dart';
import 'package:help_sum/src/features/auth/presentation/controller/notifiers/auth_state.dart';
import 'package:help_sum/src/features/core/common/profile/presentation/controller/user_state_provider.dart';
import 'package:help_sum/src/widgets/animated_dialog.dart';
import 'package:help_sum/src/widgets/custom_button.dart';
import 'package:help_sum/src/widgets/custom_text.dart';
import 'package:help_sum/src/widgets/modal_progress_hud.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectScheduleScreen extends ConsumerStatefulWidget {
  const SelectScheduleScreen({super.key, this.isEdit = false});
  final bool isEdit;

  @override
  ConsumerState<SelectScheduleScreen> createState() =>
      _SelectScheduleScreenState();
}

class _SelectScheduleScreenState extends ConsumerState<SelectScheduleScreen> {
  final List<String> days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  late Map<String, bool> selectedDays;
  Map<String, TimeOfDay> startTimes = {};
  Map<String, TimeOfDay> endTimes = {};
  bool selectAll = false;

  @override
  void initState() {
    super.initState();
    selectedDays = {for (var day in days) day: false};
    for (var day in days) {
      startTimes[day] = const TimeOfDay(hour: 08, minute: 0);
      endTimes[day] = const TimeOfDay(hour: 18, minute: 0);
    }

    final user = ref.read(currentUserProvider).user;
    if (widget.isEdit && user != null && user.schedule != null) {
      print(user.schedule.toString());
      for (var schedule in user.schedule!) {
        final day = schedule.dayOfWeek;
        if (day != null && selectedDays.containsKey(day)) {
          selectedDays[day] = true;

          if (schedule.timeSlots != null && schedule.timeSlots!.isNotEmpty) {
            final slot = schedule.timeSlots![0];
            final startTimeStr = slot.startTime;
            final endTimeStr = slot.endTime;

            try {
              final startTime = TimeOfDay.fromDateTime(
                DateFormat('HH:mm').parse(startTimeStr!),
              );
              final endTime = TimeOfDay.fromDateTime(
                DateFormat('HH:mm').parse(endTimeStr!),
              );

              startTimes[day] = startTime;
              endTimes[day] = endTime;
            } catch (e) {
              debugPrint("Time parsing error: $e");
            }
          }
        }
      }
    }
  }

  void _pickTime(String day, bool isStart) async {
    final TimeOfDay initialTime = isStart ? startTimes[day]! : endTimes[day]!;

    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: Theme(
            data: ThemeData(
              timePickerTheme: TimePickerThemeData(
                backgroundColor: const Color(0xFF303030),
                hourMinuteTextColor: Colors.white,
                dayPeriodTextColor: Colors.white,
                entryModeIconColor: const Color(0xFFFF8E01),
                dialHandColor: const Color(0xFFFF8E01),
                dialBackgroundColor: Colors.grey.shade800,
                dialTextColor: MaterialStateColor.resolveWith(
                  (states) =>
                      states.contains(MaterialState.selected)
                          ? Colors.black
                          : Colors.white,
                ),
                hourMinuteColor: MaterialStateColor.resolveWith(
                  (states) =>
                      states.contains(MaterialState.selected)
                          ? const Color(0xFFFF8E01)
                          : Colors.grey.shade800,
                ),
              ),
              colorScheme: const ColorScheme.dark(
                primary: Color(0xFFFF8E01),
                onPrimary: Colors.black,
                surface: Color(0xFF303030),
                onSurface: Colors.white,
              ),
            ),
            child: child!,
          ),
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          startTimes[day] = picked;
        } else {
          endTimes[day] = picked;
        }
      });
    }
  }

  bool _isTimeValid(String day) {
    final now = DateTime.now();
    final start = DateTime(
      now.year,
      now.month,
      now.day,
      startTimes[day]!.hour,
      startTimes[day]!.minute,
    );
    final end = DateTime(
      now.year,
      now.month,
      now.day,
      endTimes[day]!.hour,
      endTimes[day]!.minute,
    );
    return end.isAfter(start);
  }

  String _formatTime(TimeOfDay time) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat('HH:mm').format(dt); // 24-hour format
  }

  void _handleDone() {
    final selected =
        selectedDays.entries
            .where((entry) => entry.value)
            .map((e) => e.key)
            .toList();

    if (selected.isEmpty) {
      AnimatedStatusDialog.show(
        context: context,
        icon: const SizedBox(),
        title: "Please select at least one day.",
        isSuccess: true,
      );
      return;
    }

    for (var day in selected) {
      if (!_isTimeValid(day)) {
        AnimatedStatusDialog.show(
          context: context,
          icon: const SizedBox(),
          title: "End time must be after start time for $day.",
          isSuccess: true,
        );
        return;
      }
    }

    final List<Schedule> scheduleData =
        selected.map((day) {
          return Schedule(
            dayOfWeek: day,
            timeSlots: [
              TimeSlot(
                startTime: _formatTime(startTimes[day]!),
                endTime: _formatTime(endTimes[day]!),
              ),
            ],
          );
        }).toList();

    ref
        .read(authNotifierProvider.notifier)
        .updateSchdule(
          context,
          UpdateProfileRequest(schedule: scheduleData),
          onSuccess: () {
            AnimatedStatusDialog.show(
              context: context,
              isShowTimer: true,
              sucessOnly: true,
              title: "Congratulations!",
              message:
                  widget.isEdit
                      ? "Schedule updated successfully"
                      : "Your account is ready.\nYou will be redirected to home page\nin a few seconds.",
              onBack: () {
                context.goNamed(AppRoutes.mainNavigation);
              },
              isSuccess: true,
            );
          },
        );
  }

  void _toggleSelectAll(bool? value) {
    setState(() {
      selectAll = value ?? false;
      for (var day in days) {
        selectedDays[day] = selectAll;
      }
    });
  }

  void _onDaySelected(String day, bool? value) {
    setState(() {
      selectedDays[day] = value ?? false;
      selectAll = selectedDays.values.every((selected) => selected);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authNotifierProvider);

    return ModalProgressHUD(
      inAsyncCall: state is ScheduleLoading,
      child: Scaffold(
        appBar: AppBar(
          leading: const BackButton(),
          title: const Text(
            "Select your schedule",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          foregroundColor: Colors.black,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: Column(
            children: [
              _buildScheduleRow(
                "Select all",
                selectAll,
                _toggleSelectAll,
                isHeader: true,
              ),
              const Divider(),
              Expanded(
                child: ListView.separated(
                  itemCount: days.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (_, index) {
                    final day = days[index];
                    return _buildScheduleRow(
                      day,
                      selectedDays[day]!,
                      (value) => _onDaySelected(day, value),
                      startTime: _formatTime(startTimes[day]!),
                      endTime: _formatTime(endTimes[day]!),
                      onStartTimeTap: () => _pickTime(day, true),
                      onEndTimeTap: () => _pickTime(day, false),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: const [
                  Icon(Icons.info_outline, color: Colors.orange, size: 18),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "Note: End time cannot be less than or equal to start time",
                      style: TextStyle(color: Colors.orange, fontSize: 13),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              if (widget.isEdit) ...[
                SizedBox(
                  width: .44.sw,
                  child: CustomButton(
                    color: AppPalette.primaryColor,
                    textColor: AppPalette.fillColor,
                    text: "Save Changes",
                    onPressed: _handleDone,
                  ),
                ),
              ] else ...[
                const SizedBox(height: 24),
                SizedBox(
                  width: .44.sw,
                  child: CustomButton(
                    color: AppPalette.primaryColor,
                    textColor: AppPalette.fillColor,
                    text: "Done",
                    onPressed: _handleDone,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: .44.sw,
                  child: CustomButton(
                    color: AppPalette.primaryColor,
                    textColor: AppPalette.fillColor,
                    text: "Skip",
                    onPressed: () => context.goNamed(AppRoutes.mainNavigation),
                  ),
                ),
              ],
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScheduleRow(
    String title,
    bool isSelected,
    ValueChanged<bool?> onChanged, {
    bool isHeader = false,
    String? startTime,
    String? endTime,
    VoidCallback? onStartTimeTap,
    VoidCallback? onEndTimeTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => onChanged(!isSelected),
            child: Container(
              height: 18,
              width: 18,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppPalette.greyColor),
              ),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                decoration: BoxDecoration(
                  color: isSelected ? AppPalette.primaryColor : null,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          10.horizontalSpace,
          Expanded(
            child: CustomText(
              text: title,
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (!isHeader)
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildTimePicker("Start Time", startTime!, onStartTimeTap!),
                8.horizontalSpace,
                _buildTimePicker("End Time", endTime!, onEndTimeTap!),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildTimePicker(String label, String time, VoidCallback onTap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(text: label, fontSize: 11.sp, color: Colors.grey),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(6),
            ),
            child: CustomText(text: time, fontSize: 13.sp),
          ),
        ),
      ],
    );
  }
}
