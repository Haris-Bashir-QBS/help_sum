import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:help_sum/src/core/constants/app_texts.dart';
import 'package:help_sum/src/core/constants/asset_paths.dart';
import 'package:help_sum/src/core/utils/app_utils.dart';
import 'package:help_sum/src/core/constants/app_dimensions.dart';
import 'package:help_sum/src/widgets/animated_dialog.dart';
import 'package:help_sum/src/widgets/custom_button.dart';
import 'package:help_sum/src/widgets/custom_text.dart';
import 'package:help_sum/src/widgets/custom_text_formfield.dart';
import 'package:intl/intl.dart';

class CreateRequestScreen extends StatefulWidget {
  const CreateRequestScreen({super.key});

  @override
  State<CreateRequestScreen> createState() => _CreateRequestScreenState();
}

class _CreateRequestScreenState extends State<CreateRequestScreen> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _workTimeController = TextEditingController();
  final TextEditingController _offerController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  DateTime? selectedDate;

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    print("date is $picked");
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
        _timeController.clear();
      });
    }
  }

  Future<void> _pickTime() async {
    if (selectedDate == null) {
      AppUtils.showSnackBar(context, 'Please select a date first');
      return;
    }

    final now = DateTime.now();
    final picked = await AppUtils.pickTime(
      context,
      restrictPast: selectedDate!.isAtSameMomentAs(
        DateTime(now.year, now.month, now.day),
      ),
    );

    if (picked != null) {
      _timeController.text = picked.format(context);
    }
  }

  Widget _buildFormSection(String label, Widget field) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(text: label, fontSize: 16, fontWeight: FontWeight.w500),
        10.verticalSpace,
        field,
        16.verticalSpace,
      ],
    );
  }

  Widget _buildDatePickerField() {
    return GestureDetector(
      onTap: _pickDate,
      child: AbsorbPointer(
        child: CustomTextFormField(controller: _dateController),
      ),
    );
  }

  Widget _buildTimePickerField() {
    return GestureDetector(
      onTap: _pickTime,
      child: AbsorbPointer(
        child: CustomTextFormField(
          controller: _timeController,
          hint: 'Select Time',
        ),
      ),
    );
  }

  Widget _buildMediaIconsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const [
        Icon(Icons.camera_alt_outlined, size: 30),
        Icon(Icons.videocam_outlined, size: 30),
        Icon(Icons.upload_file_outlined, size: 30),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Request')),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(AppDimensions.paddingAllSides),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildFormSection(AppTexts.date, _buildDatePickerField()),
                    _buildFormSection(AppTexts.time, _buildTimePickerField()),
                    _buildFormSection(
                      AppTexts.estimatedWorkTime,
                      CustomTextFormField(controller: _workTimeController),
                    ),
                    _buildFormSection(
                      AppTexts.createAnOffer,
                      CustomTextFormField(controller: _offerController),
                    ),
                    _buildFormSection(
                      AppTexts.description,
                      CustomTextFormField(
                        controller: _descriptionController,
                        maxLines: 5,
                      ),
                    ),
                    10.verticalSpace,
                    _buildMediaIconsRow(),
                    80.verticalSpace,
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: CustomButton(
                text: AppTexts.next,
                textColor: Colors.white,
                color: Colors.blue,
                onPressed: () {
                  _showConfirmationDialog();
                },
              ),
            ),
            30.verticalSpace,
          ],
        ),
      ),
    );
  }

  void _showConfirmationDialog() {
    AnimatedStatusDialog.show(
      context: context,
      isSuccess: false,
      title: AppTexts.areYouSureToPostThisJob,
      primaryButtonText: AppTexts.yes,
      onPrimaryTap: () {
        _showAcknowledgeDialog();
      },
      secondaryButtonText: AppTexts.no,
      onSecondaryTap: () {},
    );
  }

  void _showAcknowledgeDialog() {
    AnimatedStatusDialog.show(
      context: context,
      isSuccess: true,
      icon: Image.asset(AppAssets.successIcon, width: 130, height: 130),
      title: AppTexts.requestSuccessSubtitle,
      message: "",
      primaryButtonText: AppTexts.continuee,
      onPrimaryTap: () {
        context.pop();
      },
    );
  }
}
