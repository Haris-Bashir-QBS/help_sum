import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:help_sum/src/core/constants/app_palette.dart';
import 'package:help_sum/src/features/core/common/payment/data/models/response/add_card_response_model.dart';
import 'package:help_sum/src/features/core/common/payment/presentation/controller/providers/payment_provider.dart';
import 'package:help_sum/src/widgets/custom_text.dart';

class CardListItem extends ConsumerWidget {
  final CardData card;
  final bool isDefault;
  final Function(String)? onDelete;
  final Function(String)? onSetDefault;

  const CardListItem({
    super.key,
    required this.card,
    required this.isDefault,
    this.onDelete,
    this.onSetDefault,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Slidable(
        key: ValueKey(card.id),
        endActionPane: ActionPane(
          motion: const DrawerMotion(),
          children: [
            SlidableAction(
              onPressed: (_) {
                onDelete?.call(card.id);
                if (onDelete == null) {
                  ref
                      .read(paymentNotifierProvider.notifier)
                      .deleteCard(card.id);
                }
              },
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.delete_outline,
              label: 'Delete',
            ),
            if (!isDefault)
              SlidableAction(
                onPressed: (_) {
                  onSetDefault?.call(card.id);
                  if (onSetDefault == null) {
                    ref
                        .read(paymentNotifierProvider.notifier)
                        .setDefaultCard(card.id);
                  }
                },
                backgroundColor: AppPalette.primaryColor,
                foregroundColor: Colors.white,
                icon: Icons.star,
                label: 'Default',
              ),
          ],
        ),
        child: Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: AppPalette.fillColor.withAlpha(100),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppPalette.greyColor.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              Container(
                width: 24.w,
                height: 24.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color:
                      isDefault ? AppPalette.primaryColor : Colors.transparent,
                  border: Border.all(
                    color:
                        isDefault
                            ? AppPalette.primaryColor
                            : AppPalette.greyColor,
                    width: 2.5,
                  ),
                ),
                child:
                    isDefault
                        ? Icon(Icons.check, size: 14.sp, color: Colors.white)
                        : null,
              ),
              12.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: '•••• •••• •••• ${card.last4 ?? ''}',
                      fontWeight: FontWeight.w500,
                    ),
                    4.verticalSpace,
                    CustomText(
                      text: card.brand ?? '',
                      fontSize: 12.sp,
                      color: AppPalette.greyColor,
                    ),
                    4.verticalSpace,
                    CustomText(
                      text:
                          card.expMonth != null && card.expYear != null
                              ? '${card.expMonth}/${card.expYear}'
                              : '',
                      fontSize: 12.sp,
                      color: AppPalette.greyColor,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
