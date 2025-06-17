import 'package:flutter/material.dart';
import 'package:help_sum/src/core/constants/app_palette.dart';
import 'package:help_sum/src/core/constants/app_role.dart';
import 'package:help_sum/src/core/constants/app_texts.dart';
import 'package:help_sum/src/core/utils/app_static_data.dart';
import 'package:help_sum/src/features/core/merchant/presentation/pages/all_jobs_screen.dart';
import 'package:help_sum/src/features/core/common/main_navigation/pages/home_page.dart';
import 'package:help_sum/src/features/core/common/main_navigation/pages/merchant_home.dart';
import 'package:help_sum/src/features/core/common/profile/pages/profile_details_page.dart';
import 'package:help_sum/src/features/core/consumer/booking/presentation/pages/all_booking_screen.dart';
import 'package:help_sum/src/features/core/merchant/presentation/pages/income_history.dart';
import 'package:help_sum/src/widgets/custom_app_bar.dart';
import 'package:help_sum/src/widgets/custom_text.dart';
import 'package:help_sum/src/widgets/custom_text_formfield.dart';

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [];

  final List<NavigationDestination> _consumerDestinations = [
    NavigationDestination(
      icon: Image.asset("assets/icons/bottom/unfocused/history.png"),
      selectedIcon: Image.asset("assets/icons/bottom/focused/history.png"),
      label: '',
    ),

    NavigationDestination(
      icon: Image.asset("assets/icons/bottom/unfocused/dashbaord.png"),
      selectedIcon: Image.asset("assets/icons/bottom/focused/dashboard.png"),
      label: '',
    ),
    NavigationDestination(
      icon: Image.asset("assets/icons/bottom/unfocused/profile.png"),
      selectedIcon: Image.asset("assets/icons/bottom/focused/profile.png"),
      label: '',
    ),
  ];

  final List<NavigationDestination> _merchantDestinations = [
    NavigationDestination(
      icon: Image.asset("assets/icons/bottom/unfocused/jobs.png"),
      selectedIcon: Image.asset("assets/icons/bottom/focused/jobs.png"),
      label: '',
    ),

    NavigationDestination(
      icon: Image.asset("assets/icons/bottom/unfocused/dashbaord.png"),
      selectedIcon: Image.asset("assets/icons/bottom/focused/dashboard.png"),
      label: '',
    ),

    NavigationDestination(
      icon: Image.asset("assets/icons/bottom/unfocused/history.png"),
      selectedIcon: Image.asset("assets/icons/bottom/focused/history.png"),
      label: '',
    ),

    NavigationDestination(
      icon: Image.asset("assets/icons/bottom/unfocused/profile.png"),
      selectedIcon: Image.asset("assets/icons/bottom/focused/profile.png"),
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
        MerchantHome(),
        IncomeScreen(),
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
        bottomWidget:
            _selectedIndex == 1 && appRole == AppRole.merchant
                ? PreferredSize(
                  preferredSize: Size.fromHeight(95),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    child: Row(
                      children: [
                        Expanded(
                          child: CustomTextFormField(
                            hint: 'Search...',
                            prefixIcon: Icons.search,
                          ),
                        ),
                        SizedBox(width: 10),

                        Icon(
                          Icons.bookmark,
                          size: 30,
                          color: AppPalette.primaryColor,
                        ),
                      ],
                    ),
                  ),
                )
                : null,
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
          // indicatorColor: AppPalette.primaryColor.withOpacity(0.2),
          labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        ),
      ),
    );
  }
}
