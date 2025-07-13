import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:help_sum/src/core/constants/app_dimensions.dart';
import 'package:help_sum/src/core/constants/app_palette.dart';
import 'package:help_sum/src/features/auth/data/models/request/update_profile_request_model.dart';
import 'package:help_sum/src/features/auth/presentation/controller/notifiers/auth_notifier.dart';
import 'package:help_sum/src/features/auth/presentation/controller/notifiers/auth_state.dart';
import 'package:help_sum/src/features/core/common/profile/presentation/controller/user_state_provider.dart';
import 'package:help_sum/src/widgets/app_background.dart';
import 'package:help_sum/src/widgets/custom_button.dart';
import 'package:help_sum/src/widgets/custom_text.dart';
import 'package:help_sum/src/widgets/custom_text_formfield.dart';
import 'package:help_sum/src/widgets/modal_progress_hud.dart';

class ChangeRatePage extends ConsumerStatefulWidget {
  const ChangeRatePage({super.key});

  @override
  ConsumerState<ChangeRatePage> createState() => _ChangeRatePageState();
}

class _ChangeRatePageState extends ConsumerState<ChangeRatePage> {
  final TextEditingController controller = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    controller.text =
        ref.read(currentUserProvider).user?.hourlyRate.toString() ?? '';
    super.initState();
  }

  void _listener() {
    ref.listen<AuthState>(authNotifierProvider, (prev, next) {
      if (next is RatesSuccess) {
        context.pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _listener();
    final state = ref.watch(authNotifierProvider);
    final loading = state is RatesLoading;
    return ModalProgressHUD(
      inAsyncCall: loading,
      child: AppBackground(
        onTap: () {
          Navigator.pop(context);
        },
        title: 'Rates/hr',
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingAllSides,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  30.verticalSpace,
                  CustomText(
                    maxLines: 3,
                    fontSize: 16.sp,

                    fontWeight: FontWeight.bold,
                    text: 'Enter rates/hr',
                  ),
                  20.verticalSpace,
                  CustomTextFormField(
                    controller: controller,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(5),
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    prefixIcon: Icons.monetization_on_outlined,
                    borderColor: AppPalette.greyColor,
                    maxLines: 1,
                  ),

                  Spacer(),

                  CustomButton(
                    text: 'Save Changes',
                    color: AppPalette.primaryColor,
                    textColor: AppPalette.fillColor,
                    onPressed: () {
                      ref
                          .read(authNotifierProvider.notifier)
                          .updateRate(
                            context,
                            UpdateProfileRequest(
                              hourlyRate: int.tryParse(controller.text) ?? 0,
                            ),
                          ); // Navigator.pop(context);
                    },
                  ),
                  40.verticalSpace,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
