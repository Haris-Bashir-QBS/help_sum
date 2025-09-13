import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:help_sum/src/core/constants/app_dimensions.dart';
import 'package:help_sum/src/core/constants/app_texts.dart';
import 'package:help_sum/src/core/dependency_injection/di_barrel.dart';
import 'package:help_sum/src/features/core/common/general/presentation/bloc/activity_bloc.dart';
import 'package:help_sum/src/features/core/common/general/presentation/pages/inbox_page.dart';
import 'package:help_sum/src/features/core/common/general/presentation/pages/notifications_page.dart';
import 'package:help_sum/src/features/core/common/general/presentation/widgets/filled_tabbar.dart';
import 'package:help_sum/src/widgets/app_background.dart';
import 'package:help_sum/src/widgets/custom_text.dart';

class InboxAndNotificationsView extends StatefulWidget {
  const InboxAndNotificationsView({super.key});

  @override
  State<InboxAndNotificationsView> createState() =>
      _InboxAndNotificationsViewState();
}

class _InboxAndNotificationsViewState extends State<InboxAndNotificationsView> {
  final tabs = [AppTexts.notification, AppTexts.messages];
  late final ActivityBloc _activityBloc;

  @override
  void initState() {
    _activityBloc = sl<ActivityBloc>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      onTap: () {
        context.pop();
      },
      title: AppTexts.activity,
      body: BlocProvider.value(
        value: _activityBloc,
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.paddingAllSides),
          child: Column(
            children: [
              BlocBuilder<ActivityBloc, ActivityState>(
                builder: (context, state) {
                  return FilledTabbar(
                    selectedIndex: state.selectedTab,
                    tabs: tabs,
                    onTabSelected: (value) {
                      _activityBloc.add(TabChanged(index: value));
                    },
                  );
                },
              ),
              10.verticalSpace,

              _buildTabView(context),
            ],
          ),
        ),
      ),
    );
  }

  _buildTabView(BuildContext ctx) {
    return BlocBuilder<ActivityBloc, ActivityState>(
      builder: (_, state) {
        return state.selectedTab == 0 ? NotificationsPage() : InboxPage();
      },
    );
  }
}
