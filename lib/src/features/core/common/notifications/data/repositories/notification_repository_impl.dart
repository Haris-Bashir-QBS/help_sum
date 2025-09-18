import 'package:fpdart/fpdart.dart';
import 'package:help_sum/src/core/errors/api_exceptions.dart';
import 'package:help_sum/src/features/core/common/notifications/data/data_sources/notification_remote_data_source.dart';
import 'package:help_sum/src/features/core/common/notifications/data/models/notification_model.dart';
import 'package:help_sum/src/features/core/common/notifications/domain/repositories/notification_repository.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource remoteDataSource;

  NotificationRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<NotificationModel>>> getNotifications() async {
    try {
      final notifications = await remoteDataSource.getNotifications();
      return right(notifications);
    } on Failure catch (e) {
      return left(Failure(message: e.message));
    }
  }
}
