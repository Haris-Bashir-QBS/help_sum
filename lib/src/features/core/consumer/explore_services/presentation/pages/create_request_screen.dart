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
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:help_sum/src/features/core/consumer/booking/data/models/job_request_model.dart';
import 'package:help_sum/src/features/core/consumer/booking/presentation/controller/create_job_provider.dart';
import 'package:help_sum/src/features/core/consumer/booking/presentation/controller/create_job_notifier.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/data/models/route/create_job_route_model.dart';

class CreateRequestScreen extends ConsumerStatefulWidget {
  final CreateJobRouteModel args;
  const CreateRequestScreen({super.key, required this.args});

  @override
  ConsumerState<CreateRequestScreen> createState() =>
      _CreateRequestScreenState();
}

class _CreateRequestScreenState extends ConsumerState<CreateRequestScreen> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _workTimeController = TextEditingController();
  final TextEditingController _offerController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  DateTime? selectedDate;
  String? _address;
  String? _city;
  String? _state;
  List<String> _media = [];

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
                text:
                    createJobState is CreateJobLoading
                        ? 'Loading...'
                        : AppTexts.next,
                textColor: Colors.white,
                color: Colors.blue,
                onPressed:
                    createJobState is CreateJobLoading
                        ? () {}
                        : _showConfirmationDialog,
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
      title: 'Testing Job',
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
    ref.read(createJobProvider.notifier).createJob(jobRequest);
  }

  void _clearForm() {
    _dateController.clear();
    _timeController.clear();
    _workTimeController.clear();
    _offerController.clear();
    _descriptionController.clear();
    // Optionally clear other fields
  }
}
