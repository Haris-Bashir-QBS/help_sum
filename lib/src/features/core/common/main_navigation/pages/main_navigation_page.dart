import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:help_sum/src/core/constants/app_palette.dart';
import 'package:help_sum/src/core/constants/app_role.dart';
import 'package:help_sum/src/core/dependency_injection/di_barrel.dart';
import 'package:help_sum/src/core/router/app_routes.dart';
import 'package:help_sum/src/core/utils/app_static_data.dart';
import 'package:help_sum/src/features/auth/presentation/bloc/login/login_bloc.dart';
import 'package:help_sum/src/features/auth/presentation/controller/notifiers/auth_notifier.dart';
import 'package:help_sum/src/features/core/common/general/presentation/view/inbox_and_notifications_view.dart';
import 'package:help_sum/src/features/core/common/main_navigation/widgets/custom_bottom_navigation_bar.dart';
import 'package:help_sum/src/features/core/common/profile/presentation/pages/profile_details_page.dart';
import 'package:help_sum/src/features/core/consumer/booking/presentation/pages/all_booking_screen.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/presentation/pages/Home_categories_page.dart';
import 'package:help_sum/src/features/core/merchant/presentation/pages/all_jobs_screen.dart';
import 'package:help_sum/src/features/core/merchant/presentation/pages/income_history.dart';
import 'package:help_sum/src/features/core/merchant/presentation/pages/merchant_home.dart';
import 'package:help_sum/src/widgets/custom_app_bar.dart';

class MainNavigationPage extends ConsumerStatefulWidget {
  const MainNavigationPage({super.key});

  @override
  ConsumerState<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends ConsumerState<MainNavigationPage> {
  int _selectedIndex = 0;
  String? userRole;
  final List<Widget> _pages = [];
  late final LoginBloc loginBloc;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    loginBloc = sl<LoginBloc>();
    userRole = loginBloc.state.userEntity?.role;
    debugPrint("User Role is $userRole");
    if (userRole == AppRole.consumer.name) {
      _selectedIndex = 1;
      _pages.addAll([
        AllBookingsPage(),
        HomeCategoriesPage(),
        InboxAndNotificationsView(),
        ProfileDetailsPage(),
      ]);
    } else if (userRole == AppRole.merchant.name) {
      _selectedIndex = 1;
      _pages.addAll([
        const AllJobsScreen(),
        MerchantMapScreen(),
        InboxAndNotificationsView(),
        ProfileDetailsPage(),
      ]);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        centerTitle: true,
        // (_selectedIndex != 2 && userRole == AppRole.consumer.name) ||
        // (_selectedIndex != 3 && userRole == AppRole.merchant.name),
        // ? true
        // : false,
        showLeading: false,
        title:
            userRole == AppRole.consumer.name
                ? AppStaticData.consumerAppbarTitles[_selectedIndex]
                : AppStaticData.merchantAppBarTitles[_selectedIndex],
        actions: [
          // IconButton(
          //   icon: const Icon(Icons.notifications_on_rounded),
          //   onPressed: () {
          //     context.pushNamed(AppRoutes.inboxAndNotifcations);
          //   },
          // ),
          if ((_selectedIndex == 3 && userRole == AppRole.consumer.name) ||
              (_selectedIndex == 3 && userRole == AppRole.merchant.name)) ...[
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: IconButton(
                icon: Icon(
                  Icons.logout_rounded,
                  color: AppPalette.errorColor.withAlpha(150),
                ),
                onPressed: () {
                  loginBloc.add(const LogoutUser());
                  context.goNamed(AppRoutes.roleSelection);
                },
              ),
            ),
          ],
        ],
      ),

      body: _pages[_selectedIndex],
      bottomNavigationBar: AppBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onTap: _onItemTapped,
        userRole: userRole ?? '',
      ),
    );
  }
}
