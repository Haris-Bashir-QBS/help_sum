import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:help_sum/src/core/constants/app_palette.dart';
import 'package:help_sum/src/core/constants/app_texts.dart';
import 'package:help_sum/src/features/core/common/payment/data/models/response/add_card_response_model.dart';
import 'package:help_sum/src/widgets/custom_text.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'card_list_item.dart';

class CardSkeleton extends StatelessWidget {
  const CardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    // Create dummy card data for skeleton
    final dummyCards = [
      CardData(
        id: '1',
        object: 'card',
        last4: '1234',
        brand: 'Visa',
        expMonth: 12,
        expYear: 25,
      ),
      CardData(
        id: '2',
        object: 'card',
        last4: '5678',
        brand: 'Mastercard',
        expMonth: 6,
        expYear: 26,
      ),
      CardData(
        id: '3',
        object: 'card',
        last4: '9012',
        brand: 'American Express',
        expMonth: 3,
        expYear: 27,
      ),
    ];

    return Skeletonizer(
      enabled: true,
      child: Column(
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
              physics: const NeverScrollableScrollPhysics(),
              itemCount: dummyCards.length,
              itemBuilder: (context, index) {
                final card = dummyCards[index];
                final isDefault = false;

                return CardListItem(
                  card: card,
                  isDefault: isDefault,
                  onDelete: null,
                  onSetDefault: null,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
