import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:help_sum/src/core/constants/app_palette.dart';
import 'package:help_sum/src/core/constants/app_texts.dart';
import 'package:help_sum/src/core/extensions/context_extensions.dart';
import 'package:help_sum/src/widgets/custom_text.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class MediaPickerService {
  ImagePicker picker = ImagePicker();
  XFile? getFilePath;
  CroppedFile? croppedImageFile;
  File? imageFile;

  void imageGalleryBottomSheet({
    required BuildContext context,
    required ValueChanged<String?> onMediaChanged,
    bool? multiImage,
    List<String>? allowedExtensions,
    bool showCamera = true,
    bool showGallery = true,
    bool? showFile = false,
    bool showVideo = false,
    bool showRecord = false,
  }) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
      ),
      context: context,
      builder: (_) {
        return Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(5),
              topLeft: Radius.circular(5),
            ),
          ),
          child: SafeArea(
            child: Wrap(
              children: <Widget>[
                Visibility(
                  visible: showCamera,
                  child: GestureDetector(
                    onTap: () {
                      getCameraImage(
                        onMediaChanged: onMediaChanged,
                        context: context,
                      );
                    },
                    child: Container(
                      color: Colors.transparent,
                      padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                      child: Row(
                        children: [
                          const SizedBox(width: 15.0),
                          Icon(
                            Icons.camera_enhance,
                            color: AppPalette.primaryColor,
                          ),
                          const SizedBox(width: 15.0),
                          CustomText(
                            text: AppTexts.camera,
                            color: AppPalette.primaryColor,
                            fontSize: 18.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: showGallery,
                  child: GestureDetector(
                    onTap: () {
                      getGalleryImage(
                        onMediaChanged: onMediaChanged,
                        context: context,
                      );
                    },
                    child: Container(
                      color: Colors.transparent,
                      padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                      child: Row(
                        children: [
                          const SizedBox(width: 15.0),
                          Icon(Icons.image, color: AppPalette.primaryColor),
                          const SizedBox(width: 15.0),
                          CustomText(
                            text: AppTexts.photos,
                            color: AppPalette.primaryColor,
                            fontSize: 18.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                ///// FILE UPLOAD //////////
                if (showFile == true) ...[
                  GestureDetector(
                    onTap: () {
                      getPdfFile(
                        onMediaChanged: onMediaChanged,
                        context: context,
                        allowedExtensions: allowedExtensions,
                      );
                    },
                    child: Container(
                      color: Colors.transparent,
                      padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                      child: Row(
                        children: [
                          const SizedBox(width: 15.0),
                          Icon(
                            Icons.file_copy_sharp,
                            color: AppPalette.primaryColor,
                          ),
                          const SizedBox(width: 15.0),
                          CustomText(
                            text: AppTexts.file,
                            color: AppPalette.primaryColor,
                            fontSize: 18.0,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                Visibility(
                  visible: showVideo,
                  child: GestureDetector(
                    onTap: () {
                      getVideo(
                        onMediaChanged: onMediaChanged,
                        context: context,
                      );
                    },
                    child: _buildOption(
                      icon: Icons.video_library,
                      label: "Video",
                      context: context,
                    ),
                  ),
                ),
                Visibility(
                  visible: showRecord,
                  child: GestureDetector(
                    onTap: () {
                      recordVideo(
                        onMediaChanged: onMediaChanged,
                        context: context,
                      );
                    },
                    child: _buildOption(
                      icon: Icons.videocam,
                      label: "Record Video",
                      context: context,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
    return;
  }

  Widget _buildOption({
    required IconData icon,
    required String label,
    required BuildContext context,
  }) {
    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
      child: Row(
        children: [
          const SizedBox(width: 15.0),
          Icon(icon, color: context.primaryColor),
          const SizedBox(width: 15.0),
          Text(
            label,
            style: TextStyle(fontSize: 18.0, color: context.primaryColor),
          ),
        ],
      ),
    );
  }

  void getPdfFile({
    required ValueChanged<String?> onMediaChanged,
    BuildContext? context,
    List<String>? allowedExtensions,
  }) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: allowedExtensions ?? ["pdf", "doc"],
      );
      if (result != null) {
        PlatformFile file = result.files.first;
        onMediaChanged(file.path);
        // if (!context!.mounted) return;
        // context.pop();
      }
    } on PlatformException catch (e) {
      debugPrint("Error $e");
    }
  }

  void getCameraImage({
    required ValueChanged<String?> onMediaChanged,
    required BuildContext context,
  }) async {
    try {
      final ImagePicker imagePicker = ImagePicker();
      final XFile? pickedFile = await imagePicker.pickImage(
        source: ImageSource.camera,
      );

      if (pickedFile != null) {
        if (!context.mounted) return;
        cropImage(
          onMediaChanged: onMediaChanged,
          imageFilePath: pickedFile.path,
          context: context,
        );
        // onMediaChanged(pickedFile.path);
        // if (isAnySheetOpen(context!) == false) {
        //   context!.pop();
        // }
      }
    } on PlatformException {
      //  CustomToast.s
    }
  }

  ///check is dialog open if open it return false
  bool isAnySheetOpen(BuildContext context) {
    return ModalRoute.of(context)?.isCurrent ?? false;
  }

  void getGalleryImage({
    required ValueChanged<String?> onMediaChanged,
    required BuildContext context,
  }) async {
    try {
      XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image != null) {
        if (!context.mounted) return;
        cropImage(
          onMediaChanged: onMediaChanged,
          imageFilePath: image.path,
          context: context,
        );
      }
    } on PlatformException catch (e) {
      debugPrint("Error $e");
    }
  }

  void getMultipleImages({
    required ValueChanged<List<String?>?> onMediaChanged,
    required BuildContext context,
  }) async {
    try {
      // getFilePath =
      List<XFile> multiImages = await picker.pickMultiImage(imageQuality: 80);
      List<String> multiImagesPath = [];
      //print("Multi Images:${multiImages.length}");
      if (multiImages.isNotEmpty) {
        for (int i = 0; i < multiImages.length; i++) {
          multiImagesPath.add(multiImages[i].path);
        }
      }
      onMediaChanged(multiImagesPath);
      // if (!context.mounted) return;
      // context.pop();
    } on PlatformException {
      // AppDialogs.showToast(
      //     message: e.message ?? AppStrings.SOMETHING_WENT_WRONG_ERROR);
    }
  }

  void cropImage({
    String? imageFilePath,
    required BuildContext context,
    required ValueChanged<String?> onMediaChanged,
  }) async {
    croppedImageFile = await ImageCropper().cropImage(
      sourcePath: imageFilePath!,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: "Edit Photo",
          toolbarColor: context.primaryColor,
          toolbarWidgetColor: Colors.blue,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
      ],
    );
    if (croppedImageFile != null) {
      onMediaChanged(File(croppedImageFile!.path).path);
    } else {
      onMediaChanged(null);
    }
    if (context.mounted) {
      Navigator.pop(context);
    }
  }

  void getVideo({
    required ValueChanged<String?> onMediaChanged,
    required BuildContext context,
  }) async {
    try {
      final XFile? pickedFile = await picker.pickVideo(
        source: ImageSource.gallery,
      );
      if (pickedFile != null) {
        onMediaChanged(pickedFile.path);
      } else {
        Fluttertoast.showToast(msg: "No video selected");
      }
      // if (context.mounted) {
      //   Navigator.pop(context);
      // }
    } catch (e) {
      Fluttertoast.showToast(msg: "Failed to pick video");
    }
  }

  void recordVideo({
    required ValueChanged<String?> onMediaChanged,
    required BuildContext context,
  }) async {
    try {
      final XFile? pickedFile = await picker.pickVideo(
        source: ImageSource.camera,
      );
      if (pickedFile != null) {
        onMediaChanged(pickedFile.path);
      } else {
        Fluttertoast.showToast(msg: "No video recorded");
      }
      if (!context.mounted) return;
      Navigator.pop(context);
    } catch (e) {
      Fluttertoast.showToast(msg: "Failed to record video");
    }
  }
}
