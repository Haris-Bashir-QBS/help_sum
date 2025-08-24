import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:help_sum/src/core/constants/app_dimensions.dart';
import 'package:help_sum/src/core/constants/app_palette.dart';
import 'package:help_sum/src/core/constants/app_texts.dart';
import 'package:help_sum/src/core/constants/asset_paths.dart';
import 'package:help_sum/src/core/dependency_injection/di_barrel.dart';
import 'package:help_sum/src/core/router/app_routes.dart';
import 'package:help_sum/src/features/auth/presentation/bloc/skill/skill_bloc.dart';
import 'package:help_sum/src/widgets/animated_dialog.dart';
import 'package:help_sum/src/widgets/custom_button.dart';
import 'package:help_sum/src/widgets/custom_text.dart';
import 'package:help_sum/src/widgets/custom_text_formfield.dart';
import 'package:help_sum/src/widgets/modal_progress_hud.dart';

class SkillSelectionScreen extends StatefulWidget {
  const SkillSelectionScreen({super.key, this.isEdit = false});
  final bool isEdit;

  @override
  State<SkillSelectionScreen> createState() => _SkillSelectionScreenState();
}

class _SkillSelectionScreenState extends State<SkillSelectionScreen> {
  final TextEditingController _searchController = TextEditingController();
  late final SkillBloc _skillBloc;

