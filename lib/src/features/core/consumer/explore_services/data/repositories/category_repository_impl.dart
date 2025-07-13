import 'package:fpdart/fpdart.dart';
import 'package:help_sum/src/core/errors/api_exceptions.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/data/datasources/remote/category_remote_datasource.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/domain/entities/categories_response_entity.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/domain/repositories/category_repository.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/domain/usecases/get_categories_usecase.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryRemoteDataSource remoteDataSource;

  CategoryRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, CategoriesResponseEntity>> getCategories(
    GetCategoriesParams params,
  ) async {
    try {
      final response = await remoteDataSource.getCategories(params);

      final entity = CategoriesResponseEntity(
        status: response.status,
        code: response.code,
        message: response.message,
        data: CategoriesDataEntity(
          categories: response.data.categories,
          pagination: response.data.pagination,
        ),
      );

      return right(entity);
    } on Failure catch (e) {
      return left(Failure(message: e.message));
    }
  }
}
