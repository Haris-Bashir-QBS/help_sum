import 'package:flutter/material.dart';
import 'package:help_sum/src/core/constants/app_palette.dart';
import 'package:help_sum/src/core/constants/app_role.dart';
import 'package:help_sum/src/core/utils/app_static_data.dart';

class AppBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;
  final String userRole;

  const AppBottomNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
    required this.userRole,
  });

  @override
  Widget build(BuildContext context) {
    final destinations =
        userRole == AppRole.consumer.name
            ? AppStaticData.consumerDestinations
            : AppStaticData.merchantDestinations;

    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
        border: Border(
          top: BorderSide(color: Colors.grey.withOpacity(0.5), width: 1),
        ),
      ),
      child: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: onTap,
        destinations: destinations,
        elevation: 120,
        height: 65,
        backgroundColor: AppPalette.lightGreyColor,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
      ),
    );
  }
}
