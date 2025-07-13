// ignore_for_file: public_member_api_docs, sort_constructors_first
class TimeSlot {
  final String? startTime;
  final String? endTime;

  TimeSlot({this.startTime, this.endTime});

  @override
  String toString() => 'TimeSlot(startTime: $startTime, endTime: $endTime)';
  factory TimeSlot.fromJson(Map<String, dynamic> json) {
    return TimeSlot(
      startTime: json['startTime'] as String?,
      endTime: json['endTime'] as String?,
    );
  }
}

extension TimeSlotSerializer on TimeSlot {
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (startTime != null) data['startTime'] = startTime;
    if (endTime != null) data['endTime'] = endTime;
    return data;
  }
}
