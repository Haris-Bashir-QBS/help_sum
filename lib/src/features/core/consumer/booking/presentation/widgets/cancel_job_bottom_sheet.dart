import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:help_sum/src/core/constants/app_dimensions.dart';
import 'package:help_sum/src/core/constants/app_palette.dart';
import 'package:help_sum/src/core/constants/app_texts.dart';
import 'package:help_sum/src/widgets/custom_text.dart';
import 'package:help_sum/src/widgets/animated_dialog.dart';

class CancelJobBottomSheet extends StatefulWidget {
  const CancelJobBottomSheet({super.key});

  @override
  State<CancelJobBottomSheet> createState() => _CancelJobBottomSheetState();
}

class _CancelJobBottomSheetState extends State<CancelJobBottomSheet> {
  String? _selectedReason;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppDimensions.appBorderRadius.r),
          topRight: Radius.circular(AppDimensions.appBorderRadius.r),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Top handle
          20.verticalSpace,
          Container(
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: AppPalette.greyColor.withOpacity(0.5),
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          20.verticalSpace,
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingAllSides.w,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: AppTexts.selectReasonToCancel,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
                16.verticalSpace,
                ...AppTexts.cancelJobReasons.map((reason) {
                  return RadioListTile<String>(
                    title: CustomText(text: reason),
                    value: reason,
                    groupValue: _selectedReason,
                    onChanged: (String? value) {
                      setState(() {
                        _selectedReason = value;
                      });
                      Navigator.pop(context); // Close bottom sheet
                      _showConfirmationDialog(
                        context,
                        _selectedReason!,
                      ); // Trigger dialog
                    },
                  );
                }).toList(),
                // Removed buttons as per request
                24.verticalSpace,
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showConfirmationDialog(BuildContext context, String reason) {
    AnimatedStatusDialog.show(
      context: context,
      isSuccess: false,
      title: AppTexts.areYouSureToCancelThisJob,
      message: reason,
      primaryButtonText: AppTexts.yes,
      onPrimaryTap: () {
        // TODO: Implement actual cancellation logic here
      },
      secondaryButtonText: AppTexts.no,
      onSecondaryTap: () {},
    );
  }
}
