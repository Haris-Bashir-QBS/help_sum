import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:help_sum/src/core/constants/app_texts.dart';
import 'package:help_sum/src/core/constants/app_secrets.dart';
import 'package:help_sum/src/core/services/stripe_service.dart';
import 'package:help_sum/src/core/utils/app_utils.dart';
import 'package:help_sum/src/widgets/custom_toast.dart';
import 'package:help_sum/src/features/core/common/payment/data/models/request/add_card_request_model.dart';
import 'package:help_sum/src/features/core/common/payment/data/models/response/add_card_response_model.dart';
import 'package:help_sum/src/features/core/common/payment/presentation/controller/notifiers/payment_notifier.dart';
import 'package:help_sum/src/features/core/common/payment/presentation/controller/notifiers/payment_state.dart';
import 'package:help_sum/src/features/core/common/payment/presentation/widgets/card_form_section.dart';
import 'package:help_sum/src/features/core/common/payment/presentation/widgets/card_list.dart';
import 'package:help_sum/src/widgets/custom_app_bar.dart';
import 'package:help_sum/src/widgets/custom_refresh_indicator.dart';

class AddCardScreen extends ConsumerStatefulWidget {
  const AddCardScreen({super.key});

  @override
  ConsumerState<AddCardScreen> createState() => _AddCardScreenState();
}

class _AddCardScreenState extends ConsumerState<AddCardScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  final TextEditingController _tipController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Fetch cards on screen load
    Future.microtask(
      () => ref.read(paymentNotifierProvider.notifier).getCards(),
    );
  }

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
    _listener(context);
    final state = ref.watch(paymentNotifierProvider);
    List<CardData> cards = [];
    bool isLoading = false;

    if (state is GetCardsSuccess) {
      cards = state.response.cards?.data ?? [];
    } else if (state is GetCardsLoading ||
        state is DeleteCardLoading ||
        state is SetDefaultCardLoading ||
        state is AddCardLoading) {
      isLoading = true;
    }

    return Scaffold(
      appBar: CustomAppBar(title: AppTexts.addCard, centerTitle: true),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CardFormSection(
                formKey: _formKey,
                cardNumberController: _cardNumberController,
                expiryDateController: _expiryDateController,
                cvvController: _cvvController,
                tipController: _tipController,
                emailController: _emailController,
                onAddCard: _handleAddCard,
              ),
              20.verticalSpace,
              Expanded(
                child: CustomRefreshIndicator(
                  onRefresh: () async {
                    await ref.read(paymentNotifierProvider.notifier).getCards();
                  },
                  child: CardList(
                    cards: cards,
                    isLoading: isLoading,
                    onDelete:
                        (cardId) => ref
                            .read(paymentNotifierProvider.notifier)
                            .deleteCard(cardId),
                    onSetDefault:
                        (cardId) => ref
                            .read(paymentNotifierProvider.notifier)
                            .setDefaultCard(cardId),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _listener(BuildContext context) {
    ref.listen<PaymentState>(paymentNotifierProvider, (prev, next) {
      // Add Card
      if (next is AddCardSuccess) {
        CustomToast.successToast(
          context: context,
          message: next.response.message,
        );
        _clearForm();
        ref.read(paymentNotifierProvider.notifier).getCards();
      } else if (next is AddCardError) {
        CustomToast.errorToast(context: context, message: next.message);
      }
      // Delete Card
      if (next is DeleteCardSuccess) {
        CustomToast.successToast(
          context: context,
          message: next.response.message,
        );
        ref.read(paymentNotifierProvider.notifier).getCards();
      } else if (next is DeleteCardError) {
        CustomToast.errorToast(context: context, message: next.message);
      }
      // Set Default Card
      if (next is SetDefaultCardSuccess) {
        CustomToast.successToast(
          context: context,
          message: next.response.message,
        );
        ref.read(paymentNotifierProvider.notifier).getCards();
      } else if (next is SetDefaultCardError) {
        CustomToast.errorToast(context: context, message: next.message);
      }
    });
  }

  Future<void> _handleAddCard() async {
    try {
      final cardNumber = _cardNumberController.text.replaceAll(' ', '');
      final expiryDate = _expiryDateController.text;
      final cvv = _cvvController.text;
      final parts = expiryDate.split('/');
      if (parts.length != 2) {
        AppUtils.showSnackBar(context, AppTexts.invalidExpiryDateFormat);
        return;
      }
      final month = int.parse(parts[0]);
      final year = 2000 + int.parse(parts[1]);
      final cardToken = await StripeService.instance.getCardToken(
        cardNumber: cardNumber,
        expMonth: month,
        expYear: year,
        cvc: cvv,
        publicKey: AppSecrets.stripePublicKey,
        name: _emailController.text.isNotEmpty ? _emailController.text : null,
      );
      if (cardToken == null) {
        if (!mounted) return;
        CustomToast.errorToast(
          context: context,
          message: AppTexts.failedToCreateCardToken,
        );
        return;
      }
      final requestModel = AddCardRequestModel(cardTokenId: cardToken);
      await ref.read(paymentNotifierProvider.notifier).addCard(requestModel);
    } catch (e) {
      if (!mounted) return;
      CustomToast.errorToast(
        context: context,
        message: '${AppTexts.errorProcessingCard}: $e',
      );
    }
  }

  void _clearForm() {
    _cardNumberController.clear();
    _expiryDateController.clear();
    _cvvController.clear();
    _tipController.clear();
    _emailController.clear();
  }
}
