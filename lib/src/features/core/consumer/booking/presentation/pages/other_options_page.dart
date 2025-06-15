import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:help_sum/src/core/constants/app_dimensions.dart';
import 'package:help_sum/src/core/constants/app_texts.dart';
import 'package:help_sum/src/features/core/consumer/booking/presentation/widgets/cancel_job_bottom_sheet.dart';
import 'package:help_sum/src/features/core/consumer/booking/presentation/widgets/cancel_job_button.dart';
import 'package:help_sum/src/widgets/custom_app_bar.dart';

class OtherOptionsPage extends StatelessWidget {
  const OtherOptionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: AppTexts.otherOptions,
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(AppDimensions.paddingAllSides.w),
        child: Column(
          children: [
            CancelJobButton(
              onTap: () {
                _showCancelJobBottomSheet(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showCancelJobBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return const CancelJobBottomSheet();
      },
    );
  }
}
