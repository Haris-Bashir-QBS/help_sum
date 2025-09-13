import 'package:flutter/material.dart';
import 'package:help_sum/src/features/core/common/general/presentation/widgets/message_card.dart';
import 'package:help_sum/src/widgets/custom_refresh_indicator.dart';
import 'package:help_sum/src/widgets/custom_text.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: CustomRefreshIndicator(
        onRefresh: () async {},
        child: ListView.separated(
          itemBuilder: (_, index) {
            return ContentCard(
              name: "Order Completed #45$index ",
              // unreadCount: 4,
              message:
                  "Your order no 13453 has been completed sucessfully with rating 4.5 ",
              time: "24:33",
            );
          },
          separatorBuilder: (_, index) {
            return SizedBox(height: 10);
          },
          itemCount: 100,
        ),
      ),
    );
  }
}
