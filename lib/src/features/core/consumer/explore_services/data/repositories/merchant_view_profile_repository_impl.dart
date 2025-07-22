import 'package:fpdart/fpdart.dart';
import 'package:help_sum/src/core/errors/api_exceptions.dart';
import '../../../../../auth/data/models/response/user_model.dart';
import '../../domain/repositories/merchant_view_profile_repository.dart';
import '../../domain/entities/service_provider_model.dart';
import '../datasources/remote/merchant_view_profile_remote_datasource.dart';

class MerchantViewProfileRepositoryImpl
    implements MerchantViewProfileRepository {
  final MerchantViewProfileRemoteDatasource remoteDatasource;
  MerchantViewProfileRepositoryImpl(this.remoteDatasource);

  @override
  Future<Either<Failure, UserModel>> fetchMerchantProfile(
    String merchantId,
  ) async {
    try {
      final data = await remoteDatasource.fetchMerchantProfile(merchantId);
      return right(UserModel.fromJson(data));
    } on Failure catch (e) {
      return left(Failure(message: e.message));
    }
  }
}
