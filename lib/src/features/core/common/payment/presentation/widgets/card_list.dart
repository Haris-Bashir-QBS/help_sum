import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:help_sum/src/core/constants/app_palette.dart';
import 'package:help_sum/src/core/constants/app_texts.dart';
import 'package:help_sum/src/core/extensions/context_extensions.dart';
import 'package:help_sum/src/features/core/common/payment/data/models/response/add_card_response_model.dart';
import 'package:help_sum/src/widgets/custom_text.dart';
import 'card_list_item.dart';
import 'card_skeleton.dart';

class CardList extends ConsumerWidget {
  final List<CardData> cards;
  final bool isLoading;
  final Function(String)? onDelete;
  final Function(String)? onSetDefault;

  const CardList({
    super.key,
    required this.cards,
    required this.isLoading,
    this.onDelete,
    this.onSetDefault,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (isLoading) {
      return const CardSkeleton();
    }

    if (cards.isEmpty) {
      if (!(MediaQuery.of(context).viewInsets.bottom == 0)) {
        return const SizedBox.shrink();
      }
      return _buildEmptyState(context);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: AppTexts.savedCards,
          fontSize: 18.sp,
          fontWeight: FontWeight.w600,
          color: AppPalette.blackColor,
        ),
        12.verticalSpace,
        Expanded(
          child: ListView.builder(
            shrinkWrap: true,
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: cards.length,
            itemBuilder: (context, index) {
              final card = cards[index];
              final isDefault =
                  index == 0; // Stripe returns default card at index 0

              return CardListItem(
                card: card,
                isDefault: isDefault,
                onDelete: onDelete,
                onSetDefault: onSetDefault,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    if (!context.isBottomInsetZero) return const SizedBox.shrink();
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.credit_card_outlined,
            size: 64.sp,
            color: AppPalette.greyColor,
          ),
          16.verticalSpace,
          CustomText(
            text: AppTexts.noCardsAdded,
            fontSize: 16.sp,
            color: AppPalette.greyColor,
            textAlign: TextAlign.center,
          ),
          8.verticalSpace,
          CustomText(
            text: AppTexts.addYourFirstCard,
            fontSize: 14.sp,
            color: AppPalette.greyColor.withOpacity(0.7),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
