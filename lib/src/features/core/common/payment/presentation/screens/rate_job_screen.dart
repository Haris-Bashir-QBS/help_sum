import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:help_sum/src/core/constants/app_palette.dart';
import 'package:help_sum/src/core/constants/app_texts.dart';
import 'package:help_sum/src/core/dependency_injection/di_barrel.dart';
import 'package:help_sum/src/core/enums/media_type.dart';
import 'package:help_sum/src/core/services/media_picker_service.dart';
import 'package:help_sum/src/core/utils/app_utils.dart';
import 'package:help_sum/src/features/auth/data/models/request/upload_file_request_model.dart';
import 'package:help_sum/src/features/core/common/payment/data/models/request/rate_job_request_model.dart';
import 'package:help_sum/src/features/core/common/payment/presentation/bloc/rating_bloc.dart';
import 'package:help_sum/src/features/core/common/payment/presentation/bloc/rating_state.dart';
import 'package:help_sum/src/features/core/common/profile/presentation/widgets/custom_overlay_loader.dart';
import 'package:help_sum/src/features/core/consumer/booking/data/models/job_response_model.dart';
import 'package:help_sum/src/features/core/consumer/booking/data/models/media_file.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/presentation/pages/create_request_screen.dart';
import 'package:help_sum/src/widgets/custom_app_bar.dart';
import 'package:help_sum/src/widgets/custom_button.dart';
import 'package:help_sum/src/widgets/custom_rating_widget.dart';
import 'package:help_sum/src/widgets/custom_text.dart';
import 'package:help_sum/src/widgets/custom_text_formfield.dart';
import 'package:help_sum/src/widgets/custom_toast.dart';
import 'package:logger/logger.dart';

class RateJobScreen extends ConsumerStatefulWidget {
  final bool isEdit;
  final JobData job;
  const RateJobScreen({super.key, this.isEdit = false, required this.job});

  @override
  ConsumerState<RateJobScreen> createState() => _RateJobScreenState();
}

class _RateJobScreenState extends ConsumerState<RateJobScreen> {
  double _rating = 0.0;
  final TextEditingController _reviewController = TextEditingController();
  final List<String> _selectedTags = [];
  final List<String> _tags = ["Service", "Quantity", "Payment", "Delivery"];

  final List<MediaFile> mediaFiles = [];
  late final RatingBloc _ratingBloc;

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  void _submitReview() {
    if (_rating == 0.0) {
      CustomToast.errorToast(
        context: context,
        message: "Please provide a rating",
      );
      return;
    }

    final params = RateJobRequestModel(
      jobId: widget.job.id,
      rating: _rating.toInt(),
      review: _reviewController.text,
    );
    _ratingBloc.add(PostRating(rateJobRequestModel: params));
    // ref.read(ratingNotifierProvider.notifier).rateJob(params);
  }

