import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:help_sum/src/core/constants/app_palette.dart';
import 'package:help_sum/src/core/constants/app_texts.dart';
import 'package:help_sum/src/core/constants/asset_paths.dart';
import 'package:help_sum/src/core/dependency_injection/di_barrel.dart';
import 'package:help_sum/src/core/enums/job_status.dart';
import 'package:help_sum/src/core/extensions/context_extensions.dart';
import 'package:help_sum/src/core/extensions/string_extensions.dart';
import 'package:help_sum/src/core/router/app_routes.dart';
import 'package:help_sum/src/core/utils/app_utils.dart';
import 'package:help_sum/src/features/core/common/main_navigation/widgets/service_provider_card.dart';
import 'package:help_sum/src/features/core/consumer/booking/data/models/job_response_model.dart';
import 'package:help_sum/src/features/core/consumer/booking/presentation/widgets/booking_status_header.dart';
import 'package:help_sum/src/features/core/consumer/booking/presentation/widgets/job_details_update_card.dart';
import 'package:help_sum/src/features/core/consumer/booking/presentation/widgets/job_image_slider.dart';
import 'package:help_sum/src/features/core/consumer/booking/presentation/widgets/offer_details_card.dart';
import 'package:help_sum/src/features/core/consumer/booking/presentation/widgets/service_location_map.dart';
import 'package:help_sum/src/features/core/consumer/booking/presentation/widgets/service_time_card.dart';
import 'package:help_sum/src/features/core/merchant/presentation/bloc/job_details_bloc.dart';
import 'package:help_sum/src/widgets/animated_dialog.dart';
import 'package:help_sum/src/widgets/custom_app_bar.dart';
import 'package:help_sum/src/widgets/custom_button.dart';
import 'package:help_sum/src/widgets/custom_toast.dart';
import 'package:logger/logger.dart';

import '../../../../../core/constants/app_dimensions.dart';
import '../../../../../core/enums/payment_status.dart';
import '../../../common/chat/domain/entities/inbox_chat_entity.dart';
import 'package:help_sum/src/widgets/custom_text.dart';

class JobDetailPage extends StatefulWidget {
  final JobData job;
  final String? tabName;

  const JobDetailPage({super.key, required this.job, this.tabName});

  @override
  State<JobDetailPage> createState() => _JobDetailPageState();
}

class _JobDetailPageState extends State<JobDetailPage> {
  bool showManageJobButton = true;
  late final JobDetailsBloc _jobDetailsBloc;

