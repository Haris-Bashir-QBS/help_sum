import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:help_sum/src/core/constants/app_dimensions.dart';
import 'package:help_sum/src/core/constants/app_palette.dart';
import 'package:help_sum/src/core/constants/app_texts.dart';
import 'package:help_sum/src/core/enums/job_status.dart';
import 'package:help_sum/src/core/utils/app_static_data.dart';
import 'package:help_sum/src/features/core/common/main_navigation/domain/model/job_model.dart';
import 'package:help_sum/src/widgets/app_tab_bar.dart';
import 'package:help_sum/src/widgets/custom_text.dart';
import 'package:help_sum/src/widgets/custom_text_formfield.dart';
import 'package:help_sum/src/widgets/location_timeline.dart';

class AllJobsScreen extends StatefulWidget {
  const AllJobsScreen({super.key});

  @override
  State<AllJobsScreen> createState() => _AllJobsScreenState();
}

class _AllJobsScreenState extends State<AllJobsScreen> {
  final tabs = [
    'All',
    'On Going',
    'Pending',
    'Approved',
    'Confirmation Waiting',
    'Payment Waiting',
    'Cancelled',
  ];

  final ScrollController scrollController = ScrollController();
  int selectedIndex = 0;
  List<JobModel> jobs = [];

  @override
  void initState() {
    jobs = AppStaticData.dummyJobs;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding:
              const EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingAllSides,
              ).r,
          child: CustomTextFormField(
            hint: AppTexts.searchHint,

            customHintStyle: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: AppPalette.blackColor,
            ),
            fillColor: AppPalette.fillColor,
            suffixIcon: Container(
              width: 30.w,
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
                  size: 30,
                  weight: 900,
                ),
              ),
            ),
          ),
        ),

        20.verticalSpace,
        _buildJobsTabbar(),
        20.verticalSpace,
        _jobListView(),
      ],
    );
  }

  _jobListView() {
    return Expanded(
      child: ListView.builder(
        itemCount: jobs.length,
        itemBuilder: (c, i) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              10.verticalSpace,
              Container(
                height: 40.h,
                decoration: BoxDecoration(color: Color(0xFFD9D9D9)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CustomText(
                      text: AppTexts.date,
                      fontWeight: FontWeight.bold,
                    ),
                    CustomText(
                      text: jobs[i].date,
                      fontWeight: FontWeight.normal,
                    ),

                    CustomText(
                      text: AppTexts.time,
                      fontWeight: FontWeight.bold,
                    ),
                    CustomText(
                      textAlign: TextAlign.end,
                      text: jobs[i].time,
                      fontWeight: FontWeight.normal,
                    ),
                  ],
                ),
              ),

              20.verticalSpace,

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingAllSides,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: CustomText(
                        text: jobs[i].customerName,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    CustomText(
                      text: '#${i + 2}',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.normal,
                      color: AppPalette.hintColor,
                    ),
                  ],
                ),
              ),

              10.verticalSpace,
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingAllSides,
                ),
                child: CustomText(
                  text: jobs[i].serviceName,
                  fontWeight: FontWeight.normal,
                  fontSize: 16.sp,
                  color: AppPalette.hintColor,
                ),
              ),
              30.verticalSpace,

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingAllSides,
                ),
                child: LocationTimeline(),
              ),
              16.verticalSpace,

              Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  margin: EdgeInsets.only(right: 12.w),
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 6.w,
                  ),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(-2, 5),
                        spreadRadius: 2,
                        color: AppPalette.greyColor,
                        blurRadius: 5,
                      ),
                    ],
                    color: getJobColor(jobs[i].status),
                    borderRadius: BorderRadius.circular(
                      AppDimensions.appBorderRadius,
                    ),
                  ),
                  child: CustomText(
                    color:
                        jobs[i].status == JobStatus.cancelled
                            ? AppPalette.backgroundColor
                            : null,
                    fontWeight: FontWeight.bold,
                    fontSize: 13.sp,
                    text: getJobString(jobs[i].status),
                  ),
                ),
              ),

              10.verticalSpace,
            ],
          );
        },
      ),
    );
  }

  String getJobString(JobStatus job) {
    switch (job) {
      case JobStatus.ongoing:
      case JobStatus.inProgress:
        return "In-Progress";
      case JobStatus.approved:
      case JobStatus.completed:
        return "Completed";
      case JobStatus.waitingConfirmation:
        return "Waiting Confirmation";
      case JobStatus.waitingPayment:
        return "Waiting Payment";
      case JobStatus.cancelled:
        return "Cancelled";
      case JobStatus.all:
        return AppTexts.all;
      case JobStatus.pending:
        return AppTexts.pending;
    }
  }

  Color getJobColor(JobStatus job) {
    switch (job) {
      case JobStatus.ongoing:
      case JobStatus.inProgress:
      case JobStatus.pending:
        return Color(0xFFFFC680);
      case JobStatus.approved:
      case JobStatus.completed:
        return Color(0xFFAFFFA8);
      case JobStatus.waitingConfirmation:
      case JobStatus.waitingPayment:
        return Color(0xFFFFC680);
      case JobStatus.cancelled:
        return Color(0xFFFF0000);
      case JobStatus.all:
        return Colors.transparent;
    }
  }

  _buildJobsTabbar() {
    return AppTabBar(
      selectedIndex: selectedIndex,
      tabs: tabs,
      onTapChanged: (index) {
        switch (index) {
          case 0:
            jobs = AppStaticData.dummyJobs;
            break;
          case 1:
          case 2:
            jobs =
                AppStaticData.dummyJobs
                    .where((e) => e.status == JobStatus.inProgress)
                    .toList();

            break;
          case 3:
            jobs =
                AppStaticData.dummyJobs
                    .where((e) => e.status == JobStatus.approved)
                    .toList();
            break;
          case 4:
            jobs =
                AppStaticData.dummyJobs
                    .where((e) => e.status == JobStatus.waitingConfirmation)
                    .toList();

            break;

          case 5:
            jobs =
                AppStaticData.dummyJobs
                    .where((e) => e.status == JobStatus.waitingPayment)
                    .toList();

            break;

          case 6:
            jobs =
                AppStaticData.dummyJobs
                    .where((e) => e.status == JobStatus.cancelled)
                    .toList();

            break;
        }
        setState(() {
          selectedIndex = index;
        });
      },
    );
  }
}
