import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:help_sum/src/core/constants/app_texts.dart';
import 'package:help_sum/src/core/dependency_injection/di_barrel.dart';
import 'package:help_sum/src/core/enums/media_type.dart';
import 'package:help_sum/src/core/extensions/context_extensions.dart';
import 'package:help_sum/src/core/services/media_picker_service.dart';
import 'package:help_sum/src/core/utils/app_utils.dart';
import 'package:help_sum/src/core/constants/app_palette.dart';
import 'package:help_sum/src/features/auth/data/models/request/upload_file_request_model.dart';
import 'package:help_sum/src/features/core/common/profile/presentation/widgets/custom_overlay_loader.dart';
import 'package:help_sum/src/features/core/consumer/booking/data/models/media_file.dart';
import 'package:help_sum/src/features/core/consumer/booking/presentation/bloc/create_job_bloc.dart';
import 'package:help_sum/src/widgets/animated_dialog.dart';
import 'package:help_sum/src/widgets/custom_button.dart';
import 'package:help_sum/src/widgets/custom_text_formfield.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:help_sum/src/features/core/consumer/booking/data/models/job_request_model.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/data/models/route/create_job_route_model.dart';
import 'package:help_sum/src/core/utils/app_validators.dart';
import 'package:logger/logger.dart';

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
  // List<String> _medi÷a = [];
  List<MediaFile> _pickedMediaFiles = [];
  late final CreateJobBloc _createJobBloc;

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

  Widget _buildFormSection(String label, Widget field, {IconData? icon}) {
    return Container(
      margin: EdgeInsets.only(bottom: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Container(
                  padding: EdgeInsets.all(6.w),
                  decoration: BoxDecoration(
                    color: AppPalette.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(
                    icon,
                    size: 18.sp,
                    color: AppPalette.primaryColor,
                  ),
                ),
                12.horizontalSpace,
              ],
              Text(
                label,
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
          12.verticalSpace,
          field,
        ],
      ),
    );
  }

  Widget _buildDatePickerField() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey[300]!, width: 1.5),
        color: Colors.white,
      ),
      child: CustomTextFormField(
        controller: _dateController,
        validator: AppValidators.validateEmpty(AppTexts.date),
        readOnly: true,
        onTap: _pickDate,
        decoration: InputDecoration(
          hintText: 'Select Date',
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 16.h,
          ),
          suffixIcon: Icon(
            Icons.calendar_today_outlined,
            color: AppPalette.primaryColor,
          ),
        ),
      ),
    );
  }

  Widget _buildTimePickerField() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey[300]!, width: 1.5),
        color: Colors.white,
      ),
      child: CustomTextFormField(
        controller: _timeController,
        hint: 'Select Time',
        validator: AppValidators.validateEmpty(AppTexts.time),
        readOnly: true,
        onTap: _pickTime,
        decoration: InputDecoration(
          hintText: 'Select Time',
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 16.h,
          ),
          suffixIcon: Icon(
            Icons.access_time_outlined,
            color: AppPalette.primaryColor,
          ),
        ),
      ),
    );
  }

  Widget _buildOutlinedField({
    required TextEditingController controller,
    required String hint,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey[300]!, width: 1.5),
        color: Colors.white,
      ),
      child: TextFormField(
        controller: controller,
        validator: validator,
        keyboardType: keyboardType,
        maxLines: maxLines,
        style: TextStyle(fontSize: 14.sp, color: Colors.grey[800]),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14.sp),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: maxLines > 1 ? 16.h : 16.h,
          ),
        ),
      ),
    );
  }

  Widget _buildMediaSection() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!, width: 1.5),
        borderRadius: BorderRadius.circular(12.r),
        color: Colors.grey[50],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.attachment_outlined,
                color: AppPalette.primaryColor,
                size: 20.sp,
              ),
              8.horizontalSpace,
              Text(
                'Attach Media (Optional)',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
          16.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMediaButton(Icons.camera_alt_outlined, 'Photo', () {
                MediaPickerService().imageGalleryBottomSheet(
                  context: context,
                  onMediaChanged: (String? picked) async {
                    if (picked == null) return;

                    // final mediaFile = MediaFile(
                    //   media: Media.photo,
                    //   mediaType: MediaType.file,
                    //   path: picked,
                    // );
                    _createJobBloc.add(
                      UploadNewFile(file: UploadFileRequest([File(picked)])),
                    );

                    // _pickedMediaFiles.add(mediaFile);

                    // setState(() {});

                    Logger().log(Level.debug, "pciked file $picked");
                    // widget.loginBloc.add(
                    //   UpdateProfileImageEvent(file: UploadFileRequest([File(picked)])),
                    // );
                  },
                );
              }),
              _buildMediaButton(Icons.videocam_outlined, 'Video', () {
                MediaPickerService().getVideo(
                  context: context,
                  onMediaChanged: (String? picked) async {
                    if (picked == null) return;

                    // final mediaFile = MediaFile(
                    //   media: Media.video,
                    //   mediaType: MediaType.file,
                    //   path: picked,
                    // );

                    _createJobBloc.add(
                      UploadNewFile(file: UploadFileRequest([File(picked)])),
                    );

                    // _pickedMediaFiles.add(mediaFile);

                    // setState(() {});

                    Logger().log(Level.debug, "pciked file $picked");
                    // widget.loginBloc.add(
                    //   UpdateProfileImageEvent(file: UploadFileRequest([File(picked)])),
                    // );
                  },
                );
              }),
              _buildMediaButton(Icons.upload_file_outlined, 'Files', () {
                MediaPickerService().getPdfFile(
                  context: context,
                  onMediaChanged: (String? picked) async {
                    if (picked == null) return;
                    _createJobBloc.add(
                      UploadNewFile(file: UploadFileRequest([File(picked)])),
                    );

                    Logger().log(Level.debug, "pciked file $picked");
                    // widget.loginBloc.add(
                    //   UpdateProfileImageEvent(file: UploadFileRequest([File(picked)])),
                    // );
                  },
                );
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMediaButton(IconData icon, String label, Function()? onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          border: Border.all(color: AppPalette.primaryColor.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(12.r),
          color: Colors.white,
        ),
        child: Column(
          children: [
            Icon(icon, color: AppPalette.primaryColor, size: 24.sp),
            4.verticalSpace,
            Text(
              label,
              style: TextStyle(
                fontSize: 11.sp,
                color: AppPalette.primaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    _createJobBloc = sl<CreateJobBloc>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final createJobState = ref.watch(createJobProvider);
    // ref.listen(createJobProvider, (previous, next) {
    //   if (next is CreateJobSuccess) {
    //     AppUtils.showSnackBar(context, next.response.message);
    //     _clearForm();
    //     Navigator.of(context).popUntil((route) => route.isFirst);
    //   } else if (next is CreateJobError) {
    //     AppUtils.showSnackBar(context, next.message);
    //   }
    // });

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Create Request',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18.sp),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        shadowColor: Colors.grey[200],
        surfaceTintColor: Colors.transparent,
      ),
      body: BlocProvider.value(
        value: _createJobBloc,
        child: BlocListener<CreateJobBloc, CreateJobState>(
          listener: (context, next) {
            if (next is CreateJobSuccess) {
              AppUtils.showSnackBar(context, next.response.message);
              _clearForm();
              Navigator.of(context).popUntil((route) => route.isFirst);
            } else if (next is CreateJobError) {
              AppUtils.showSnackBar(context, next.message);
            } else if (next is UploadFileLoading) {
              CustomOverlayLoader.show(
                context,
                message: "Please wait we are\n uploading your file.",
              );
            } else if (next is UploadFileError) {
              CustomOverlayLoader.hide();
            } else if (next is UploadFileSuccess) {
              CustomOverlayLoader.hide();
              if (next.files.isNotEmpty) {
                final firstFile = next.files.first;
                final mediaFile = MediaFile(
                  media: MediaUtils.detectMedia(firstFile.mimeType),
                  mediaType: MediaUtils.detectMediaType(firstFile.url),
                  path: firstFile.url,
                );
                setState(() {
                  _pickedMediaFiles.add(mediaFile);
                });
              }
            }
          },
          child: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(20.w),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header section with gradient
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(20.w),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppPalette.primaryColor.withOpacity(0.1),
                                  AppPalette.primaryColor.withOpacity(0.05),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(16.r),
                              border: Border.all(
                                color: AppPalette.primaryColor.withOpacity(0.2),
                              ),
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.work_outline,
                                  size: 32.sp,
                                  color: AppPalette.primaryColor,
                                ),
                                8.verticalSpace,
                                Text(
                                  'Create Your Service Request',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey[800],
                                  ),
                                ),
                                4.verticalSpace,
                                Text(
                                  'Fill in the details below to get started',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          24.verticalSpace,

                          // Date & Time Row
                          Row(
                            children: [
                              Expanded(
                                child: _buildFormSection(
                                  AppTexts.date,
                                  _buildDatePickerField(),
                                  icon: Icons.calendar_today_outlined,
                                ),
                              ),
                              12.horizontalSpace,
                              Expanded(
                                child: _buildFormSection(
                                  AppTexts.time,
                                  _buildTimePickerField(),
                                  icon: Icons.access_time_outlined,
                                ),
                              ),
                            ],
                          ),

                          _buildFormSection(
                            AppTexts.jobTitle,
                            _buildOutlinedField(
                              controller: _jobTitleController,
                              hint: 'Enter job title',
                              validator: AppValidators.validateEmpty(
                                AppTexts.jobTitle,
                              ),
                            ),
                            icon: Icons.title_outlined,
                          ),

                          _buildFormSection(
                            AppTexts.estimatedWorkTimeWithUnit,
                            _buildOutlinedField(
                              controller: _workTimeController,
                              hint: 'e.g. 2 hours',
                              validator: AppValidators.validateEmpty(
                                AppTexts.estimatedWorkTimeWithUnit,
                              ),
                              keyboardType: TextInputType.number,
                            ),
                            icon: Icons.schedule_outlined,
                          ),

                          _buildFormSection(
                            AppTexts.createAnOffer,
                            _buildOutlinedField(
                              controller: _offerController,
                              hint: 'Enter your offer amount',
                              validator: AppValidators.validateEmpty(
                                AppTexts.createAnOffer,
                              ),
                              keyboardType: TextInputType.number,
                            ),
                            icon: Icons.attach_money_outlined,
                          ),

                          _buildFormSection(
                            AppTexts.description,
                            _buildOutlinedField(
                              controller: _descriptionController,
                              hint: 'Describe your requirements in detail...',
                              validator: AppValidators.validateEmpty(
                                AppTexts.description,
                              ),
                              maxLines: 4,
                            ),
                            icon: Icons.description_outlined,
                          ),

                          _buildFormSection(
                            'Attachments',
                            _buildMediaSection(),
                            icon: Icons.attach_file_outlined,
                          ),

                          _displayAttachments(),

                          60.verticalSpace,
                        ],
                      ),
                    ),
                  ),
                ),

                // Bottom section with button
                BlocBuilder<CreateJobBloc, CreateJobState>(
                  builder: (context, state) {
                    return Container(
                      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 24.h),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, -2),
                          ),
                        ],
                      ),
                      child: CustomButton(
                        text: AppTexts.next,
                        textColor: Colors.white,
                        isLoading: state is CreateJobLoading,
                        color: context.primaryColor,
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _showConfirmationDialog();
                          }
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
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
      address: _address ?? '',
      city: _city ?? '',
      state: _state ?? '',
      lat: widget.args.lat,
      long: widget.args.long,
      date: _dateController.text,
      time: _timeController.text,
      estimatedWorkTime: int.tryParse(_workTimeController.text) ?? 0,
      offer: _offerController.text,
      media:
          _pickedMediaFiles.isNotEmpty
              ? _pickedMediaFiles.map((e) => e.path).toList()
              : [],
    );
    log("Create request object is ${jobRequest.toJson().toString()}");
    // ref.read(createJobProvider.notifier).createJob(jobRequest);
    _createJobBloc.add(CreateNewRequest(jobRequestModel: jobRequest));
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

  _displayAttachments() {
    return _pickedMediaFiles.isNotEmpty
        ? Container(
          height: 150.h,
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppPalette.primaryColor.withOpacity(0.1),
                AppPalette.primaryColor.withOpacity(0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: AppPalette.primaryColor.withOpacity(0.1)),
          ),

          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemBuilder: (_, index) {
              final media = _pickedMediaFiles[index];
              return AttachmentCard(
                mediaFile: media,
                onDelete: () {
                  _pickedMediaFiles.removeAt(index);
                  setState(() {});
                },
              );
            },
            separatorBuilder: (_, i) => SizedBox(width: 10.w),
            itemCount: _pickedMediaFiles.length,
          ),
        )
        : SizedBox.shrink();
  }


}

class AttachmentCard extends StatelessWidget {
  const AttachmentCard({super.key, required this.mediaFile, this.onDelete});
  final MediaFile mediaFile;
  final Function()? onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.h,

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          Positioned.fill(child: _getMediaPreview()),
          Positioned(
            right: 0,
            child: GestureDetector(
              onTap: onDelete,
              child: Container(
                padding: EdgeInsets.all(5).r,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.close, size: 18),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _getMediaPreview() {
    switch (mediaFile.media) {
      case Media.photo:
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child:
              mediaFile.mediaType == MediaType.file
                  ? Image.file(File(mediaFile.path), fit: BoxFit.cover)
                  : Image.network(mediaFile.path),
        );
      case Media.video:
        return Center(
          child: Container(
            height: 30,
            width: 30,
            padding: EdgeInsets.all(2).r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppPalette.primaryColor.withValues(alpha: .2),
            ),
            child: Icon(Icons.play_arrow),
          ),
        );
      case Media.file:
        return Icon(Icons.picture_as_pdf_sharp, color: AppPalette.primaryColor);
    }
  }
}