  @override
  void initState() {
    Logger().i(widget.job.paymentStatus);
    _jobDetailsBloc = sl<JobDetailsBloc>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _jobDetailsBloc,
      child: BlocListener<JobDetailsBloc, JobDetailsState>(
        listener: (context, state) {
          if (state is JobDetailsLoading) {
            AppUtils.showProgressLoader(context: context);
          } else if (state is JobActionSuccess) {
            Navigator.pop(context);
            switch (state.action) {
              case 'start':
                Navigator.pop(context);
                break;
              case 'complete':
                CustomToast.successToast(
                    context: context, message: "Job Completed");
                showJobReceiptDialog(context);
                break;
              case 'cancel':
                CustomToast.successToast(
                    context: context, message: "Job Cancelled");
                Navigator.pop(context);
                break;
              case 'accept':
                CustomToast.successToast(
                    context: context, message: "Job Approved");
                Navigator.pop(context);
                break;
              case 'reject':
                CustomToast.successToast(
                    context: context, message: "Job Rejected");
                Navigator.pop(context);
                break;
              case 'change':
                Navigator.pop(context);
                break;
            }
          } else if (state is JobDetailsError) {
            Navigator.pop(context);
            CustomToast.errorToast(context: context, message: state.message);
          }
        },
        child: Scaffold(
          appBar: CustomAppBar(
            title: AppTexts.JobDetail,
            onBackButtonPressed: () {
              context.pop(true);
            },
          ),
          body: Column(
            children: [
              20.verticalSpace,
              BookingStatusHeader(
                text: widget.job.status.capitalizeAndReplaceUnderscore(),
                showContractTag:
                    widget.job.status == JobStatus.in_progress.name ||
                        widget.job.status == JobStatus.pending.name,
              ),
              10.verticalSpace,
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Visibility(
                        visible: widget.job.status == JobStatus.pending.name ||
                            widget.job.status ==
                                JobStatus.waitingConfirmation.name ||
                            widget.job.status == JobStatus.in_progress.name &&
                                widget.job.jobStartTime == null,
                        child: ServiceTimeCard(
                          title: "Starting Time",
                          date: AppUtils.formatReadableDate(widget.job.date),
                          time: AppUtils.formatReadableTime(widget.job.time),
                        ),
                      ),
                      Visibility(
                        visible: widget.job.jobStartTime != null,
                        child: ServiceTimeCard(
                          title: "Start Time",
                          date: widget.job.date,
                          time: '3:10 PM',
                        ),
                      ),
                      Visibility(
                        visible: widget.job.jobEndTime != null,
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 20.h),
                              child: ServiceTimeCard(
                                title: "End Time",
                                date: widget.job.date,
                                time: '2:10 PM',
                              ),
                            ),
                            10.verticalSpace,
                            Divider(),
                          ],
                        ),
                      ),
                      _imageSlider(),
                      10.verticalSpace,
                      OfferDetailsCard(job: widget.job),
                      20.verticalSpace,
                      Divider(),
                      LocationMapView(
                        latitude: widget.job.location.coordinates[1],
                        longitude: widget.job.location.coordinates[0],
                      ),
                      10.verticalSpace,
                      ServiceProviderCard(
                        title: widget.job.consumerId.firstName +
                            widget.job.consumerId.lastName,
                        reviews: widget.job.consumerId.averageRating.toString(),
                        imageUrl: widget.job.consumerId.image,
                        showMapIcon: false,
                        onTap: () {},
                        onTapChat: () {
                          context.pushNamed(
                            AppRoutes.chatScreen,
                            extra: InboxChatEntity(
                              userId: widget.job.consumerId.id ?? "",
                              firstName: widget.job.consumerId.firstName,
                              lastName: widget.job.consumerId.firstName,
                              image: widget.job.consumerId.image,
                            ),
                          );
                        },
                        onTapMap: () {
                          context.pushNamed(AppRoutes.mapTracking);
                        },
                      ),
                      if (widget.job.status == JobStatus.ongoing.name ||
                          widget.job.status == JobStatus.approved.name ||
                          widget.job.status ==
                              JobStatus.waitingConfirmation.name) ...[
                        JobDetailsUpdateCard(
                          heading: "Job Details Update",
                          showMerchantNotes: true,
                          workLabel: AppUtils.parseJobStatus(
                                          widget.job.status) ==
                                      JobStatus.waitingPayment ||
                                  AppUtils.parseJobStatus(widget.job.status) ==
                                      JobStatus.completed
                              ? AppTexts.totalServiceTime
                              : null,
                          workValue: AppUtils.parseJobStatus(
                                          widget.job.status) ==
                                      JobStatus.waitingPayment ||
                                  AppUtils.parseJobStatus(widget.job.status) ==
                                      JobStatus.completed
                              ? AppTexts.threeHours
                              : null,
                        ),
                        20.verticalSpace,
                      ],
                      if (widget.job.status !=
                          JobStatus.waitingPayment.name) ...[
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 14.w),
                          child: Divider(),
                        ),
                      ],
                      if (widget.job.status == JobStatus.cancelled.name ||
                          widget.job.status == JobStatus.rejected.name)
                        _serviceProviderCard(),
                      if (widget.job.status == JobStatus.pending.name) ...[
                        10.verticalSpace,
                        _approveAndRejectJobButtons(context),
                      ],
                      if (widget.job.status == JobStatus.in_progress.name ||
                          widget.job.status == JobStatus.accepted.name) ...[
                        20.verticalSpace,
                        _bookingConfirmAndCancelButtons(context),
                      ],
                      if (widget.job.paymentStatus == PaymentStatus.paid.name &&
                          widget.job.status != JobStatus.completed.name) ...[
                        10.verticalSpace,
                        _paymentReceivedButton(),
                      ],
                      if (widget.job.status == JobStatus.completed.name &&
                          widget.job.isMerchantRated != true)
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15.h),
                          child: CustomButton(
                            text: AppTexts.rate,
                            color: context.primaryColor,
                            radius: 10,
                            onPressed: () {
                              context.pushNamed(
                                AppRoutes.rateScreen,
                                extra: widget.job,
                              );
                            },
                          ),
                        ),
                      50.verticalSpace,
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ServiceProviderCard _serviceProviderCard() {
    return ServiceProviderCard(
      title: widget.job.consumerId.firstName,
      reviews: AppTexts.ratingAndReviews,
      showMapIcon: false,
      showChatIcon: false,
      onTap: () {},
      onTapChat: () {},
      onTapMap: () {},
    );
  }

  Widget _imageSlider() {
    return widget.job.media.isNotEmpty
        ? JobImageSlider(imageUrls: widget.job.media.map((e) => e).toList())
        : SizedBox.shrink();
  }

  Widget _paymentReceivedButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.h),
      child: CustomButton(
        text: "Payment Received",
        radius: 10,
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
            text: "Track  {widget.job.consumerId.firstName}",
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
            text: "Chat with  {widget.job.consumerId.firstName}",
            iconWidget: Image.asset(
              AppAssets.chatIcon,
              width: 20.w,
              height: 20.h,
            ),
            onPressed: () {
              context.pushNamed(
                AppRoutes.chatScreen,
                extra: InboxChatEntity(
                  userId: widget.job.consumerId.id ?? "",
                  firstName: widget.job.consumerId.firstName,
                  lastName: widget.job.consumerId.firstName,
                  image: widget.job.consumerId.image,
                ),
              );
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
                _jobDetailsBloc.add(ChangeJobStatusEvent(
                  jobId: widget.job.id,
                  action: "accept",
                ));
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
                _jobDetailsBloc.add(ChangeJobStatusEvent(
                  jobId: widget.job.id,
                  action: "reject",
                ));
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
              text: widget.job.status == JobStatus.accepted.name
                  ? AppTexts.startJob
                  : AppTexts.endJob,
              color: AppPalette.primaryColor.withAlpha(220),
              textColor: Colors.white,
              radius: 10,
              onPressed: () {
                if (widget.job.status == JobStatus.accepted.name) {
                  _jobDetailsBloc.add(StartJobEvent(widget.job.id));
                } else {
                  _showJobEndConfirmationDialog(context);
                }
              },
            ),
          ),
          10.horizontalSpace,
          Expanded(
            child: CustomButton(
              text: AppTexts.cancelJob,
              textColor: Colors.white,
              color: AppPalette.redColor,
              radius: 10,
              onPressed: () {
                _jobDetailsBloc.add(ChangeJobStatusEvent(
                  jobId: widget.job.id,
                  action: "cancel",
                ));
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
        _jobDetailsBloc.add(CompleteJobEvent(widget.job.id));
      },
      secondaryButtonText: AppTexts.yes,
    );
  }

  void showJobReceiptDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: CustomText(
                    text: 'Job Receipt',
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppPalette.primaryColor,
                  ),
                ),
                const Divider(thickness: 1),
                const SizedBox(height: 12),
                CustomText(
                  text: 'Service Started on:',
                  fontWeight: FontWeight.bold,
                ),
                CustomText(text: 'Mon, 5th Feb 2023'),
                CustomText(text: '06:31 PM'),
                const SizedBox(height: 16),
                CustomText(
                  text: 'Service Ended on:',
                  fontWeight: FontWeight.bold,
                ),
                CustomText(text: 'Mon, 5th Feb 2023'),
                CustomText(text: '06:31 PM'),
                const SizedBox(height: 16),
                CustomText(
                  text: 'Total Time:',
                  fontWeight: FontWeight.bold,
                ),
                CustomText(text: '00:10:12'),
                const SizedBox(height: 16),
                CustomText(
                  text: 'Total Amount:',
                  fontWeight: FontWeight.bold,
                ),
                CustomText(text: ' 500'),
                const SizedBox(height: 24),
                Center(
                  child: SizedBox(
                    width: 150.w,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppPalette.primaryColor,
                        foregroundColor: AppPalette.primaryColor,
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
}
