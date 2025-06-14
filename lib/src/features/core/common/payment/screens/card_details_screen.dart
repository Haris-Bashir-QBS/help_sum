import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:help_sum/src/core/constants/app_palette.dart';
import 'package:help_sum/src/core/constants/app_texts.dart';
import 'package:help_sum/src/core/router/app_routes.dart';
import 'package:help_sum/src/features/core/common/payment/models/card_detail_params.dart';
import 'package:help_sum/src/features/core/common/payment/widgets/card_details_form.dart';
import 'package:help_sum/src/widgets/custom_app_bar.dart';
import 'package:help_sum/src/widgets/custom_button.dart';

class CardDetailsScreen extends StatefulWidget {
  const CardDetailsScreen({super.key});

  @override
  State<CardDetailsScreen> createState() => _CardDetailsScreenState();
}

class _CardDetailsScreenState extends State<CardDetailsScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  final TextEditingController _tipController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryDateController.dispose();
    _cvvController.dispose();
    _tipController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: AppTexts.cardDetails,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            children: [
              Expanded(
                child: CardDetailsForm(
                  formKey: _formKey,
                  cardNumberController: _cardNumberController,
                  expiryDateController: _expiryDateController,
                  cvvController: _cvvController,
                  tipController: _tipController,
                  emailController: _emailController,
                ),
              ),
              CustomButton(
                text: AppTexts.done,
                color: AppPalette.primaryColor,
                textColor: Colors.white,
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState?.save();
                    _handleCardDetailsSubmitted();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// ================== Card Details ===========================
  void _handleCardDetailsSubmitted() {
    context.pushNamed(
      AppRoutes.paymentConfirmation,
      extra: CardDetailParams(
        amount: 100.0,
        cardNumber: "",
        cardHolderName: "",
        cvv: "",
      ),
    );
  }
}
