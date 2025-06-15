import 'package:flutter/material.dart';
import 'package:help_sum/src/widgets/custom_text.dart';

class AppointmentDateTimeCard extends StatelessWidget {
  final String date;
  final String time;

  const AppointmentDateTimeCard({
    Key? key,
    required this.date,
    required this.time,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(text: date, fontWeight: FontWeight.bold),
            CustomText(text: time, fontWeight: FontWeight.bold),
          ],
        ),
      ),
    );
  }
}