  @override
  void initState() {
    _ratingBloc = sl<RatingBloc>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // ref.listen(ratingNotifierProvider, (previous, current) {
    //   if (current is RatingSuccess) {
    //     CustomToast.successToast(
    //       context: context,
    //       message: 'Rating submitted successfully',
    //     );
    //     context.pop();
    //     context.pop(true);
    //   } else if (current is RatingError) {
    //     CustomToast.errorToast(context: context, message: current.message);
    //   }
    // });

    // final ratingState = ref.watch(ratingNotifierProvider);

    return Scaffold(
      appBar: CustomAppBar(title: "Feedback"),
      body: BlocProvider.value(
        value: _ratingBloc,
        child: BlocListener<RatingBloc, RatingState>(
          listener: (_, current) {
            if (current is RatingSuccess) {
              CustomToast.successToast(
                context: context,
                message: 'Rating submitted successfully',
              );
              context.pop();
              context.pop(true);
            } else if (current is RatingError) {
              CustomToast.errorToast(
                context: context,
                message: current.message,
              );
            } else if (current is UploadImageLoading) {
              CustomOverlayLoader.show(
                context,
                message: AppTexts.pleaseWaitWeAreUploadingYourFile,
              );
            } else if (current is UploadImageError) {
              CustomOverlayLoader.hide();
              CustomToast.errorToast(
                context: context,
                message: current.message,
              );
            } else if (current is UploadImageSuccess) {
              CustomOverlayLoader.hide();
              CustomToast.successToast(
                context: context,
                message: AppTexts.fileUploadedSuccessfully,
              );
              if (current.files.isNotEmpty) {
                final files = current.files;
                for (var file in files) {
                  final mediaFile = MediaFile(
                    media: MediaUtils.detectMedia(file.mimeType),
                    mediaType: MediaUtils.detectMediaType(file.url),
                    path: file.url,
                  );
                  mediaFiles.add(mediaFile);
                }
                setState(() {});
              }
            }
          },
          child: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Emoji selection row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildEmoji(
                        Icons.sentiment_very_dissatisfied_sharp,
                        false,
                      ),
                      SizedBox(width: 16.w),
                      _buildEmoji(Icons.sentiment_neutral, false),
                      SizedBox(width: 16.w),
                      _buildEmoji(Icons.sentiment_very_satisfied, false),
                    ],
                  ),
                  SizedBox(height: 24.h),

                  // Tag selection chips
                  Wrap(
                    spacing: 12.w,
                    runSpacing: 8.h,
                    children:
                        _tags.map((tag) {
                          final isSelected = _selectedTags.contains(tag);
                          return ChoiceChip(
                            label: Text(tag),
                            selected: isSelected,
                            onSelected: (value) {
                              setState(() {
                                if (value) {
                                  _selectedTags.add(tag);
                                } else {
                                  _selectedTags.remove(tag);
                                }
                              });
                            },
                            selectedColor: AppPalette.primaryColor.withOpacity(
                              0.2,
                            ),
                            labelStyle: TextStyle(
                              color:
                                  isSelected
                                      ? AppPalette.primaryColor
                                      : Colors.black,
                              fontSize: 14.sp,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.r),
                              side: BorderSide(
                                color:
                                    isSelected
                                        ? AppPalette.primaryColor
                                        : Colors.grey.shade300,
                              ),
                            ),
                          );
                        }).toList(),
                  ),
                  SizedBox(height: 24.h),

                  // Review field
                  CustomText(
                    fontWeight: FontWeight.w600,
                    text: AppTexts.careToShareMore,
                    fontSize: 16.sp,
                    // style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 8.h),
                  CustomTextFormField(
                    isOutlinedBorder: true,
                    controller: _reviewController,
                    borderRadius: BorderRadius.circular(20),
                    hint: AppTexts.pleaseGiveReview,
                    maxLines: 3,
                    keyboardType: TextInputType.multiline,
                    borderColor: Colors.grey,
                  ),
                  SizedBox(height: 24.h),

                  // Upload image section (placeholder)
                  CustomText(
                    text: AppTexts.uploadImages,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    // style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 8.h),

                  Row(
                    children: [
                      Flexible(child: _displayAttachments()),
                      SizedBox(width: 12.w),
                      _buildUploadBox(),
                      // _buildUploadedImage(),
                    ],
                  ),
                  SizedBox(height: 24.h),

                  // Rating section
                  CustomText(
                    text: "Rating",
                    fontWeight: FontWeight.w600,
                    // style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 8.h),
                  Center(
                    child: CustomRatingWidget(
                      initialRating: _rating,
                      onRatingUpdate: (rating) {
                        setState(() {
                          _rating = rating;
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 32.h),

                  // Submit button
                  BlocBuilder<RatingBloc, RatingState>(
                    builder: (context, state) {
                      return CustomButton(
                        text: AppTexts.done,
                        onPressed: _submitReview,
                        color: AppPalette.primaryColor,
                        textColor: Colors.white,
                        isLoading: state is RatingLoading,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmoji(IconData icon, bool isSelected) {
    return CircleAvatar(
      radius: 24.r,
      backgroundColor:
          isSelected
              ? AppPalette.primaryColor.withOpacity(0.1)
              : Colors.grey.shade200,
      child: Icon(
        icon,
        color: isSelected ? AppPalette.primaryColor : Colors.grey,
        size: 28.sp,
      ),
    );
  }

  _displayAttachments() {
    return mediaFiles.isNotEmpty
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
              final media = mediaFiles[index];
              return AttachmentCard(
                mediaFile: media,
                onDelete: () {
                  mediaFiles.removeAt(index);
                  setState(() {});
                },
              );
            },
            separatorBuilder: (_, i) => SizedBox(width: 10.w),
            itemCount: mediaFiles.length,
          ),
        )
        : SizedBox.shrink();
  }

  Widget _buildUploadBox() {
    return GestureDetector(
      onTap: () {
        MediaPickerService().imageGalleryBottomSheet(
          context: context,
          onMediaChanged: (String? picked) async {
            if (picked == null) return;

            // final mediaFile = MediaFile(
            //   media: Media.photo,
            //   mediaType: MediaType.file,
            //   path: picked,
            // );
            // // _createJobBloc.add(
            //   UploadNewFile(file: UploadFileRequest([File(picked)])),
            // );

            _ratingBloc.add(
              UploadImage(file: UploadFileRequest([File(picked)])),
            );

            // mediaFiles.add(mediaFile);

            // setState(() {});

            Logger().log(Level.debug, "pciked file $picked");
            // widget.loginBloc.add(
            //   UpdateProfileImageEvent(file: UploadFileRequest([File(picked)])),
            // );
          },
        );
      },
      child: Container(
        height: 150.h,
        width: 100.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: const Icon(Icons.add, color: Colors.grey),
      ),
    );
  }

  Widget _buildUploadedImage() {
    return Stack(
      children: [
        Container(
          width: 64.w,
          height: 64.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            color: Colors.grey.shade200,
            image: const DecorationImage(
              image: AssetImage(
                "assets/images/sample.png",
              ), // replace with dynamic
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: -6,
          right: -6,
          child: GestureDetector(
            onTap: () {
              // remove image logic
            },
            child: CircleAvatar(
              radius: 10.r,
              backgroundColor: Colors.red,
              child: Icon(Icons.close, color: Colors.white, size: 12.sp),
            ),
          ),
        ),
      ],
    );
  }
}
