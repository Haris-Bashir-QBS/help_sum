import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:help_sum/src/core/constants/app_texts.dart';
import 'package:help_sum/src/core/constants/asset_paths.dart';
import 'package:help_sum/src/core/router/app_routes.dart';
import 'package:help_sum/src/widgets/custom_app_bar.dart';
import '../widgets/payment_amount_card.dart';
import '../widgets/invoice_label_widget.dart';
import '../widgets/total_amount_widget.dart';

class PaymentMethodScreen extends StatelessWidget {
  const PaymentMethodScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: AppTexts.selectPaymentMethod,
        centerTitle: false,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          20.verticalSpace,
          InvoiceLabelWidget(name: "Michael"),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 24.h),
                TotalAmountWidget(amount: "\$500"),
                Divider(),
                10.verticalSpace,
                PaymentAmountCard(
                  title: AppTexts.payNowWithCard,
                  subtitle: AppTexts.makeinstantpayment,
                  iconPath: AppAssets.payIcon,
                  onTap: () {
                    context.goNamed(AppRoutes.cardDetails);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
