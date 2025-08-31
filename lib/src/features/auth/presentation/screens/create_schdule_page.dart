import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:help_sum/src/core/constants/app_palette.dart';
import 'package:help_sum/src/core/dependency_injection/di_barrel.dart';
import 'package:help_sum/src/core/extensions/context_extensions.dart';
import 'package:help_sum/src/core/router/app_routes.dart';
import 'package:help_sum/src/features/auth/data/models/request/schdule_request_model.dart';
import 'package:help_sum/src/features/auth/data/models/request/time_slot_model.dart';
import 'package:help_sum/src/features/auth/data/models/request/update_profile_request_model.dart';
import 'package:help_sum/src/features/auth/presentation/bloc/login/login_bloc.dart';
import 'package:help_sum/src/features/auth/presentation/bloc/schedule/schedule_bloc.dart';
import 'package:help_sum/src/widgets/animated_dialog.dart';
import 'package:help_sum/src/widgets/custom_button.dart';
import 'package:help_sum/src/widgets/custom_text.dart';
import 'package:help_sum/src/widgets/modal_progress_hud.dart';
import 'package:intl/intl.dart';

class SchedulePage extends StatefulWidget {
  final bool isEdit;
  const SchedulePage({super.key, this.isEdit = false});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  late final ScheduleBloc _scheduleBloc;
  bool selectAll = false;

