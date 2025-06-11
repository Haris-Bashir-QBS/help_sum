import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:help_sum/src/core/constants/app_palette.dart';
import 'package:help_sum/src/core/constants/app_texts.dart';
import 'package:help_sum/src/core/utils/app_validators.dart';
import 'package:help_sum/src/features/core/common/profile/models/user_model.dart';
import 'package:help_sum/src/features/core/common/profile/widgets/info_card.dart';
import 'package:help_sum/src/features/core/common/profile/widgets/info_row.dart';
import 'package:help_sum/src/widgets/custom_app_bar.dart';
import 'package:help_sum/src/widgets/custom_button.dart';

class EditBasicInfoScreen extends StatefulWidget {
  final UserModel user;

  const EditBasicInfoScreen({
    super.key,
    required this.user,
  });

  @override
  State<EditBasicInfoScreen> createState() => _EditBasicInfoScreenState();
}

class _EditBasicInfoScreenState extends State<EditBasicInfoScreen> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(text: widget.user.firstName);
    _lastNameController = TextEditingController(text: widget.user.lastName);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
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
      appBar: const CustomAppBar(
       // title: AppTexts.editBasicInformation,
          title: AppTexts.account,
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            children: [
              InfoCard(
                title: AppTexts.basicInformation,
                children: [
                  InfoRow(
                    label: AppTexts.firstName,
                    value: widget.user.firstName,
                    isEditable: true,
                    controller: _firstNameController,
                    validator: AppValidators.validateFullName(),
                    onChanged: (value) {
                      _formKey.currentState?.validate();
                    },
                  ),
                  InfoRow(
                    label: AppTexts.lastName,
                    value: widget.user.lastName,
                    isEditable: true,
                    controller: _lastNameController,
                    validator: AppValidators.validateFullName(),
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