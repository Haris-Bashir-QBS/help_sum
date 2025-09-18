import 'package:fpdart/fpdart.dart';
import 'package:help_sum/src/core/use_cases/use_case.dart';
import 'package:help_sum/src/features/core/common/notifications/domain/entities/notification_entity.dart';
import 'package:help_sum/src/features/core/common/notifications/domain/repositories/notification_repository.dart';

import '../../../../../../core/errors/api_exceptions.dart';

class GetNotificationsUseCase
    extends UseCase<List<NotificationEntity>, NoParams> {
  final NotificationRepository _repository;

  GetNotificationsUseCase(this._repository);

  @override
  Future<Either<Failure, List<NotificationEntity>>> call(
    NoParams params,
  ) async {
    return await _repository.getNotifications();
  }
}
