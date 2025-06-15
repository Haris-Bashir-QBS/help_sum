import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:help_sum/src/core/constants/app_texts.dart';
import 'package:help_sum/src/core/formatters/input_formatters.dart';
import 'package:help_sum/src/core/utils/app_utils.dart';
import 'package:help_sum/src/core/utils/app_validators.dart';
import 'package:help_sum/src/widgets/custom_text.dart';
import 'package:help_sum/src/widgets/custom_text_formfield.dart';

class CardDetailsForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController cardNumberController;
  final TextEditingController expiryDateController;
  final TextEditingController cvvController;
  final TextEditingController tipController;
  final TextEditingController emailController;

  const CardDetailsForm({
    super.key,
    required this.formKey,
    required this.cardNumberController,
    required this.expiryDateController,
    required this.cvvController,
    required this.tipController,
    required this.emailController,
  });

  @override
  State<CardDetailsForm> createState() => _CardDetailsFormState();
}

class _CardDetailsFormState extends State<CardDetailsForm> {
  @override
  void initState() {
    super.initState();
    // No need to parse initial date here, picker will handle it
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: AppTexts.accountNumber,
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
            ),
            SizedBox(height: 8.h),
            CustomTextFormField.card(
              controller: widget.cardNumberController,
              hint: AppTexts.cardNumberHint,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                CardNumberFormatter(),
                LengthLimitingTextInputFormatter(19),
              ],
              validator: AppValidators.validateCardNumber,
            ),
            SizedBox(height: 16.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: AppTexts.expiryDate,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      ),
                      SizedBox(height: 8.h),
                      CustomTextFormField.card(
                        controller: widget.expiryDateController,
                        hint: AppTexts.expiryDateHint,
                        readOnly: true,
                        onTap: () async => await _showMonthYearDialog(context),
                        validator: AppValidators.validateExpiryDate,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: AppTexts.cvv,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      ),
                      SizedBox(height: 8.h),
                      CustomTextFormField.card(
                        controller: widget.cvvController,
                        hint: AppTexts.cvvHint,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(4),
                        ],
                        validator: AppValidators.validateCVV,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            CustomText(
              text: AppTexts.enterTip,
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
            ),
            SizedBox(height: 8.h),
            CustomTextFormField.card(
              controller: widget.tipController,
              hint: AppTexts.tipHint,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            SizedBox(height: 16.h),
            CustomText(
              text: AppTexts.enterEmail,
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
            ),
            SizedBox(height: 8.h),
            CustomTextFormField.card(
              controller: widget.emailController,
              hint: AppTexts.emailHint,
              keyboardType: TextInputType.emailAddress,
              validator: AppValidators.validateEmail(),
            ),
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }

  Future<void> _showMonthYearDialog(BuildContext context) async {
    await AppUtils.selectExpiryDate(
      context,
      onSelected: (month, year) {
        if (kDebugMode) {
          print('Selected month: $month, year: $year');
        }
        setState(() {
          widget.expiryDateController.text =
              '${month.toString().padLeft(2, '0')}/${year.toString().substring(2)}';
        });
      },
    );
  }
}
