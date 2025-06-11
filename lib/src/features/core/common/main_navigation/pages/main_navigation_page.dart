import 'package:flutter/material.dart';
import 'package:help_sum/src/core/constants/app_palette.dart';
import 'package:help_sum/src/core/constants/app_texts.dart';
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

  final List<Widget> _pages = [
    const HomePage(), 
    CustomText(text: AppTexts.categories), 
    ProfileDetailsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.apps),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "",
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: AppPalette.primaryColor,
        onTap: _onItemTapped,
      ),
    );
  }
}
