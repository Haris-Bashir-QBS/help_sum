import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:help_sum/src/core/constants/app_palette.dart';
import 'package:help_sum/src/core/constants/app_role.dart';
import 'package:help_sum/src/core/constants/app_texts.dart';
import 'package:help_sum/src/features/core/common/main_navigation/pages/consumer/all_jobs_screen.dart';
import 'package:help_sum/src/features/core/common/main_navigation/pages/home_page.dart';
import 'package:help_sum/src/features/core/common/profile/pages/profile_details_page.dart';
import 'package:help_sum/src/widgets/custom_text.dart';

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [];

  final List<BottomNavigationBarItem> bottomItems = [];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    if (appRole == AppRole.user) {
      _pages.addAll([
        const HomePage(),
        CustomText(text: AppTexts.categories),
        ProfileDetailsPage(),
      ]);

      bottomItems.addAll(const <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.history), label: ""),
        BottomNavigationBarItem(icon: Icon(Icons.apps), label: ""),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: ""),
      ]);
    } else {
      bottomItems.addAll(const <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.copy_all), label: ""),
        BottomNavigationBarItem(icon: Icon(Icons.apps), label: ""),
      ]);
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
      appBar: AppBar(
        centerTitle: false,
        title:
            appRole == AppRole.consumer && _selectedIndex == 0
                ? CustomText(
                  text: 'Jobs',
                  fontWeight: FontWeight.bold,
                  fontSize: 24.sp,
                )
                : null,
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: bottomItems,
        currentIndex: _selectedIndex,
        selectedItemColor: AppPalette.primaryColor,
        onTap: _onItemTapped,
      ),
    );
  }
}
