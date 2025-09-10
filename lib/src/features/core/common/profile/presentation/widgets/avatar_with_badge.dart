import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:help_sum/src/core/constants/asset_paths.dart';
import 'package:help_sum/src/core/dependency_injection/di_barrel.dart';
import 'package:help_sum/src/core/services/media_picker_service.dart';
import 'package:help_sum/src/features/auth/data/models/request/upload_file_request_model.dart';
import 'package:help_sum/src/features/auth/presentation/bloc/login/login_bloc.dart';
import 'package:help_sum/src/widgets/comman_imageview.dart';

class AvatarWithBadge extends StatefulWidget {
  const AvatarWithBadge({super.key, this.imageUrl, required this.loginBloc});
  final String? imageUrl;
  final LoginBloc loginBloc;

  @override
  State<AvatarWithBadge> createState() => _AvatarWithBadgeState();
}

class _AvatarWithBadgeState extends State<AvatarWithBadge> {
  @override
  void initState() {
    log("sssss ${widget.imageUrl}");
    super.initState();
  }

  Future<void> _pickAndUploadImage(BuildContext context) async {
    MediaPickerService().imageGalleryBottomSheet(
      context: context,
      onMediaChanged: (String? picked) async {
        if (picked == null) return;
        widget.loginBloc.add(
          UpdateProfileImageEvent(file: UploadFileRequest([File(picked)])),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _pickAndUploadImage(context),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // CircleAvatar(
          //   radius: 70.r,
          //   backgroundColor: Colors.grey.shade300,
          //   backgroundImage:
          //       widget.imageUrl != null && widget.imageUrl!.isEmpty
          //           ?
          //           : null,
          //   child:
          //       widget.imageUrl == null || widget.imageUrl!.isEmpty
          //           ? Icon(
          //             Icons.account_circle_outlined,
          //             size: 32.sp,
          //             color: Colors.grey.shade800,
          //           )
          //           : null,
          // ),
          Container(
            height: 120.w,
            width: 120.w,
            padding: EdgeInsets.all(2),
            decoration: BoxDecoration(shape: BoxShape.circle),
            child: ClipOval(
              child: CustomImageView(
                imagePath:
                    widget.imageUrl != null &&
                            widget.imageUrl?.isNotEmpty == true
                        ? widget.imageUrl
                        : AppAssets.appLogo,
                imageType:
                    widget.imageUrl != null &&
                            widget.imageUrl?.isNotEmpty == true
                        ? ImageType.network
                        : ImageType.asset,
              ),
            ),
          ),
          if (widget.imageUrl == null || widget.imageUrl!.isEmpty)
            Positioned(
              top: 2,
              right: 10,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.error, color: Colors.orange, size: 18.r),
              ),
            ),
        ],
      ),
    );
  }
}
