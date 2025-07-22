import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:help_sum/src/core/constants/app_texts.dart';
import 'package:help_sum/src/core/extensions/context_extensions.dart';
import 'package:help_sum/src/core/utils/app_utils.dart';
import 'package:help_sum/src/core/constants/app_dimensions.dart';
import 'package:help_sum/src/widgets/animated_dialog.dart';
import 'package:help_sum/src/widgets/custom_button.dart';
import 'package:help_sum/src/widgets/custom_text.dart';
import 'package:help_sum/src/widgets/custom_text_formfield.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:help_sum/src/features/core/consumer/booking/data/models/job_request_model.dart';
import 'package:help_sum/src/features/core/consumer/booking/presentation/controller/create_job_provider.dart';
import 'package:help_sum/src/features/core/consumer/booking/presentation/controller/create_job_notifier.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/data/models/route/create_job_route_model.dart';
import 'package:help_sum/src/core/utils/app_validators.dart';

class CreateRequestScreen extends ConsumerStatefulWidget {
  final CreateJobRouteModel args;
  const CreateRequestScreen({super.key, required this.args});

  @override
  ConsumerState<CreateRequestScreen> createState() =>
      _CreateRequestScreenState();
}

class _CreateRequestScreenState extends ConsumerState<CreateRequestScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _workTimeController = TextEditingController();
  final TextEditingController _offerController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _jobTitleController = TextEditingController();

  DateTime? selectedDate;
  String? _address;
  String? _city;
  String? _state;
  List<String> _media = [];

  Future<void> _pickDate() async {
    final today = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(today.year, today.month, today.day),
      firstDate: DateTime(today.year, today.month, today.day),
      lastDate: DateTime(today.year + 1),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: context.primaryColor,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            dialogTheme: DialogThemeData(backgroundColor: Colors.white),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
        _dateController.text = DateFormat('M/d/yyyy').format(picked);
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
      final time = TimeOfDay(hour: picked.hour, minute: picked.minute);
      final formatted =
          time.hour.toString().padLeft(2, '0') +
          ':' +
          time.minute.toString().padLeft(2, '0');
      _timeController.text = formatted;
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
    return CustomTextFormField(
      controller: _dateController,
      validator: AppValidators.validateEmpty(AppTexts.date),
      readOnly: true,
      onTap: _pickDate,
    );
  }

  Widget _buildTimePickerField() {
    return CustomTextFormField(
      controller: _timeController,
      hint: 'Select Time',
      validator: AppValidators.validateEmpty(AppTexts.time),
      readOnly: true,
      onTap: _pickTime,
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
    final createJobState = ref.watch(createJobProvider);
    ref.listen(createJobProvider, (previous, next) {
      if (next is CreateJobSuccess) {
        AppUtils.showSnackBar(context, next.response.message);
        _clearForm();
        Navigator.of(context).popUntil((route) => route.isFirst);
      } else if (next is CreateJobError) {
        AppUtils.showSnackBar(context, next.message);
      }
    });
    return Scaffold(
      appBar: AppBar(title: const Text('Create Request')),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(AppDimensions.paddingAllSides),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildFormSection(AppTexts.date, _buildDatePickerField()),
                      _buildFormSection(AppTexts.time, _buildTimePickerField()),
                      _buildFormSection(
                        AppTexts.estimatedWorkTimeWithUnit,
                        CustomTextFormField(
                          controller: _workTimeController,
                          validator: AppValidators.validateEmpty(
                            AppTexts.estimatedWorkTimeWithUnit,
                          ),
                          keyboardType: TextInputType.number,
                          hint: 'e.g. 2',
                        ),
                      ),
                      _buildFormSection(
                        AppTexts.createAnOffer,
                        CustomTextFormField(
                          controller: _offerController,
                          validator: AppValidators.validateEmpty(
                            AppTexts.createAnOffer,
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      _buildFormSection(
                        AppTexts.jobTitle,
                        CustomTextFormField(
                          controller: _jobTitleController,
                          validator: AppValidators.validateEmpty(
                            AppTexts.jobTitle,
                          ),
                        ),
                      ),
                      _buildFormSection(
                        AppTexts.description,
                        CustomTextFormField(
                          controller: _descriptionController,
                          maxLines: 5,
                          validator: AppValidators.validateEmpty(
                            AppTexts.description,
                          ),
                        ),
                      ),
                      10.verticalSpace,
                      //   _buildMediaIconsRow(),
                      80.verticalSpace,
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: CustomButton(
                text: AppTexts.next,
                textColor: Colors.white,
                isLoading: createJobState is CreateJobLoading,
                color: context.primaryColor,
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _showConfirmationDialog();
                  }
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
        _submitJobRequest();
      },
      secondaryButtonText: AppTexts.no,
    );
  }

  void _submitJobRequest() {
    final jobRequest = JobRequestModel(
      merchantId: widget.args.merchantId,
      serviceId: widget.args.serviceId,
      title: _jobTitleController.text,
      description: _descriptionController.text,
      address: _address ?? 'gulshan',
      city: _city ?? 'karachi',
      state: _state ?? 'sindh',
      lat: widget.args.lat,
      long: widget.args.long,
      date: _dateController.text,
      time: _timeController.text,
      estimatedWorkTime: int.tryParse(_workTimeController.text) ?? 0,
      offer: _offerController.text,
      media: _media,
    );
    log("Creaste request object is ${jobRequest.toJson().toString()}");
    ref.read(createJobProvider.notifier).createJob(jobRequest);
  }

  void _clearForm() {
    _dateController.clear();
    _timeController.clear();
    _workTimeController.clear();
    _offerController.clear();
    _descriptionController.clear();
    _jobTitleController.clear();
    // Optionally clear other fields
  }
}
