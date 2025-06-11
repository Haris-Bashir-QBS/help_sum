import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:help_sum/src/core/constants/app_texts.dart';
import 'package:help_sum/src/core/formatters/input_formatters.dart';
import 'package:help_sum/src/core/utils/app_validators.dart';
import 'package:help_sum/src/widgets/custom_button.dart';
import 'package:help_sum/src/widgets/custom_text.dart';
import 'package:help_sum/src/widgets/custom_text_formfield.dart';

class CardDetailsForm extends StatefulWidget {
  final Function(String cardNumber, String cardHolderName, String expiryDate, String cvv) onSubmit;

  const CardDetailsForm({
    super.key,
    required this.onSubmit,
  });

  @override
  State<CardDetailsForm> createState() => _CardDetailsFormState();
}

class _CardDetailsFormState extends State<CardDetailsForm> {
  final _formKey = GlobalKey<FormState>();
  final _cardNumberController = TextEditingController();
  final _cardHolderNameController = TextEditingController();
  final _expiryDateController = TextEditingController();
  final _cvvController = TextEditingController();

  @override
  void dispose() {
    _cardNumberController.dispose();
    _cardHolderNameController.dispose();
    _expiryDateController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.onSubmit(
        _cardNumberController.text.replaceAll(' ', ''),
        _cardHolderNameController.text,
        _expiryDateController.text,
        _cvvController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: AppTexts.cardNumber,
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
          SizedBox(height: 8.h),
          CustomTextFormField(
            controller: _cardNumberController,
            hint: AppTexts.cardNumber,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              CardNumberFormatter(),
            ],
            validator: AppValidators.validateCardNumber,
          ),
          SizedBox(height: 16.h),
          CustomText(
            text: AppTexts.cardHolderName,
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
          SizedBox(height: 8.h),
          CustomTextFormField(
            controller: _cardHolderNameController,
            hint: AppTexts.cardHolderName,
            validator: AppValidators.validateCardHolderName,
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: AppTexts.expiryDate,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    SizedBox(height: 8.h),
                    CustomTextFormField(
                      controller: _expiryDateController,
                      hint: AppTexts.expiryDate,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        ExpiryDateFormatter(),
                      ],
                      validator: AppValidators.validateExpiryDate,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: AppTexts.cvv,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    SizedBox(height: 8.h),
                    CustomTextFormField(
                      controller: _cvvController,
                      hint: AppTexts.cvv,
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
          SizedBox(height: 24.h),
          CustomButton(
            text: AppTexts.continueText,
            onPressed: _handleSubmit,
          ),
        ],
      ),
    );
  }
} 