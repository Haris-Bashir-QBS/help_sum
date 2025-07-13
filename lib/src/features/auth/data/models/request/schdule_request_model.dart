// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'time_slot_model.dart';

class Schedule {
  final String? dayOfWeek;
  final List<TimeSlot>? timeSlots;

  Schedule({this.dayOfWeek, this.timeSlots});

  @override
  String toString() => 'Schedule(dayOfWeek: $dayOfWeek, timeSlots: $timeSlots)';

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      dayOfWeek: json['dayOfWeek'] as String?,
      timeSlots:
          (json['timeSlots'] as List?)
              ?.map((e) => TimeSlot.fromJson(e as Map<String, dynamic>))
              .toList(),
    );
  }
}

extension ScheduleSerializer on Schedule {
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (dayOfWeek != null) data['dayOfWeek'] = dayOfWeek;
    if (timeSlots != null && timeSlots!.isNotEmpty) {
      data['timeSlots'] = timeSlots!.map((t) => t.toJson()).toList();
    }
    return data;
  }
}
