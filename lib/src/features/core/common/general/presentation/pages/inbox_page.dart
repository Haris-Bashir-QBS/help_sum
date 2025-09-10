import 'package:flutter/material.dart';
import 'package:help_sum/src/features/core/common/general/presentation/widgets/message_card.dart';
import 'package:help_sum/src/widgets/custom_refresh_indicator.dart';

class InboxPage extends StatelessWidget {
  const InboxPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: CustomRefreshIndicator(
        onRefresh: () async {},
        child: ListView.separated(
          itemBuilder: (_, index) {
            return ContentCard(
              name: "Ali R",
              unreadCount: 4,
              message: "Lorem Ipsum dummy" * 4,
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
