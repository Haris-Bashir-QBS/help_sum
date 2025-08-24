part of 'schedule_bloc.dart';

sealed class ScheduleEvent {
  const ScheduleEvent();
}

class UpdateUserSchedule extends ScheduleEvent {
  final UpdateProfileRequest schedule;
  const UpdateUserSchedule({required this.schedule});
}
