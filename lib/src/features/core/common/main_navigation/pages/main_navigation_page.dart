import 'package:flutter/material.dart';
import 'package:help_sum/src/core/constants/app_palette.dart';
import 'package:help_sum/src/core/constants/app_role.dart';
import 'package:help_sum/src/core/constants/app_texts.dart';
import 'package:help_sum/src/core/utils/app_static_data.dart';
import 'package:help_sum/src/features/core/common/main_navigation/pages/consumer/all_jobs_screen.dart';
import 'package:help_sum/src/features/core/common/main_navigation/pages/home_page.dart';
import 'package:help_sum/src/features/core/common/profile/pages/profile_details_page.dart';
import 'package:help_sum/src/features/core/consumer/booking/presentation/pages/all_booking_screen.dart';
import 'package:help_sum/src/widgets/custom_app_bar.dart';
import 'package:help_sum/src/widgets/custom_text.dart';

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [];

  final List<NavigationDestination> _consumerDestinations = const [
    NavigationDestination(
      icon: Icon(Icons.history_outlined),
      selectedIcon: Icon(Icons.history),
      label: '',
    ),
    NavigationDestination(
      icon: Icon(Icons.apps_outlined),
      selectedIcon: Icon(Icons.apps),
      label: '',
    ),
    NavigationDestination(
      icon: Icon(Icons.person_outline),
      selectedIcon: Icon(Icons.person),
      label: '',
    ),
  ];

  final List<NavigationDestination> _merchantDestinations = const [
    NavigationDestination(
      icon: Icon(Icons.copy_all_outlined),
      selectedIcon: Icon(Icons.copy_all),
      label: '',
    ),
    NavigationDestination(
      icon: Icon(Icons.apps_outlined),
      selectedIcon: Icon(Icons.apps),
      label: '',
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    if (appRole == AppRole.consumer) {
      _pages.addAll([AllBookingsPage(), HomePage(), ProfileDetailsPage()]);
    } else {
      _pages.addAll([
        const AllJobsScreen(),
        CustomText(text: AppTexts.categories),
        ProfileDetailsPage(),
      ]);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        centerTitle: false,
        showLeading: false,
        title:
            appRole == AppRole.consumer
                ? AppStaticData.consumerAppbarTitles[_selectedIndex]
                : AppStaticData.merchantAppBarTitles[_selectedIndex],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
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
          //  shadowColor: Colors.red,
          selectedIndex: _selectedIndex,
          onDestinationSelected: _onItemTapped,
          destinations:
              appRole == AppRole.consumer
                  ? _consumerDestinations
                  : _merchantDestinations,
          elevation: 120,
          height: 65,
          backgroundColor: AppPalette.lightGreyColor,
          indicatorColor: AppPalette.primaryColor.withOpacity(0.2),
          labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        ),
      ),
    );
  }
}
