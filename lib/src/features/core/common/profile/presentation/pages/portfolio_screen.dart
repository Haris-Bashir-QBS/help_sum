import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:help_sum/src/core/constants/app_dimensions.dart';
import 'package:help_sum/src/core/constants/app_palette.dart';
import 'package:help_sum/src/core/constants/app_texts.dart';
import 'package:help_sum/src/core/services/media_picker_service.dart';
import 'package:help_sum/src/features/auth/data/models/request/update_profile_request_model.dart';
import 'package:help_sum/src/features/auth/data/models/request/upload_file_request_model.dart';
import 'package:help_sum/src/features/auth/domain/entities/user_entity.dart';
import 'package:help_sum/src/features/auth/presentation/controller/notifiers/auth_notifier.dart';
import 'package:help_sum/src/features/auth/presentation/controller/notifiers/auth_state.dart';
import 'package:help_sum/src/features/core/common/profile/presentation/controller/user_state_provider.dart';
import 'package:help_sum/src/features/core/consumer/booking/presentation/widgets/job_image_slider.dart';
import 'package:help_sum/src/widgets/app_background.dart';
import 'package:help_sum/src/widgets/comman_imageview.dart';
import 'package:help_sum/src/widgets/custom_button.dart';
import 'package:help_sum/src/widgets/custom_text.dart';
import 'package:help_sum/src/widgets/custom_toast.dart';
import 'package:help_sum/src/widgets/enlarged_image_view_widget.dart';
import 'package:help_sum/src/widgets/modal_progress_hud.dart';

class PortfolioScreen extends ConsumerStatefulWidget {
  const PortfolioScreen({super.key});

  @override
  ConsumerState<PortfolioScreen> createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends ConsumerState<PortfolioScreen> {
  List<String> imageUrls = [];
  @override
  void initState() {
    super.initState();
  }

  void _listener() {
    ref.listen<AuthState>(authNotifierProvider, (prev, next) {
      if (next is UploadingFileSuccess) {
        final files = next.files;
        ref
            .read(currentUserProvider)
            .user
            ?.media
            ?.addAll(files.map((e) => e.url));
      } else if (next is UploadingFileError) {
        CustomToast.errorToast(context: context, message: next.failure.message);
      }
      if (next is SavePortfolioSuccess) {
        CustomToast.successToast(
          context: context,
          message: 'Portfolio updated successfully',
        );
        context.pop();
      } else if (next is SavePortfolioError) {
        CustomToast.errorToast(context: context, message: next.failure.message);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _listener();

    final state = ref.watch(authNotifierProvider);
    final userProvider = ref.watch(currentUserProvider);

    return ModalProgressHUD(
      inAsyncCall:
          state is UploadingFileLoading || state is SavePortfolioLoading,
      child: AppBackground(
        onTap: () {
          context.pop();
        },
        actions: [
          IconButton(
            onPressed: () {
              MediaPickerService().imageGalleryBottomSheet(
                onMediaChanged: (v) {
                  if (v != null) {
                    final files = UploadFileRequest([File(v)]);
                    ref.read(authNotifierProvider.notifier).uploadFile(files);
                  }
                },
                context: context,
              );

              // ref.read(authNotifierProvider.notifier).uploadFile(params);
            },
            icon: Icon(Icons.add),
          ),
        ],
        title: 'Work Photo Gallery',
        bottomWidget: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CustomButton(
            color: AppPalette.primaryColor,
            text: AppTexts.saveChanges,
            onPressed: () {
              ref
                  .read(authNotifierProvider.notifier)
                  .updatePortfolio(
                    context,
                    UpdateProfileRequest(media: userProvider.user?.media ?? []),
                  );
            },
          ),
        ),

        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingAllSides,
          ),
          child:
              userProvider.user?.media?.isNotEmpty == true
                  ? _buildMediaGrid(userProvider.user)
                  : _emptyMediaView(),
        ),
      ),
    );
  }

  _buildMediaGrid(UserEntity? user) {
    return GridView.builder(
      itemCount: user?.media?.length ?? 0,
      padding: EdgeInsets.only(top: 5.h),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index) {
        final url = user?.media![index];
        final tag = 'job_image_hero_' + index.toString();

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              PageRouteBuilder(
                opaque: false,
                pageBuilder: (BuildContext context, _, __) {
                  return EnlargedImageView(imageUrl: url!, tag: tag);
                },
                transitionsBuilder: (_, animation, __, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
              ),
            );
          },
          child: CustomImageView(
            imageType: ImageType.network,
            imagePath: url,
            fit: BoxFit.cover,
            borderRadius: BorderRadius.circular(30),
          ),
        );
      },
    );
  }

  Column _emptyMediaView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.photo),
        SizedBox(height: 10.h),
        Center(child: CustomText(text: 'No Photos ')),

        SizedBox(height: 20.h),

        Center(
          child: CustomText(
            maxLines: 3,
            fontSize: 14.sp,
            text:
                'We recommend to keep adding your work photos here \nso new consumers can see what you have done so far.',
          ),
        ),
      ],
    );
  }
}
