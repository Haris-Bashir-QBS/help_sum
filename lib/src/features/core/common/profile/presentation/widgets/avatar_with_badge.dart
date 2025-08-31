import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:help_sum/src/core/dependency_injection/di_barrel.dart';
import 'package:help_sum/src/core/services/local_storage_service.dart';
import 'package:help_sum/src/core/services/media_picker_service.dart';
import 'package:help_sum/src/features/auth/data/models/request/upload_file_request_model.dart';
import 'package:help_sum/src/features/auth/data/models/request/update_profile_request_model.dart';
import 'package:help_sum/src/features/auth/data/models/response/user_model.dart';
import 'package:help_sum/src/features/auth/presentation/bloc/login/login_bloc.dart';
import 'package:help_sum/src/features/auth/presentation/controller/notifiers/auth_state.dart';
import 'package:help_sum/src/features/auth/presentation/controller/notifiers/auth_notifier.dart';
import 'package:help_sum/src/features/core/common/profile/presentation/controller/user_state_provider.dart';
import 'package:help_sum/src/widgets/custom_circular_progress_indicator.dart';

import '../../../../../../widgets/custom_toast.dart';

class AvatarWithBadge extends ConsumerStatefulWidget {
  const AvatarWithBadge({super.key});

  @override
  ConsumerState<AvatarWithBadge> createState() => _AvatarWithBadgeState();
}

class _AvatarWithBadgeState extends ConsumerState<AvatarWithBadge> {
  bool _isUploading = false;
  String? _pendingImageUrl;

  @override
  void didUpdateWidget(covariant AvatarWithBadge oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_isUploading && _pendingImageUrl != null) {
      _pendingImageUrl = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = sl<LoginBloc>().state.userEntity;
    ref.listen<AuthState>(authNotifierProvider, (prev, next) async {
      if (_isUploading && _pendingImageUrl != null) {
        if (next is SaveBasicInfoSuccess) {
          final updatedUser = user?.copyWith(image: _pendingImageUrl);
          if (updatedUser != null) {
            CustomToast.successToast(
              context: context,
              message: 'Profile image updated successfully',
            );
            await LocalStorageService().saveUser(
              UserModel.fromEntity(updatedUser),
            );
            ref.read(currentUserProvider.notifier).updateUser(updatedUser);
          }
          if (Navigator.of(context, rootNavigator: true).canPop()) {
            Navigator.of(context, rootNavigator: true).pop();
          }
          setState(() {
            _isUploading = false;
            _pendingImageUrl = null;
          });
        } else if (next is SaveBasicInfoError) {
          if (Navigator.of(context, rootNavigator: true).canPop()) {
            Navigator.of(context, rootNavigator: true).pop();
          }
          setState(() {
            _isUploading = false;
            _pendingImageUrl = null;
          });
        }
      }
    });

    return GestureDetector(
      onTap: () async {
        MediaPickerService().imageGalleryBottomSheet(
          context: context,
          onMediaChanged: (String? picked) async {
            if (picked != null) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder:
                    (context) =>
                        const Center(child: CustomCircularProgressIndicator()),
              );
              final files = UploadFileRequest([File(picked)]);
              final notifier = ref.read(authNotifierProvider.notifier);
              await notifier.uploadFile(files);
              final state = ref.read(authNotifierProvider);
              if (state is UploadingFileSuccess && state.files.isNotEmpty) {
                final url = state.files.first.url;
                if (user != null) {
                  setState(() {
                    _isUploading = true;
                    _pendingImageUrl = url;
                  });
                  notifier.updateInfo(
                    context,
                    UpdateProfileRequest(image: url),
                  );
                }
              } else {
                // If upload failed, close the dialog
                if (Navigator.of(context, rootNavigator: true).canPop()) {
                  Navigator.of(context, rootNavigator: true).pop();
                }
              }
            }
          },
        );
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          CircleAvatar(
            radius: 70.r,
            backgroundColor: Colors.grey.shade300,
            backgroundImage:
                user?.image != null && user!.image!.isNotEmpty
                    ? NetworkImage(user.image!)
                    : null,
            child:
                user?.image == null || user!.image!.isEmpty
                    ? Icon(
                      Icons.account_circle_outlined,
                      size: 32.sp,
                      color: Colors.grey.shade800,
                    )
                    : null,
          ),
          if (user?.image == null || user!.image!.isEmpty)
            Positioned(
              top: -2,
              right: -2,
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
