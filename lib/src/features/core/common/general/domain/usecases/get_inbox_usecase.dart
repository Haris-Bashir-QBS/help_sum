import 'package:fpdart/fpdart.dart';
import 'package:help_sum/src/core/errors/api_exceptions.dart';
import 'package:help_sum/src/core/use_cases/use_case.dart';
import 'package:help_sum/src/features/core/common/general/domain/entities/recent_message_entity.dart';
import 'package:help_sum/src/features/core/common/general/domain/repositories/activity_repo.dart';

class GetInboxUsecase implements UseCase<List<RecentMessageEntity>, NoParams> {
  final ActivityRepo repository;

  GetInboxUsecase(this.repository);

  @override
  Future<Either<Failure, List<RecentMessageEntity>>> call(NoParams params) {
    // TODO: implement call
    throw UnimplementedError();
  }

  // @override
  // Future<Either<Failure, List<RecentMessageEntity>>> call(NoParams params) {
  // //  return await repository.getInboxMessages();
  // }
}