  final List<String> days = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday",
  ];

  late Map<String, bool> selectedDays;
  late Map<String, TimeOfDay> startTimes;
  late Map<String, TimeOfDay> endTimes;

  @override
  void initState() {
    super.initState();
    _scheduleBloc = sl<ScheduleBloc>();
    selectedDays = {for (var d in days) d: false};
    startTimes = {for (var d in days) d: const TimeOfDay(hour: 9, minute: 0)};
    endTimes = {for (var d in days) d: const TimeOfDay(hour: 17, minute: 0)};

    final user = sl<LoginBloc>().state.userEntity;
    if (widget.isEdit && user != null && user.schedule != null) {
      for (var schedule in user.schedule!) {
        final day = schedule.dayOfWeek;
        if (day != null && selectedDays.containsKey(day)) {
          selectedDays[day] = true;
          if (schedule.timeSlots != null && schedule.timeSlots!.isNotEmpty) {
            final slot = schedule.timeSlots!.first;
            try {
              startTimes[day] = TimeOfDay.fromDateTime(
                DateFormat('HH:mm').parse(slot.startTime!),
              );
              endTimes[day] = TimeOfDay.fromDateTime(
                DateFormat('HH:mm').parse(slot.endTime!),
              );
            } catch (e) {
              debugPrint("Time parsing error: $e");
            }
          }
        }
      }
    }
  }

  Future<void> _pickTime(String day, bool isStart) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStart ? startTimes[day]! : endTimes[day]!,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: Theme(
            data: ThemeData.dark().copyWith(
              timePickerTheme: TimePickerThemeData(
                dialHandColor: AppPalette.primaryColor,
                entryModeIconColor: AppPalette.primaryColor,
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

  String _formatTime(TimeOfDay time) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat('HH:mm').format(dt);
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
      selectAll = selectedDays.values.every((s) => s);
    });
  }

  void _handleDone() {
    final selected =
        selectedDays.entries.where((e) => e.value).map((e) => e.key).toList();
    if (selected.isEmpty) {
      AnimatedStatusDialog.show(
        context: context,
        title: "Please select at least one day.",
        isSuccess: false,
      );
      return;
    }
    for (var day in selected) {
      if (!_isTimeValid(day)) {
        AnimatedStatusDialog.show(
          context: context,
          title: "End time must be after start time for $day.",
          isSuccess: false,
        );
        return;
      }
    }

    final scheduleData =
        selected
            .map(
              (day) => Schedule(
                dayOfWeek: day,
                timeSlots: [
                  TimeSlot(
                    startTime: _formatTime(startTimes[day]!),
                    endTime: _formatTime(endTimes[day]!),
                  ),
                ],
              ),
            )
            .toList();

    _scheduleBloc.add(
      UpdateUserSchedule(
        schedule: UpdateProfileRequest(schedule: scheduleData),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _scheduleBloc,
      child: BlocConsumer<ScheduleBloc, ScheduleState>(
        listener: (context, state) {
          if (state.apiErrorMessage.isNotEmpty) {
            AnimatedStatusDialog.show(
              context: context,
              title: state.apiErrorMessage,
              isSuccess: false,
            );
          }
          if (state.scheduleCreated) {
            AnimatedStatusDialog.show(
              context: context,
              title: "Congratulations!",
              message:
                  widget.isEdit
                      ? "Schedule updated successfully"
                      : "Your account is ready. Redirecting...",
              isSuccess: true,
              isShowTimer: true,
              onBack: () => context.goNamed(AppRoutes.mainNavigation),
            );
          }
        },
        builder: (context, state) {
          return ModalProgressHUD(
            inAsyncCall: state.isLoading,
            child: SafeArea(
              top: false,
              child: Scaffold(
                backgroundColor: context.primaryColor,
                appBar: AppBar(
                  leading: const BackButton(),
                  title: const Text(
                    "Select your schedule",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  elevation: 0,
                ),
                body: Column(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(24.r),
                            bottomLeft: Radius.circular(24.r),
                          ),
                        ),
                        child: Column(
                          children: [
                            _buildScheduleRow(
                              "Select all",
                              selectAll,
                              _toggleSelectAll,
                              isHeader: true,
                            ),
                            const Divider(height: 15),
                            Expanded(
                              child: ListView.separated(
                                itemCount: days.length,
                                separatorBuilder:
                                    (_, __) => const Divider(height: 20),
                                itemBuilder: (_, i) {
                                  final d = days[i];
                                  return _buildScheduleRow(
                                    d,
                                    selectedDays[d]!,
                                    (v) => _onDaySelected(d, v),
                                    startTime: _formatTime(startTimes[d]!),
                                    endTime: _formatTime(endTimes[d]!),
                                    onStartTimeTap: () => _pickTime(d, true),
                                    onEndTimeTap: () => _pickTime(d, false),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                      ).copyWith(bottom: 26.h),
                      child:
                          widget.isEdit
                              ? CustomButton(
                                color: AppPalette.whiteColor,
                                textColor: AppPalette.primaryColor,
                                text: "Save Changes",
                                radius: 10,
                                onPressed: _handleDone,
                              )
                              : Row(
                                children: [
                                  Expanded(
                                    child: CustomButton(
                                      color: AppPalette.whiteColor,
                                      textColor: AppPalette.primaryColor,
                                      text: "Skip",
                                      radius: 10,
                                      onPressed:
                                          () => context.goNamed(
                                            AppRoutes.mainNavigation,
                                          ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: CustomButton(
                                      color: AppPalette.whiteColor,
                                      textColor: AppPalette.primaryColor,
                                      text: "Done",
                                      radius: 10,
                                      onPressed: _handleDone,
                                    ),
                                  ),
                                ],
                              ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
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
    return Column(
      children: [
        Row(
          children: [
            Checkbox(
              value: isSelected,
              onChanged: onChanged,
              activeColor: AppPalette.primaryColor,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            Expanded(
              child: CustomText(
                text: title,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        if (!isHeader)
          Padding(
            padding: const EdgeInsets.only(left: 0, top: 6),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: onStartTimeTap,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 12,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [Text(startTime ?? "--:--"), clockIcon()],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: onEndTimeTap,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 12,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [Text(endTime ?? "--:--"), clockIcon()],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Icon clockIcon() {
    return Icon(Icons.access_time, size: 20, color: context.primaryColor);
  }
}
