import 'package:flutter/material.dart';
import 'package:help_sum/src/core/constants/app_texts.dart';
import 'package:help_sum/src/core/constants/asset_paths.dart';
import 'package:help_sum/src/core/enums/job_status.dart';
import 'package:help_sum/src/features/core/common/main_navigation/domain/model/job_model.dart';
import 'package:help_sum/src/features/core/merchant/domain/models/service_provider_model.dart';

class AppStaticData {
  const AppStaticData._();
  static List<String> consumerAppbarTitles = [
    AppTexts.bookings,
    AppTexts.categories,
    AppTexts.profile,
  ];
  static List<String> merchantAppBarTitles = [AppTexts.jobs, "", ""];

  static const List<String> jobStatusTabs = [
    AppTexts.all,
    AppTexts.completed,
    AppTexts.inProgress,
    AppTexts.pending,
    AppTexts.approved,
    AppTexts.waitingConfirmation,
    AppTexts.waitingPayment,
    AppTexts.cancelled,
    AppTexts.rejected,
  ];

  static const List<OnboardingSlideData> onboardingSlides = [
    OnboardingSlideData(
      imagePath: AppAssets.onboarding1,
      title: AppTexts.qualityServiceTitle,
      description: AppTexts.qualityServiceDescription,
      isLastPage: false,
    ),
    OnboardingSlideData(
      imagePath: AppAssets.onboarding2,
      title: AppTexts.workFasterTitle,
      description: AppTexts.workFasterDescription,
      isLastPage: false,
    ),
    OnboardingSlideData(
      imagePath: AppAssets.onboarding3,
      title: AppTexts.getEmployedTitle,
      description: AppTexts.getEmployedDescription,
      isLastPage: true,
    ),
  ];

  static const List<CategoryData> categories = [
    CategoryData(name: AppTexts.officeWorkers, iconPath: AppAssets.officeWorker),
    CategoryData(name: AppTexts.education,iconPath: AppAssets.education),
    CategoryData(name: AppTexts.eventPlanner, iconPath: AppAssets.eventPlanner),
    CategoryData(name: AppTexts.mechanic, iconPath: AppAssets.mechanic),
    CategoryData(name: AppTexts.health, iconPath: AppAssets.health),
    CategoryData(name: AppTexts.dailyWorkers, iconPath: AppAssets.dailyWorkers),
    CategoryData(name: AppTexts.artist, iconPath: AppAssets.artist),
    CategoryData(name: AppTexts.personalCare, iconPath: AppAssets.perosnalCare),
    CategoryData(name: AppTexts.careTakers,iconPath: AppAssets.careTaker),
    CategoryData(name: AppTexts.technicians, iconPath: AppAssets.technician),
  ];

  static const List<ServiceProviderModel> serviceProviders = [
    ServiceProviderModel(
      id: '1',
      name: 'John Doe',
      profession: 'Electrician',
      isAvailable: true,
      rating: 4.5,
      reviewsCount: 120,
      aboutText:
          'Experienced electrician with over 10 years of experience in residential and commercial electrical work. Specialized in wiring, installations, and repairs.',
      profileImages: [
        'https://picsum.photos/800/400?random=1',
        'https://picsum.photos/800/400?random=2',
        'https://picsum.photos/800/400?random=3',
      ],
      profileImage: 'https://picsum.photos/200/200?random=1',
      reviews: [
        {
          'reviewerName': 'Alice Smith',
          'rating': 5.0,
          'reviewText':
              'Excellent service! Very professional and completed the work quickly.',
          'date': '2 days ago',
        },
        {
          'reviewerName': 'Bob Johnson',
          'rating': 4.0,
          'reviewText':
              'Good work, but a bit expensive. Would recommend for quality work.',
          'date': '1 week ago',
        },
      ],
      rate: 250.0,
      rateLabel: 'per hour',
      distance: 5.5,
      distanceLabel: 'km',
      completedJobs: 24,
      completedJobsLabel: 'jobs completed',
    ),
    ServiceProviderModel(
      id: '2',
      name: 'Jane Smith',
      profession: 'Plumber',
      isAvailable: true,
      rating: 4.8,
      reviewsCount: 85,
      aboutText:
          'Professional plumber specializing in emergency repairs and installations. Available 24/7 for urgent plumbing issues.',
      profileImages: [
        'https://picsum.photos/800/400?random=4',
        'https://picsum.photos/800/400?random=5',
        'https://picsum.photos/800/400?random=6',
      ],
      profileImage: 'https://picsum.photos/200/200?random=2',
      reviews: [
        {
          'reviewerName': 'Charlie Brown',
          'rating': 5.0,
          'reviewText':
              'Saved me from a major water leak! Very responsive and professional.',
          'date': '1 day ago',
        },
        {
          'reviewerName': 'Diana Ross',
          'rating': 4.5,
          'reviewText': 'Great service, fixed my plumbing issues efficiently.',
          'date': '3 days ago',
        },
      ],
      rate: 200.0,
      rateLabel: 'per hour',
      distance: 3.2,
      distanceLabel: 'km',
      completedJobs: 18,
      completedJobsLabel: 'jobs completed',
    ),
  ];

  static final List<JobModel> dummyJobs = [
    JobModel(
      date: "26/07/2022",
      time: "3:30 pm",
      customerName: "Ali",
      serviceName: "Tyre Change",
      status: JobStatus.inProgress,
    ),
    JobModel(
      date: "26/07/2022",
      time: "4:00 pm",
      customerName: "Hamza",
      serviceName: "Electronic Repair",
      status: JobStatus.ongoing,
    ),
    JobModel(
      date: "27/07/2022",
      time: "11:00 am",
      customerName: "Ahmed",
      serviceName: "Appliance Repair",
      status: JobStatus.cancelled,
    ),
    JobModel(
      date: "27/07/2022",
      time: "11:00 am",
      customerName: "Ahmed",
      serviceName: "Appliance Repair",
      status: JobStatus.pending,
    ),
    JobModel(
      date: "28/07/2022",
      time: "1:00 pm",
      customerName: "Fatima",
      serviceName: "Tire Change",
      status: JobStatus.waitingConfirmation,
    ),
    JobModel(
      date: "28/07/2022",
      time: "2:00 pm",
      customerName: "Zain",
      serviceName: "Refrigerator Repair",
      status: JobStatus.waitingPayment,
    ),
    JobModel(
      date: "29/07/2022",
      time: "10:00 am",
      customerName: "Sara",
      serviceName: "AC Service",
      status: JobStatus.approved,
    ),
    JobModel(
      date: "29/07/2022",
      time: "10:00 am",
      customerName: "Sara",
      serviceName: "AC Service",
      status: JobStatus.completed,
    ),
    JobModel(
      date: "28/07/2022",
      time: "2:00 pm",
      customerName: "Shafeeq",
      serviceName: "Refrigerator Repair",
      status: JobStatus.rejected,
    ),
  ];
}

class OnboardingSlideData {
  final String imagePath;
  final String title;
  final String description;
  final bool isLastPage;

  const OnboardingSlideData({
    required this.imagePath,
    required this.title,
    required this.description,
    required this.isLastPage,
  });
}

class CategoryData {
  final String name;
  final String iconPath;

  const CategoryData({required this.name, required this.iconPath});
}
