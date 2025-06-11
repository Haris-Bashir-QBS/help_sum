class ServiceProviderModel {
  final String id;
  final String name;
  final String profession;
  final bool isAvailable;
  final double rating;
  final int reviewsCount;
  final String aboutText;
  final List<String> profileImages;
  final String profileImage;
  final List<Map<String, dynamic>> reviews;
  final double rate;
  final String rateLabel;
  final double distance;
  final String distanceLabel;
  final int completedJobs;
  final String completedJobsLabel;

  const ServiceProviderModel({
    required this.id,
    required this.name,
    required this.profession,
    required this.isAvailable,
    required this.rating,
    required this.reviewsCount,
    required this.aboutText,
    required this.profileImages,
    required this.profileImage,
    required this.reviews,
    required this.rate,
    required this.rateLabel,
    required this.distance,
    required this.distanceLabel,
    required this.completedJobs,
    required this.completedJobsLabel,
  });

  factory ServiceProviderModel.fromJson(Map<String, dynamic> json) {
    return ServiceProviderModel(
      id: json['id'] as String,
      name: json['name'] as String,
      profession: json['profession'] as String,
      isAvailable: json['isAvailable'] as bool,
      rating: json['rating'] as double,
      reviewsCount: json['reviewsCount'] as int,
      aboutText: json['aboutText'] as String,
      profileImages: List<String>.from(json['profileImages'] as List),
      profileImage: json['profileImage'] as String,
      reviews: List<Map<String, dynamic>>.from(json['reviews'] as List),
      rate: json['rate'] as double,
      rateLabel: json['rateLabel'] as String,
      distance: json['distance'] as double,
      distanceLabel: json['distanceLabel'] as String,
      completedJobs: json['completedJobs'] as int,
      completedJobsLabel: json['completedJobsLabel'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'profession': profession,
      'isAvailable': isAvailable,
      'rating': rating,
      'reviewsCount': reviewsCount,
      'aboutText': aboutText,
      'profileImages': profileImages,
      'profileImage': profileImage,
      'reviews': reviews,
      'rate': rate,
      'rateLabel': rateLabel,
      'distance': distance,
      'distanceLabel': distanceLabel,
      'completedJobs': completedJobs,
      'completedJobsLabel': completedJobsLabel,
    };
  }
} 