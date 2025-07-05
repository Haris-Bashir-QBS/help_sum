import 'package:help_sum/src/features/core/consumer/explore_services/data/models/response/get_categories_response_model.dart';
import 'package:help_sum/src/features/core/consumer/explore_services/domain/usecases/get_categories_usecase.dart';

abstract class CategoryRemoteDataSource {
  Future<GetCategoriesResponseModel> getCategories(GetCategoriesParams params);
}
