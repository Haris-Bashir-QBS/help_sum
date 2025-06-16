import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:help_sum/src/core/constants/app_texts.dart';
import 'package:help_sum/src/core/constants/asset_paths.dart';
import 'package:help_sum/src/widgets/animated_dialog.dart';
import 'package:help_sum/src/widgets/custom_app_bar.dart';
import 'package:help_sum/src/widgets/custom_button.dart';
import 'package:help_sum/src/widgets/custom_text_formfield.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ImmediateBookingScreen extends StatefulWidget {
  const ImmediateBookingScreen({super.key});

  @override
  State<ImmediateBookingScreen> createState() => _ImmediateBookingScreenState();
}

class _ImmediateBookingScreenState extends State<ImmediateBookingScreen> {
  final TextEditingController _descriptionController = TextEditingController();

  void _showBottomSheetMenu() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 16.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildBottomSheetItem(Icons.camera_alt, 'Image'),
              16.verticalSpace,
              _buildBottomSheetItem(Icons.videocam, 'Video'),
              16.verticalSpace,
              _buildBottomSheetItem(Icons.upload_file, 'Document'),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBottomSheetItem(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 28),
        16.horizontalSpace,
        Text(label, style: TextStyle(fontSize: 16.sp)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: AppTexts.bookAJob,
        actions: [
          IconButton(
            icon: RotatedBox(
              quarterTurns: 1,
              child: const Icon(Icons.attachment),
            ),
            onPressed: _showBottomSheetMenu,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  10.verticalSpace,
                  CustomTextFormField(
                    controller: _descriptionController,
                    maxLines: 15,
                    hint: AppTexts.enterDescriptionAboutJob,
                  ),
                  80.verticalSpace,
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.w),
            child: CustomButton(
              text: AppTexts.postAJob,
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
