import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:help_sum/src/core/constants/app_dimensions.dart';
import 'package:help_sum/src/core/constants/app_palette.dart';
import 'package:help_sum/src/core/constants/app_texts.dart';
import 'package:help_sum/src/core/constants/asset_paths.dart';
import 'package:help_sum/src/core/router/app_routes.dart';
<<<<<<< Updated upstream:lib/src/features/auth/presentation/pages/consumer/select_skill.dart
import 'package:help_sum/src/features/auth/domain/model/skill_category.dart';
import 'package:help_sum/src/features/auth/domain/model/skill_model.dart';
=======
import 'package:help_sum/src/core/models/merchant/skill_category.dart';
import 'package:help_sum/src/features/auth/data/models/request/update_profile_model.dart';
import 'package:help_sum/src/features/auth/presentation/controller/notifiers/auth_notifier.dart';
import 'package:help_sum/src/features/auth/presentation/controller/notifiers/auth_state.dart';
>>>>>>> Stashed changes:lib/src/features/auth/presentation/screens/select_skill_page.dart
import 'package:help_sum/src/widgets/animated_dialog.dart';
import 'package:help_sum/src/widgets/custom_button.dart';
import 'package:help_sum/src/widgets/custom_text.dart';
import 'package:help_sum/src/widgets/custom_text_formfield.dart';
import 'package:help_sum/src/widgets/modal_progress_hud.dart';

// Data Model for a single skill

class SkillSelectionScreen extends ConsumerStatefulWidget {
  const SkillSelectionScreen({super.key, this.isEdit = false});
  final bool isEdit;

  @override
  ConsumerState<SkillSelectionScreen> createState() =>
      _SkillSelectionScreenState();
}

class _SkillSelectionScreenState extends ConsumerState<SkillSelectionScreen> {
  // Master list of all skills, used for filtering and state updates
  // List of skills currently displayed, updated by search
  // Controller for the search text field
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

<<<<<<< Updated upstream:lib/src/features/auth/presentation/pages/consumer/select_skill.dart
    print(widget.isEdit);
=======
    debugPrint(widget.isEdit.toString());
    WidgetsBinding.instance.addPostFrameCallback((t) {
      ref.read(authNotifierProvider.notifier).getGrouppedServices();
    });

    _searchController.addListener(() {
      // isSearchingTrue
      if (_searchController.text.isNotEmpty) {
        ref.read(authNotifierProvider.notifier).updateSearch(true);
      } else {
        ref.read(authNotifierProvider.notifier).updateSearch(false);
      }
    });

>>>>>>> Stashed changes:lib/src/features/auth/presentation/screens/select_skill_page.dart
    // Initialize with a proper list of categories and skills
    // _allSkillsData = [
    //   SkillCategory(
    //     categoryName: "Personal Care",
    //     skills: [
    //       Skill(id: "personalCare_makeup", name: "Makeup"),
    //       Skill(
    //         id: "personalCare_hairStylist",
    //         name: "Hairstylist",
    //         selected: true,
    //       ), // Example: initially selected
    //       Skill(id: "personalCare_barber", name: "Barber"),
    //     ],
    //   ),
    //   SkillCategory(
    //     categoryName: "Mechanic",
    //     skills: [
    //       Skill(id: "mechanic_motorcycle", name: "Motorcycle Mechanic"),
    //       Skill(id: "mechanic_tyreChange", name: "Tyre Change"),
    //     ],
    //   ),
    //   SkillCategory(
    //     categoryName: "Daily Workers",
    //     skills: [
    //       Skill(id: "dailyWorkers_maid", name: "Maid"),
    //       Skill(id: "dailyWorkers_waiter", name: "Waiter"),
    //       Skill(id: "dailyWorkers_houseMaintenance", name: "House Maintenance"),
    //     ],
    //   ),
    // ];
    // // Initially, filtered skills are all skills
    // _filteredSkillsData = List<SkillCategory>.from(
    //   _allSkillsData.map((e) => e.copyWith(skills: List<Skill>.from(e.skills))),
    // );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Toggles the selection status of a skill.
  /// Updates the master list (`_allSkillsData`) and then re-filters the displayed list.
  // void _toggleSkillSelection(String categoryName, String skillId) {
  //   setState(() {
  //     _allSkillsData =
  //         _allSkillsData.map((category) {
  //           if (category.categoryName == categoryName) {
  //             // Create a new list of skills with the updated skill
  //             final updatedSkills =
  //                 category.skills.map((skill) {
  //                   return skill.id == skillId
  //                       ? skill.copyWith(selected: !skill.selected)
  //                       : skill;
  //                 }).toList();
  //             // Return a new category object with the updated skills list
  //             return category.copyWith(skills: updatedSkills);
  //           }
  //           return category; // Return category as is if not the one to be updated
  //         }).toList();
  //     _filterSkills(); // Re-filter to update the displayed list based on the new state
  //   });
  // }