  @override
  void initState() {
    _skillBloc = sl<SkillBloc>();
    super.initState();
    debugPrint(widget.isEdit.toString());
    WidgetsBinding.instance.addPostFrameCallback((t) {
      _skillBloc.add(LoadSkills());
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _skillBloc,
      child: BlocConsumer<SkillBloc, SkillState>(
        listener: (context, state) {
          if (state.skillUpdated && !state.savingSkills) {
            if (!widget.isEdit) {
              context.goNamed(AppRoutes.createSchedule);
            }
          }
        },
        builder: (context, state) {
          return ModalProgressHUD(
            inAsyncCall: state.savingSkills,
            child: Scaffold(
              appBar: AppBar(
                leading:
                    widget.isEdit
                        ? InkWell(
                          onTap: () {
                            context.pop();
                          },
                          child: Image.asset(AppAssets.cross),
                        )
                        : null,
                title: CustomText(
                  text: widget.isEdit ? "Add your skills" : AppTexts.appTitle,
                  fontWeight: FontWeight.bold,
                  fontSize: 24.sp,
                ),
                bottom:
                    !widget.isEdit
                        ? PreferredSize(
                          preferredSize: Size.fromHeight(50),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal:
                                  AppDimensions
                                      .paddingAllSides
                                      .w, // Apply .w for horizontal padding
                            ),
                            child: CustomTextFormField(
                              hint:
                                  "Search for a skill", // Replaced AppTexts.searchHint
                              controller: _searchController,
                              onChanged: (value) {
                                _skillBloc.add(SearchSkill(searchText: value));
                              }, // Call filter on text change
                              customHintStyle: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                                color: AppPalette.blackColor,
                              ),
                              fillColor: AppPalette.fillColor,
                              suffixIcon: Container(
                                width:
                                    48.w, // Increased width for better touch target and visual
                                height: 48.h, // Added height for better sizing
                                decoration: BoxDecoration(
                                  color: AppPalette.orangeColor,
                                  borderRadius: BorderRadius.circular(
                                    AppDimensions.appBorderRadius.r,
                                  ),
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.search,
                                    color: AppPalette.blackColor,
                                    size: 24.sp, // Use .sp for icon size
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                        : null,
              ),
              body: _buildBody(state),
            ),
          );
        },
      ),
    );
  }

  _buildBody(SkillState skillState) {
    if (skillState.isLoading) {
      return Center(
        child: CircularProgressIndicator(color: AppPalette.primaryColor),
      );
    } else if (skillState.apiErrorMessage.isNotEmpty) {
      return Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomText(
              text: skillState.apiErrorMessage,
              fontSize: 20.sp,
              color: AppPalette.redColor,
            ),
            SizedBox(height: 10),

            SizedBox(
              width: .4.sw,
              child: CustomButton(
                text: 'Retry',
                onPressed: () {
                  _skillBloc.add(LoadSkills());
                  // ref.read(authNotifierProvider.notifier).getGrouppedServices();
                },
              ),
            ),
          ],
        ),
      );
    } else if (skillState.cats.isNotEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!widget.isEdit)
            20.verticalSpace, // Spacing from flutter_screenutil

          if (!widget.isEdit)
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingAllSides.w,
              ),
              child: CustomText(
                text: "Add your skill", // Heading for skill section
                fontSize: 20.sp, // Use .sp for font size
                fontWeight: FontWeight.bold,
                color: AppPalette.blackColor,
              ),
            ),
          15.verticalSpace,

          Expanded(
            child:
                skillState.isSearching
                    ? ListView.builder(
                      itemCount: skillState.filteredServices.length,
                      itemBuilder: (context, categoryIndex) {
                        final category =
                            skillState.filteredServices[categoryIndex];

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: AppDimensions.paddingAllSides.w,
                                vertical: 10.h,
                              ),
                              child: CustomText(
                                text: category.categoryName,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w600,
                                color: AppPalette.blackColor.withOpacity(0.7),
                              ),
                            ),

                            // Divider below category name if needed, but not in original image
                            // Divider(color: AppPalette.greyColor.withOpacity(0.3), height: 1.h),
                            ...category.services.map((skill) {
                              ///is Selected
                              /// If the skill is selected, show a check icon
                              final isSelected = skillState.selectedServices
                                  .contains(skill);

                              return Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      if (!isSelected) {
                                        _skillBloc.add(AddSkill(skill: skill));
                                        AnimatedStatusDialog.show(
                                          context: context,
                                          sucessOnly: true,
                                          isSuccess: true,
                                          title: AppTexts.skillAdded,
                                          message: "Success",
                                        );

                                        Future.delayed(
                                          Duration(seconds: 2),
                                          () async {
                                            if (mounted) {
                                              context.pop();
                                            }
                                          },
                                        );
                                      } else {
                                        log(
                                          "Skill already selected: ${skill.name}",
                                        );
                                        _skillBloc.add(
                                          RemoveSkill(skill: skill),
                                        );
                                      }

                                      // _toggleSkillSelection(
                                      //   category.categoryName,
                                      //   skill.id,
                                      // );
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal:
                                            AppDimensions.paddingAllSides.w,
                                        vertical: 12.h,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          CustomText(
                                            text: skill.name,
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.normal,
                                            color: AppPalette.blackColor,
                                          ),
                                          Icon(
                                            isSelected
                                                ? Icons.check
                                                : Icons.add,
                                            color:
                                                isSelected
                                                    ? AppPalette.orangeColor
                                                    : AppPalette
                                                        .primaryColor, // Use AppPalette colors
                                            size: 24.sp,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  // Divider below each skill item
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal:
                                          AppDimensions.paddingAllSides.w,
                                    ),
                                    child: Divider(
                                      color: AppPalette.greyColor.withOpacity(
                                        0.2,
                                      ),
                                      height: 1.h,
                                    ),
                                  ),
                                ],
                              );
                            }),
                            20.verticalSpace, // Space between categories
                          ],
                        );
                      },
                    )
                    : ListView.builder(
                      itemCount: skillState.cats.length,
                      itemBuilder: (context, categoryIndex) {
                        final category = skillState.cats[categoryIndex];

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: AppDimensions.paddingAllSides.w,
                                vertical: 10.h,
                              ),
                              child: CustomText(
                                text: category.categoryName,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w600,
                                color: AppPalette.blackColor.withOpacity(0.7),
                              ),
                            ),

                            // Divider below category name if needed, but not in original image
                            // Divider(color: AppPalette.greyColor.withOpacity(0.3), height: 1.h),
                            ...category.services.map((skill) {
                              ///is Selected
                              /// If the skill is selected, show a check icon
                              final isSelected = skillState
                                  // .read(authNotifierProvider.notifier)
                                  .selectedServices
                                  .contains(skill);

                              return Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      if (!isSelected) {
                                        _skillBloc.add(AddSkill(skill: skill));

                                        // ref
                                        //     .read(authNotifierProvider.notifier)
                                        //     .addService(skill);
                                        AnimatedStatusDialog.show(
                                          context: context,
                                          sucessOnly: true,
                                          isSuccess: true,
                                          title: AppTexts.skillAdded,
                                          message: "Success",
                                        );

                                        Future.delayed(
                                          Duration(seconds: 2),
                                          () async {
                                            if (mounted) {
                                              context.pop();
                                            }
                                          },
                                        );
                                      } else {
                                        log(
                                          "Skill already selected: ${skill.name}",
                                        );
                                        _skillBloc.add(
                                          RemoveSkill(skill: skill),
                                        );
                                      }

                                      // _toggleSkillSelection(
                                      //   category.categoryName,
                                      //   skill.id,
                                      // );
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal:
                                            AppDimensions.paddingAllSides.w,
                                        vertical: 12.h,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          CustomText(
                                            text: skill.name,
                                            fontSize: 16.sp,
                                            fontWeight: FontWeight.normal,
                                            color: AppPalette.blackColor,
                                          ),
                                          Icon(
                                            isSelected
                                                ? Icons.check
                                                : Icons.add,
                                            color:
                                                isSelected
                                                    ? AppPalette.orangeColor
                                                    : AppPalette
                                                        .primaryColor, // Use AppPalette colors
                                            size: 24.sp,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  // Divider below each skill item
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal:
                                          AppDimensions.paddingAllSides.w,
                                    ),
                                    child: Divider(
                                      color: AppPalette.greyColor.withValues(
                                        alpha: 0.2,
                                      ),
                                      height: 1.h,
                                    ),
                                  ),
                                ],
                              );
                            }),
                            20.verticalSpace, // Space between categories
                          ],
                        );
                      },
                    ),
          ),
          // if (widget.isEdit) 40.verticalSpace,
          // if (widget.isEdit)
          Center(
            child: SizedBox(
              width: widget.isEdit ? 0.5.sw : 0.4.sw,
              child: CustomButton(
                color:
                    widget.isEdit
                        ? AppPalette.primaryColor
                        : AppPalette.orangeColor,
                textColor: AppPalette.whiteColor,
                text: widget.isEdit ? AppTexts.saveChanges : AppTexts.next,
                onPressed: () {
                  final selectedSkills =
                      skillState
                          // .read(authNotifierProvider.notifier)
                          .selectedServices
                          .map((e) => e.id)
                          .toList();
                  _skillBloc.add(UpdateSkill(selectedSkills: selectedSkills));
                },
              ),
            ),
          ),

          // Next Button
          40.verticalSpace,
        ],
      );
    }

    return SizedBox();
  }
}
