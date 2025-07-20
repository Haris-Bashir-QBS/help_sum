import 'package:fpdart/fpdart.dart';
import 'package:help_sum/src/core/errors/api_exceptions.dart';
import '../../domain/repositories/merchant_view_profile_repository.dart';
import '../../domain/entities/service_provider_model.dart';
import '../datasources/remote/merchant_view_profile_remote_datasource.dart';

class MerchantViewProfileRepositoryImpl
    implements MerchantViewProfileRepository {
  final MerchantViewProfileRemoteDatasource remoteDatasource;
  MerchantViewProfileRepositoryImpl(this.remoteDatasource);

  @override
  Future<Either<Failure, ServiceProviderModel>> fetchMerchantProfile(
    String merchantId,
  ) async {
    try {
      final data = await remoteDatasource.fetchMerchantProfile(merchantId);
      final serviceProvider = ServiceProviderModel(
        id: data['_id'] ?? '',
        name: (data['firstName'] ?? '') + ' ' + (data['lastName'] ?? ''),
        profession: data['role'] ?? '',
        isAvailable: data['isVerified'] ?? false,
        rating: (data['averageRating'] ?? 0).toDouble(),
        reviewsCount: data['totalReviews'] ?? 0,
        aboutText: data['description'] ?? '',
        profileImages: List<String>.from(data['Media'] ?? []),
        profileImage: data['image'] ?? '',
        reviews: [], // Map reviews if available
        rate: (data['hourlyRate'] ?? 0).toDouble(),
        rateLabel: '',
        distance: 0,
        distanceLabel: '',
        completedJobs: data['totalCompletedJobs'] ?? 0,
        completedJobsLabel: '',
      );
      return right(serviceProvider);
    } on Failure catch (e) {
      return left(Failure(message: e.message));
    }
  }
}