  /// Filters the skills data based on the current search term.
  /// Updates `_filteredSkillsData` which the ListView uses to display items.
  // void _filterSkills() {
  //   final searchTerm = _searchController.text.toLowerCase();
  //   if (searchTerm.isEmpty) {
  //     // If search term is empty, display all skills
  //     setState(() {
  //       _filteredSkillsData = List<SkillCategory>.from(
  //         _allSkillsData.map(
  //           (e) => e.copyWith(skills: List<Skill>.from(e.skills)),
  //         ),
  //       );
  //     });
  //   } else {
  //     setState(() {
  //       _filteredSkillsData =
  //           _allSkillsData
  //               .map((category) {
  //                 // Filter skills within each category
  //                 final filteredCategorySkills =
  //                     category.skills.where((skill) {
  //                       return skill.name.toLowerCase().contains(searchTerm);
  //                     }).toList();
  //                 // Return a new category object with the filtered skills
  //                 return category.copyWith(skills: filteredCategorySkills);
  //               })
  //               .where(
  //                 (category) => category.skills.isNotEmpty,
  //               ) // Only include categories that have matching skills
  //               .toList();
  //     });
  //   }
  // }

  /// Handles the "Next" button press.
  /// Gathers all selected skills and prints them.
  void _handleNext() {
    final selectedSkills =
        _allSkillsData
            .expand(
              (category) => category.skills,
            ) // Flatten the list of lists into a single list of skills
            .where((skill) => skill.selected) // Filter for selected skills
            .toList();

    debugPrint('Selected Skills:');
    for (var skill in selectedSkills) {
      debugPrint('- ${skill.name} (ID: ${skill.id})');
    }

    // In a real application, you would typically navigate to another screen
    // or send the selected skills to a backend service here.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Selected ${selectedSkills.length} skills. Check debug console for details.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Initialize ScreenUtil based on your project's main.dart setup, if not already
    // ScreenUtil.init(context, designSize: const Size(375, 812)); // Example values
    final authState = ref.watch(authNotifierProvider);

<<<<<<< Updated upstream:lib/src/features/auth/presentation/pages/consumer/select_skill.dart
    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          text: AppTexts.appTitle,
          fontWeight: FontWeight.bold,
          fontSize: 24.sp,
        ),
        bottom: PreferredSize(
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
              onChanged:
                  (value) => _filterSkills(), // Call filter on text change
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
        ),
=======
    log(authState.toString());

