import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:help_sum/src/core/constants/app_palette.dart';
import 'package:help_sum/src/core/router/app_routes.dart';
import 'package:help_sum/src/features/auth/data/models/request/schedule_request_model.dart';
import 'package:help_sum/src/features/auth/data/models/request/time_slot_request_model.dart';
import 'package:help_sum/src/features/auth/data/models/request/update_profile_model.dart';
import 'package:help_sum/src/features/auth/presentation/controller/notifiers/auth_notifier.dart';
import 'package:help_sum/src/features/auth/presentation/controller/notifiers/auth_state.dart';
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
<<<<<<< Updated upstream:lib/src/features/auth/presentation/pages/consumer/create_schdule.dart
<<<<<<< Updated upstream:lib/src/features/auth/presentation/pages/consumer/create_schdule.dart
  _SelectScheduleScreenState createState() => _SelectScheduleScreenState();
}

class _SelectScheduleScreenState extends State<SelectScheduleScreen> {
=======
  ConsumerState<SelectScheduleScreen> createState() =>
      SelectScheduleScreenState();
}

class SelectScheduleScreenState extends ConsumerState<SelectScheduleScreen> {
>>>>>>> Stashed changes:lib/src/features/auth/presentation/screens/create_schdule_page.dart
=======
  ConsumerState<SelectScheduleScreen> createState() =>
      SelectScheduleScreenState();
}

