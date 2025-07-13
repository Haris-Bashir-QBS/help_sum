import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:help_sum/src/core/constants/app_dimensions.dart';
import 'package:help_sum/src/features/auth/data/models/request/update_profile_request_model.dart';
import 'package:help_sum/src/features/auth/presentation/controller/notifiers/auth_notifier.dart';
import 'package:help_sum/src/features/auth/presentation/controller/notifiers/auth_state.dart';
import 'package:help_sum/src/features/core/common/profile/presentation/controller/user_state_provider.dart';

import 'package:help_sum/src/widgets/app_background.dart';
import 'package:help_sum/src/widgets/custom_button.dart';
import 'package:help_sum/src/widgets/custom_text.dart';
import 'package:help_sum/src/widgets/custom_text_formfield.dart';
import 'package:help_sum/src/widgets/modal_progress_hud.dart';

import '../../../../../core/constants/app_palette.dart';

class ChangeDescriptionPage extends ConsumerStatefulWidget {
  const ChangeDescriptionPage({super.key});

  @override
  ConsumerState<ChangeDescriptionPage> createState() =>
      _ChangeDescriptionPageState();
}

class _ChangeDescriptionPageState extends ConsumerState<ChangeDescriptionPage> {
  final TextEditingController controller = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String errorText = '';

  @override
  void initState() {
    super.initState();
    controller.text = ref.read(currentUserProvider).user?.description ?? '';
    controller.addListener(() {
      if (controller.text.length < 10) {
        setState(() {
          errorText = 'Minimum 10 characters';
        });
      } else {
        errorText = '';

        setState(() {});
      }
    });
  }

  void _listener() {
    ref.listen<AuthState>(authNotifierProvider, (prev, next) {
      if (next is DescriptionSuccess) {
        context.pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _listener();
    final state = ref.watch(authNotifierProvider);
    final loading = state is DescriptionLoading;
    return ModalProgressHUD(
      inAsyncCall: loading,
      child: AppBackground(
        onTap: () {
          Navigator.pop(context);
        },
        title: 'Description',
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
                    text:
                        'Enter a precise description about your skill or\nabout yourself that will be vissible to the consumer',
                  ),
                  30.verticalSpace,
                  CustomTextFormField(
                    controller: controller,
                    borderColor: AppPalette.greyColor,
                    maxLines: 4,
                  ),

                  if (errorText != '')
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: CustomText(
                        maxLines: 3,
                        fontSize: 16.sp,
                        color: Color(0xFFFF8E01),
                        fontWeight: FontWeight.bold,
                        text: errorText,
                      ),
                    ),
                  Spacer(),

                  CustomButton(
                    text: 'Save Changes',
                    color:
                        controller.text.length >= 10
                            ? AppPalette.primaryColor
                            : AppPalette.darkGreyColor,
                    textColor: AppPalette.fillColor,
                    onPressed: () {
                      if (controller.text.length >= 10) {
                        ref
                            .read(authNotifierProvider.notifier)
                            .updateDescription(
                              context,
                              UpdateProfileRequest(
                                description: controller.text.trim(),
                              ),
                            );
                      }
                      // Navigator.pop(context);
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
