import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:help_sum/src/core/constants/app_dimensions.dart';
import 'package:help_sum/src/core/constants/app_palette.dart';
import 'package:help_sum/src/core/constants/app_texts.dart';
import 'package:help_sum/src/core/constants/asset_paths.dart';
import 'package:help_sum/src/core/models/merchant/skill_model.dart';
import 'package:help_sum/src/core/router/app_routes.dart';
import 'package:help_sum/src/core/models/merchant/skill_category.dart';
import 'package:help_sum/src/widgets/animated_dialog.dart';
import 'package:help_sum/src/widgets/custom_button.dart';
import 'package:help_sum/src/widgets/custom_text.dart';
import 'package:help_sum/src/widgets/custom_text_formfield.dart';

// Data Model for a single skill

class SkillSelectionScreen extends StatefulWidget {
  const SkillSelectionScreen({super.key, this.isEdit = false});
  final bool isEdit;

  @override
  State<SkillSelectionScreen> createState() => _SkillSelectionScreenState();
}

class _SkillSelectionScreenState extends State<SkillSelectionScreen> {
  // Master list of all skills, used for filtering and state updates
  late List<SkillCategory> _allSkillsData;
  // List of skills currently displayed, updated by search
  late List<SkillCategory> _filteredSkillsData;
  // Controller for the search text field
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    debugPrint(widget.isEdit.toString());
    // Initialize with a proper list of categories and skills
    _allSkillsData = [
      SkillCategory(
        categoryName: "Personal Care",
        skills: [
          Skill(id: "personalCare_makeup", name: "Makeup"),
          Skill(
            id: "personalCare_hairStylist",
            name: "Hairstylist",
            selected: true,
          ), // Example: initially selected
          Skill(id: "personalCare_barber", name: "Barber"),
        ],
      ),
      SkillCategory(
        categoryName: "Mechanic",
        skills: [
          Skill(id: "mechanic_motorcycle", name: "Motorcycle Mechanic"),
          Skill(id: "mechanic_tyreChange", name: "Tyre Change"),
        ],
      ),
      SkillCategory(
        categoryName: "Daily Workers",
        skills: [
          Skill(id: "dailyWorkers_maid", name: "Maid"),
          Skill(id: "dailyWorkers_waiter", name: "Waiter"),
          Skill(id: "dailyWorkers_houseMaintenance", name: "House Maintenance"),
        ],
      ),
    ];
    // Initially, filtered skills are all skills
    _filteredSkillsData = List<SkillCategory>.from(
      _allSkillsData.map((e) => e.copyWith(skills: List<Skill>.from(e.skills))),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Toggles the selection status of a skill.
  /// Updates the master list (`_allSkillsData`) and then re-filters the displayed list.
  void _toggleSkillSelection(String categoryName, String skillId) {
    setState(() {
      _allSkillsData =
          _allSkillsData.map((category) {
            if (category.categoryName == categoryName) {
              // Create a new list of skills with the updated skill
              final updatedSkills =
                  category.skills.map((skill) {
                    return skill.id == skillId
                        ? skill.copyWith(selected: !skill.selected)
                        : skill;
                  }).toList();
              // Return a new category object with the updated skills list
              return category.copyWith(skills: updatedSkills);
            }
            return category; // Return category as is if not the one to be updated
          }).toList();
      _filterSkills(); // Re-filter to update the displayed list based on the new state
    });
  }

  /// Filters the skills data based on the current search term.
  /// Updates `_filteredSkillsData` which the ListView uses to display items.
  void _filterSkills() {
    final searchTerm = _searchController.text.toLowerCase();
    if (searchTerm.isEmpty) {
      // If search term is empty, display all skills
      setState(() {
        _filteredSkillsData = List<SkillCategory>.from(
          _allSkillsData.map(
            (e) => e.copyWith(skills: List<Skill>.from(e.skills)),
          ),
        );
      });
    } else {
      setState(() {
        _filteredSkillsData =
            _allSkillsData
                .map((category) {
                  // Filter skills within each category
                  final filteredCategorySkills =
                      category.skills.where((skill) {
                        return skill.name.toLowerCase().contains(searchTerm);
                      }).toList();
                  // Return a new category object with the filtered skills
                  return category.copyWith(skills: filteredCategorySkills);
                })
                .where(
                  (category) => category.skills.isNotEmpty,
                ) // Only include categories that have matching skills
                .toList();
      });
    }
  }

  // /// Handles the "Next" button press.
  // /// Gathers all selected skills and prints them.
  // void _handleNext() {
  //   final selectedSkills =
  //       _allSkillsData
  //           .expand(
  //             (category) => category.skills,
  //           ) // Flatten the list of lists into a single list of skills
  //           .where((skill) => skill.selected) // Filter for selected skills
  //           .toList();
  //
  //   debugPrint('Selected Skills:');
  //   for (var skill in selectedSkills) {
  //     debugPrint('- ${skill.name} (ID: ${skill.id})');
  //   }
  //
  //   // In a real application, you would typically navigate to another screen
  //   // or send the selected skills to a backend service here.
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: Text(
  //         'Selected ${selectedSkills.length} skills. Check debug console for details.',
  //       ),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    // Initialize ScreenUtil based on your project's main.dart setup, if not already
    // ScreenUtil.init(context, designSize: const Size(375, 812)); // Example values

    return Scaffold(
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
                      onChanged:
                          (value) =>
                              _filterSkills(), // Call filter on text change
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
      body: Column(
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
            child: ListView.builder(
              itemCount: _filteredSkillsData.length,
              itemBuilder: (context, categoryIndex) {
                final category = _filteredSkillsData[categoryIndex];
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
                    ...category.skills.map((skill) {
                      return Column(
                        children: [
                          InkWell(
                            onTap: () {
                              if (!skill.selected) {
                                AnimatedStatusDialog.show(
                                  context: context,
                                  sucessOnly: true,
                                  isSuccess: true,
                                  title: AppTexts.skillAdded,
                                  message: "Success",
                                );

                                Future.delayed(Duration(seconds: 2), () async {
                                  if(mounted) {
                                    context.pop();
                                  }
                                });

                              }

                              _toggleSkillSelection(
                                category.categoryName,
                                skill.id,
                              );
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: AppDimensions.paddingAllSides.w,
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
                                    skill.selected ? Icons.check : Icons.add,
                                    color:
                                        skill.selected
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
                              horizontal: AppDimensions.paddingAllSides.w,
                            ),
                            child: Divider(
                              color: AppPalette.greyColor.withOpacity(0.2),
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
          if (!widget.isEdit) 40.verticalSpace,
          if (!widget.isEdit)
            Center(
              child: SizedBox(
                width: 0.4.sw,
                child: CustomButton(
                  color:
                      widget.isEdit
                          ? AppPalette.primaryColor
                          : AppPalette.orangeColor,
                  textColor: AppPalette.whiteColor,
                  text: AppTexts.next,
                  onPressed: () {
                    if (widget.isEdit) {
                      context.pop();
                    } else {
                      context.goNamed(AppRoutes.createSchedule);
                    }
                  },
                ),
              ),
            ),

          // Next Button
          40.verticalSpace,
        ],
      ),
    );
  }
}