class SelectScheduleScreenState extends ConsumerState<SelectScheduleScreen> {
>>>>>>> Stashed changes:lib/src/features/auth/presentation/screens/create_schdule_page.dart
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
      startTimes[day] = const TimeOfDay(hour: 15, minute: 3);
      endTimes[day] = const TimeOfDay(hour: 16, minute: 3);
    }
  }

  void _pickTime(String day, bool isStart) async {
    final TimeOfDay initialTime = isStart ? startTimes[day]! : endTimes[day]!;

    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
      builder: (context, child) {
        return Theme(
          data: ThemeData(
            timePickerTheme: TimePickerThemeData(
              backgroundColor: Color(0xFF303030),
              hourMinuteTextColor: Colors.white,
              dayPeriodTextColor: Colors.white,
              entryModeIconColor: Color(0xFFFF8E01),
              dialHandColor: Color(0xFFFF8E01),
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
                        ? Color(0xFFFF8E01)
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
    return DateFormat('h:mm a').format(dt);
  }

  void _handleDone() {
    final selected = selectedDays.entries
        .where((entry) => entry.value)
        .map((e) => e.key);
    if (selected.isEmpty) {
      AnimatedStatusDialog.show(
        context: context,
        icon: SizedBox(),
        title: "Please select at least one day.",
        isSuccess: true,
      );
      return;
    }

    for (var day in selected) {
      if (!_isTimeValid(day)) {
        AnimatedStatusDialog.show(
          context: context,
          icon: SizedBox(),
          title: "Error: End time must be after start time for $day.",
          isSuccess: true,
        );
        return;
      }
    }
<<<<<<< Updated upstream:lib/src/features/auth/presentation/pages/consumer/create_schdule.dart
<<<<<<< Updated upstream:lib/src/features/auth/presentation/pages/consumer/create_schdule.dart
    // Save or submit logic here
    // ScaffoldMessenger.of(context).showSnackBar(
    //   const SnackBar(content: Text("Schedule saved successfully")),
    // );
    AnimatedStatusDialog.show(
      context: context,
      isShowTimer: true,
      title: "Congratulations!",
      message:
          widget.isEdit
              ? "Skills updated successfully"
              : "Your account is ready.You will\n be redirected to home page\n in a few seconds",
=======
>>>>>>> Stashed changes:lib/src/features/auth/presentation/screens/create_schdule_page.dart
=======
>>>>>>> Stashed changes:lib/src/features/auth/presentation/screens/create_schdule_page.dart

    final List<Schedule> scheduleData = [];

    for (var day in selected) {
      final shedule = Schedule(
        dayOfWeek: day,
        timeSlots: [
          TimeSlot(
            startTime: _formatTime(startTimes[day]!),
            endTime: _formatTime(endTimes[day]!),
          ),
        ],
      );
      scheduleData.add(shedule);
    }

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
                      : "Your account is ready.You will\n be redirected to home page\n in a few seconds",

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
      selectAll = selectedDays.values.every((isSelected) => isSelected);
    });
  }

  @override
  Widget build(BuildContext context) {
    // You can use ref here for Riverpod providers if needed
    return ModalProgressHUD(
      inAsyncCall: ref.watch(authNotifierProvider) is ScheduleLoading,
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
<<<<<<< Updated upstream:lib/src/features/auth/presentation/pages/consumer/create_schdule.dart
<<<<<<< Updated upstream:lib/src/features/auth/presentation/pages/consumer/create_schdule.dart
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
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
            if (widget.isEdit) ...[
              20.verticalSpace,
              SizedBox(
                width: .44.sw,
                child: CustomButton(
                  color: AppPalette.primaryColor,
                  textColor: AppPalette.fillColor,
                  text: "Save Changes",
                  onPressed: () => _handleDone(),
                ),
              ),
            ],

            if (!widget.isEdit) ...[
              const SizedBox(height: 24),
              SizedBox(
                width: .44.sw,
                child: CustomButton(
                  color: AppPalette.primaryColor,
                  textColor: AppPalette.fillColor,
                  text: "Done",
                  onPressed: () => _handleDone(),
                ),
              ),

              const SizedBox(height: 12),
              SizedBox(
                width: .44.sw,
                child: CustomButton(
                  color: AppPalette.primaryColor,
                  textColor: AppPalette.fillColor,
                  text: "Skip",
                  onPressed: () => Navigator.pop(context),
=======
=======
>>>>>>> Stashed changes:lib/src/features/auth/presentation/screens/create_schdule_page.dart
              const Divider(),
              Expanded(
                child: ListView.separated(
                  itemCount: days.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    final day = days[index];
                    return _buildScheduleRow(
                      day,
                      selectedDays[day]!,
                      (value) => _onDaySelected(day, value),
                      onStartTimeTap: () => _pickTime(day, true),
                      onEndTimeTap: () => _pickTime(day, false),
                      startTime: _formatTime(startTimes[day]!),
                      endTime: _formatTime(endTimes[day]!),
                    );
                  },
>>>>>>> Stashed changes:lib/src/features/auth/presentation/screens/create_schdule_page.dart
                ),
              ),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
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
              if (widget.isEdit) ...[
                20.verticalSpace,
                SizedBox(
                  width: .44.sw,
                  child: CustomButton(
                    color: AppPalette.primaryColor,
                    textColor: AppPalette.fillColor,
                    text: "Save Changes",
                    onPressed: () => _handleDone(),
                  ),
                ),
              ],

              if (!widget.isEdit) ...[
                const SizedBox(height: 24),
                SizedBox(
                  width: .44.sw,
                  child: CustomButton(
                    color: AppPalette.primaryColor,
                    textColor: AppPalette.fillColor,
                    text: "Done",
                    onPressed: () => _handleDone(),
                  ),
                ),

                const SizedBox(height: 12),
                SizedBox(
                  width: .44.sw,
                  child: CustomButton(
                    color: AppPalette.primaryColor,
                    textColor: AppPalette.fillColor,
                    text: "Skip",
                    onPressed: () {
                      context.goNamed(AppRoutes.mainNavigation);
                    },
                  ),
                ),
                const SizedBox(height: 10),
              ],
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
            onTap: () {
              onChanged(!isSelected);
            },
            child: Container(
              height: 18,
              width: 18,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppPalette.greyColor),
              ),
              child: AnimatedContainer(
                duration: Duration(milliseconds: 500),
                height: 18,
                width: 18,
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
      children: [
        CustomText(text: label, fontWeight: FontWeight.bold, fontSize: 12.sp),
        10.verticalSpace,
        InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8).r,
            decoration: BoxDecoration(
              color: Color(0xFFA9A9A9),
              borderRadius: BorderRadius.circular(8),
            ),
            child: CustomText(
              text: time,
              fontSize: 12.sp,
              color: AppPalette.whiteColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
