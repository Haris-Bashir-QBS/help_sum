import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:help_sum/src/core/constants/app_palette.dart';
import 'package:help_sum/src/core/constants/app_texts.dart';
import 'package:help_sum/src/features/core/common/payment/presentation/controller/notifiers/payment_state.dart';
import 'package:help_sum/src/features/core/common/payment/presentation/controller/providers/payment_provider.dart';
import 'package:help_sum/src/features/core/common/payment/presentation/widgets/card_details_form.dart';
import 'package:help_sum/src/widgets/custom_button.dart';
import 'package:help_sum/src/widgets/custom_text.dart';

class CardFormSection extends ConsumerWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController cardNumberController;
  final TextEditingController expiryDateController;
  final TextEditingController cvvController;
  final TextEditingController tipController;
  final TextEditingController emailController;
  final VoidCallback? onAddCard;

  const CardFormSection({
    super.key,
    required this.formKey,
    required this.cardNumberController,
    required this.expiryDateController,
    required this.cvvController,
    required this.tipController,
    required this.emailController,
    this.onAddCard,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: AppTexts.addNewCard,
          fontSize: 18.sp,
          fontWeight: FontWeight.w600,
        ),
        16.verticalSpace,
        CardDetailsForm(
          formKey: formKey,
          cardNumberController: cardNumberController,
          expiryDateController: expiryDateController,
          cvvController: cvvController,
          tipController: tipController,
          emailController: emailController,
          showTipAndEmail: false,
        ),
        16.verticalSpace,
        Consumer(
          builder: (context, ref, child) {
            final state = ref.watch(paymentNotifierProvider);
            return CustomButton(
              text: AppTexts.addCard,
              isLoading: state is AddCardLoading,
              color: AppPalette.primaryColor,
              textColor: Colors.white,
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  formKey.currentState?.save();
                  onAddCard?.call();
                }
              },
            );
          },
        ),
      ],
    );
  }
}