    return ModalProgressHUD(
      inAsyncCall: authState is ServicesSuccess && authState.savingSkills,
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
                          ref
                              .read(authNotifierProvider.notifier)
                              .filterServices(value);
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
        body: _buildBody(authState),
>>>>>>> Stashed changes:lib/src/features/auth/presentation/screens/select_skill_page.dart
      ),
    );
  }

  _buildBody(AuthState authState) {
    if (authState is ServicesLoading) {
      return Center(
        child: CircularProgressIndicator(color: AppPalette.primaryColor),
      );
    } else if (authState is ServicesError) {
      return Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomText(
              text: authState.message,
              fontSize: 20.sp,
              color: AppPalette.redColor,
            ),
            SizedBox(height: 10),

            SizedBox(
              width: .4.sw,
              child: CustomButton(
                text: 'Retry',
                onPressed: () {
                  ref.read(authNotifierProvider.notifier).getGrouppedServices();
                },
              ),
            ),
          ],
        ),
      );
    } else if (authState is ServicesSuccess) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          20.verticalSpace, // Spacing from flutter_screenutil

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
                authState.isSearching
                    ? ListView.builder(
                      itemCount: authState.filteredServices.length,
                      itemBuilder: (context, categoryIndex) {
                        final category =
                            authState.filteredServices[categoryIndex];

<<<<<<< Updated upstream:lib/src/features/auth/presentation/pages/consumer/select_skill.dart
                    // Divider below category name if needed, but not in original image
                    // Divider(color: AppPalette.greyColor.withOpacity(0.3), height: 1.h),
                    ...category.skills.map((skill) {
                      return Column(
                        children: [
                          InkWell(
                            onTap: () {
                              if (!skill.selected) {
                                AnimatedStatusDialog.show(
                                  context: context,
                                  isSuccess: true,
                                  title: AppTexts.skillAdded,
                                  message: "Success",
                                );

                                Future.delayed(Duration(seconds: 2), () {
                                  context.pop();
                                });
                              }

                              _toggleSkillSelection(
                                category.categoryName,
                                skill.id,
                              );
                            },
                            child: Padding(
=======
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
>>>>>>> Stashed changes:lib/src/features/auth/presentation/screens/select_skill_page.dart
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
                              final isSelected = ref
                                  .read(authNotifierProvider.notifier)
                                  .selectedServices
                                  .contains(skill);

                              return Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      if (!isSelected) {
                                        ref
                                            .read(authNotifierProvider.notifier)
                                            .addService(skill);
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
                      itemCount: authState.cats.length,
                      itemBuilder: (context, categoryIndex) {
                        final category = authState.cats[categoryIndex];

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
<<<<<<< Updated upstream:lib/src/features/auth/presentation/pages/consumer/select_skill.dart
                          ),
                          // Divider below each skill item
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppDimensions.paddingAllSides.w,
                            ),
                            child: Divider(
                              color: AppPalette.greyColor.withOpacity(0.2),
                              height: 1.h,
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                    20.verticalSpace, // Space between categories
                  ],
                );
              },
            ),
          ),
          40.verticalSpace,
          Center(
            child: SizedBox(
              width: 0.4.sw,
              child: CustomButton(
                color: AppPalette.orangeColor,
                textColor: AppPalette.whiteColor,
                text: AppTexts.next,
                onPressed: () {
                  if (widget.isEdit) {
                    context.pop();
                  } else {
                    context.goNamed(AppRoutes.createSchedule);
                  }
=======

                            // Divider below category name if needed, but not in original image
                            // Divider(color: AppPalette.greyColor.withOpacity(0.3), height: 1.h),
                            ...category.services.map((skill) {
                              ///is Selected
                              /// If the skill is selected, show a check icon
                              final isSelected = ref
                                  .read(authNotifierProvider.notifier)
                                  .selectedServices
                                  .contains(skill);
                              ;
                              return Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      if (!isSelected) {
                                        ref
                                            .read(authNotifierProvider.notifier)
                                            .addService(skill);
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
                      ref
                          .read(authNotifierProvider.notifier)
                          .selectedServices
                          .map((e) => e.id)
                          .toList();
                  ref
                      .read(authNotifierProvider.notifier)
                      .updateSkills(
                        context,
                        UpdateProfileRequest(services: selectedSkills),
                        onSuccess: () {
                          if (widget.isEdit) {
                            context.pop();
                          } else {
                            context.goNamed(AppRoutes.createSchedule);
                          }
                        },
                      );
>>>>>>> Stashed changes:lib/src/features/auth/presentation/screens/select_skill_page.dart
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
