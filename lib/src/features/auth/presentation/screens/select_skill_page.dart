import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:help_sum/src/core/constants/app_dimensions.dart';
import 'package:help_sum/src/core/constants/app_palette.dart';
import 'package:help_sum/src/core/constants/app_texts.dart';
import 'package:help_sum/src/core/dependency_injection/di_barrel.dart';
import 'package:help_sum/src/core/router/app_routes.dart';
import 'package:help_sum/src/features/auth/presentation/bloc/skill/skill_bloc.dart';
import 'package:help_sum/src/widgets/custom_button.dart';
import 'package:help_sum/src/widgets/custom_text.dart';
import 'package:help_sum/src/widgets/custom_text_formfield.dart';
import 'package:help_sum/src/widgets/custom_toast.dart';
import 'package:help_sum/src/widgets/modal_progress_hud.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/services/local_storage_service.dart';

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
            } else {
              context.pop();
              CustomToast.successToast(
                context: context,
                message: "Skills updated successfully",
              );
            }
          }
        },
        builder: (context, state) {
          return ModalProgressHUD(
            inAsyncCall: state.savingSkills,
            child: SafeArea(
              top: false,
              child: Scaffold(
                backgroundColor: AppPalette.primaryColor,
                appBar: _appBar(context),
                body: _buildBody(state),
              ),
            ),
          );
        },
      ),
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      leading: BackButton(
        onPressed: () {
          if (widget.isEdit) {
            context.pop();
          } else {
            context.goNamed(AppRoutes.login);
            LocalStorageService().clearAll();
          }
        },
      ),
      title: CustomText(
        text: "Select skills",
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
                    hint: "Search for a skill", // Replaced AppTexts.searchHint
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
                        color: AppPalette.primaryColor,
                        borderRadius: BorderRadius.circular(
                          AppDimensions.appBorderRadius.r,
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.search,
                          color: AppPalette.whiteColor,
                          size: 24.sp, // Use .sp for icon size
                        ),
                      ),
                    ),
                  ),
                ),
              )
              : null,
    );
  }

  Widget _buildBody(SkillState skillState) {
    if (skillState.isLoading) {
      return _shimmerWidget();
    } else if (skillState.apiErrorMessage.isNotEmpty) {
      return Center(
        child: Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  CustomText(
                    text: skillState.apiErrorMessage,
                    fontSize: 20.sp,
                    color: AppPalette.redColor,
                  ),
                ],
              ),
              SizedBox(height: 10),
              SizedBox(
                width: .4.sw,
                child: CustomButton(
                  text: 'Retry',
                  onPressed: () {
                    _skillBloc.add(LoadSkills());
                  },
                ),
              ),
            ],
          ),
        ),
      );
    } else if (skillState.cats.isNotEmpty) {
      return Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24.r),
                  bottomRight: Radius.circular(24.r),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (!widget.isEdit) 20.verticalSpace,
                  Expanded(
                    child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      itemCount:
                          skillState.isSearching
                              ? skillState.filteredServices.length
                              : skillState.cats.length,
                      itemBuilder: (context, categoryIndex) {
                        final category =
                            skillState.isSearching
                                ? skillState.filteredServices[categoryIndex]
                                : skillState.cats[categoryIndex];

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// Category title (hidden in search mode)
                            if (!skillState.isSearching)
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

                            /// Skills as chips
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: AppDimensions.paddingAllSides.w,
                              ),
                              child: Wrap(
                                spacing: 8.w,
                                runSpacing: 8.h,
                                children:
                                    category.services.map((skill) {
                                      final isSelected = skillState
                                          .selectedServices
                                          .contains(skill);

                                      return InkWell(
                                        onTap: () {
                                          if (isSelected) {
                                            _skillBloc.add(
                                              RemoveSkill(skill: skill),
                                            );
                                          } else {
                                            _skillBloc.add(
                                              AddSkill(skill: skill),
                                            );
                                            // AnimatedStatusDialog.show(
                                            //   context: context,
                                            //   sucessOnly: true,
                                            //   isSuccess: true,
                                            //   title: AppTexts.skillAdded,
                                            //   message: "Success",
                                            // );
                                          }
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 14.w,
                                            vertical: 10.h,
                                          ),
                                          decoration: BoxDecoration(
                                            color:
                                                isSelected
                                                    ? AppPalette.primaryColor
                                                    : AppPalette.fillColor,
                                            borderRadius: BorderRadius.circular(
                                              24.r,
                                            ),
                                            border: Border.all(
                                              color:
                                                  isSelected
                                                      ? AppPalette.primaryColor
                                                      : Colors.grey.shade300,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                skill.name,
                                                style: TextStyle(
                                                  color:
                                                      isSelected
                                                          ? Colors.white
                                                          : AppPalette
                                                              .blackColor,
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              if (isSelected) ...[
                                                SizedBox(width: 6.w),
                                                Icon(
                                                  Icons.check,
                                                  size: 18.sp,
                                                  color: Colors.white,
                                                ),
                                              ],
                                            ],
                                          ),
                                        ),
                                      );
                                    }).toList(),
                              ),
                            ),

                            20.verticalSpace,
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          _continueButton(skillState),
        ],
      );
    }

    return SizedBox();
  }

  Column _shimmerWidget() {
    return Column(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24.r),
                bottomRight: Radius.circular(24.r),
              ),
            ),
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 5, // Number of fake shimmer categories
              itemBuilder: (context, index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Fake skill category title shimmer
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppDimensions.paddingAllSides.w,
                        vertical: 10.h,
                      ),
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey.shade300,
                        highlightColor: Colors.grey.shade100,
                        child: Container(
                          width: 140.w,
                          height: 20.h,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                      ),
                    ),

                    // Fake skill chips shimmer
                    _buildSkillShimmerChips(),

                    20.verticalSpace,
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _continueButton(SkillState skillState) {
    return Visibility(
      visible: MediaQuery.of(context).viewInsets.bottom == 0,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingAllSides,
          vertical: 26.h,
        ),
        child: CustomButton(
          color: AppPalette.whiteColor,
          textColor: AppPalette.primaryColor,
          radius: 10,
          text: AppTexts.continuee,
          onPressed: () {
            final selectedSkills =
                skillState.selectedServices.map((e) => e.id).toList();
            _skillBloc.add(UpdateSkill(selectedSkills: selectedSkills));
          },
        ),
      ),
    );
  }

  Widget _buildSkillShimmerChips() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingAllSides.w,
        vertical: 10.h,
      ),
      child: Wrap(
        spacing: 8.w,
        runSpacing: 8.h,
        children: List.generate(6, (index) {
          return Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              width: 90.w,
              height: 36.h,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(24.r),
              ),
            ),
          );
        }),
      ),
    );
  }
}
