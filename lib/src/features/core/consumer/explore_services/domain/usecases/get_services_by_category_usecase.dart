import 'package:fpdart/fpdart.dart';
import 'package:help_sum/src/core/errors/api_exceptions.dart';
import 'package:help_sum/src/core/use_cases/use_case.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/data/models/response/services_response_model.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/domain/repositories/category_repository.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/domain/usecases/get_services_params.dart';

class GetServicesByCategoryUseCase
    extends UseCase<ServicesResponseModel, GetServicesParams> {
  final CategoryRepository _repository;

  GetServicesByCategoryUseCase(this._repository);

  @override
  Future<Either<Failure, ServicesResponseModel>> call(
    GetServicesParams params,
  ) async {
    return await _repository.getServicesByCategory(params);
  }
}
