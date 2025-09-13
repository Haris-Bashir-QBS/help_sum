import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:help_sum/src/core/animation/fade_and_scale.dart';
import 'package:help_sum/src/core/constants/app_dimensions.dart';
import 'package:help_sum/src/core/dependency_injection/di_barrel.dart';
import 'package:help_sum/src/features/auth/presentation/bloc/login/login_bloc.dart';
import 'package:help_sum/src/features/core/merchant/presentation/widgets/transaction_history_item.dart';
import 'package:help_sum/src/features/core/merchant/presentation/widgets/wallet_card.dart';
import 'package:help_sum/src/widgets/custom_text.dart';

// You can move this enum to a separate file if you use it elsewhere
enum TimePeriod { weekly, monthly, yearly }

class IncomeScreen extends StatefulWidget {
  const IncomeScreen({super.key});

  @override
  State<IncomeScreen> createState() => _IncomeScreenState();
}

class _IncomeScreenState extends State<IncomeScreen> {
  TimePeriod _selectedPeriod = TimePeriod.weekly;

  late final LoginBloc loginBloc;

  @override
  void initState() {
    loginBloc = sl<LoginBloc>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Light grey background
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingAllSides,
        ),
        child: BlocProvider.value(
          value: loginBloc,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlocBuilder<LoginBloc, LoginState>(
                builder: (context, state) {
                  return FadeScaleTransitionWidget(
                    child: WalletCard(
                      userName:
                          "${state.userEntity?.firstName ?? ""} ${state.userEntity?.lastName ?? ""}",
                    ),
                  );
                },
              ),

              20.verticalSpace,
              Row(
                children: [
                  Expanded(
                    child: CustomText(
                      text: "Transaction History",
                      fontWeight: FontWeight.bold,
                      fontSize: 20.sp,
                    ),
                  ),

                  CustomText(
                    text: "See All",
                    fontSize: 20.sp,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ],
              ),

              20.verticalSpace,

              TransactionHistoryItem(
                stars: 5,
                name: 'Kumail',
                professionalTitle: 'Mechanic',
                jobTitle: 'Pro',
                price: 3044,
              ),
              20.verticalSpace,
              TransactionHistoryItemShimmer(),
            ],
          ),
        ),
      ),
    );
  }
}
