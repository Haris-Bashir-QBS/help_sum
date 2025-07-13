import 'package:fpdart/fpdart.dart';
import 'package:help_sum/src/core/errors/api_exceptions.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/domain/entities/categories_response_entity.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/domain/usecases/get_categories_usecase.dart';

abstract class CategoryRepository {
  Future<Either<Failure, CategoriesResponseEntity>> getCategories(
    GetCategoriesParams params,
  );
}
