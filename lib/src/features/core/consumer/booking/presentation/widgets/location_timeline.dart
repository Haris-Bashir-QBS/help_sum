import 'package:flutter/material.dart';

class LocationTimeline extends StatelessWidget {
  const LocationTimeline({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.location_on, color: Colors.blue),
        SizedBox(width: 8),
        Expanded(child: Container(height: 1, color: Colors.grey)),
        SizedBox(width: 8),
        Icon(Icons.location_on, color: Colors.green),
      ],
    );
  }
}
