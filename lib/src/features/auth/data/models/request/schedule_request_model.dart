// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'time_slot_request_model.dart';

class Schedule {
  final String? dayOfWeek;
  final List<TimeSlot>? timeSlots;

  Schedule({this.dayOfWeek, this.timeSlots});

  @override
  String toString() => 'Schedule(dayOfWeek: $dayOfWeek, timeSlots: $timeSlots)';
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
