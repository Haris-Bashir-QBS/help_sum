import 'package:flutter/material.dart';
import 'package:help_sum/src/core/constants/app_texts.dart';
import 'package:help_sum/src/core/constants/asset_paths.dart';
import 'package:help_sum/src/features/core/merchant/domain/models/service_provider_model.dart';


class AppStaticData {
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
    CategoryData(name: AppTexts.officeWorkers, icon: Icons.business_center),
    CategoryData(name: AppTexts.education, icon: Icons.school),
    CategoryData(name: AppTexts.eventPlanner, icon: Icons.calendar_today),
    CategoryData(name: AppTexts.mechanic, icon: Icons.car_repair),
    CategoryData(name: AppTexts.health, icon: Icons.favorite_border),
    CategoryData(name: AppTexts.dailyWorkers, icon: Icons.engineering),
    CategoryData(name: AppTexts.artist, icon: Icons.palette),
    CategoryData(name: AppTexts.personalCare, icon: Icons.spa),
    CategoryData(name: AppTexts.careTakers, icon: Icons.people),
    CategoryData(name: AppTexts.technicians, icon: Icons.build),
  ];


  static const List<ServiceProviderModel> serviceProviders = [
    ServiceProviderModel(
      id: '1',
      name: 'John Doe',
      profession: 'Electrician',
      isAvailable: true,
      rating: 4.5,
      reviewsCount: 120,
      aboutText: 'Experienced electrician with over 10 years of experience in residential and commercial electrical work. Specialized in wiring, installations, and repairs.',
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
          'reviewText': 'Excellent service! Very professional and completed the work quickly.',
          'date': '2 days ago',
        },
        {
          'reviewerName': 'Bob Johnson',
          'rating': 4.0,
          'reviewText': 'Good work, but a bit expensive. Would recommend for quality work.',
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
      aboutText: 'Professional plumber specializing in emergency repairs and installations. Available 24/7 for urgent plumbing issues.',
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
          'reviewText': 'Saved me from a major water leak! Very responsive and professional.',
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
  final IconData icon;

  const CategoryData({
    required this.name,
    required this.icon,
  });
}


