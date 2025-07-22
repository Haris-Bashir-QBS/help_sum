import 'package:fpdart/fpdart.dart';
import 'package:help_sum/src/core/errors/api_exceptions.dart';
import 'package:help_sum/src/features/auth/data/models/response/user_model.dart';

abstract class MerchantViewProfileRepository {
  Future<Either<Failure, UserModel>> fetchMerchantProfile(String merchantId);
}
