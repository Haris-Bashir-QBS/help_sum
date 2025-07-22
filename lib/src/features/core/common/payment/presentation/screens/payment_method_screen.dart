import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:help_sum/src/core/constants/app_texts.dart';
import 'package:help_sum/src/core/constants/app_palette.dart';
import 'package:help_sum/src/core/router/app_routes.dart';
import 'package:help_sum/src/features/core/common/payment/data/models/response/add_card_response_model.dart';
import 'package:help_sum/src/features/core/common/payment/presentation/controller/notifiers/payment_state.dart';
import 'package:help_sum/src/features/core/common/payment/presentation/controller/providers/payment_provider.dart';
import 'package:help_sum/src/features/core/consumer/booking/data/models/job_response_model.dart';
import 'package:help_sum/src/widgets/custom_app_bar.dart';
import 'package:help_sum/src/widgets/custom_button.dart';
import 'package:help_sum/src/widgets/custom_text.dart';
import 'package:help_sum/src/widgets/custom_toast.dart';
import '../widgets/card_list.dart';
import '../widgets/total_amount_widget.dart';

class PaymentMethodScreen extends ConsumerStatefulWidget {
  final JobData job;
  const PaymentMethodScreen({super.key, required this.job});

  @override
  ConsumerState<PaymentMethodScreen> createState() =>
      _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends ConsumerState<PaymentMethodScreen> {
  bool _paying = false;
  List<CardData> _cards = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref.read(paymentNotifierProvider.notifier).getCards(),
    );
  }

  @override
  Widget build(BuildContext context) {
    _listener(context);

    final state = ref.watch(paymentNotifierProvider);
    _isLoading = state is GetCardsLoading;

    final hasCards = _cards.isNotEmpty;

    return Scaffold(
      appBar: CustomAppBar(
        title: AppTexts.selectPaymentMethod,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 1.sw,
                color: AppPalette.lightBlueColor,
                padding: EdgeInsets.symmetric(vertical: 18.h),
                child: Center(
                  child: CustomText(
                    text: AppTexts.paymentAmount,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.sp,
                  ),
                ),
              ),
              16.verticalSpace,
              TotalAmountWidget(amount: "\$${widget.job.offer}"),
              Divider(),
              16.verticalSpace,
              _cardWidget(_isLoading, hasCards, _cards, context),
              24.verticalSpace,
              CustomButton(
                text: AppTexts.payNow,
                color: AppPalette.primaryColor,
                textColor: Colors.white,
                isLoading: _paying,
                onPressed: () {
                  if (_cards.isNotEmpty) {
                    ref
                        .read(paymentNotifierProvider.notifier)
                        .payForJob(
                          jobId: widget.job.id,
                          paymentToken: _cards[0].id,
                          amount: widget.job.offer,
                        );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _listener(BuildContext context) {
    ref.listen<PaymentState>(paymentNotifierProvider, (prev, next) {
      if (next is PayForJobLoading) {
        setState(() => _paying = true);
      } else {
        setState(() => _paying = false);
      }

      if (next is GetCardsSuccess) {
        setState(() {
          _cards = next.response.cards?.data ?? [];
        });
      } else if (next is GetCardsError) {
        CustomToast.errorToast(context: context, message: next.message);
      } else if (next is PayForJobSuccess) {
        CustomToast.successToast(
          context: context,
          message: next.response.message,
        );
        context.pushNamed(
          AppRoutes.paymentResult,
          extra: {'isSuccess': true, 'job': widget.job},
        );
      } else if (next is PayForJobError) {
        CustomToast.errorToast(context: context, message: next.message);
        context.pushNamed(
          AppRoutes.paymentResult,
          extra: {'isSuccess': false, 'job': widget.job},
        );
      } else if (next is DeleteCardSuccess) {
        CustomToast.successToast(
          context: context,
          message: next.response.message,
        );
        ref.read(paymentNotifierProvider.notifier).getCards();
      } else if (next is DeleteCardError) {
        CustomToast.errorToast(context: context, message: next.message);
      } else if (next is SetDefaultCardSuccess) {
        CustomToast.successToast(
          context: context,
          message: next.response.message,
        );
        ref.read(paymentNotifierProvider.notifier).getCards();
      }
    });
  }

  Expanded _cardWidget(
    bool isLoading,
    bool hasCards,
    List<CardData> cards,
    BuildContext context,
  ) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: CardList(
              showHeading: false,
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
        ],
      ),
    );
  }
}
