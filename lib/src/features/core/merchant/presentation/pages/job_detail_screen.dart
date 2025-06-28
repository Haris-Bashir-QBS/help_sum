import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:help_sum/src/core/constants/app_palette.dart';
import 'package:help_sum/src/core/constants/app_texts.dart';
import 'package:help_sum/src/core/constants/asset_paths.dart';
import 'package:help_sum/src/core/enums/job_status.dart';
import 'package:help_sum/src/core/utils/app_utils.dart';
import 'package:help_sum/src/features/core/common/main_navigation/domain/model/job_model.dart';
import 'package:help_sum/src/features/core/common/main_navigation/widgets/service_provider_card.dart';
import 'package:help_sum/src/features/core/consumer/booking/presentation/widgets/booking_status_header.dart';
import 'package:help_sum/src/features/core/consumer/booking/presentation/widgets/booking_timer.dart';
import 'package:help_sum/src/features/core/consumer/booking/presentation/widgets/job_details_update_card.dart';
import 'package:help_sum/src/features/core/consumer/booking/presentation/widgets/offer_details_card.dart';
import 'package:help_sum/src/features/core/consumer/booking/presentation/widgets/service_location_map.dart';
import 'package:help_sum/src/features/core/consumer/booking/presentation/widgets/service_time_card.dart';
import 'package:help_sum/src/features/core/merchant/presentation/widgets/section_divider_text.dart';
import 'package:help_sum/src/widgets/custom_app_bar.dart';
import 'package:help_sum/src/widgets/custom_button.dart';
import 'package:help_sum/src/widgets/animated_dialog.dart';
import 'package:go_router/go_router.dart';
import 'package:help_sum/src/core/router/app_routes.dart';
import 'package:help_sum/src/features/core/consumer/booking/presentation/widgets/job_image_slider.dart';
import 'package:help_sum/src/widgets/custom_text.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../../core/constants/app_dimensions.dart';

class JobDetailPage extends StatefulWidget {
  final JobModel job;
  final String? tabName;

  const JobDetailPage({super.key, required this.job, this.tabName});

  @override
  State<JobDetailPage> createState() => _JobDetailPageState();
}

