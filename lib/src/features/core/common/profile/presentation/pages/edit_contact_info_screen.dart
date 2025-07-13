import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:help_sum/src/core/constants/app_palette.dart';
import 'package:help_sum/src/core/constants/app_texts.dart';
import 'package:help_sum/src/core/utils/app_validators.dart';
import 'package:help_sum/src/features/auth/domain/entities/user_entity.dart';
import 'package:help_sum/src/features/core/common/profile/presentation/widgets/info_card.dart';
import 'package:help_sum/src/features/core/common/profile/presentation/widgets/info_row.dart';
import 'package:help_sum/src/widgets/custom_app_bar.dart';
import 'package:help_sum/src/widgets/custom_button.dart';

class EditContactInfoScreen extends StatefulWidget {
  final UserEntity user;

  const EditContactInfoScreen({super.key, required this.user});

  @override
  State<EditContactInfoScreen> createState() => _EditContactInfoScreenState();
}

class _EditContactInfoScreenState extends State<EditContactInfoScreen> {
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.user.email);
    _phoneController = TextEditingController(text: widget.user.phone);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    if (_formKey.currentState?.validate() ?? false) {
      // TODO: Implement save logic
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        //  title: AppTexts.editContactInformation,
        title: AppTexts.account,
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            children: [
              InfoCard(
                title: AppTexts.contactInformation,
                children: [
                  InfoRow(
                    label: AppTexts.emailAddress,
                    value: widget.user.email ?? "",
                    isEditable: true,
                    controller: _emailController,
                    validator: AppValidators.validateEmail(),
                    onChanged: (value) {
                      _formKey.currentState?.validate();
                    },
                  ),
                  InfoRow(
                    label: AppTexts.phoneNumber,
                    value: widget.user.phone ?? "",
                    isEditable: true,
                    controller: _phoneController,
                    validator: AppValidators.validatePhoneNumber(),
                    onChanged: (value) {
                      _formKey.currentState?.validate();
                    },
                  ),
                ],
                onPressed: () {},
              ),
              const Spacer(),
              CustomButton(
                text: AppTexts.saveChanges,
                textColor: Colors.white,
                color: AppPalette.primaryColor,
                onPressed: _saveChanges,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
