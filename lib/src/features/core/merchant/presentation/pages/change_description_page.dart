import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:help_sum/src/core/themes/app_dimensions.dart';
import 'package:help_sum/src/widgets/app_background.dart';
import 'package:help_sum/src/widgets/custom_button.dart';
import 'package:help_sum/src/widgets/custom_text.dart';
import 'package:help_sum/src/widgets/custom_text_formfield.dart';

import '../../../../../core/constants/app_palette.dart';

class ChangeDescriptionPage extends StatefulWidget {
  const ChangeDescriptionPage({super.key});

  @override
  State<ChangeDescriptionPage> createState() => _ChangeDescriptionPageState();
}

class _ChangeDescriptionPageState extends State<ChangeDescriptionPage> {
  final TextEditingController controller = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String errorText = '';

  @override
  void initState() {
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return AppBackground(
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
                  color: AppPalette.primaryColor,
                  textColor: AppPalette.fillColor,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                40.verticalSpace,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