class _JobDetailPageState extends State<JobDetailPage> {
  bool showManageJobButton = true;
  @override
  Widget build(BuildContext context) {
    print("job status is ${widget.job.status}");
    return Scaffold(
      appBar: CustomAppBar(title: AppTexts.bookingDetail),
      body: Column(
        children: [
          20.verticalSpace,
          BookingStatusHeader(
            text: widget.tabName ?? "",
            showContractTag:
                widget.job.status == JobStatus.inProgress ||
                widget.job.status == JobStatus.pending,
          ),
          10.verticalSpace,
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.job.status == JobStatus.inProgress) ...[
                    const BookingTimer(),
                    // 20.verticalSpace,
                  ],

                  ServiceTimeCard(
                    title: AppUtils.getServiceStartTimeTitle(widget.job.status),
                    date: 'Tuesday, 11 November',
                    time: '3:10 PM',
                  ),
                  20.verticalSpace,
                  ServiceTimeCard(
                    title: AppUtils.getServiceEndTimeTitle(widget.job.status),
                    date: 'Thursday, 12 November',
                    time: '2:10 PM',
                  ),
                  20.verticalSpace,
                  if (widget.job.status == JobStatus.cancelled ||
                      widget.job.status == JobStatus.rejected)
                    SectionDividerText(
                      heading: "Job Description",
                      text: "Pipe Repair",
                    ),
                  if (widget.job.status == JobStatus.cancelled)
                    SectionDividerText(
                      heading: "Cancelling Reason",
                      text: "Unsatisfied with merchant",
                    ),

                  if (widget.job.status == JobStatus.waitingPayment ||
                      widget.job.status == JobStatus.completed) ...[
                    SectionDividerText(heading: "Total Time", text: "00:06:13"),
                    SectionDividerText(heading: "Total Earning", text: "\$500"),
                  ],
                  if (widget.job.status == JobStatus.pending) ...[
                    SectionDividerText(
                      heading: "Distance from service location:",
                      text: "0.2 km",
                    ),
                  ],
                  if (widget.job.status != JobStatus.cancelled &&
                      widget.job.status != JobStatus.rejected) ...[
                    const OfferDetailsCard(),
                    10.verticalSpace,
                  ],
                  if (widget.job.status == JobStatus.ongoing ||
                      widget.job.status == JobStatus.approved ||
                      widget.job.status == JobStatus.waitingConfirmation
                  //|| job.status == JobStatus.pending//
                  ) ...[
                    JobDetailsUpdateCard(
                      heading: "Job Details Update",
                      showMerchantNotes: true,
                      workLabel:
                          widget.job.status == JobStatus.waitingPayment ||
                                  widget.job.status == JobStatus.completed
                              ? AppTexts.totalServiceTime
                              : null,
                      workValue:
                          widget.job.status == JobStatus.waitingPayment ||
                                  widget.job.status == JobStatus.completed
                              ? AppTexts.threeHours
                              : null,
                    ),
                    20.verticalSpace,
                  ],
                  if (widget.job.status == JobStatus.waitingConfirmation) ...[
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 14.w),
                      child: CustomButton(
                        text: "Chat with usama",
                        textColor: Colors.black,
                        color: Color(0xFF04DB00).withAlpha(40),
                        iconWidget: Image.asset(
                          AppAssets.chatIcon,
                          width: 25.w,
                          height: 25.h,
                          //color: Colors.white,
                        ),
                        onPressed: () {
                          context.pushNamed(AppRoutes.chatScreen);
                        },
                      ),
                    ),
                    10.verticalSpace,
                  ],
                  if (widget.job.status == JobStatus.rejected) ...[
                    JobImageSlider(
                      imageUrls: [
                        'https://picsum.photos/id/237/200/300',
                        'https://picsum.photos/id/238/200/300',
                        'https://picsum.photos/id/239/200/300',
                        'https://picsum.photos/id/240/200/300',
                      ],
                    ),
                    20.verticalSpace,
                  ],
                  if (widget.job.status != JobStatus.waitingPayment) ...[
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 14.w),
                      child: Divider(),
                    ),
                    10.verticalSpace,
                    LocationMapView(
                      heading: "Service Location",
                      latitude: 144,
                      longitude: 146,
                    ),
                    10.verticalSpace,
                  ],
                  if (widget.job.status == JobStatus.inProgress) ...[
                    _chatAndTrackConsumerButtons(context),
                  ],
                  if (widget.job.status == JobStatus.cancelled ||
                      widget.job.status == JobStatus.rejected)
                    ServiceProviderCard(
                      title: widget.job.customerName,
                      reviews: AppTexts.ratingAndReviews,
                      showMapIcon: false,
                      showChatIcon: false,
                      onTap: () {},
                      onTapChat: () {},
                      onTapMap: () {},
                    ),
                  if (widget.job.status == JobStatus.pending) ...[
                    10.verticalSpace,
                    _approveAndRejectJobButtons(context),
                  ],
                  if (widget.job.status == JobStatus.approved) ...[
                    10.verticalSpace,
                    _otherOptionsButton(context),
                  ],
                  if (widget.job.status == JobStatus.inProgress) ...[
                    20.verticalSpace,
                    _bookingConfirmAndCancelButtons(context),
                  ],
                  if (widget.job.status == JobStatus.waitingPayment) ...[
                    10.verticalSpace,
                    _paymentReceivedButton(),
                  ],
                  50.verticalSpace,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _paymentReceivedButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.h),
      child: CustomButton(
        text: "Payment Received",
        color: AppPalette.primaryColor,
        onPressed: () {},
      ),
    );
  }

  Widget _chatAndTrackConsumerButtons(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 40.w),
          child: CustomButton.bordered(
            text: "Track Usama",
            iconWidget: Image.asset(
              AppAssets.trgetIcon,
              width: 20.w,
              height: 20.h,
            ),
            onPressed: () {
              context.pushNamed(AppRoutes.mapTracking);
            },
          ),
        ),
        10.verticalSpace,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 40.w),
          child: CustomButton.bordered(
            text: "Chat with Usama",
            iconWidget: Image.asset(
              AppAssets.chatIcon,
              width: 20.w,
              height: 20.h,
            ),
            onPressed: () {
              context.pushNamed(AppRoutes.chatScreen);
            },
          ),
        ),
      ],
    );
  }

  Padding _approveAndRejectJobButtons(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppDimensions.paddingAllSides),
      child: Row(
        children: [
          Expanded(
            child: CustomButton(
              text: "Approve Job",
              color: AppPalette.primaryColor.withAlpha(220),
              textColor: Colors.white,
              onPressed: () {
                Fluttertoast.showToast(msg: "Job Approved");
                context.pop();
                // _showJobStartConfirmationDialog(context);
              },
            ),
          ),
          10.horizontalSpace,
          Expanded(
            child: CustomButton(
              text: "Reject Job",
              textColor: Colors.white,
              color: AppPalette.redColor,
              onPressed: () {
                Fluttertoast.showToast(msg: "Job Rejected");
                context.pop();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _bookingConfirmAndCancelButtons(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppDimensions.paddingAllSides),
      child: Row(
        children: [
          Expanded(
            child: CustomButton(
              text: "End Job",
              color: AppPalette.primaryColor.withAlpha(220),
              textColor: Colors.white,
              onPressed: () {
                //   Fluttertoast.showToast(msg: "Job Ended");
                //context.pop();
                _showJobEndConfirmationDialog(context);
              },
            ),
          ),
          10.horizontalSpace,
          Expanded(
            child: CustomButton(
              text: AppTexts.cancelJob,
              textColor: Colors.white,
              color: AppPalette.redColor,
              onPressed: () {
                Fluttertoast.showToast(msg: "Job Cancelled");
                context.pop();
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showJobEndConfirmationDialog(BuildContext context) async {
    await AnimatedStatusDialog.show(
      context: context,
      isSuccess: true,
      title: "Are you sure to end this job?",
      primaryButtonText: AppTexts.no,
      onSecondaryTap: () {
        showJobReceiptDialog(context);
      },
      secondaryButtonText: AppTexts.yes,
    );
  }

  void showJobReceiptDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevents dismiss on outside tap
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20), // Rounded corners
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'Job Receipt',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                const Divider(thickness: 1),
                const SizedBox(height: 12),

                const Text(
                  'Service Started on:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const Text('Mon, 5th Feb 2023'),
                const Text('06:31 PM'),
                const SizedBox(height: 16),

                const Text(
                  'Service Ended on:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const Text('Mon, 5th Feb 2023'),
                const Text('06:31 PM'),
                const SizedBox(height: 16),

                const Text(
                  'Total Time:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const Text('00:10:12'),
                const SizedBox(height: 16),

                const Text(
                  'Total Amount:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const Text('\$500'),
                const SizedBox(height: 24),

                Center(
                  child: SizedBox(
                    width: 150.w,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context); // First pop (dialog)
                        Navigator.pop(
                          context,
                        ); // Second pop (parent page, if needed)
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text("Done"),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _otherOptionsButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        children: [
          if (showManageJobButton == true) ...[
            CustomButton(
              text: "Manage Job",
              color: AppPalette.primaryColor,
              onPressed: () async {
                bool? isSuccess = await context.pushNamed(AppRoutes.manageJob);
                if (isSuccess == true) {
                  showManageJobButton = false;
                  Fluttertoast.showToast(msg: "Job Updated Successfully");
                  setState(() {});
                }
              },
            ),
            10.verticalSpace,
          ],

          CustomButton(
            text: "Start Job",
            color: AppPalette.primaryColor,
            onPressed: () {
              context.pop();
              Fluttertoast.showToast(msg: "Job Started");
            },
          ),
        ],
      ),
    );
  }
}
