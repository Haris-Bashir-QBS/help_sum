import 'package:fpdart/fpdart.dart';
import 'package:help_sum/src/core/errors/api_exceptions.dart';
import 'package:help_sum/src/core/use_cases/use_case.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/domain/entities/categories_response_entity.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/domain/repositories/category_repository.dart';

class GetCategoriesParams {
  final int page;
  final int limit;

  GetCategoriesParams({required this.page, required this.limit});
}

class GetCategoriesUseCase
    implements UseCase<CategoriesResponseEntity, GetCategoriesParams> {
  final CategoryRepository repository;

  GetCategoriesUseCase(this.repository);

  @override
  Future<Either<Failure, CategoriesResponseEntity>> call(
    GetCategoriesParams params,
  ) async {
    return await repository.getCategories(params);
  }
}
